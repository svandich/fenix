#!/usr/bin/env python3
# (ya ejecutado) Inserta las secciones "Ciclos y Máquinas" y "Gases Reales y
# Transporte" en el sidebar de todos los HTML de termo existentes (cat_1..20,
# cc_1..7, termo/index.html) y actualiza el subtítulo del sidebar-header.
import os
import re

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

NEW_BLOCK_REL = '''    <div class="nav-section-title">Ciclos y Máquinas</div>
    <a class="nav-link" href="../cat_21/"><span class="dot dot-u6"></span><span class="num">21</span> Entropía Irreversible</a>
    <a class="nav-link" href="../cat_22/"><span class="dot dot-u6"></span><span class="num">22</span> Máquinas Térmicas</a>
    <a class="nav-link" href="../cat_23/"><span class="dot dot-u6"></span><span class="num">23</span> Ciclo de Carnot</a>
    <a class="nav-link" href="../cc_8/"><span class="dot dot-u6"></span><span class="num">CC8</span> Máq. de Carnot</a>
    <a class="nav-link" href="../cc_9/"><span class="dot dot-u6"></span><span class="num">CC9</span> Entropía (Clausius)</a>
    <div class="nav-section-title">Gases Reales y Transporte</div>
    <a class="nav-link" href="../cat_24/"><span class="dot dot-u7"></span><span class="num">24</span> Equipartición y Pauli</a>
    <a class="nav-link" href="../cat_25/"><span class="dot dot-u7"></span><span class="num">25</span> Hacia Gases Reales</a>
    <a class="nav-link" href="../cat_26/"><span class="dot dot-u7"></span><span class="num">26</span> Van der Waals</a>
    <a class="nav-link" href="../cat_27/"><span class="dot dot-u7"></span><span class="num">27</span> Coexistencia de Fases</a>
    <a class="nav-link" href="../cat_28/"><span class="dot dot-u7"></span><span class="num">28</span> Síntesis y Browniano</a>
    <a class="nav-link" href="../cc_10/"><span class="dot dot-u7"></span><span class="num">CC10</span> Teorema del Virial</a>
    <a class="nav-link" href="../cc_11/"><span class="dot dot-u7"></span><span class="num">CC11</span> Licuefacción</a>
'''
NEW_BLOCK_INDEX = NEW_BLOCK_REL.replace('href="../cat_', 'href="cat_').replace('href="../cc_', 'href="cc_')

ANCHOR_REL = re.compile(
    r'(<a class="nav-link[^"]*"[^>]*href="\.\./cc_7/"[^>]*>[^\n]*</a>\n)(\s*</div>\n</nav>)',
)
ANCHOR_INDEX = re.compile(
    r'(<a class="nav-link[^"]*"[^>]*href="cc_7/"[^>]*>[^\n]*</a>\n)(\s*</div>\n</nav>)',
)

OLD_SUBTITLE = "Cátedras 1–20 · CC 1–7"
NEW_SUBTITLE = "Cátedras 1–28 · CC 1–11"


def patch_file(path, anchor, new_block):
    with open(path, encoding="utf-8") as f:
        html = f.read()

    def repl(m):
        return m.group(1) + new_block + m.group(2)

    html, count = anchor.subn(repl, html, count=1)
    if count == 0:
        print(f"  WARNING: sidebar anchor not found in {path}")
        return
    html, sub_count = html.replace(OLD_SUBTITLE, NEW_SUBTITLE), html.count(OLD_SUBTITLE)
    if sub_count == 0:
        print(f"  WARNING: subtitle not found in {path}")
    with open(path, "w", encoding="utf-8") as f:
        f.write(html)
    print(f"  patched: {path}")


print("-- termo/index.html --")
patch_file(os.path.join(REPO, "termo", "index.html"), ANCHOR_INDEX, NEW_BLOCK_INDEX)

print("-- cat_1..cat_20, cc_1..cc_7 --")
pages = [f"cat_{n}" for n in range(1, 21)] + [f"cc_{n}" for n in range(1, 8)]
for page in pages:
    patch_file(os.path.join(REPO, "termo", page, "index.html"), ANCHOR_REL, NEW_BLOCK_REL)

print("\nDone.")
