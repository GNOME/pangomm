#!/bin/bash

# Regenerate all pangomm's docs.xml and .defs files

./pango_generate_docs.sh
./pango_generate_enums.sh
./pango_generate_extra_defs.sh
./pango_generate_methods.sh
