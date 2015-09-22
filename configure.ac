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

AC_INIT([pangomm], [2.38.1],
        [http://bugzilla.gnome.org/enter_bug.cgi?product=pangomm],
        [pangomm], [http://www.gtkmm.org/])
AC_PREREQ([2.59])

AC_CONFIG_SRCDIR([pango/pangomm.h])
AC_CONFIG_AUX_DIR([build])
AC_CONFIG_MACRO_DIR([build])
AC_CONFIG_HEADERS([config.h pango/pangommconfig.h])

AM_INIT_AUTOMAKE([1.9 -Wno-portability check-news dist-bzip2 no-define nostdinc tar-ustar])
m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES])
AM_MAINTAINER_MODE
AC_ARG_VAR([ACLOCAL_FLAGS], [aclocal flags, e.g. -I <macro dir>])

MM_PREREQ([0.9.8])
MM_INIT_MODULE([pangomm-1.4])

# Copy the mm-common .pl scripts into docs/,
# and use them from there,
# so we can dist them to avoid a tarball-build dependency.
MM_CONFIG_DOCTOOL_DIR([docs])

# http://www.gnu.org/software/libtool/manual/html_node/Updating-version-info.html
AC_SUBST([LIBPANGOMM_SO_VERSION], [1:30:0])

AC_PROG_CXX
MM_AX_CXX_COMPILE_STDCXX_11([noext],[mandatory])

AC_DISABLE_STATIC
LT_INIT([win32-dll])

AC_SUBST([PANGOMM_MODULES], ['glibmm-2.4 >= 2.46.1 cairomm-1.0 >= 1.12.0 pangocairo >= 1.38.0'])
PKG_CHECK_MODULES([PANGOMM], [$PANGOMM_MODULES])

MM_PKG_CONFIG_SUBST([GTHREAD_CFLAGS], [--cflags-only-other gthread-2.0])
MM_PKG_CONFIG_SUBST([GMMPROC_DIR], [--variable=gmmprocdir glibmm-2.4])

MM_ARG_DISABLE_DEPRECATED_API
MM_ARG_ENABLE_DOCUMENTATION
MM_ARG_WITH_TAGFILE_DOC([libstdc++.tag], [mm-common-libstdc++])
MM_ARG_WITH_TAGFILE_DOC([libsigc++-2.0.tag], [sigc++-2.0])
MM_ARG_WITH_TAGFILE_DOC([glibmm-2.4.tag], [glibmm-2.4])
MM_ARG_WITH_TAGFILE_DOC([cairomm-1.0.tag], [cairomm-1.0])

AC_LANG([C++])
MM_ARG_ENABLE_WARNINGS([PANGOMM_WXXFLAGS],
                       [-Wall],
                       [-pedantic -Wall -Wextra -Wno-long-long -DGSEAL_ENABLE],
                       [G PANGO GLIBMM])

AC_CONFIG_FILES([Makefile
                 tools/Makefile
                 pango/${PANGOMM_MODULE_NAME}.pc:pango/pangomm.pc.in
                 pango/${PANGOMM_MODULE_NAME}-uninstalled.pc:pango/pangomm-uninstalled.pc.in
                 pango/src/Makefile
                 pango/pangomm/Makefile
                 docs/Makefile
                 docs/reference/Doxyfile
                 MSVC_Net2013/pangomm/pangomm.rc])

# Copy the generated configuration headers into the MSVC project directories.
AC_CONFIG_COMMANDS([MSVC_Net2013/pangomm/pangommconfig.h],
                   [cp -f pango/pangommconfig.h MSVC_Net2013/pangomm/pangommconfig.h])
AC_OUTPUT
