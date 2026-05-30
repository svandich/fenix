#!/usr/bin/env python3
"""Replace $$...$$ display-math divs in aux HTML files with Typst SVG images."""

import re
import os

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

COURSES = {
    "electro": range(1, 17),
    "termo":   range(1, 13),
}

PATTERN = re.compile(
    r'<div class="formula-math">\$\$.*?\$\$</div>',
    re.DOTALL,
)

def process(course, n):
    path = os.path.join(REPO, course, f"aux_{n}.html")
    if not os.path.exists(path):
        print(f"  SKIP (not found): {path}")
        return

    with open(path, encoding="utf-8") as f:
        html = f.read()

    counter = [0]

    def replacement(_m):
        counter[0] += 1
        p = counter[0]
        src = f"../typst-out/{course}/aux_{n}_{p}.svg"
        return f'<div class="formula-math"><img class="typst-formula" src="{src}" alt=""></div>'

    new_html, count = PATTERN.subn(replacement, html)
    if count == 0:
        print(f"  WARNING: no formulas found in {course}/aux_{n}.html")
        return

    # Remove MathJax display math processing (keep inline $...$ for descriptions)
    # MathJax is still needed for inline math — keep the script tag, just done.

    with open(path, "w", encoding="utf-8") as f:
        f.write(new_html)

    print(f"  {course}/aux_{n}.html → {count} formula(s) replaced")

for course, nums in COURSES.items():
    print(f"\n── {course} ──")
    for n in nums:
        process(course, n)

print("\nDone.")
