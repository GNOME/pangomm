#!/bin/bash

# The script assumes that it resides in the tools/gen_scripts/ directory
# and the defs file will be placed in pango/src.

source "$(dirname "$0")/init_generate.sh"

out_dir="$root_dir/pango/src"

shopt -s extglob # Enable extended pattern matching
shopt -s nullglob # Skip a filename pattern that matches no file
# Process files whose names end with .h, but not with private.h or internal.h.
"$gen_methods" "$source_prefix"/pango/!(*private|*internal).h "$build_prefix"/pango/!(*private).h > "$out_dir"/pango_methods.defs
