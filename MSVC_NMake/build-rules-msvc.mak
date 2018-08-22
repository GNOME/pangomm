# NMake Makefile portion for compilation rules
# Items in here should not need to be edited unless
# one is maintaining the NMake build files.  The format
# of NMake Makefiles here are different from the GNU
# Makefiles.  Please see the comments about these formats.

# Inference rules for compiling the .obj files.
# Used for libs and programs with more than a single source file.
# Format is as follows
# (all dirs must have a trailing '\'):
#
# {$(srcdir)}.$(srcext){$(destdir)}.obj::
# 	$(CC)|$(CXX) $(cflags) /Fo$(destdir) /c @<<
# $<
# <<
{..\pango\pangomm\}.cc{$(CFG)\$(PLAT)\pangomm\}.obj::
	$(CXX) $(LIBPANGOMM_CFLAGS) $(CFLAGS_NOGL) /Fo$(CFG)\$(PLAT)\pangomm\ /c @<<
$<
<<

{.\pangomm\}.rc{$(CFG)\$(PLAT)\pangomm\}.res:
	rc /fo$@ $<

# Rules for building .lib files
$(PANGOMM_LIB): $(PANGOMM_DLL)

# Rules for linking DLLs
# Format is as follows (the mt command is needed for MSVC 2005/2008 builds):
# $(dll_name_with_path): $(dependent_libs_files_objects_and_items)
#	link /DLL [$(linker_flags)] [$(dependent_libs)] [/def:$(def_file_if_used)] [/implib:$(lib_name_if_needed)] -out:$@ @<<
# $(dependent_objects)
# <<
# 	@-if exist $@.manifest mt /manifest $@.manifest /outputresource:$@;2
$(PANGOMM_DLL): $(CFG)\$(PLAT)\pangomm\pangomm.def $(pangomm_OBJS)
	link /DLL $(LDFLAGS_NOLTCG) $(PANGOMM_DEP_LIBS) /implib:$(PANGOMM_LIB) /def:$(CFG)\$(PLAT)\pangomm\pangomm.def -out:$@ @<<
$(pangomm_OBJS)
<<

	@-if exist $@.manifest mt /manifest $@.manifest /outputresource:$@;2

# Rules for linking Executables
# Format is as follows (the mt command is needed for MSVC 2005/2008 builds):
# $(dll_name_with_path): $(dependent_libs_files_objects_and_items)
#	link [$(linker_flags)] [$(dependent_libs)] -out:$@ @<<
# $(dependent_objects)
# <<
# 	@-if exist $@.manifest mt /manifest $@.manifest /outputresource:$@;1

# For the gendef tool
{.\gendef\}.cc{$(CFG)\$(PLAT)\}.exe:
	@if not exist $(CFG)\$(PLAT)\gendef\ $(MAKE) -f Makefile.vc CFG=$(CFG) $(CFG)\$(PLAT)\gendef
	$(CXX) $(PANGOMM_BASE_CFLAGS) $(CFLAGS) /Fo$(CFG)\$(PLAT)\gendef\ $< /link $(LDFLAGS) /out:$@

clean:
	@-del /f /q $(CFG)\$(PLAT)\*.exe
	@-del /f /q $(CFG)\$(PLAT)\*.dll
	@-del /f /q $(CFG)\$(PLAT)\*.pdb
	@-del /f /q $(CFG)\$(PLAT)\*.ilk
	@-del /f /q $(CFG)\$(PLAT)\*.exp
	@-del /f /q $(CFG)\$(PLAT)\*.lib
	@-del /f /q $(CFG)\$(PLAT)\pangomm\*.def
	@-del /f /q $(CFG)\$(PLAT)\pangomm\*.res
	@-del /f /q $(CFG)\$(PLAT)\pangomm\*.obj
	@-del /f /q $(CFG)\$(PLAT)\gendef\*.obj
	@-rd $(CFG)\$(PLAT)\pangomm
	@-rd $(CFG)\$(PLAT)\gendef
	@-del /f /q vc$(PDBVER)0.pdb
