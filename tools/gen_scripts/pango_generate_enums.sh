#!/bin/bash

# Note that JHBUILD_SOURCES should be defined to contain the path to the root
# of the jhbuild sources. The script assumes that it resides in the
# tools/gen_scripts/ directory and the defs file will be placed in pango/src.

if [ -z "$JHBUILD_SOURCES" ]; then
  echo -e "JHBUILD_SOURCES must contain the path to the jhbuild sources."
  exit 1;
fi

PREFIX="$JHBUILD_SOURCES/pango"
ROOT_DIR="$(dirname "$0")/../.."
OUT_DIR="$ROOT_DIR/pango/src"

ENUM_PL="$JHBUILD_SOURCES/glibmm/tools/enum.pl"
$ENUM_PL "$PREFIX"/pango/*.h > "$OUT_DIR"/pango_enums.defs
