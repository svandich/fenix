#!/usr/bin/env bash
# Compile Typst formula files to SVG.
# Usage: ./build.sh           → all courses
#        ./build.sh electro   → electro only
#        ./build.sh termo     → termo only

bash scripts/compile-typst.sh "$@"
