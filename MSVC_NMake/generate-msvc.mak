# NMake Makefile portion for code generation and
# intermediate build directory creation
# Items in here should not need to be edited unless
# one is maintaining the NMake build files.

# Create the build directories
vs$(VSVER)\$(CFG)\$(PLAT)\gendef	\
vs$(VSVER)\$(CFG)\$(PLAT)\pangomm:
	@-mkdir $@

# Generate .def files
vs$(VSVER)\$(CFG)\$(PLAT)\pangomm\pangomm.def: $(GENDEF) vs$(VSVER)\$(CFG)\$(PLAT)\pangomm $(pangomm_OBJS)
	vs$(VSVER)\$(CFG)\$(PLAT)\gendef.exe $@ $(PANGOMM_LIBNAME) vs$(VSVER)\$(CFG)\$(PLAT)\pangomm\*.obj
