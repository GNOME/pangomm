# NMake Makefile portion for code generation and
# intermediate build directory creation
# Items in here should not need to be edited unless
# one is maintaining the NMake build files.

# Create the build directories
vs$(VSVER)\$(CFG)\$(PLAT)\pangomm	\
vs$(VSVER)\$(CFG)\$(PLAT)\pangomm\private:
	@-md $@

# Generate wrap_init.cc files
vs$(VSVER)\$(CFG)\$(PLAT)\pangomm\wrap_init.cc: $(pangomm_real_hg)
	@if not exist ..\pango\pangomm\wrap_init.cc $(PERL) -- "$(GMMPROC_DIR)/generate_wrap_init.pl" --namespace=Pango --parent_dir=pangomm $(pangomm_real_hg:\=/)>$@

# Generate pre-generated resources and configuration headers (builds from GIT)
prep-git-build: pkg-ver.mak
	$(MAKE) /f Makefile.vc CFG=$(CFG) GENERATE_VERSIONED_FILES=1 pangomm\pangomm.rc pangomm\pangommconfig.h

pangomm\pangomm.rc: ..\configure.ac pangomm\pangomm.rc.in
	@if not "$(DO_REAL_GEN)" == "1" if exist pkg-ver.mak del pkg-ver.mak
	@if not exist pkg-ver.mak $(MAKE) /f Makefile.vc CFG=$(CFG) prep-git-build
	@if "$(DO_REAL_GEN)" == "1" echo Generating $@...
	@if "$(DO_REAL_GEN)" == "1" copy $@.in $@
	@if "$(DO_REAL_GEN)" == "1" $(PERL) -pi.bak -e "s/\@PANGOMM_MAJOR_VERSION\@/$(PKG_MAJOR_VERSION)/g" $@
	@if "$(DO_REAL_GEN)" == "1" $(PERL) -pi.bak -e "s/\@PANGOMM_MINOR_VERSION\@/$(PKG_MINOR_VERSION)/g" $@
	@if "$(DO_REAL_GEN)" == "1" $(PERL) -pi.bak -e "s/\@PANGOMM_MICRO_VERSION\@/$(PKG_MICRO_VERSION)/g" $@
	@if "$(DO_REAL_GEN)" == "1" $(PERL) -pi.bak -e "s/\@PACKAGE_VERSION\@/$(PKG_MAJOR_VERSION).$(PKG_MINOR_VERSION).$(PKG_MICRO_VERSION)/g" $@
	@if "$(DO_REAL_GEN)" == "1" $(PERL) -pi.bak -e "s/\@PANGOMM_MODULE_NAME\@/pangomm-$(PANGOMM_MAJOR_VERSION).$(PANGOMM_MINOR_VERSION)/g" $@
	@if "$(DO_REAL_GEN)" == "1" del $@.bak

# You may change PANGOMM_DISABLE_DEPRECATED if you know what you are doing
pangomm\pangommconfig.h: ..\configure.ac ..\pango\pangommconfig.h.in
	@if not "$(DO_REAL_GEN)" == "1" if exist pkg-ver.mak del pkg-ver.mak
	@if not exist pkg-ver.mak $(MAKE) /f Makefile.vc CFG=$(CFG) prep-git-build
	@if "$(DO_REAL_GEN)" == "1" echo Generating $@...
	@if "$(DO_REAL_GEN)" == "1" copy ..\pango\$(@F).in $@
	@if "$(DO_REAL_GEN)" == "1" $(PERL) -pi.bak -e "s/\#undef PANGOMM_DISABLE_DEPRECATED/\/\* \#undef PANGOMM_DISABLE_DEPRECATED \*\//g" $@
	@if "$(DO_REAL_GEN)" == "1" $(PERL) -pi.bak -e "s/\#undef PANGOMM_MAJOR_VERSION/\#define PANGOMM_MAJOR_VERSION $(PKG_MAJOR_VERSION)/g" $@
	@if "$(DO_REAL_GEN)" == "1" $(PERL) -pi.bak -e "s/\#undef PANGOMM_MINOR_VERSION/\#define PANGOMM_MINOR_VERSION $(PKG_MINOR_VERSION)/g" $@
	@if "$(DO_REAL_GEN)" == "1" $(PERL) -pi.bak -e "s/\#undef PANGOMM_MICRO_VERSION/\#define PANGOMM_MICRO_VERSION $(PKG_MICRO_VERSION)/g" $@
	@if "$(DO_REAL_GEN)" == "1" del $@.bak

pkg-ver.mak: ..\configure.ac
	@echo Generating version info Makefile Snippet...
	@$(PERL) -00 -ne "print if /AC_INIT\(/" $** |	\
	$(PERL) -pe "tr/, /\n/s" |	\
	$(PERL) -ne "print if 2 .. 2" |	\
	$(PERL) -ne "print /\[(.*)\]/" > ver.txt
	@echo @echo off>pkg-ver.bat
	@echo.>>pkg-ver.bat
	@echo set /p pangomm_ver=^<ver.txt>>pkg-ver.bat
	@echo for /f "tokens=1,2,3 delims=." %%%%a IN ("%pangomm_ver%") do (echo PKG_MAJOR_VERSION=%%%%a^& echo PKG_MINOR_VERSION=%%%%b^& echo PKG_MICRO_VERSION=%%%%c)^>$@>>pkg-ver.bat
	@pkg-ver.bat
	@del ver.txt pkg-ver.bat
