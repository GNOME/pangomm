# pango/pangomm

# Input: pangomm_deps, pangomm_pcname, maintainer_mode, project_source_root,
#        generate_binding, m4_files, pangomm_libversion, install_includedir,
#        dist_cmd, python3
# Output: hg_ccg_basenames, extra_h_files, built_file_targets, built_files_root

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
src_untracked_pangomm = project_source_root / untracked_pangomm

if maintainer_mode

  # Maintainer mode. Generate .h and .cc files from .hg and .ccg files in ../src.

  # docs/reference/meson.build needs this.
  built_files_root = project_build_root

  hg_files = []
  foreach file : hg_ccg_basenames
    hg_files += '..' / 'src' / file + '.hg'
  endforeach

  # Create wrap_init.cc in project_build_root/pango/pangomm.
  wrap_init_target = custom_target('wrap_init.cc',
    input: hg_files,
    output: 'wrap_init.cc',
    command: [
      python3, generate_binding, 'generate_wrap_init',
      gmmproc_dir,
      '@OUTPUT@',
      'Pango', # namespace
      '@INPUT@',
    ],
    build_by_default: maintainer_mode,
    install: false,
  )

  # Force meson+ninja to generate source files before anything is compiled.
  # Compilation must depend on these targets.
  built_file_targets = []

  # Create .h/_p.h/.cc files from .hg/.ccg files in project_build_root/pango/pangomm.
  foreach file : hg_ccg_basenames
    hg_file = '..' / 'src' / file + '.hg'
    ccg_file = '..' / 'src' / file + '.ccg'
    built_file_targets += custom_target(file + '.cc',
      input: [hg_file, ccg_file],
      output: [file + '.stamp', file + '.cc'],
      command: [
        python3, generate_binding, 'gmmproc',
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
  endforeach

  pangomm_library = library(pangomm_pcname,
    wrap_init_target, built_file_targets, extra_cc_files,
    version: pangomm_libversion,
    include_directories: '..',
    dependencies: pangomm_deps,
    install: true,
  )

  # Install built .h and _p.h files.
  meson.add_install_script(
    python3.path(), generate_binding, 'install_built_h_files',
    meson.current_build_dir(),
    install_includedir / pangomm_pcname / 'pangomm', # subdir below {prefix}
    hg_ccg_basenames
  )

  if not meson.is_subproject()
    # Distribute built files.
    # (add_dist_script() is not allowed in a subproject)
    meson.add_dist_script(
      python3.path(), dist_cmd,
      python3.path(), generate_binding, 'dist_built_files',
      meson.current_build_dir(),
      untracked_pangomm,
      hg_ccg_basenames,
    )
  endif

else # not maintainer_mode

  # Not maintainer mode. Compile built source code files in
  # project_source_root/untracked/pango/pangomm.

  # docs/reference/meson.build needs these.
  built_file_targets = []
  built_files_root = project_source_root / 'untracked'

  # Two cases:
  # 1. The source code comes from a tarball, where the built files
  #    are stored in project_source_root/untracked.
  #    There are no built files in the build tree.
  # 2. Files have been built in the build tree. Then maintainer_mode has
  #    been changed from true to false. Files that are missing or not up to date
  #    in project_source_root/untracked are copied from the build tree.

  # Try to copy built source code files to the source tree.
  run_command(
    python3, generate_binding, 'copy_built_files',
    meson.current_build_dir(),
    src_untracked_pangomm,
    hg_ccg_basenames,
  )

  built_cc_files = [ src_untracked_pangomm / 'wrap_init.cc' ]
  foreach file : hg_ccg_basenames
    built_cc_files += src_untracked_pangomm / file + '.cc'
  endforeach

  pangomm_library = library(pangomm_pcname,
    built_cc_files, extra_cc_files,
    version: pangomm_libversion,
    include_directories: [ '..', '..' / '..' / 'untracked' / 'pango' ],
    dependencies: pangomm_deps,
    install: true,
  )

  # Install built .h and _p.h files.
  meson.add_install_script(
    python3.path(), generate_binding, 'install_built_h_files',
    src_untracked_pangomm,
    install_includedir / pangomm_pcname / 'pangomm', # subdir below {prefix}
    hg_ccg_basenames
  )

  if not meson.is_subproject()
    # Distribute built files.
    # (add_dist_script() is not allowed in a subproject)
    meson.add_dist_script(
      python3.path(), dist_cmd,
      python3.path(), generate_binding, 'dist_built_files',
      src_untracked_pangomm,
      untracked_pangomm,
      hg_ccg_basenames,
    )
  endif

endif

# This is useful in the main project when pangomm is used as a subproject.
pangomm_dep = declare_dependency(
  link_with: pangomm_library,
  include_directories: '..',
  dependencies: pangomm_deps
)
