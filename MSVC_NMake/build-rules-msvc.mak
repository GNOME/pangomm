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
{$(OUTDIR)\pangomm\}.cc{$(OUTDIR)\pangomm\}.obj::
	$(CXX) $(CFLAGS) $(LIBPANGOMM_CFLAGS) $(PANGOMM_INCLUDES) /Fo$(OUTDIR)\pangomm\ /Fd$(OUTDIR)\pangomm\ /c @<<
$<
<<

{..\untracked\pango\pangomm\}.cc{$(OUTDIR)\pangomm\}.obj::
	$(CXX) $(CFLAGS) $(LIBPANGOMM_CFLAGS) $(PANGOMM_INCLUDES) /Fo$(OUTDIR)\pangomm\ /Fd$(OUTDIR)\pangomm\ /c @<<
$<
<<

{..\pango\pangomm\}.cc{$(OUTDIR)\pangomm\}.obj::
	$(CXX) $(CFLAGS) $(LIBPANGOMM_CFLAGS) $(PANGOMM_INCLUDES) /Fo$(OUTDIR)\pangomm\ /Fd$(OUTDIR)\pangomm\ /c @<<
$<
<<

{..\pango\src\}.ccg{$(OUTDIR)\pangomm\}.obj:
	@if not exist $(@D)\private\ md $(@D)\private
	@if not exist pangomm\pangommconfig.h $(MAKE) /f Makefile.vc CFG=$(CFG) prep-git-build
	@if "$(UNIX_TOOLS_BINDIR_CHECKED)" == "" echo Warning: m4 is not in %PATH% or specified M4 or UNIX_TOOLS_BINDIR is not valid. Builds may fail!
	@set PATH=$(PATH);$(UNIX_TOOLS_BINDIR_CHECKED)
	@for %%s in ($(<D)\*.ccg) do @if not exist ..\pango\pangomm\%%~ns.cc if not exist $(@D)\%%~ns.cc $(PERL) -- $(GMMPROC_DIR)/gmmproc -I ../tools/m4 --defs $(<D:\=/) %%~ns $(<D:\=/) $(@D)
	@if exist $(@D)\$(<B).cc $(CXX) $(CFLAGS) $(LIBPANGOMM_CFLAGS) $(PANGOMM_INCLUDES) /Fo$(@D)\ /Fd$(@D)\ /c $(@D)\$(<B).cc
	@if exist ..\pango\pangomm\$(<B).cc $(CXX) $(CFLAGS) $(LIBPANGOMM_CFLAGS) $(PANGOMM_INCLUDES) /Fo$(@D)\ /Fd$(@D)\ /c ..\pango\pangomm\$(<B).cc
	@if exist ..\untracked\pango\pangomm\$(<B).cc $(CXX) $(CFLAGS) $(LIBPANGOMM_CFLAGS) $(PANGOMM_INCLUDES) /Fo$(@D)\ /Fd$(@D)\ /c ..\pango\pangomm\$(<B).cc

{.\pangomm\}.rc{$(OUTDIR)\pangomm\}.res:
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
$(PANGOMM_DLL): $(OUTDIR)\pangomm $(pangomm_OBJS)
	link /DLL $(LDFLAGS) $(DEP_LDFLAGS) /implib:$(PANGOMM_LIB) -out:$@ @<<
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

clean:
	@-del /f /q $(OUTDIR)\*.exe
	@-del /f /q $(OUTDIR)\*.dll
	@-del /f /q $(OUTDIR)\*.pdb
	@-del /f /q $(OUTDIR)\*.ilk
	@-del /f /q $(OUTDIR)\*.exp
	@-del /f /q $(OUTDIR)\*.lib
	@-del /f /q $(OUTDIR)\pangomm\*.res
	@-del /f /q $(OUTDIR)\pangomm\*.pdb
	@-del /f /q $(OUTDIR)\pangomm\*.obj
	@-del /f /q $(OUTDIR)\pangomm\private\*.h
	@-del /f /q $(OUTDIR)\pangomm\*.h
	@-del /f /q $(OUTDIR)\pangomm\*.cc
	@-rd $(OUTDIR)\pangomm\private
	@-rd $(OUTDIR)\pangomm

.SUFFIXES: .cc .h .ccg .hg .obj
