#!/usr/bin/env python3
"""Traductor del subconjunto de LaTeX usado en el math inline de este repo a
sintaxis matemática de Typst.

No pretende cubrir LaTeX entero: cubre exactamente los 84 macros que aparecen en
las paginas del repo (ver docs/typst-inline-migration.md, §2). Cualquier macro
desconocido levanta LatexSyntaxError en vez de traducirse mal en silencio.

Decisiones que evitan los modos de falla silenciosos documentados en §4 del doc:

* Los simbolos se emiten como el **codepoint Unicode literal**, no como el nombre
  Typst (`ε` y no `epsilon`). Asi la inversion `\\epsilon`/`\\varepsilon` entre
  LaTeX y Typst no puede ocurrir: el mapeo va de macro LaTeX a codepoint.
* Las fracciones se emiten como `frac(a, b)`, no como `(a)/(b)`, de modo que la
  trampa `lr((A)/(B))` no existe: `frac()` es una llamada a funcion y los
  parentesis que la rodean nunca se consumen como agrupacion.
* Las letras adyacentes se separan siempre (`PV` -> `P V`), que es lo que Typst
  necesita para no leerlas como un identificador.
* Las barras `/` literales de LaTeX se escapan a `\\/` para que Typst no las
  convierta en fraccion.
"""

import re

class LatexSyntaxError(ValueError):
    pass


# --- macro LaTeX -> codepoint Unicode -----------------------------------------
SYMBOLS = {
    'alpha': 'α', 'beta': 'β', 'gamma': 'γ', 'delta': 'δ', 'epsilon': 'ϵ',
    'varepsilon': 'ε', 'zeta': 'ζ', 'eta': 'η', 'theta': 'θ',
    'vartheta': 'ϑ', 'iota': 'ι', 'kappa': 'κ', 'lambda': 'λ', 'mu': 'μ',
    'nu': 'ν', 'xi': 'ξ', 'pi': 'π', 'rho': 'ρ', 'sigma': 'σ', 'tau': 'τ',
    'upsilon': 'υ', 'phi': 'ϕ', 'varphi': 'φ', 'chi': 'χ', 'psi': 'ψ',
    'omega': 'ω',
    'Gamma': 'Γ', 'Delta': 'Δ', 'Theta': 'Θ', 'Lambda': 'Λ', 'Xi': 'Ξ',
    'Pi': 'Π', 'Sigma': 'Σ', 'Upsilon': 'Υ', 'Phi': 'Φ', 'Psi': 'Ψ',
    'Omega': 'Ω',

    'partial': '∂', 'nabla': '∇', 'infty': '∞', 'ell': 'ℓ', 'hbar': 'ℏ',
    'circ': '∘', 'cdot': '⋅', 'times': '×', 'pm': '±', 'mp': '∓',
    'sum': '∑', 'prod': '∏', 'int': '∫', 'oint': '∮', 'iint': '∬',
    'iiint': '∭',
    'approx': '≈', 'propto': '∝', 'sim': '∼', 'simeq': '≃', 'equiv': '≡',
    'neq': '≠', 'ne': '≠', 'geq': '≥', 'ge': '≥', 'leq': '≤', 'le': '≤',
    'll': '≪', 'gg': '≫', 'in': '∈', 'notin': '∉', 'perp': '⊥',
    'parallel': '∥',
    'to': '→', 'rightarrow': '→', 'leftarrow': '←', 'leftrightarrow': '↔',
    'Rightarrow': '⇒', 'Leftarrow': '⇐', 'Leftrightarrow': '⇔',
    'ldots': '…', 'dots': '…', 'cdots': '⋯', 'vdots': '⋮',
    'langle': '⟨', 'rangle': '⟩',
    'prime': '′', 'degree': '°', 'angle': '∠',
    'cup': '∪', 'cap': '∩', 'subset': '⊂', 'emptyset': '∅',
}

# --- macro LaTeX -> funcion Typst de un argumento ------------------------------
ACCENTS = {
    'vec': 'arrow', 'bar': 'macron', 'overline': 'overline', 'hat': 'hat',
    'dot': 'dot', 'ddot': 'dot.double', 'tilde': 'tilde', 'widehat': 'hat',
}
FONTS = {
    'mathbf': 'bold', 'boldsymbol': 'bold', 'mathcal': 'cal', 'mathbb': 'bb',
    'mathit': 'italic', 'mathsf': 'sans', 'mathfrak': 'frak',
}
# operadores con nombre: Typst ya los trae como identificadores rectos
OPERATORS = {
    'ln', 'log', 'exp', 'sin', 'cos', 'tan', 'sinh', 'cosh', 'tanh', 'lim',
    'max', 'min', 'sup', 'inf', 'det', 'arg', 'gcd', 'sec', 'csc', 'cot',
    'arcsin', 'arccos', 'arctan',
}
# espaciados: no admiten sub/superindice encima
SPACES = {
    ',': 'thin', ':': 'med', ';': 'thick', ' ': 'thick',
    '!': '#h(-0.16667em)', 'quad': 'quad', 'qquad': 'wide',
}

TOKEN_RE = re.compile(r'\\[a-zA-Z]+|\\.|.', re.S)
# caracteres que Typst interpreta y hay que escapar para que salgan literales
TYPST_ESCAPE = {'/': '\\/', '#': '\\#', '$': '\\$', '&': '\\&', '\\': '\\\\'}


class _Atom:
    """Un termino. `sfx` guarda los sub/superindices aparte de la base para que
    una prima que llega despues (`Q_y'`) se pueda insertar antes de ellos:
    Typst solo la eleva en `Q'_(y)`, no en `Q_(y)'`."""

    __slots__ = ('base', 'sfx', 'kind')

    def __init__(self, base, kind='atom', sfx=''):
        self.base = base
        self.sfx = sfx
        self.kind = kind          # 'atom' | 'space' | 'bar' | 'prime'

    @property
    def text(self):
        return self.base + self.sfx

    def __repr__(self):
        return f'<{self.kind} {self.text!r}>'


def _tokenize(src):
    return TOKEN_RE.findall(src)


def _join(atoms):
    """Une atomos con espacio, salvo junto a una cadena `"..."` literal.

    Typst convierte un espacio de fuente adyacente a un string en un espacio
    real de 0.2222em; LaTeX ignora ese espacio. Sin esta excepcion `0{,}082`
    saldria como `0 , 082`. Los atomos de espaciado explicito (`thin`, `thick`)
    quedan exentos: ahi el espacio de fuente separa identificadores.
    """
    kept = [a for a in atoms if a.text]
    out = ''
    for k, a in enumerate(kept):
        if k:
            prev = kept[k - 1]
            glue = ((out.endswith('"') or a.text.startswith('"'))
                    and prev.kind != 'space' and a.kind != 'space')
            if not glue:
                out += ' '
        out += a.text
    return out


def _wrap_arg(atoms):
    """Envuelve una secuencia como argumento de sub/superindice o de funcion."""
    return '(' + _join(atoms) + ')'


class _Parser:
    def __init__(self, src):
        self.src = src
        self.toks = _tokenize(src)
        self.i = 0

    # -- utilidades ------------------------------------------------------------
    def peek(self):
        return self.toks[self.i] if self.i < len(self.toks) else None

    def next(self):
        t = self.peek()
        if t is None:
            raise LatexSyntaxError(f'fin inesperado en {self.src!r}')
        self.i += 1
        return t

    def fail(self, msg):
        raise LatexSyntaxError(f'{msg} en {self.src!r}')

    # -- entrada ---------------------------------------------------------------
    def parse(self):
        atoms = self.sequence(stop_at_brace=False)
        return _join(self.fold_bars(atoms))

    def sequence(self, stop_at_brace=True):
        atoms = []
        while True:
            t = self.peek()
            if t is None:
                break
            if t == '}':
                if stop_at_brace:
                    break
                self.fail("'}' sin abrir")
            if t == '\\right':
                break
            if t in ('^', '_'):
                self.attach_scripts(atoms)
                continue
            new = self.unit()
            for a in new:
                if a.kind == 'prime':
                    # Typst solo eleva la prima si esta pegada a su base
                    if atoms and atoms[-1].kind == 'atom':
                        atoms[-1].base += "'"
                    else:
                        atoms.append(_Atom("zws'"))
                else:
                    atoms.append(a)
        return atoms

    # -- sub/superindices ------------------------------------------------------
    def attach_scripts(self, atoms):
        sub = sup = None
        while self.peek() in ('^', '_'):
            mark = self.next()
            arg = self.argument()
            if mark == '^':
                sup = arg if sup is None else sup + ' ' + arg
            else:
                sub = arg if sub is None else sub + ' ' + arg
        target = atoms[-1] if atoms and atoms[-1].kind == 'atom' else None
        if target is None:
            # `25\,^\circ`: la base es vacia, no el espacio que la precede
            target = _Atom('zws')
            atoms.append(target)
        if sub is not None:
            target.sfx += '_' + sub
        if sup is not None:
            target.sfx += '^' + sup

    def skip_space(self):
        while self.peek() is not None and self.peek().isspace():
            self.next()

    def argument(self):
        """Un argumento de script o de macro, siempre entre parentesis Typst."""
        self.skip_space()
        t = self.peek()
        if t is None:
            self.fail('argumento faltante')
        if t == '{':
            self.next()
            atoms = self.sequence()
            if self.peek() != '}':
                self.fail("falta '}'")
            self.next()
            if len(atoms) == 1 and atoms[0].text == ',':
                # `0{,}5`: coma decimal, atomo ordinario sin espaciado
                return '(",")'
            return _wrap_arg(self.fold_bars(atoms))
        # sin llaves el argumento es UN token: `\\frac32` es 3/2, no 32/algo,
        # y `x^23` es x elevado a 2 seguido de un 3.
        return _wrap_arg(self.unit(single=True))

    # -- una unidad ------------------------------------------------------------
    def unit(self, single=False):
        t = self.next()
        if t == '{':
            atoms = self.sequence()
            if self.peek() != '}':
                self.fail("falta '}'")
            self.next()
            atoms = self.fold_bars(atoms)
            if len(atoms) == 1 and atoms[0].text == ',':
                return [_Atom('","')]
            if not atoms:
                return []
            if len(atoms) == 1:
                return atoms
            return [_Atom('(' + _join(atoms) + ')')]
        if t.startswith('\\'):
            return self.command(t)
        return self.char(t, single=single)

    def char(self, c, single=False):
        if c.isspace():
            return []
        if c == '|':
            return [_Atom('|', 'bar')]
        if c == "'":
            return [_Atom("'", 'prime')]
        if c.isdigit():
            num = c
            while not single:
                nxt = self.peek()
                if nxt is not None and nxt.isdigit():
                    num += self.next()
                elif (nxt == '.' and self.i + 1 < len(self.toks)
                      and self.toks[self.i + 1].isdigit()):
                    num += self.next()
                else:
                    break
            return [_Atom(num)]
        if c in TYPST_ESCAPE:
            return [_Atom(TYPST_ESCAPE[c])]
        if c == '"':
            return [_Atom('\\"')]
        return [_Atom(c)]

    def command(self, tok):
        name = tok[1:]

        if name in SPACES:                       # \, \! \; \  \quad
            return [_Atom(SPACES[name], 'space')]
        if name in ('{', '}', '%', '#', '$', '&', '_'):
            return [_Atom('\\' + name if name in '#$&_' else name)]
        if name == '\\':
            return [_Atom('\\\\')]
        if name in SYMBOLS:
            return [_Atom(SYMBOLS[name])]
        if name in OPERATORS:
            return [_Atom(name)]
        if name in ACCENTS:
            return [_Atom(f'{ACCENTS[name]}{self.argument()}')]
        if name in FONTS:
            return [_Atom(f'{FONTS[name]}{self.argument()}')]
        if name == 'mathrm':
            return [_Atom(f'upright{self.text_argument(math=True)}')]
        if name in ('text', 'textrm', 'mbox'):
            return [_Atom(self.text_argument(math=False))]
        if name == 'sqrt':
            return [_Atom(f'sqrt{self.argument()}')]
        if name in ('frac', 'dfrac', 'tfrac'):
            num, den = self.argument(), self.argument()
            f = f'frac{self.pair(num, den)}'
            if name == 'dfrac':
                f = f'display({f})'
            elif name == 'tfrac':
                f = f'inline({f})'
            return [_Atom(f)]
        if name == 'left':
            return self.left_right()
        if name == 'operatorname':
            return [_Atom(f'op{self.text_argument(math=False)}')]
        self.fail(f'macro no soportado \\{name}')

    @staticmethod
    def pair(num, den):
        """`frac(a, b)` salvo que un argumento tenga coma de nivel superior."""
        def risky(arg):
            depth = 0
            for ch in arg[1:-1]:
                if ch in '([{':
                    depth += 1
                elif ch in ')]}':
                    depth -= 1
                elif ch == ',' and depth == 0:
                    return True
            return False
        if risky(num) or risky(den):
            return f'-USE-SLASH-{num}/{den}'
        return f'({num[1:-1]}, {den[1:-1]})'

    def text_argument(self, math):
        self.skip_space()
        if self.peek() != '{':
            # `\text` sin llaves no aparece en el corpus, pero por si acaso
            return _wrap_arg(self.unit())
        self.next()
        depth = 1
        raw = ''
        while True:
            t = self.next()
            if t == '{':
                depth += 1
            elif t == '}':
                depth -= 1
                if depth == 0:
                    break
            raw += t
        if math:
            # \mathrm siempre va por la via math: `upright(F e)` y no
            # `upright("Fe")`. Un string literal es un text run y Typst le mete
            # 0.2222em de aire a cada lado cuando la fuente trae un espacio,
            # cosa que LaTeX no hace: `\mathrm{Fe}(s)` saldria como "Fe (s)".
            return f'({_Parser(raw).parse()})'
        esc = raw.replace('\\', '\\\\').replace('"', '\\"')
        return f'("{esc}")' if math else f'"{esc}"'

    def left_right(self):
        self.skip_space()
        open_tok = self.next()
        open_d = self.delim(open_tok)
        atoms = self.sequence()
        if self.peek() != '\\right':
            self.fail('\\left sin \\right')
        self.next()
        self.skip_space()
        close_d = self.delim(self.next())
        inner = _join(self.fold_bars(atoms))
        if open_d == '|' and close_d == '|':
            return [_Atom(f'abs({inner})')]
        return [_Atom(f'lr({open_d} {inner} {close_d})')]

    def delim(self, tok):
        if tok in ('(', ')', '[', ']', '|', '.', '/'):
            return {'.': '', '/': '\\/'}.get(tok, tok)
        if tok in ('\\{', '\\}'):
            return tok[1]
        if tok in ('\\langle', '\\rangle'):
            return SYMBOLS[tok[1:]]
        if tok == '\\|':
            return '‖'
        self.fail(f'delimitador no soportado {tok!r}')

    @staticmethod
    def fold_bars(atoms):
        """`|q|` -> `abs(q)`; deja las barras sueltas tal cual."""
        out, i = [], 0
        while i < len(atoms):
            if atoms[i].kind == 'bar':
                j = next((k for k in range(i + 1, len(atoms))
                          if atoms[k].kind == 'bar'), None)
                if j is not None:
                    out.append(_Atom(f'abs({_join(atoms[i + 1:j])})'))
                    i = j + 1
                    continue
            out.append(atoms[i])
            i += 1
        return out


def latex_to_typst(src):
    """Traduce una expresion LaTeX inline a math de Typst."""
    out = _Parser(src).parse()
    while '-USE-SLASH-' in out:
        # frac() con coma de nivel superior: cae a la forma (a)/(b), donde la
        # coma es agrupacion matematica y no separador de argumentos.
        out = re.sub(r'frac-USE-SLASH-(\([^()]*(?:\([^()]*\)[^()]*)*\))/'
                     r'(\([^()]*(?:\([^()]*\)[^()]*)*\))', r'\1/\2', out, count=1)
        if '-USE-SLASH-' in out and 'frac-USE-SLASH-' not in out:
            raise LatexSyntaxError('no se pudo resolver frac con coma')
    return out


if __name__ == '__main__':
    import sys
    for line in sys.stdin:
        line = line.rstrip('\n')
        if line:
            print(latex_to_typst(line))
