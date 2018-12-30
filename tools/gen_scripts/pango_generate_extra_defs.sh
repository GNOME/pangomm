#!/bin/bash

# The script assumes that it resides in the tools/gen_scripts directory
# and the defs files will be placed in pango/src.

source "$(dirname "$0")/init_generate.sh"

out_dir="$root_dir/pango/src"

# Without LC_ALL=C documentation (docs "xxx") may be translated in the .defs file.
LC_ALL=C "$extra_defs_gen_dir"/generate_extra_defs > "$out_dir"/pango_signals.defs
