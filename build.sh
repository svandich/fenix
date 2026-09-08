#!/usr/bin/env bash
# Build the static pages: Typst formulas to SVG, and inline math to MathML.
# Usage: ./build.sh           → all courses
#        ./build.sh electro   → electro only
#        ./build.sh termo     → termo only

set -e
bash scripts/compile-typst.sh "$@"
echo "── math inline ──────────────────────────"
python3 scripts/inline-mathml.py "$@"
