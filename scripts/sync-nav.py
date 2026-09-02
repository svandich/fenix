#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Sincroniza los bloques de navegación duplicados en todas las páginas de un curso.

La sidebar y el bloque prev/next están copiados literalmente en cada `index.html`. Este script
los regenera desde `scripts/courses.py`, que es la única fuente de verdad, y los sustituye
textualmente sin tocar nada más del archivo.

    ./scripts/sync-nav.py                 sincroniza todos los cursos
    ./scripts/sync-nav.py termoquimica    sincroniza sólo ese curso
    ./scripts/sync-nav.py --check         no escribe; sale con código 1 si algo está desincronizado
    ./scripts/sync-nav.py --diff          muestra el diff que aplicaría, sin escribir

Ver docs/sidebar-maintenance.md para el contrato del marcado y las trampas conocidas.
"""

import argparse
import difflib
import os
import re
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from courses import COURSES  # noqa: E402

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# El bloque de sidebar es único por archivo y </nav> no se repite.
SIDEBAR = re.compile(r'<nav class="sidebar">.*?</nav>', re.S)
# page-nav contiene <div> anidados, así que el cierre se ancla en el </main> que le sigue.
# El lookahead deja la cola (</div></main>) fuera del reemplazo, intacta byte a byte.
PAGENAV = re.compile(r'<div class="page-nav">.*?</div>(?=\s*</div>\s*</main>)', re.S)

HOME_TITLE = 'Temario general'


# ---------------------------------------------------------------- generadores

def sidebar_html(c, active, is_index):
    """`active` es el slug de la página activa, o None para el index del curso."""
    home = './' if is_index else '../'
    prefix = '' if is_index else '../'
    home_active = ' active' if active is None else ''
    out = [
        '<nav class="sidebar">',
        '  <div class="sidebar-header">',
        f'    <a class="sidebar-logo" href="{home}">',
        f'      <span class="icon">{c["icon"]}</span>',
        f'      <div><div class="name">{c["name"]}</div>'
        f'<div class="subtitle">{c["subtitle"]}</div></div>',
        '    </a>',
        '  </div>',
        '  <div class="sidebar-nav">',
        '    <div class="nav-section-title">Índice</div>',
        f'    <a class="nav-link{home_active}" href="{home}">'
        f'<span class="dot" style="background:var(--text-muted)"></span>'
        f'<span>{HOME_TITLE}</span></a>',
    ]
    for block in c['blocks']:
        out.append(f'    <div class="nav-section-title">{block}</div>')
        for slug, num, label, unit, blk, _title in c['pages']:
            if blk != block:
                continue
            act = ' active' if slug == active else ''
            out.append(f'    <a class="nav-link{act}" href="{prefix}{slug}/">'
                       f'<span class="dot dot-{unit}"></span>'
                       f'<span class="num">{num}</span> {label}</a>')
    out += ['  </div>', '</nav>']
    return '\n'.join(out)


def pagenav_html(c, slug):
    order = nav_order(c)
    titles = {p[0]: p[5] for p in c['pages']}
    i = order.index(slug)

    if i == 0:
        left = ('../', '← Volver', HOME_TITLE)
    else:
        prev = order[i - 1]
        left = (f'../{prev}/', '← Anterior', titles[prev])

    if i == len(order) - 1:
        right = ('../', 'Volver →', HOME_TITLE)
    else:
        nxt = order[i + 1]
        right = (f'../{nxt}/', 'Siguiente →', titles[nxt])

    def link(href, extra, direction, title):
        return (f'    <a href="{href}"{extra}><div class="nav-dir">{direction}</div>'
                f'<div class="nav-title">{title}</div></a>')

    return ('<div class="page-nav">\n'
            + link(left[0], '', left[1], left[2]) + '\n'
            + link(right[0], ' class="next"', right[1], right[2]) + '\n'
            + '  </div>')


def nav_order(c):
    """Orden de la cadena prev/next. Por defecto es el orden de la sidebar."""
    return c.get('nav_order') or [p[0] for p in c['pages']]


# ------------------------------------------------------------------ el trabajo

def replace_block(path, text, pattern, new, what):
    """Sustituye el único bloque `what` de `text`. Aborta si no aparece exactamente una vez."""
    n = len(pattern.findall(text))
    if n != 1:
        sys.exit(f'error: {os.path.relpath(path, ROOT)}: se esperaba 1 bloque {what}, '
                 f'se encontraron {n}')
    # repl como función: re no interpreta \1 ni \g<> dentro del bloque generado.
    return pattern.sub(lambda _m: new, text, count=1)


def planned_changes(course):
    """[(ruta, texto viejo, texto nuevo)] para cada archivo del curso que cambiaría."""
    c = COURSES[course]
    validate(course, c)
    changes = []

    for path, slug, is_index in targets(course, c):
        with open(path, encoding='utf-8') as fh:
            old = fh.read()
        new = replace_block(path, old, SIDEBAR, sidebar_html(c, slug, is_index), 'sidebar')
        if not is_index:
            new = replace_block(path, new, PAGENAV, pagenav_html(c, slug), 'page-nav')
        if new != old:
            changes.append((path, old, new))
    return changes


def targets(course, c):
    """[(ruta, slug activo o None, es_index)] — el index del curso y una entrada por página."""
    out = [(os.path.join(ROOT, course, 'index.html'), None, True)]
    for slug, *_rest in c['pages']:
        out.append((os.path.join(ROOT, course, slug, 'index.html'), slug, False))
    return out


def validate(course, c):
    """El manifiesto tiene que cuadrar con el disco antes de escribir nada."""
    errs = []
    slugs = [p[0] for p in c['pages']]

    dupes = {s for s in slugs if slugs.count(s) > 1}
    if dupes:
        errs.append(f'slugs repetidos en el manifiesto: {sorted(dupes)}')

    for slug, _num, _label, _unit, block, _title in c['pages']:
        if block not in c['blocks']:
            errs.append(f'{slug}: bloque {block!r} no está en `blocks` (la página no saldría en la sidebar)')
        if not os.path.isfile(os.path.join(ROOT, course, slug, 'index.html')):
            errs.append(f'{slug}: el manifiesto lo lista pero no existe {course}/{slug}/index.html')

    # Carpetas con index.html que el manifiesto no conoce. Las que no lo tienen
    # (p. ej. termo/problemas/) no son páginas del curso y se ignoran en silencio.
    for entry in sorted(os.listdir(os.path.join(ROOT, course))):
        d = os.path.join(ROOT, course, entry)
        if os.path.isdir(d) and os.path.isfile(os.path.join(d, 'index.html')) and entry not in slugs:
            errs.append(f'{entry}: existe {course}/{entry}/index.html pero no está en el manifiesto')

    order = nav_order(c)
    if sorted(order) != sorted(slugs):
        errs.append(f'`nav_order` no cubre exactamente las páginas de `pages` '
                    f'(sobran {sorted(set(order) - set(slugs))}, faltan {sorted(set(slugs) - set(order))})')

    if errs:
        sys.exit('\n'.join(f'error [{course}]: {e}' for e in errs))


# ------------------------------------------------------------------------ CLI

def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('courses', nargs='*', metavar='CURSO',
                    help='cursos a sincronizar (por defecto: todos)')
    g = ap.add_mutually_exclusive_group()
    g.add_argument('--check', action='store_true',
                   help='no escribe; sale con código 1 si algo está desincronizado')
    g.add_argument('--diff', action='store_true',
                   help='muestra el diff que aplicaría, sin escribir')
    args = ap.parse_args()

    selected = args.courses or list(COURSES)
    for name in selected:
        if name not in COURSES:
            ap.error(f'curso desconocido: {name} (conocidos: {", ".join(COURSES)})')

    total = 0
    for course in selected:
        changes = planned_changes(course)
        total += len(changes)
        n = len(targets(course, COURSES[course]))
        rel = [os.path.relpath(p, ROOT) for p, _o, _n in changes]

        if args.diff:
            for path, old, new in changes:
                r = os.path.relpath(path, ROOT)
                sys.stdout.writelines(difflib.unified_diff(
                    old.splitlines(True), new.splitlines(True), f'a/{r}', f'b/{r}'))
        elif args.check:
            print(f'{course}: {len(changes)}/{n} archivos desincronizados' if changes
                  else f'{course}: {n} archivos sincronizados')
            for r in rel:
                print(f'    {r}')
        else:
            for path, _old, new in changes:
                with open(path, 'w', encoding='utf-8') as fh:
                    fh.write(new)
            print(f'{course}: {len(changes)}/{n} archivos actualizados')
            for r in rel:
                print(f'    {r}')

    if args.check and total:
        print(f'\n{total} archivo(s) desincronizado(s). '
              f'Correr ./scripts/sync-nav.py para arreglarlo.')
        return 1
    return 0


if __name__ == '__main__':
    sys.exit(main())
