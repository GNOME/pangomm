# NMake Makefile snippet for copying the built libraries, utilities and headers to
# a path under $(PREFIX).

install: all
	@if not exist $(PREFIX)\bin\ mkdir $(PREFIX)\bin
	@if not exist $(PREFIX)\lib\pangomm-$(PANGOMM_MAJOR_VERSION).$(PANGOMM_MINOR_VERSION)\include\ mkdir $(PREFIX)\lib\pangomm-$(PANGOMM_MAJOR_VERSION).$(PANGOMM_MINOR_VERSION)\include
	@if not exist $(PREFIX)\include\pangomm-$(PANGOMM_MAJOR_VERSION).$(PANGOMM_MINOR_VERSION)\pangomm\private\ @mkdir $(PREFIX)\include\pangomm-$(PANGOMM_MAJOR_VERSION).$(PANGOMM_MINOR_VERSION)\pangomm\private
	@copy /b $(CFG)\$(PLAT)\$(PANGOMM_LIBNAME).dll $(PREFIX)\bin
	@copy /b $(CFG)\$(PLAT)\$(PANGOMM_LIBNAME).pdb $(PREFIX)\bin
	@copy /b $(CFG)\$(PLAT)\$(PANGOMM_LIBNAME).lib $(PREFIX)\lib
	@copy ..\pango\pangomm.h "$(PREFIX)\include\pangomm-$(PANGOMM_MAJOR_VERSION).$(PANGOMM_MINOR_VERSION)\"
	@for %h in ($(files_extra_h)) do @copy ..\pango\pangomm\%h "$(PREFIX)\include\pangomm-$(PANGOMM_MAJOR_VERSION).$(PANGOMM_MINOR_VERSION)\pangomm\%h"
	@for %h in ($(files_built_h)) do @if exist ..\untracked\pango\pangomm\%h copy ..\untracked\pango\pangomm\%h "$(PREFIX)\include\pangomm-$(PANGOMM_MAJOR_VERSION).$(PANGOMM_MINOR_VERSION)\pangomm\%h"
	@for %h in ($(files_built_h)) do @if exist ..\pango\pangomm\%h if not exist ..\untracked\pango\pangomm\%h copy ..\pango\pangomm\%h "$(PREFIX)\include\pangomm-$(PANGOMM_MAJOR_VERSION).$(PANGOMM_MINOR_VERSION)\pangomm\%h"
	@for %h in ($(files_built_h)) do @if exist $(CFG)\$(PLAT)\pangomm\%h copy $(CFG)\$(PLAT)\pangomm\%h "$(PREFIX)\include\pangomm-$(PANGOMM_MAJOR_VERSION).$(PANGOMM_MINOR_VERSION)\pangomm\%h"
	@for %h in ($(files_built_h)) do @if exist ..\untracked\pango\pangomm\private\%h copy ..\untracked\pango\pangomm\private\%h "$(PREFIX)\include\pangomm-$(PANGOMM_MAJOR_VERSION).$(PANGOMM_MINOR_VERSION)\pangomm\private\%h"
	@for %h in ($(PANGOMM_BUILD_PRIVATE_HEADERS)) do @if exist ..\pango\pangomm\private\%h if not exist ..\untracked\pango\pangomm\private\%h copy ..\pango\pangomm\private\%h "$(PREFIX)\include\pangomm-$(PANGOMM_MAJOR_VERSION).$(PANGOMM_MINOR_VERSION)\pangomm\private\%h"
	@for %h in ($(PANGOMM_BUILD_PRIVATE_HEADERS)) do @if exist $(CFG)\$(PLAT)\pangomm\private\%h copy $(CFG)\$(PLAT)\pangomm\private\%h "$(PREFIX)\include\pangomm-$(PANGOMM_MAJOR_VERSION).$(PANGOMM_MINOR_VERSION)\pangomm\private\%h"
	@copy ".\pangomm\pangommconfig.h" "$(PREFIX)\lib\pangomm-$(PANGOMM_MAJOR_VERSION).$(PANGOMM_MINOR_VERSION)\include\"
