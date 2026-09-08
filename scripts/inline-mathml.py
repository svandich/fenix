#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Hornea el math inline (`$...$`) de las páginas como MathML, vía Typst.

Reemplaza cada `$...$` por el `<math>` equivalente, generado compilando la
expresión con Typst (`--format html`). El LaTeX original queda guardado en el
atributo `data-tex` del propio `<math>`, así que el script es idempotente y
reversible: en la corrida siguiente vuelve a leer de ahí y regenera.

    ./scripts/inline-mathml.py                 procesa todas las páginas
    ./scripts/inline-mathml.py termoquimica    sólo ese curso
    ./scripts/inline-mathml.py --check         no escribe; código 1 si algo quedó sin hornear
    ./scripts/inline-mathml.py --diff          muestra el diff que aplicaría

Flujo: se juntan todas las expresiones distintas de todas las páginas, se
traducen con `scripts/latex2typst.py`, se compilan **en un solo documento
Typst**, y se reparte el MathML resultante a cada página.

Ver docs/typst-inline-migration.md para por qué se hizo así y cómo se verificó.
"""

import argparse
import difflib
import html
import os
import re
import subprocess
import sys
import tempfile
import unicodedata as ud

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from latex2typst import latex_to_typst, LatexSyntaxError  # noqa: E402

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
COURSES = ('electro', 'termo', 'termoquimica', 'basicos')

# `$...$` que no sea `$$`. El punto abarca saltos de línea: hay expresiones
# partidas en dos líneas dentro de un párrafo.
DOLLAR = re.compile(r'(?<!\$)\$(?!\$)(.+?)(?<!\$)\$(?!\$)', re.S)
BAKED = re.compile(r'<math\b[^>]*\sdata-tex="([^"]*)"[^>]*>.*?</math>', re.S)
# Bloques donde no hay que tocar nada: CSS y JS. La excepción son las
# explicaciones de los quizzes, que son texto que quiz.js inyecta como HTML.
SKIP = re.compile(
    r'<style\b[^>]*>.*?</style>'
    r'|<script\b(?![^>]*type="text/explanation")[^>]*>.*?</script>', re.S)

MARKER = 'ZZQ%dZZQ'
MARKER_RE = re.compile(r'ZZQ(\d+)ZZQ\s*(<math\b.*?</math>)', re.S)


# ------------------------------------------------------- normalización MathML

def _plane_map():
    """Alfanuméricos matemáticos (U+1D400+) -> (letra base, estilo).

    Typst emite `𝑃` (MATHEMATICAL ITALIC CAPITAL P) donde MathJax emite `<mi>P</mi>`
    y deja que el navegador lo incline. La forma de MathJax es la que conviene:
    esos codepoints sólo existen en fuentes matemáticas, y este repo se
    auto-hospeda Inter, que no los trae. Con la letra base el math hereda la
    tipografía de la página y además se puede buscar con Ctrl+F.
    """
    out = {'ℎ': ('h', '')}          # PLANCK CONSTANT: la `h` italica de Typst
    for cp in range(0x1D400, 0x1D800):
        ch = chr(cp)
        name = ud.name(ch, '')
        if not name.startswith('MATHEMATICAL '):
            continue
        base = ud.normalize('NFKC', ch)
        if len(base) != 1 or base == ch:
            continue
        rest = name[len('MATHEMATICAL '):]
        if rest.startswith('BOLD ITALIC'):
            style = 'bi'
        elif rest.startswith('ITALIC'):
            style = ''
        elif rest.startswith('BOLD'):
            style = 'b'
        else:
            continue                      # script/fraktur/doble trazo: se dejan
        out[ch] = (base, style)
    return out


PLANE = _plane_map()
# `epsilon`/`phi` tienen dos glifos y NFKC los funde; el mapeo va explícito.
PLANE.update({'\U0001d716': ('ϵ', ''), '\U0001d700': ('ε', ''),
              '\U0001d719': ('ϕ', ''), '\U0001d711': ('φ', ''),
              '\U0001d717': ('ϑ', ''), '\U0001d718': ('ϰ', ''),
              '\U0001d71a': ('ϱ', '')})

MI = re.compile(r'<(mi|mn|mo|mtext)([^>]*)>([^<]*)</\1>')


def normalize(mathml):
    """Baja los alfanuméricos matemáticos a letra base + clase CSS."""
    def token(m):
        tag, attrs, body = m.groups()
        styles = set()
        chars = []
        for ch in body:
            base, style = PLANE.get(ch, (ch, None))
            chars.append(base)
            if style:
                styles.add(style)
        body = ''.join(chars)
        if styles and 'class="' not in attrs:
            attrs += ' class="%s"' % ' '.join('mv-' + s for s in sorted(styles))
        return f'<{tag}{attrs}>{body}</{tag}>'
    return MI.sub(token, mathml)


# ----------------------------------------------------------------- extracción

def pages(courses):
    for course in courses:
        base = os.path.join(ROOT, course)
        for dirpath, _dirs, files in os.walk(base):
            if 'index.html' in files:
                yield os.path.join(dirpath, 'index.html')


def segments(text):
    """Parte el HTML en (procesable, trozo)."""
    pos = 0
    for m in SKIP.finditer(text):
        if m.start() > pos:
            yield True, text[pos:m.start()]
        yield False, m.group(0)
        pos = m.end()
    yield True, text[pos:]


def collect(text):
    """Todas las expresiones LaTeX de una página, horneadas o no."""
    found = []
    for ok, chunk in segments(text):
        if not ok:
            continue
        for m in BAKED.finditer(chunk):
            found.append(html.unescape(m.group(1)))
        for m in DOLLAR.finditer(BAKED.sub('', chunk)):
            found.append(m.group(1))
    return found


def rewrite(text, rendered):
    out = []
    for ok, chunk in segments(text):
        if ok:
            chunk = BAKED.sub(lambda m: rendered[html.unescape(m.group(1))], chunk)
            chunk = DOLLAR.sub(lambda m: rendered[m.group(1)], chunk)
        out.append(chunk)
    return ''.join(out)


# ------------------------------------------------------------------ compilado

def compile_batch(exprs):
    """LaTeX -> Typst -> MathML, todo en una sola corrida de `typst compile`."""
    exprs = sorted(set(exprs))
    typst = []
    for e in exprs:
        try:
            typst.append(latex_to_typst(html.unescape(e)))
        except LatexSyntaxError as err:
            sys.exit(f'error de traducción: {err}')

    with tempfile.TemporaryDirectory() as tmp:
        src = os.path.join(tmp, 'inline.typ')
        dst = os.path.join(tmp, 'inline.html')
        with open(src, 'w', encoding='utf-8') as fh:
            fh.write('#set text(size: 13pt)\n')
            for i, t in enumerate(typst):
                fh.write(f'{MARKER % i} ${t}$\n\n')
        proc = subprocess.run(
            ['typst', 'compile', '--format', 'html', '--features', 'html', src, dst],
            capture_output=True, text=True)
        if proc.returncode:
            sys.exit(proc.stderr)
        page = open(dst, encoding='utf-8').read()

    body = page.split('<body>', 1)[1]
    got = MARKER_RE.findall(body)
    if len(got) != len(exprs):
        sys.exit(f'Typst devolvió {len(got)} fórmulas y se esperaban {len(exprs)}')

    rendered = {}
    for i, ((idx, mathml), expr) in enumerate(zip(got, exprs)):
        if int(idx) != i:
            sys.exit(f'Typst devolvió las fórmulas fuera de orden ({idx} != {i})')
        tex = html.escape(html.unescape(expr), quote=True)
        inner = normalize(mathml)[len('<math>'):-len('</math>')]
        rendered[expr] = f'<math data-tex="{tex}">{inner}</math>'
    return rendered


# ---------------------------------------------------------------------- main

def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument('course', nargs='?', choices=COURSES)
    ap.add_argument('--check', action='store_true',
                    help='no escribe; código 1 si alguna página quedó sin hornear')
    ap.add_argument('--diff', action='store_true', help='muestra el diff, sin escribir')
    args = ap.parse_args()

    targets = list(pages([args.course] if args.course else COURSES))
    targets.sort()
    sources = {p: open(p, encoding='utf-8').read() for p in targets}

    everything = [e for text in sources.values() for e in collect(text)]
    if not everything:
        print('no hay math inline que procesar')
        return 0
    rendered = compile_batch(everything)
    print(f'{len(rendered)} expresiones distintas compiladas '
          f'({len(everything)} instancias)')

    changed = []
    for path in targets:
        new = rewrite(sources[path], rendered)
        if new != sources[path]:
            changed.append((path, sources[path], new))

    for path, old, new in changed:
        rel = os.path.relpath(path, ROOT)
        if args.diff:
            sys.stdout.writelines(difflib.unified_diff(
                old.splitlines(True), new.splitlines(True), f'a/{rel}', f'b/{rel}'))
        elif not args.check:
            with open(path, 'w', encoding='utf-8') as fh:
                fh.write(new)

    verb = 'sin hornear' if args.check else 'actualizadas'
    print(f'{len(changed)}/{len(targets)} páginas {verb}')
    for path, _o, _n in changed:
        print('    ' + os.path.relpath(path, ROOT))
    if args.check and changed:
        print('\nCorrer ./scripts/inline-mathml.py para arreglarlo.')
        return 1
    return 0


if __name__ == '__main__':
    sys.exit(main())
