# Convert the source listing to object (.obj) listing in
# another NMake Makefile module, include it, and clean it up.
# This is a "fact-of-life" regarding NMake Makefiles...
# This file does not need to be changed unless one is maintaining the NMake Makefiles

# For those wanting to add things here:
# To add a list, do the following:
# # $(description_of_list)
# if [call create-lists.bat header $(makefile_snippet_file) $(variable_name)]
# endif
#
# if [call create-lists.bat file $(makefile_snippet_file) $(file_name)]
# endif
#
# if [call create-lists.bat footer $(makefile_snippet_file)]
# endif
# ... (repeat the if [call ...] lines in the above order if needed)
# !include $(makefile_snippet_file)
#
# (add the following after checking the entries in $(makefile_snippet_file) is correct)
# (the batch script appends to $(makefile_snippet_file), you will need to clear the file unless the following line is added)
#!if [del /f /q $(makefile_snippet_file)]
#!endif

# In order to obtain the .obj filename that is needed for NMake Makefiles to build DLLs/static LIBs or EXEs, do the following
# instead when doing 'if [call create-lists.bat file $(makefile_snippet_file) $(file_name)]'
# (repeat if there are multiple $(srcext)'s in $(source_list), ignore any headers):
# !if [for %c in ($(source_list)) do @if "%~xc" == ".$(srcext)" @call create-lists.bat file $(makefile_snippet_file) $(intdir)\%~nc.obj]
#
# $(intdir)\%~nc.obj needs to correspond to the rules added in build-rules-msvc.mak
# %~xc gives the file extension of a given file, %c in this case, so if %c is a.cc, %~xc means .cc
# %~nc gives the file name of a given file without extension, %c in this case, so if %c is a.cc, %~nc means a

NULL=

# Ensure we build the right generated sources for pangomm
pangomm_generated_private_headers = $(files_used_hg:.hg=_p.h)
files_extra_ph_int = $(files_extra_ph:/=\)

# For pangomm

!if [call create-lists.bat header pangomm.mak pangomm_OBJS]
!endif

!if [for %c in ($(files_built_cc)) do @if "%~xc" == ".cc" @call create-lists.bat file pangomm.mak vs^$(VSVER)\^$(CFG)\^$(PLAT)\pangomm\%~nc.obj]
!endif

!if [for %c in ($(files_extra_cc)) do @if "%~xc" == ".cc" @call create-lists.bat file pangomm.mak vs^$(VSVER)\^$(CFG)\^$(PLAT)\pangomm\%~nc.obj]
!endif

!if [@call create-lists.bat file pangomm.mak vs^$(VSVER)\^$(CFG)\^$(PLAT)\pangomm\pangomm.res]
!endif

!if [call create-lists.bat footer pangomm.mak]
!endif

!if [call create-lists.bat header pangomm.mak pangomm_real_hg]
!endif

!if [for %c in ($(files_hg)) do @call create-lists.bat file pangomm.mak ..\pango\src\%c]
!endif

!if [call create-lists.bat footer pangomm.mak]
!endif

!if [for %f in (pangomm\attributes.h) do @if not exist ..\pango\%f if not exist ..\untracked\pango\%f if not exist vs$(VSVER)\$(CFG)\$(PLAT)\%f (md vs$(VSVER)\$(CFG)\$(PLAT)\pangomm\private) & ($(PERL) -- $(GMMPROC_DIR)/gmmproc -I ../tools/m4 --defs ../pango/src attributes ../pango/src vs$(VSVER)/$(CFG)/$(PLAT)/pangomm)]
!endif

!if [for %d in (vs$(VSVER)\$(CFG)\$(PLAT)\pangomm ..\pango\pangomm ..\untracked\pango\pangomm) do @if exist %d\attributes.h call get-gmmproc-ver %d\attributes.h>>pangomm.mak]
!endif

!include pangomm.mak

!if [del /f /q pangomm.mak]
!endif

!if "$(GMMPROC_VER)" >= "2.64.3"
PANGOMM_INT_TARGET = vs$(VSVER)\$(CFG)\$(PLAT)\pangomm
PANGOMM_DEF_LDFLAG =
!else
PANGOMM_INT_TARGET = vs$(VSVER)\$(CFG)\$(PLAT)\pangomm\pangomm.def
PANGOMM_DEF_LDFLAG = /def:$(PANGOMM_INT_TARGET)
PANGOMM_BASE_CFLAGS = $(PANGOMM_BASE_CFLAGS) /DPANGOMM_USE_GENDEF
!endif
