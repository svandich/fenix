#!/usr/bin/env bash
# Compile Typst formula files to SVG.
# Usage: ./scripts/compile-typst.sh           → all courses
#        ./scripts/compile-typst.sh electro   → electro only
#        ./scripts/compile-typst.sh termo     → termo only

set -e
cd "$(dirname "$0")/.."

COURSES=("electro" "termo")
if [ -n "$1" ]; then
  COURSES=("$1")
fi

for course in "${COURSES[@]}"; do
  echo "── $course ──────────────────────────────"
  for f in "typst/$course"/aux_*.typ; do
    [ -f "$f" ] || continue
    base=$(basename "$f" .typ)
    mkdir -p "$course/$base"
    typst compile "$f" "$course/$base/${base}_{p}.svg" 2>&1 \
      | grep -v 'is deprecated' || true
    echo "  compiled: $base"
  done
done
echo "Done."
