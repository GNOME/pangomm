#!/bin/bash

# Regenerate all pangomm's docs.xml and .defs files

cd "$(dirname "$0")"

echo === pango_generate_docs.sh ===
./pango_generate_docs.sh
echo === pango_generate_enums.sh ===
./pango_generate_enums.sh
echo === pango_generate_extra_defs.sh ===
./pango_generate_extra_defs.sh
echo === pango_generate_methods.sh ===
./pango_generate_methods.sh
