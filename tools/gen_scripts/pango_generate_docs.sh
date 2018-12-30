#!/bin/bash

# The script assumes that it resides in the tools/gen_scripts/ directory and
# the XML file will be placed in pango/src.

source "$(dirname "$0")/init_generate.sh"

out_dir="$root_dir/pango/src"

params="--with-properties --no-recursion"
for dir in "$source_prefix"/pango "$build_prefix"/pango; do
  if [ -d "$dir" ]; then
    params="$params -s $dir"
  fi
done

"$gen_docs" $params > "$out_dir/pango_docs.xml"
