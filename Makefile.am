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

ACLOCAL_AMFLAGS = -I build ${ACLOCAL_FLAGS}
DISTCHECK_CONFIGURE_FLAGS = --enable-warnings=fatal

if MAINTAINER_MODE
src_subdirs = pango/src
else
src_subdirs =
endif
if ENABLE_DOCUMENTATION
doc_subdirs = docs
else
doc_subdirs =
endif
SUBDIRS = tools $(src_subdirs) pango/pangomm $(doc_subdirs)

pangomm_includedir = $(includedir)/$(PANGOMM_MODULE_NAME)
pangomm_include_HEADERS = pango/pangomm.h
pangomm_libincludedir = $(libdir)/$(PANGOMM_MODULE_NAME)/include
nodist_pangomm_libinclude_HEADERS = pango/pangommconfig.h

pkgconfigdir = $(libdir)/pkgconfig
nodist_pkgconfig_DATA = pango/$(PANGOMM_MODULE_NAME).pc

include $(srcdir)/MSVC_Net2005/filelist.am
include $(srcdir)/MSVC_Net2008/filelist.am
include $(srcdir)/MSVC_Net2010/filelist.am

text_files = COPYING.tools README.SUN README.win32
msvc_files = $(addprefix MSVC_Net2005/,$(msvc_net2005_data)) \
             $(addprefix MSVC_Net2008/,$(msvc_net2008_data)) \
             $(addprefix MSVC_Net2010/,$(msvc_net2010_data))

dist_noinst_DATA = $(text_files) $(msvc_files)
dist_noinst_SCRIPTS = autogen.sh

DISTCLEANFILES = MSVC_Net2005/pangomm/pangommconfig.h MSVC_Net2008/pangomm/pangommconfig.h MSVC_Net2010/pangomm/pangommconfig.h
