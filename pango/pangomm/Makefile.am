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

lib_LTLIBRARIES = libpangomm-@PANGOMM_API_VERSION@.la

include $(srcdir)/../src/filelist.am
include $(srcdir)/filelist.gmake.am

include $(top_srcdir)/build/compile-binding.am

local_cppflags = $(binding_includes) $(binding_cppflags) -DPANGOMM_BUILD=1

AM_CPPFLAGS = $(local_cppflags) $(GTHREAD_CFLAGS) $(PANGOMM_CFLAGS)
AM_CXXFLAGS = $(PANGOMM_WXXFLAGS)

libpangomm_@PANGOMM_API_VERSION@_la_SOURCES = $(binding_sources)
libpangomm_@PANGOMM_API_VERSION@_la_LDFLAGS = -no-undefined -version-info $(LIBPANGOMM_SO_VERSION)
libpangomm_@PANGOMM_API_VERSION@_la_LIBADD  = $(PANGOMM_LIBS)
