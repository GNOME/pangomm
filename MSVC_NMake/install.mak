# NMake Makefile snippet for copying the built libraries, utilities and headers to
# a path under $(PREFIX).

install: all
	@if not exist $(PREFIX)\bin\ mkdir $(PREFIX)\bin
	@if not exist $(PREFIX)\lib\pangomm-$(PANGOMM_MAJOR_VERSION).$(PANGOMM_MINOR_VERSION)\include\ mkdir $(PREFIX)\lib\pangomm-$(PANGOMM_MAJOR_VERSION).$(PANGOMM_MINOR_VERSION)\include
	@if not exist $(PREFIX)\include\pangomm-$(PANGOMM_MAJOR_VERSION).$(PANGOMM_MINOR_VERSION)\pangomm\private\ @mkdir $(PREFIX)\include\pangomm-$(PANGOMM_MAJOR_VERSION).$(PANGOMM_MINOR_VERSION)\pangomm\private
	@if not exist $(PREFIX)\lib\pangomm-$(PANGOMM_MAJOR_VERSION).$(PANGOMM_MINOR_VERSION)\proc\m4\ @mkdir $(PREFIX)\lib\pangomm-$(PANGOMM_MAJOR_VERSION).$(PANGOMM_MINOR_VERSION)\proc\m4
	@copy /b $(OUTDIR)\$(PANGOMM_LIBNAME).dll $(PREFIX)\bin
	@copy /b $(OUTDIR)\$(PANGOMM_LIBNAME).pdb $(PREFIX)\bin
	@copy /b $(OUTDIR)\$(PANGOMM_LIBNAME).lib $(PREFIX)\lib
	@copy ..\pango\pangomm.h "$(PREFIX)\include\pangomm-$(PANGOMM_MAJOR_VERSION).$(PANGOMM_MINOR_VERSION)\"
	@for %h in ($(files_built_h) $(files_extra_h)) do @if exist ..\untracked\pango\pangomm\%h copy ..\untracked\pango\pangomm\%h "$(PREFIX)\include\pangomm-$(PANGOMM_MAJOR_VERSION).$(PANGOMM_MINOR_VERSION)\pangomm\%h"
	@for %h in ($(files_built_h) $(files_extra_h)) do @if exist ..\pango\pangomm\%h if not exist ..\untracked\pango\pangomm\%h copy ..\pango\pangomm\%h "$(PREFIX)\include\pangomm-$(PANGOMM_MAJOR_VERSION).$(PANGOMM_MINOR_VERSION)\pangomm\%h"
	@for %h in ($(files_built_h) $(files_extra_h)) do @if exist $(OUTDIR)\pangomm\%h copy $(OUTDIR)\pangomm\%h "$(PREFIX)\include\pangomm-$(PANGOMM_MAJOR_VERSION).$(PANGOMM_MINOR_VERSION)\pangomm\%h"
	@for %h in ($(pangomm_generated_private_headers)) do @if exist ..\untracked\pango\pangomm\private\%h copy ..\untracked\pango\pangomm\private\%h "$(PREFIX)\include\pangomm-$(PANGOMM_MAJOR_VERSION).$(PANGOMM_MINOR_VERSION)\pangomm\private\%h"
	@for %h in ($(pangomm_generated_private_headers)) do @if exist ..\pango\pangomm\private\%h if not exist ..\pango\pangomm\private\%h copy ..\pango\pangomm\private\%h "$(PREFIX)\include\pangomm-$(PANGOMM_MAJOR_VERSION).$(PANGOMM_MINOR_VERSION)\pangomm\private\%h"
	@for %h in ($(pangomm_generated_private_headers)) do @if exist $(OUTDIR)\pangomm\private\%h copy $(OUTDIR)\pangomm\private\%h "$(PREFIX)\include\pangomm-$(PANGOMM_MAJOR_VERSION).$(PANGOMM_MINOR_VERSION)\pangomm\private\%h"
	@copy ".\pangomm\pangommconfig.h" "$(PREFIX)\lib\pangomm-$(PANGOMM_MAJOR_VERSION).$(PANGOMM_MINOR_VERSION)\include\"
	@copy ..\tools\m4\*.m4 $(PREFIX)\lib\pangomm-$(PANGOMM_MAJOR_VERSION).$(PANGOMM_MINOR_VERSION)\proc\m4
