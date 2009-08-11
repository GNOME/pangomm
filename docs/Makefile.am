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

include $(top_srcdir)/pango/src/filelist.am
include $(top_srcdir)/pango/pangomm/filelist.am

pangomm_files_h = $(files_built_h) $(filter-out wrap_init.h,$(files_extra_h))

book_name = $(PANGOMM_MODULE_NAME)
doc_input = $(addprefix $(top_srcdir)/pango/pangomm/,$(pangomm_files_h))

# Override the web location to use the old-style path with redundant
# directory components.
htmlrefpub = http://www.gtkmm.org/docs/$(book_name)/docs/reference/html

docimagesdir = $(libdocdir)/images
dist_docimages_DATA = images/gtkmm_logo.gif images/top.gif

include $(top_srcdir)/scripts/doc-reference.am

dist_noinst_DATA +=				\
	reference/pangomm_header.html_fragment	\
	reference/pangomm_footer.html_fragment
