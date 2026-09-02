#!/usr/bin/env python3
"""Verifica que la recompilación con Typst 0.15 no cambió nada visible.

Compara cada SVG modificado contra su versión en git (HEAD), renombrando los
ids de glifo por orden de aparición. Si el único cambio son los hashes, los
dos archivos quedan idénticos y la migración es un no-op visual.

Uso:  python3 scripts/verify-typst-migration.py
Sale con código 1 si algún archivo cambió de verdad.
"""
import re, subprocess, sys

GLYPH_ID = re.compile(r'\b(g[0-9A-F]{20,})\b')

def canon(s: str) -> str:
    """Renombra gABC123... -> G0, G1, G2... por orden de aparición."""
    mapping = {}
    def repl(m):
        return mapping.setdefault(m.group(1), f'G{len(mapping)}')
    return GLYPH_ID.sub(repl, s)

changed = subprocess.run(['git', 'diff', '--name-only', '--', '*.svg'],
                         capture_output=True, text=True, check=True).stdout.split()
if not changed:
    print('No hay SVGs modificados.')
    sys.exit(0)

same, real = 0, []
for path in changed:
    old = subprocess.run(['git', 'show', f'HEAD:{path}'],
                         capture_output=True, text=True).stdout
    with open(path, encoding='utf-8') as fh:
        new = fh.read()
    if canon(old) == canon(new):
        same += 1
    else:
        real.append(path)

print(f'SVGs revisados:                  {len(changed)}')
print(f'  idénticos salvo ids de glifo:  {same}')
print(f'  con diferencia real:           {len(real)}')
for p in real[:20]:
    print('   ⚠', p)

if real:
    print('\nHay cambios reales. Revisarlos a ojo antes de commitear.')
    sys.exit(1)
print('\n✓ Migración limpia: ningún cambio visual.')
