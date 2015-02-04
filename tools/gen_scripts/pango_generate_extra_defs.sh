#!/bin/bash

# The script assumes that it resides in the tools/gen_scripts directory
# and the defs files will be placed in pango/src.
# It shall be executed from the tools/gen_scripts directory.

# To update the gtk_signals.defs file:
# 1. ./pango_generate_extra_defs.sh
#    Generates pango/src/pango_signals.defs.orig and pango/src/pango_signals.defs.
#    If any hunks from the patch file fail to apply, apply them manually to the
#    pango_signals.defs file, if required.
# 2. Optional: Remove pango/src/pango_signals.defs.orig.

# To update the pango_signals.defs file and the patch file:
# 1. Like step 1 when updating only the pango_signals.defs file.
# 2. Apply new patches manually to the pango_signals.defs file.
# 3. ./pango_generate_extra_defs.sh --make-patch
# 4. Like step 2 when updating only the pango_signals.defs file.

ROOT_DIR="$(dirname "$0")/../.."
GEN_DIR="$ROOT_DIR/tools/extra_defs_gen"
OUT_DIR="$ROOT_DIR/pango/src"
OUT_DEFS_FILE="$OUT_DIR"/pango_signals.defs

if [ $# -eq 0 ]
then
  # Without LC_ALL=C documentation (docs "xxx") may be translated in the .defs file.
  LC_ALL=C "$GEN_DIR"/generate_extra_defs > "$OUT_DEFS_FILE"
  # PATCH_OPTIONS="--backup --version-control=simple --suffix=.orig"
  # patch $PATCH_OPTIONS "$OUT_DEFS_FILE" "$OUT_DEFS_FILE".patch
elif [ "$1" = "--make-patch" ]
then
  diff --unified=10 "$OUT_DEFS_FILE".orig "$OUT_DEFS_FILE" > "$OUT_DEFS_FILE".patch
else
  echo "Usage: $0 [--make-patch]"
  exit 1
fi

