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

AC_INIT([pangomm], [2.24.0], [http://bugzilla.gnome.org/enter_bug.cgi?product=pangomm],
        [pangomm], [http://www.gtkmm.org/])
AC_PREREQ([2.59])

AC_CONFIG_SRCDIR([pango/pangomm.h])
AC_CONFIG_AUX_DIR([scripts])
AC_CONFIG_MACRO_DIR([scripts])
AC_CONFIG_HEADERS([config.h pango/pangommconfig.h])

MM_INIT_MODULE([pangomm-1.4], m4_expand([AC_PACKAGE_VERSION]))

# http://www.gnu.org/software/libtool/manual/html_node/Updating-version-info.html
AC_SUBST([LIBPANGOMM_SO_VERSION], [1:30:0])

AM_INIT_AUTOMAKE([1.9 -Wno-portability dist-bzip2 no-define nostdinc tar-pax])
AM_MAINTAINER_MODE
AC_ARG_VAR([ACLOCAL_FLAGS], [aclocal flags, e.g. -I <macro dir>])

AC_PROG_CXX
AC_DISABLE_STATIC
AC_LIBTOOL_WIN32_DLL
AC_PROG_LIBTOOL

AC_SUBST([PANGOMM_MODULES], ['glibmm-2.4 >= 2.14.1 cairomm-1.0 >= 1.2.2 pangocairo >= 1.23.0'])
PKG_CHECK_MODULES([PANGOMM], [$PANGOMM_MODULES])

MM_PKG_CONFIG_SUBST([GTHREAD_CFLAGS], [--cflags-only-other gthread-2.0])
MM_PKG_CONFIG_SUBST([GMMPROC_DIR], [--variable=gmmprocdir glibmm-2.4])

AC_LANG([C++])

MM_ARG_ENABLE_WARNINGS([PANGOMM_WXXFLAGS],
                       [-Wall],
                       [-pedantic -Wall -Wextra],
                       [G PANGO])

AC_ARG_ENABLE([deprecated-api],
              [AS_HELP_STRING([--disable-deprecated-api],
                              [omit deprecated API from the library])],
              [pangomm_deprecated_api=$enableval],
              [pangomm_deprecated_api=yes])
AS_IF([test "x$pangomm_deprecated_api" = xyes],
[
  AC_MSG_NOTICE([[Deprecated API will be built, for backwards-compatibility.]])
  DISABLE_DEPRECATED_API_CFLAGS=dnl
], [
  AC_MSG_WARN([[Deprecated API will not be built, breaking backwards-compatibility.
Do not use this option for distribution packages.]])
  DISABLE_DEPRECATED_API_CFLAGS='-DPANGOMM_DISABLE_DEPRECATED'dnl
])
AC_SUBST([DISABLE_DEPRECATED_API_CFLAGS])

AC_CONFIG_FILES([
  Makefile

  pango/pangomm-1.4.pc
    pango/src/Makefile
    pango/pangomm/Makefile

  tools/Makefile

  MSVC_Net2005/Makefile
    MSVC_Net2005/gendef/Makefile
    MSVC_Net2005/pangomm/Makefile
    MSVC_Net2005/pangomm/pangomm.rc
  MSVC_Net2008/Makefile
    MSVC_Net2008/gendef/Makefile
    MSVC_Net2008/pangomm/Makefile
    MSVC_Net2008/pangomm/pangomm.rc
])

AC_CONFIG_FILES([
  scripts/Makefile
])

AC_OUTPUT
