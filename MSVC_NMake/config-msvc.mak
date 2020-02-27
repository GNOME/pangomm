# NMake Makefile portion for enabling features for Windows builds

# These are the base minimum libraries required for building pangomm.
BASE_INCLUDES =	/I$(PREFIX)\include

# Please do not change anything beneath this line unless maintaining the NMake Makefiles
PANGO_API_VERSION = 1.0
GLIB_API_VERSION = 2.0

PANGOMM_MAJOR_VERSION = 1
PANGOMM_MINOR_VERSION = 4

CAIROMM_MAJOR_VERSION = 1
CAIROMM_MINOR_VERSION = 0

GLIBMM_MAJOR_VERSION = 2
GLIBMM_MINOR_VERSION = 4

LIBSIGC_MAJOR_VERSION = 2
LIBSIGC_MINOR_VERSION = 0

!if "$(CFG)" == "debug" || "$(CFG)" == "Debug"
DEBUG_SUFFIX = -d
!else
DEBUG_SUFFIX =
!endif

!ifndef GMMPROC_DIR
GMMPROC_DIR=$(PREFIX)\share\glibmm-$(GLIBMM_MAJOR_VERSION).$(GLIBMM_MINOR_VERSION)\proc
!endif

PANGOMM_BASE_CFLAGS =			\
	/Ivs$(PDBVER)\$(CFG)\$(PLAT)	\
	/I..\pango /I..\pango\pangomm /I.\pangomm		\
	/wd4530 /EHsc	\
	/FImsvc_recommended_pragmas.h

PANGOMM_EXTRA_INCLUDES =	\
	/I$(PREFIX)\include\pango-$(PANGO_API_VERSION)	\
	/I$(PREFIX)\include\glibmm-$(GLIBMM_MAJOR_VERSION).$(GLIBMM_MINOR_VERSION)	\
	/I$(PREFIX)\lib\glibmm-$(GLIBMM_MAJOR_VERSION).$(GLIBMM_MINOR_VERSION)\include	\
	/I$(PREFIX)\include\glib-$(GLIB_API_VERSION)	\
	/I$(PREFIX)\lib\glib-$(GLIB_API_VERSION)\include	\
	/I$(PREFIX)\include\cairomm-$(CAIROMM_MAJOR_VERSION).$(CAIROMM_MINOR_VERSION)	\
	/I$(PREFIX)\lib\cairomm-$(CAIROMM_MAJOR_VERSION).$(CAIROMM_MINOR_VERSION)\include	\
	/I$(PREFIX)\include\sigc++-$(LIBSIGC_MAJOR_VERSION).$(LIBSIGC_MINOR_VERSION)	\
	/I$(PREFIX)\lib\sigc++-$(LIBSIGC_MAJOR_VERSION).$(LIBSIGC_MINOR_VERSION)\include

PANGOMM_CFLAGS = /DPANGOMM_BUILD $(PANGOMM_BASE_CFLAGS) $(PANGOMM_EXTRA_INCLUDES)

# We build pangomm-vc$(PDBVER)0-$(PANGOMM_MAJOR_VERSION)_$(PANGOMM_MINOR_VERSION).dll or
#          pangomm-vc$(PDBVER)0-d-$(PANGOMM_MAJOR_VERSION)_$(PANGOMM_MINOR_VERSION).dll at least

GLIBMM_LIBNAME = glibmm-vc$(PDBVER)0$(DEBUG_SUFFIX)-$(GLIBMM_MAJOR_VERSION)_$(GLIBMM_MINOR_VERSION)
CAIROMM_LIBNAME = cairomm-vc$(PDBVER)0$(DEBUG_SUFFIX)-$(CAIROMM_MAJOR_VERSION)_$(CAIROMM_MINOR_VERSION)
LIBSIGC_LIBNAME = sigc-vc$(PDBVER)0$(DEBUG_SUFFIX)-$(LIBSIGC_MAJOR_VERSION)_$(LIBSIGC_MINOR_VERSION)

GLIBMM_DLL = $(GLIBMM_LIBNAME).dll
GLIBMM_LIB = $(GLIBMM_LIBNAME).lib
CAIROMM_DLL = $(CAIROMM_LIBNAME).dll
CAIROMM_LIB = $(CAIROMM_LIBNAME).lib
LIBSIGC_DLL = $(LIBSIGC_LIBNAME).dll
LIBSIGC_LIB = $(LIBSIGC_LIBNAME).lib

PANGOMM_LIBNAME = pangomm-vc$(PDBVER)0$(DEBUG_SUFFIX)-$(PANGOMM_MAJOR_VERSION)_$(PANGOMM_MINOR_VERSION)

PANGOMM_DLL = vs$(PDBVER)\$(CFG)\$(PLAT)\$(PANGOMM_LIBNAME).dll
PANGOMM_LIB = vs$(PDBVER)\$(CFG)\$(PLAT)\$(PANGOMM_LIBNAME).lib

GENDEF = vs$(PDBVER)\$(CFG)\$(PLAT)\gendef.exe
GOBJECT_LIBS = gobject-$(GLIB_API_VERSION).lib glib-$(GLIB_API_VERSION).lib

PANGO_LIBS = pangocairo-$(PANGO_API_VERSION).lib pango-$(PANGO_API_VERSION).lib $(GOBJECT_LIBS) cairo.lib

PANGOMM_BUILD_PRIVATE_HEADERS = $(files_built_h:.h=_p.h)