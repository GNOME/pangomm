# NMake Makefile portion for code generation and
# intermediate build directory creation
# Items in here should not need to be edited unless
# one is maintaining the NMake build files.

# Create the build directories
$(CFG)\$(PLAT)\gendef	\
$(CFG)\$(PLAT)\pangomm:
	@-mkdir $@

# Generate .def files
$(CFG)\$(PLAT)\pangomm\pangomm.def: $(GENDEF) $(CFG)\$(PLAT)\pangomm $(pangomm_OBJS)
	$(CFG)\$(PLAT)\gendef.exe $@ $(PANGOMM_LIBNAME) $(CFG)\$(PLAT)\pangomm\*.obj
