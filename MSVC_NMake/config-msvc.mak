# NMake Makefile portion for enabling features for Windows builds

# These are the base minimum libraries required for building pangomm.
BASE_INCLUDES =	/I$(PREFIX)\include

# Please do not change anything beneath this line unless maintaining the NMake Makefiles
PANGO_API_VERSION = 1.0
PANGOMM_MAJOR_VERSION = 2
PANGOMM_MINOR_VERSION = 44

GLIB_API_VERSION = 2.0

LIBSIGC_MAJOR_VERSION = 3
LIBSIGC_MINOR_VERSION = 0
GLIBMM_MAJOR_VERSION = 2
GLIBMM_MINOR_VERSION = 66
CAIROMM_MAJOR_VERSION = 1
CAIROMM_MINOR_VERSION = 16


!if "$(CFG)" == "debug" || "$(CFG)" == "Debug"
DEBUG_SUFFIX = -d
!else
DEBUG_SUFFIX =
!endif

!ifndef GMMPROC_DIR
GMMPROC_DIR=$(PREFIX)\share\glibmm-$(GLIBMM_MAJOR_VERSION).$(GLIBMM_MINOR_VERSION)\proc
!endif

PANGOMM_BASE_CFLAGS =			\
	/Ivs$(VSVER)\$(CFG)\$(PLAT)	\
	/I..\untracked\pango /I..\untracked\pango\pangomm		\
	/I..\pango /I..\pango\pangomm /I.\pangomm		\
	/wd4530 /wd4251 /wd4275 /std:c++17 /utf-8	\
	/FImsvc_recommended_pragmas.h

PANGOMM_EXTRA_INCLUDES =	\
	/I$(PREFIX)\include\pango-$(PANGO_API_VERSION)	\
	/I$(PREFIX)\include\glibmm-$(GLIBMM_MAJOR_VERSION).$(GLIBMM_MINOR_VERSION)	\
	/I$(PREFIX)\lib\glibmm-$(GLIBMM_MAJOR_VERSION).$(GLIBMM_MINOR_VERSION)\include	\
	/I$(PREFIX)\include\cairomm-$(CAIROMM_MAJOR_VERSION).$(CAIROMM_MINOR_VERSION)	\
	/I$(PREFIX)\lib\cairomm-$(CAIROMM_MAJOR_VERSION).$(CAIROMM_MINOR_VERSION)\include	\
	/I$(PREFIX)\include\glib-$(GLIB_API_VERSION)	\
	/I$(PREFIX)\lib\glib-$(GLIB_API_VERSION)\include	\
	/I$(PREFIX)\include\sigc++-$(LIBSIGC_MAJOR_VERSION).$(LIBSIGC_MINOR_VERSION)	\
	/I$(PREFIX)\lib\sigc++-$(LIBSIGC_MAJOR_VERSION).$(LIBSIGC_MINOR_VERSION)\include	\
	/I$(PREFIX)\include\harfbuzz	\
	/I$(PREFIX)\include

LIBPANGOMM_CFLAGS = /DPANGOMM_BUILD $(PANGOMM_BASE_CFLAGS) $(PANGOMM_EXTRA_INCLUDES)

# We build pangomm-vc$(VSVER_LIB)-$(PANGOMM_MAJOR_VERSION)_$(PANGOMM_MINOR_VERSION).dll or
#          pangomm-vc$(VSVER_LIB)-d-$(PANGOMM_MAJOR_VERSION)_$(PANGOMM_MINOR_VERSION).dll at least

!if $(VSVER) > 14 && "$(USE_COMPAT_LIBS)" != ""
VSVER_LIB = 150
MESON_VSVER_LIB =
!else
VSVER_LIB = $(PDBVER)$(VSVER_SUFFIX)
MESON_VSVER_LIB = -vc$(VSVER_LIB)
!endif

!ifdef USE_MESON_LIBS
LIBSIGC_LIBNAME = sigc-$(LIBSIGC_MAJOR_VERSION).$(LIBSIGC_MINOR_VERSION)
GLIBMM_LIBNAME = glibmm$(MESON_VSVER_LIB)-$(GLIBMM_MAJOR_VERSION).$(GLIBMM_MINOR_VERSION)
CAIROMM_LIBNAME = cairomm$(MESON_VSVER_LIB)-$(CAIROMM_MAJOR_VERSION).$(CAIROMM_MINOR_VERSION)
LIBSIGC_DLL = $(LIBSIGC_LIBNAME)-0.dll
GLIBMM_DLL = $(GLIBMM_LIBNAME)-1.dll
CAIROMM_DLL = $(CAIROMM_LIBNAME)-1.dll
!else
LIBSIGC_LIBNAME = sigc-vc$(VSVER_LIB)$(DEBUG_SUFFIX)-$(LIBSIGC_MAJOR_VERSION)_$(LIBSIGC_MINOR_VERSION)
GLIBMM_LIBNAME = glibmm-vc$(VSVER_LIB)$(DEBUG_SUFFIX)-$(GLIBMM_MAJOR_VERSION)_$(GLIBMM_MINOR_VERSION)
CAIROMM_LIBNAME = cairomm-vc$(VSVER_LIB)$(DEBUG_SUFFIX)-$(CAIROMM_MAJOR_VERSION)_$(CAIROMM_MINOR_VERSION)
LIBSIGC_DLL = $(LIBSIGC_LIBNAME).dll
GLIBMM_DLL = $(GLIBMM_LIBNAME).dll
CAIROMM_DLL = $(CAIROMM_LIBNAME).dll
!endif

LIBSIGC_LIB = $(LIBSIGC_LIBNAME).lib
GLIBMM_LIB = $(GLIBMM_LIBNAME).lib
CAIROMM_LIB = $(CAIROMM_LIBNAME).lib

PANGOMM_LIBNAME = pangomm-vc$(VSVER_LIB)$(DEBUG_SUFFIX)-$(PANGOMM_MAJOR_VERSION)_$(PANGOMM_MINOR_VERSION)

PANGOMM_DLL = vs$(VSVER)\$(CFG)\$(PLAT)\$(PANGOMM_LIBNAME).dll
PANGOMM_LIB = vs$(VSVER)\$(CFG)\$(PLAT)\$(PANGOMM_LIBNAME).lib

GOBJECT_LIBS = gobject-$(GLIB_API_VERSION).lib glib-$(GLIB_API_VERSION).lib
CAIRO_LIB = cairo.lib
PANGO_LIBS = pangocairo-$(PANGO_API_VERSION).lib pango-$(PANGO_API_VERSION).lib $(GOBJECT_LIBS) $(CAIRO_LIB)
PANGOMM_DEP_LIBS = $(GLIBMM_LIB) $(CAIROMM_LIB) $(LIBSIGC_LIB) $(PANGO_LIBS)
