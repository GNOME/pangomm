# NMake Makefile portion for enabling features for Windows builds

# These are the base minimum libraries required for building pangomm.
!ifndef BASE_INCLUDEDIR
BASE_INCLUDEDIR = $(PREFIX)\include
!endif
!ifndef BASE_LIBDIR
BASE_LIBDIR = $(PREFIX)\lib
!endif

# Please do not change anything beneath this line unless maintaining the NMake Makefiles
PANGO_API_VERSION = 1.0
GLIB_API_VERSION = 2.0

PANGOMM_MAJOR_VERSION = 1
PANGOMM_MINOR_VERSION = 4
PANGOMM_API_VERSION = $(PANGOMM_MAJOR_VERSION).$(PANGOMM_MINOR_VERSION)

GLIBMM_MAJOR_VERSION = 2
GLIBMM_MINOR_VERSION = 4
GLIBMM_API_VERSION = $(GLIBMM_MAJOR_VERSION).$(GLIBMM_MINOR_VERSION)

CAIROMM_MAJOR_VERSION = 1
CAIROMM_MINOR_VERSION = 0
CAIROMM_API_VERSION = $(CAIROMM_MAJOR_VERSION).$(CAIROMM_MINOR_VERSION)

SIGC_MAJOR_VERSION = 2
SIGC_MINOR_VERSION = 0
SIGC_SERIES = $(SIGC_MAJOR_VERSION).$(SIGC_MINOR_VERSION)

OUTDIR = vs$(VSVER)\$(CFG)\$(PLAT)
DEPS_MKFILE = deps-vs$(VSVER)-$(PLAT)-$(CFG).mak
M4_PATH_MKFILE = find-m4-bindir-vs$(VSVER)-$(PLAT)-$(CFG).mak
UNIX_TOOLS_PATH_MKFILE = check-unix-tools-bindir-vs$(VSVER)-$(PLAT)-$(CFG).mak
GENERATE_CHECK_HEADER_BAT = gen-check-header-vs$(VSVER)-$(PLAT)-$(CFG).bat
BUILD_MKFILE_SNIPPET = pangomm-vs$(VSVER)-$(PLAT)-$(CFG).mak

# Gather up dependencies for their include directories and lib/bin dirs.
!if [for %t in (PANGO GLIBMM CAIROMM SIGC CAIRO HARFBUZZ GLIB) do @(echo !ifndef %t_INCLUDEDIR>>$(DEPS_MKFILE) & echo %t_INCLUDEDIR=^$^(BASE_INCLUDEDIR^)>>$(DEPS_MKFILE) & echo !endif>>$(DEPS_MKFILE))]
!endif
!if [for %t in (PANGO GLIBMM CAIROMM SIGC CAIRO HARFBUZZ GLIB) do @(echo !ifndef %t_LIBDIR>>$(DEPS_MKFILE) & echo %t_LIBDIR=^$^(BASE_LIBDIR^)>>$(DEPS_MKFILE) & echo !endif>>$(DEPS_MKFILE))]
!endif

!include $(DEPS_MKFILE)

!if [del /f/q $(DEPS_MKFILE)]
!endif

!if "$(CFG)" == "debug" || "$(CFG)" == "Debug"
DEBUG_SUFFIX = -d
!else
DEBUG_SUFFIX =
!endif

!ifndef M4
!ifdef UNIX_TOOLS_BINDIR
M4 = $(UNIX_TOOLS_BINDIR)\m4.exe
!else
M4 = m4
!endif
!endif

# Try to deduce full path to m4.exe, as needed
!if [if not exist $(M4)\ if exist $(M4) echo M4_FULL_PATH = $(M4)>$(M4_PATH_MKFILE)]
!endif
!if [if exist $(M4).exe echo M4_FULL_PATH = $(M4).exe>$(M4_PATH_MKFILE)]
!endif
!if [if not exist $(M4_PATH_MKFILE) ((echo M4_FULL_PATH = \>$(M4_PATH_MKFILE)) & where $(M4)>>$(M4_PATH_MKFILE) 2>NUL)]
!endif

!include $(M4_PATH_MKFILE)

!if [del /f/q $(M4_PATH_MKFILE)]
!endif

!if [if not "$(UNIX_TOOLS_BINDIR)" == "" if not "$(M4_FULL_PATH)" == "" echo UNIX_TOOLS_BINDIR_CHECKED = $(UNIX_TOOLS_BINDIR)>$(UNIX_TOOLS_PATH_MKFILE)]
!endif

!if [if "$(UNIX_TOOLS_BINDIR)" == "" if not "$(M4_FULL_PATH)" == "" (for %f in ($(M4_FULL_PATH)) do @echo UNIX_TOOLS_BINDIR_CHECKED = %~dpf>$(UNIX_TOOLS_PATH_MKFILE))]
!endif

!if [if not exist $(UNIX_TOOLS_PATH_MKFILE) (echo UNIX_TOOLS_BINDIR_CHECKED = >$(UNIX_TOOLS_PATH_MKFILE))]
!endif

!include $(UNIX_TOOLS_PATH_MKFILE)

!if [del /f/q $(UNIX_TOOLS_PATH_MKFILE)]
!endif

!ifndef GMMPROC_DIR
GMMPROC_DIR=$(GLIBMM_LIBDIR)\glibmm-$(GLIBMM_API_VERSION)\proc
!endif

DEP_CFLAGS =	\
	/I$(PANGO_INCLUDEDIR)\pango-$(PANGO_API_VERSION)	\
	/I$(GLIBMM_INCLUDEDIR)\giomm-$(GLIBMM_API_VERSION)	\
	/I$(GLIBMM_LIBDIR)\giomm-$(GLIBMM_API_VERSION)\include	\
	/I$(GLIBMM_INCLUDEDIR)\glibmm-$(GLIBMM_API_VERSION)	\
	/I$(GLIBMM_LIBDIR)\glibmm-$(GLIBMM_API_VERSION)\include	\
	/I$(CAIROMM_INCLUDEDIR)\cairomm-$(CAIROMM_API_VERSION)	\
	/I$(CAIROMM_LIBDIR)\cairomm-$(CAIROMM_API_VERSION)\include	\
	/I$(SIGC_INCLUDEDIR)\sigc++-$(SIGC_SERIES)	\
	/I$(SIGC_LIBDIR)\sigc++-$(SIGC_SERIES)\include	\
	/I$(GLIB_INCLUDEDIR)\glib-$(GLIB_API_VERSION)	\
	/I$(GLIB_LIBDIR)\glib-$(GLIB_API_VERSION)\include	\
	/I$(CAIRO_INCLUDEDIR)\cairo	\
	/I$(HARFBUZZ_INCLUDEDIR)\harfbuzz	\
	/I$(BASE_INCLUDEDIR)

PANGOMM_BASE_CFLAGS = /FImsvc_recommended_pragmas.h

PANGOMM_INCLUDES =	\
	/I$(OUTDIR)	\
	/I..\untracked\pango /I..\untracked\pango\pangomm		\
	/I..\pango /I..\pango\pangomm /I.\pangomm		\
	$(DEP_CFLAGS)

LIBPANGOMM_CFLAGS = /DPANGOMM_BUILD $(PANGOMM_BASE_CFLAGS)

# We build pangomm-vc$(VSVER_LIB)-$(PANGOMM_MAJOR_VERSION)_$(PANGOMM_MINOR_VERSION).dll or
#          pangomm-vc$(VSVER_LIB)-d-$(PANGOMM_MAJOR_VERSION)_$(PANGOMM_MINOR_VERSION).dll at least

!if "$(USE_COMPAT_LIBS)" != ""
VSVER_LIB = $(PDBVER)0
MESON_VSVER_LIB =
!else
VSVER_LIB = $(PDBVER)$(VSVER_SUFFIX)
MESON_VSVER_LIB = -vc$(VSVER_LIB)
!endif

!ifdef USE_MESON_LIBS

SIGC_LIBNAME = sigc-$(SIGC_SERIES)
GIOMM_LIBNAME = giomm$(MESON_VSVER_LIB)-$(GLIBMM_API_VERSION)
GLIBMM_LIBNAME = glibmm$(MESON_VSVER_LIB)-$(GLIBMM_API_VERSION)
CAIROMM_LIBNAME = cairomm$(MESON_VSVER_LIB)-$(CAIROMM_API_VERSION)
PANGOMM_LIBNAME = pangomm$(MESON_VSVER_LIB)-$(PANGOMM_API_VERSION)

PANGOMM_DLLNAME = $(PANGOMM_LIBNAME)-1
!else
SIGC_LIBNAME = sigc-vc$(PDBVER)0$(DEBUG_SUFFIX)-$(SIGC_SERIES:.=_)
GIOMM_LIBNAME = giomm-vc$(VSVER_LIB)$(DEBUG_SUFFIX)-$(GLIBMM_API_VERSION:.=_)
GLIBMM_LIBNAME = glibmm-vc$(VSVER_LIB)$(DEBUG_SUFFIX)-$(GLIBMM_API_VERSION:.=_)
CAIROMM_LIBNAME = cairomm-vc$(VSVER_LIB)$(DEBUG_SUFFIX)-$(CAIROMM_API_VERSION:.=_)
PANGOMM_LIBNAME = pangomm-vc$(VSVER_LIB)$(DEBUG_SUFFIX)-$(PANGOMM_API_VERSION:.=_)

PANGOMM_DLLNAME = $(PANGOMM_LIBNAME)
!endif

SIGC_LIB = $(SIGC_LIBNAME).lib
GIOMM_LIB = $(GIOMM_LIBNAME).lib
GLIBMM_LIB = $(GLIBMM_LIBNAME).lib
CAIROMM_LIB = $(CAIROMM_LIBNAME).lib
PANGOMM_LIB = $(OUTDIR)\$(PANGOMM_LIBNAME).lib
PANGOMM_DLL = $(OUTDIR)\$(PANGOMM_DLLNAME).dll

GENDEF = vs$(VSVER)\$(CFG)\$(PLAT)\gendef.exe
GOBJECT_LIBS = gobject-$(GLIB_API_VERSION).lib glib-$(GLIB_API_VERSION).lib
CAIRO_LIB = cairo.lib
PANGO_LIBS = pangocairo-$(PANGO_API_VERSION).lib pango-$(PANGO_API_VERSION).lib

PANGOMM_BUILD_PRIVATE_HEADERS = $(files_built_h:.h=_p.h)

DEP_LDFLAGS = $(SIGC_LIB) /libpath:$(BASE_LIBDIR)
!if "$(SIGC_LIBDIR)" != "$(BASE_LIBDIR)"
DEP_LDFLAGS = /libpath:$(SIGC_LIBDIR) $(DEP_LDFLAGS)
!endif
DEP_LDFLAGS = $(CAIRO_LIB) $(DEP_LDFLAGS)
!if "$(CAIRO_LIBDIR)" != "$(BASE_LIBDIR)"
DEP_LDFLAGS = /libpath:$(CAIRO_LIBDIR) $(DEP_LDFLAGS)
!endif
DEP_LDFLAGS = $(GOBJECT_LIBS) $(DEP_LDFLAGS)
!if "$(GLIB_LIBDIR)" != "$(BASE_LIBDIR)"
DEP_LDFLAGS = /libpath:$(GLIB_LIBDIR) $(DEP_LDFLAGS)
!endif
DEP_LDFLAGS = $(CAIROMM_LIB) $(DEP_LDFLAGS)
!if "$(CAIROMM_LIBDIR)" != "$(BASE_LIBDIR)"
DEP_LDFLAGS = /libpath:$(CAIROMM_LIBDIR) $(DEP_LDFLAGS)
!endif
DEP_LDFLAGS = $(GIOMM_LIB) $(GLIBMM_LIB) $(DEP_LDFLAGS)
!if "$(GLIBMM_LIBDIR)" != "$(BASE_LIBDIR)"
DEP_LDFLAGS = /libpath:$(GLIBMM_LIBDIR) $(DEP_LDFLAGS)
!endif
DEP_LDFLAGS = $(CAIROMM_LIB) $(DEP_LDFLAGS)
!if "$(CAIROMM_LIBDIR)" != "$(BASE_LIBDIR)"
DEP_LDFLAGS = /libpath:$(CAIROMM_LIBDIR) $(DEP_LDFLAGS)
!endif
DEP_LDFLAGS = $(PANGO_LIBS) $(DEP_LDFLAGS)
!if "$(PANGO_LIBDIR)" != "$(BASE_LIBDIR)"
DEP_LDFLAGS = /libpath:$(PANGO_LIBDIR) $(DEP_LDFLAGS)
!endif
