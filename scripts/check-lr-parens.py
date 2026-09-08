#!/usr/bin/env python3
"""Detecta `lr((A)/(B))`, que renderiza SIN paréntesis.

Typst consume los paréntesis de `(A)` y `(B)` como agrupación de la fracción, así
que `lr()` se queda sin delimitadores que escalar y no dibuja nada. No da error:
simplemente sale mal. La forma correcta lleva un par interno explícito:

    mal:  lr((partial U)/(partial V))_T
    bien: lr(( (partial U)/(partial V) ))_T

No se puede detectar con grep, porque la forma correcta contiene a la incorrecta
como subcadena; hay que emparejar paréntesis de verdad.

Uso:  python3 scripts/check-lr-parens.py        → sale 1 si encuentra algo
"""
import glob
import os
import re
import sys

# El argumento de lr() es exactamente (NUM)/(DEN), con un nivel de anidamiento
# permitido dentro de cada operando.
BROKEN = re.compile(r'^\((?:[^()]|\([^()]*\))*\)\s*/\s*\((?:[^()]|\([^()]*\))*\)$')


def lr_args(src):
    """Devuelve (posición, argumento) de cada lr(...) con paréntesis balanceados."""
    for m in re.finditer(r'\blr\(', src):
        open_at = m.end() - 1
        depth = 0
        for j in range(open_at, len(src)):
            if src[j] == '(':
                depth += 1
            elif src[j] == ')':
                depth -= 1
                if depth == 0:
                    yield m.start(), src[open_at + 1:j]
                    break


def main():
    root = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..')
    found = []
    for path in sorted(glob.glob(os.path.join(root, 'typst/**/*.typ'),
                                 recursive=True)):
        src = open(path).read()
        for pos, arg in lr_args(src):
            if BROKEN.match(arg.strip()):
                line = src.count('\n', 0, pos) + 1
                found.append((os.path.relpath(path, root), line, arg))

    if not found:
        print('lr(): sin paréntesis perdidos.')
        return 0

    print(f'lr(): {len(found)} con los paréntesis perdidos\n')
    for path, line, arg in found:
        print(f'  {path}:{line}')
        print(f'    mal:  lr({arg})')
        print(f'    bien: lr(( {arg} ))')
    return 1


if __name__ == '__main__':
    sys.exit(main())
