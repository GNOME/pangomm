## Copyright (c) 2009  Openismus GmbH  <http://www.openismus.com/>
##
## This file is part of pangomm.
##
## pangomm is free software: you can redistribute it and/or modify it
## under the terms of the GNU Lesser General Public License as published
## by the Free Software Foundation, either version 2.1 of the License,
## or (at your option) any later version.
##
## pangomm is distributed in the hope that it will be useful, but
## WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
## See the GNU Lesser General Public License for more details.
##
## You should have received a copy of the GNU Lesser General Public License
## along with this library.  If not, see <http://www.gnu.org/licenses/>.

AC_INIT([pangomm], [2.56.1],
        [https://gitlab.gnome.org/GNOME/pangomm/issues/],
        [pangomm], [https://gtkmm.gnome.org/])
AC_PREREQ([2.59])

AC_CONFIG_SRCDIR([pango/pangomm.h])
AC_CONFIG_AUX_DIR([build])
AC_CONFIG_MACRO_DIR([build])
AC_CONFIG_HEADERS([config.h pango/pangommconfig.h])

AM_INIT_AUTOMAKE([1.9 -Wno-portability check-news dist-bzip2 no-define nostdinc tar-ustar foreign])
# Support silent build rules.
# Disable by either passing --disable-silent-rules to configure or passing V=1 to make.
m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])
AM_MAINTAINER_MODE
AC_ARG_VAR([ACLOCAL_FLAGS], [aclocal flags, e.g. -I <macro dir>])

MM_PREREQ([0.9.12])
MM_INIT_MODULE([pangomm-2.48])

# Copy the mm-common .pl scripts into docs/,
# and use them from there,
# so we can dist them to avoid a tarball-build dependency.
MM_CONFIG_DOCTOOL_DIR([docs])

# http://www.gnu.org/software/libtool/manual/html_node/Updating-version-info.html
AC_SUBST([LIBPANGOMM_SO_VERSION], [1:30:0])

AC_PROG_CXX
MM_AX_CXX_COMPILE_STDCXX([17], [noext], [mandatory])

AC_DISABLE_STATIC
LT_INIT([win32-dll])

AC_SUBST([PANGOMM_MODULES], ['giomm-2.68 >= 2.68.0 cairomm-1.16 >= 1.15.1 pangocairo >= 1.56.0'])
AC_SUBST([MSVC_TOOLSET_VER], [''])
PKG_CHECK_MODULES([PANGOMM], [$PANGOMM_MODULES])

MM_PKG_CONFIG_SUBST([GTHREAD_CFLAGS], [--cflags-only-other gthread-2.0])
MM_PKG_CONFIG_SUBST([GMMPROC_DIR], [--variable=gmmprocdir glibmm-2.68])

MM_ARG_DISABLE_DEPRECATED_API
MM_ARG_ENABLE_DOCUMENTATION
MM_ARG_WITH_TAGFILE_DOC([libstdc++.tag], [mm-common-libstdc++])
MM_ARG_WITH_TAGFILE_DOC([libsigc++-3.0.tag], [sigc++-3.0])
MM_ARG_WITH_TAGFILE_DOC([glibmm-2.68.tag], [glibmm-2.68])
MM_ARG_WITH_TAGFILE_DOC([cairomm-1.16.tag], [cairomm-1.16])

AC_LANG([C++])
MM_ARG_ENABLE_WARNINGS([PANGOMM_WXXFLAGS],
                       [-Wall],
                       [-pedantic -Wall -Wextra -Wformat-security -Wsuggest-override -Wshadow -Wno-long-long],
                       [G PANGO GLIBMM])

AC_CONFIG_FILES([Makefile
                 tools/Makefile
                 pango/${PANGOMM_MODULE_NAME}.pc:pango/pangomm.pc.in
                 pango/${PANGOMM_MODULE_NAME}-uninstalled.pc:pango/pangomm-uninstalled.pc.in
                 pango/src/Makefile
                 pango/pangomm/Makefile
                 docs/Makefile
                 docs/reference/Doxyfile
                 MSVC_NMake/pangomm/pangomm.rc])

# Copy the generated configuration headers into the MSVC project directories.
AC_CONFIG_COMMANDS([MSVC_NMake/pangomm/pangommconfig.h],
                   [cp -f pango/pangommconfig.h MSVC_NMake/pangomm/pangommconfig.h])
AC_OUTPUT
