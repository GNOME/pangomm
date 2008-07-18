# Build the generate_properties_defs utility executable.
# This is not used to build the rest of pangomm.

INCLUDES = $(PANGOMM_CFLAGS)
LIBS = $(PANGOMM_LIBS) -lglibmm_generate_extra_defs-2.4

noinst_PROGRAMS = generate_extra_defs
generate_extra_defs_SOURCES = generate_defs_pango.cc
