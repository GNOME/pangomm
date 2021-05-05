# pango/pangomm

# Input: pangomm_build_dep, pangomm_pcname, maintainer_mode, project_source_root,
#        generate_binding_py, m4_files, pangomm_libversion, install_includedir,
#        python3, pangomm_rc, dummy_header_py, gmmproc_dir, build_shared_libs_directly,
#        msvc14x_toolset_ver, macos_darwin_versions, can_add_dist_script
# Output: hg_ccg_basenames, extra_h_files, built_h_file_targets, built_files_root,
#         pangomm_own_dep

defs_basefiles = [
  'pango.defs',
  'pango_methods.defs',
  'pango_enums.defs',
  'pango_vfuncs.defs',
  'pango_extra_objects.defs',
  'pango_docs.xml',
  'pango_docs_override.xml',
]

defs_files = []
foreach file : defs_basefiles
  defs_files += '..' / 'src' / file
endforeach

hg_ccg_basenames = [
  'attributes',
  'attriter',
  'attrlist',
  'cairofontmap',
  'color',
  'context',
  'coverage',
  'font',
  'fontdescription',
  'fontface',
  'fontfamily',
  'fontmap',
  'fontmetrics',
  'fontset',
  'glyph',
  'glyphstring',
  'item',
  'language',
  'layout',
  'layoutiter',
  'layoutline',
  'layoutrun',
  'rectangle',
  'renderer',
  'tabarray',
]

extra_cc_files = [
  'init.cc',
]

extra_h_files = [
  'init.h',
  'types.h',
  'wrap_init.h',
]

install_headers('..' / 'pangomm.h', subdir: pangomm_pcname)
install_headers(extra_h_files, subdir: pangomm_pcname / 'pangomm')

untracked_pangomm = 'untracked' / 'pango' / 'pangomm'
rel_untracked_pangomm = '..' / '..' / untracked_pangomm
src_untracked_pangomm = project_source_root / untracked_pangomm

pangomm_cpp_args = [ '-DPANGOMM_BUILD=1' ]

if is_msvc and not build_shared_libs_directly
  pangomm_cpp_args += '-DPANGOMM_USE_GENDEF'
endif

if maintainer_mode

  # Maintainer mode. Generate .h and .cc files from .hg and .ccg files in ../src.

  # docs/reference/meson.build needs these.
  built_files_root = project_build_root
  built_h_file_targets = []

  # Force meson+ninja to generate source files before anything is compiled.
  # Compilation must depend on these targets.
  built_cc_file_targets = []

  hg_files = []
  foreach file : hg_ccg_basenames
    hg_files += '..' / 'src' / file + '.hg'
  endforeach

  # Create wrap_init.cc in project_build_root/pango/pangomm.
  built_cc_file_targets += custom_target('wrap_init.cc',
    input: hg_files,
    output: 'wrap_init.cc',
    command: [
      python3, generate_binding_py, 'generate_wrap_init',
      gmmproc_dir,
      '@OUTPUT@',
      'Pango', # namespace
      '@INPUT@',
    ],
    build_by_default: maintainer_mode,
    install: false,
  )

  # Create .h/_p.h/.cc files from .hg/.ccg files in project_build_root/pango/pangomm.
  foreach file : hg_ccg_basenames
    hg_file = '..' / 'src' / file + '.hg'
    ccg_file = '..' / 'src' / file + '.ccg'
    built_file_target = custom_target(file + '.cc',
      input: [hg_file, ccg_file],
      output: [file + '.stamp', file + '.cc', file + '.h'],
      command: [
        python3, generate_binding_py, 'gmmproc',
        gmmproc_dir,
        '@OUTPUT0@',
        file,
        meson.current_source_dir() / '..' / 'src',
        project_source_root / 'tools' / 'm4',
      ],
      depend_files: defs_files + m4_files,
      build_by_default: maintainer_mode,
      install: false,
    )
    built_cc_file_targets += built_file_target[1]
    built_h_file_targets += built_file_target[2]
  endforeach

  # Create dummy_header.h, depending on all generated headers.
  # It's created if it does not exist, but it's never updated.
  # It guarantees that all generated headers are built before pangomm_library
  # is built, at the same time avoiding unnecessary recompilations.
  # If built_h_file_targets would be listed as sources to pangomm_library,
  # all generated .cc files could be recompiled if one generated .h file has
  # been changed.
  built_dummy_h_file_target = custom_target('dummy_header.h',
    input: built_h_file_targets,
    output: 'dummy_header.h',
    command: [
      python3, dummy_header_py,
      '@OUTPUT@',
    ],
    build_by_default: maintainer_mode,
    install: false,
  )

  extra_include_dirs = ['..']

  pango_gen_sources = built_cc_file_targets

  built_h_cc_dir = meson.current_build_dir()

else # not maintainer_mode

  # Not maintainer mode. Compile built source code files in
  # project_source_root/untracked/pango/pangomm.

  # docs/reference/meson.build needs these.
  built_files_root = project_source_root / 'untracked'
  built_h_file_targets = []

  # Two cases:
  # 1. The source code comes from a tarball, where the built files
  #    are stored in project_source_root/untracked.
  #    There are no built files in the build tree.
  # 2. Files have been built in the build tree. Then maintainer_mode has
  #    been changed from true to false. Files that are missing or not up to date
  #    in project_source_root/untracked are copied from the build tree.

  # Try to copy built source code files to the source tree.
  run_command(
    python3, generate_binding_py, 'copy_built_files',
    meson.current_build_dir(),
    src_untracked_pangomm,
    hg_ccg_basenames,
  )

  built_cc_files = [ rel_untracked_pangomm / 'wrap_init.cc' ]
  foreach file : hg_ccg_basenames
    built_cc_files += rel_untracked_pangomm / file + '.cc'
  endforeach

  pango_gen_sources = built_cc_files
  built_dummy_h_file_target = []

  extra_include_dirs = [ '..', '..' / '..' / 'untracked' / 'pango' ]

  built_h_cc_dir = src_untracked_pangomm

endif

extra_pangomm_objects = []

# Build the .rc file for Windows builds and link to it
if host_machine.system() == 'windows'
  windows = import('windows')
  pangomm_res = windows.compile_resources(pangomm_rc)
  extra_pangomm_objects += pangomm_res
endif

pangomm_libname = meson.project_name() + msvc14x_toolset_ver + '-' + pangomm_api_version

if build_shared_libs_directly
  pangomm_library = library(pangomm_libname, extra_pangomm_objects,
    pango_gen_sources, built_dummy_h_file_target, extra_cc_files,
    implicit_include_directories: false,
    include_directories: extra_include_dirs,
    cpp_args: pangomm_cpp_args,
    version: pangomm_libversion,
    darwin_versions: macos_darwin_versions,
    dependencies: pangomm_build_dep,
    install: true,
  )
else
  # Building with headers generated from *.hg files with
  # gmmproc < 2.64.0 on Visual Studio: We need this so
  # that we can run gendef.exe to get the .def file
  # needed for obtaining the .lib file for the pangomm DLL
  pango_int_lib = static_library('pangomm-int',
    pango_gen_sources, built_dummy_h_file_target, extra_cc_files,
    implicit_include_directories: false,
    include_directories: extra_include_dirs,
    cpp_args: pangomm_cpp_args,
    dependencies: pangomm_build_dep,
    install: false,
  )

  pangomm_def = custom_target('pangomm.def',
    output: 'pangomm.def',
    depends: pango_int_lib,
    command: [ gendef,
      '@OUTPUT@',
      '@0@-@1@.dll'.format(pangomm_libname,
                           libtool_soversion[0] - libtool_soversion[2]),
      pango_int_lib.full_path(),
    ],
    install: false,
  )
  pangomm_extra_link_args = ['/def:@0@'.format(pangomm_def.full_path())]

  pangomm_library = library(pangomm_libname, extra_pangomm_objects,
    objects: pango_int_lib.extract_all_objects(),
    version: pangomm_libversion,
    darwin_versions: macos_darwin_versions,
    implicit_include_directories: false,
    dependencies: pangomm_build_dep,
    link_depends: pangomm_def,
    link_args: pangomm_extra_link_args,
    install: true,
  )
endif

# Install built .h and _p.h files.
meson.add_install_script(
  python3.path(), generate_binding_py, 'install_built_h_files',
  built_h_cc_dir,
  install_includedir / pangomm_pcname / 'pangomm', # subdir below {prefix}
  hg_ccg_basenames
)

if can_add_dist_script
  # Distribute built files.
  meson.add_dist_script(
    python3.path(), generate_binding_py, 'dist_built_files',
    built_h_cc_dir,
    untracked_pangomm,
    hg_ccg_basenames,
  )
endif

# This is part of pangomm_dep, when pangomm is a subproject.
# It can also be used if there are example programs and test programs to build.
pangomm_own_dep = declare_dependency(
  sources: built_h_file_targets,
  link_with: pangomm_library,
  include_directories: extra_include_dirs,
  dependencies: pangomm_build_dep
)
