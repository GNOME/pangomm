# This file is part of pangomm.

project('pangomm', 'cpp',
  version: '2.42.1',
  license: 'LGPLv2.1+',
  default_options: [
    'cpp_std=c++11'
  ],
  meson_version: '>= 0.50.0', # required for python3.path()
)

pangomm_api_version = '1.4'
pangomm_pcname = meson.project_name() + '-' + pangomm_api_version

pangomm_version_array = meson.project_version().split('.')
pangomm_major_version = pangomm_version_array[0].to_int()
pangomm_minor_version = pangomm_version_array[1].to_int()
pangomm_micro_version = pangomm_version_array[2].to_int()

# http://www.gnu.org/software/libtool/manual/html_node/Updating-version-info.html
# The relation between libtool's current:revison:age interface versioning
# and the .so filename, .so.x.y.z, is
# x = current - age
# y = age
# z = revision
# If libtool_soversion is updated as described in libtool's documentation,
# x.y.z will usually *not* be equal to meson.project_version().
libtool_soversion = [1, 30, 0]
pangomm_libversion = '@0@.@1@.@2@'.format(
  libtool_soversion[0] - libtool_soversion[2],
  libtool_soversion[2],
  libtool_soversion[1])

# Use these instead of meson.source_root() and meson.build_root() in subdirectories.
# source_root() and build_root() are not useful, if this is a subproject.
project_source_root = meson.current_source_dir()
project_build_root = meson.current_build_dir()

cpp_compiler = meson.get_compiler('cpp')
is_msvc = cpp_compiler.get_id() == 'msvc'
python3 = import('python').find_installation('python3')

python_version = python3.language_version()
python_version_req = '>= 3.5'
if not python_version.version_compare(python_version_req)
  error('Requires Python @0@, found @1@.'.format(python_version_req, python_version))
endif

# Do we build from a git repository?
# Suppose we do if and only if a '.git' directory or file exists.
cmd_py = '''
import os
import sys
sys.exit(os.path.isdir("@0@") or os.path.isfile("@0@"))
'''.format(project_source_root / '.git')
is_git_build = run_command(python3, '-c', cmd_py).returncode() != 0

# Options.
maintainer_mode_opt = get_option('maintainer-mode')
maintainer_mode = maintainer_mode_opt == 'true' or \
                 (maintainer_mode_opt == 'if-git-build' and is_git_build)
warning_level = get_option('warnings')
build_deprecated_api = get_option('build-deprecated-api')
build_documentation_opt = get_option('build-documentation')
build_documentation = build_documentation_opt == 'true' or \
                     (build_documentation_opt == 'if-maintainer-mode' and maintainer_mode)

# Installation directories are relative to {prefix}.
install_prefix = get_option('prefix')
install_includedir = get_option('includedir')
install_libdir = get_option('libdir')
install_datadir = get_option('datadir')
install_pkgconfigdir = install_libdir / 'pkgconfig'

# Dependencies.
# pangomm_build_dep: Dependencies when building the pangomm library.
# pangomm_dep (created in pango/pangomm/meson.build):
#   Dependencies when using the pangomm library.

# glibmm recently gained Meson build support, so we can try looking
# for its pkg-config files on Visual Studio as well
glibmm_req = '>= 2.48.0'

# Pango supported pkg-config files on MSVC files for a good while,
# so just use that
pangocairo_req = '>= 1.41.0'
pangocairo_dep = dependency('pangocairo', version: pangocairo_req)

# The -mm libraries do not yet have pkg-config files for MSVC builds,
# so check for them manually
glibmm_req_minor_ver = '4'
cairomm_req_minor_ver = '0'

if is_msvc
  # We must have Visual Studio 2013 or later...
  assert(cpp_compiler.version().split('.')[0].to_int() >= 18, 'Visual Studio 2013 or later is required')

  sigc_major_ver = '2'

  glibmm_dep = dependency('glibmm-2.@0@'.format(glibmm_req_minor_ver), required: false, version: glibmm_req)
  if not glibmm_dep.found()
    assert(cpp_compiler.has_header('sigc++-@0@.0/sigc++/sigc++.h'.format(sigc_major_ver)) and cpp_compiler.has_header('sigc++-@0@.0/include/sigc++config.h'.format(sigc_major_ver)),
           'sigc++-@0@.x headers are required'.format(sigc_major_ver))
    assert(cpp_compiler.has_header('glibmm-2.@0@/glibmm.h'.format(glibmm_req_minor_ver)) and cpp_compiler.has_header('glibmm-2.@0@/include/glibmmconfig.h'.format(glibmm_req_minor_ver)),
           'glibmm-2.@0@ headers are required'.format(glibmm_req_minor_ver))
  else
    sigc_dep = dependency('', required: false) # glibmm covers for libsigc++ in its pkg-config file
  endif
  assert(cpp_compiler.has_header('cairomm-1.@0@/cairomm/cairomm.h'.format(cairomm_req_minor_ver)) and cpp_compiler.has_header('cairomm-1.@0@/include/cairommconfig.h'.format(cairomm_req_minor_ver)),
         'cairomm-1.@0@ headers are required'.format(cairomm_req_minor_ver))
  message('Ensure your INCLUDE and LIB contain the paths that lead to the appropriate headers and .lib\'s for glibmm-2.@0@, cairomm-1.@1@ and libsigc++-2.x'.format(glibmm_req_minor_ver, cairomm_req_minor_ver))

  # We need to look for appropriate versions of Visual
  # Studio since those built by NMake and the former
  # Visual Studio projects are versioned by the VS versions
  if cpp_compiler.version().split('.')[0].to_int() == 18
    msvc_check_range = [12] # Visual Studio 2013
    warning('Visual Studio 2013 must configure without -Dwarnings=fatal, which is the default')
  elif cpp_compiler.version().split('.')[0].to_int() == 19
    # Visual Studio 2019 can consume libraries built with 2017 and 2015
    # and Visual Studio 2017 can consume libraries built with 2015
    msvc_check_range = [14] # Visual Studio 2015, 2017, 2019
    message('It is safe to ignore warnings from Meson that MSVC does not support C++11')
  endif

  debugsuffix = ''
  if get_option('buildtype') == 'debug'
    debugsuffix = '-d'
  endif

  # We can be looking for MSVC 2015-built libraries on 2017 and 2019 builds as well,
  # as well as 2017-built libraries on 2019 as well, so we can't just assume that
  # libraries exist, but check that compatible versions are really found
  cairomm_dep = dependency('', required: false)

  foreach v : msvc_check_range
    glibmm_dep = glibmm_dep.found() ? glibmm_dep : cpp_compiler.find_library('glibmm-vc@0@0@1@-2_@2@'.format(v.to_string(), debugsuffix, glibmm_req_minor_ver), required: false)
    cairomm_dep = cairomm_dep.found() ? cairomm_dep : cpp_compiler.find_library('cairomm-vc@0@0@1@-1_@2@'.format(v.to_string(), debugsuffix, cairomm_req_minor_ver), required: false)
  endforeach

  if glibmm_dep.type_name() == 'library'
    warning('Note: Be sure to check that this finds the same libsigc++ .lib your glibmm is linked to')
    sigc_dep = cpp_compiler.find_library('sigc-@0@.0'.format(sigc_major_ver), required: false)
    foreach v : msvc_check_range
      sigc_dep = sigc_dep.found() ? sigc_dep : cpp_compiler.find_library('sigc-vc@0@0@1@-2_0'.format(v.to_string(), debugsuffix), required: false)
    endforeach
  endif

  # Now make sure the appropriate -mm libraries are found
  assert(glibmm_dep.found() and cairomm_dep.found() and (glibmm_dep.type_name() == 'pkgconfig' or sigc_dep.found()), 'Appropriate glibmm-vcxx0@0@-2_@1@.lib, cairomm-vcxx0@0@-1_@2@.lib and sigc-vcxx0@0@-@3@_0.lib are required'.format(debugsuffix, glibmm_req_minor_ver, cairomm_req_minor_ver, sigc_major_ver))

  # Put glibmm in the required packages if we find it by pkg-config
  # When cairomm gains Meson build support, we can replace
  # this with what is done on other build systems.
  mm_lib_requires = ''
  if glibmm_dep.type_name() == 'pkgconfig'
    mm_lib_requires += ' '.join([
      'glibmm-2.@0@'.format(glibmm_req_minor_ver), glibmm_req,
    ]) + ' '
  endif

  pangomm_requires = mm_lib_requires + ' '.join([
    'pangocairo', pangocairo_req,
  ])

  pangomm_build_dep = [glibmm_dep, cairomm_dep, sigc_dep, pangocairo_dep]
else
  cairomm_req = '>= 1.2.2'
  glibmm_dep = dependency('glibmm-2.@0@'.format(glibmm_req_minor_ver), version: glibmm_req)
  cairomm_dep = dependency('cairomm-1.@0@'.format(cairomm_req_minor_ver), version: cairomm_req)
  pangomm_build_dep = [glibmm_dep, cairomm_dep, pangocairo_dep]
  pangomm_requires = ' '.join([
    'glibmm-2.@0@'.format(glibmm_req_minor_ver), glibmm_req,
    'cairomm-1.@0@'.format(cairomm_req_minor_ver), cairomm_req,
    'pangocairo', pangocairo_req,
  ])
endif

# Some dependencies are required only in maintainer mode and/or if
# reference documentation shall be built.
mm_common_get = find_program('mm-common-get', required: maintainer_mode)
m4 = find_program('m4', required: maintainer_mode) # Used by gmmproc (in glibmm)
perl = find_program('perl', required: maintainer_mode or build_documentation)
doxygen = find_program('doxygen', required: build_documentation)
dot = find_program('dot', required: build_documentation) # Used by Doxygen
xsltproc = find_program('xsltproc', required: build_documentation)

# Where to find gmmproc and generate_wrap_init.pl.
if glibmm_dep.type_name() == 'pkgconfig'
  gmmproc_dir = glibmm_dep.get_pkgconfig_variable('gmmprocdir')
else
  if is_msvc
    gmmproc_dir = get_option('gmmproc-dir')
  endif
endif

script_dir = project_source_root / 'untracked' / 'build_scripts'
generate_binding = script_dir / 'generate-binding.py'
doc_reference = script_dir / 'doc-reference.py'
dist_changelog = script_dir / 'dist-changelog.py'
dist_build_scripts = script_dir / 'dist-build-scripts.py'
dist_cmd = project_source_root / 'tools' / 'dist-cmd.py' # Must be committed to git.

if maintainer_mode and mm_common_get.found()
  # Copy files to untracked/build_scripts and untracked/docs.
  run_command(mm_common_get, '--force', script_dir,
    project_source_root / 'untracked' / 'docs')
endif

# Set compiler warnings.
warning_flags = []
if warning_level == 'min'
  if is_msvc
    warning_flags = ['/W3']
  else
    warning_flags = ['-Wall']
  endif
elif warning_level == 'max' or warning_level == 'fatal'
  if is_msvc
    warning_flags = ['/W4']
  else
    warning_flags = '-pedantic -Wall -Wextra -Wformat-security -Wsuggest-override -Wshadow -Wno-long-long'.split()
  endif
  if warning_level == 'fatal'
    if is_msvc
      warning_flags += ['/WX']
    else
      warning_flags += ['-Werror']
    endif
    deprecations = 'G PANGO GLIBMM SIGCXX'.split()
    foreach d : deprecations
      warning_flags += '-D@0@_DISABLE_DEPRECATED'.format(d)
    endforeach
  endif
endif

warning_flags = cpp_compiler.get_supported_arguments(warning_flags)
add_project_arguments(warning_flags, language: 'cpp')

# MSVC: Ignore warnings that aren't really harmful, but make those
#       that should not be overlooked stand out.
if is_msvc
  foreach wd : ['/FImsvc_recommended_pragmas.h', '/wd4267', '/wd4530', '/wd4251']
    disabled_warning = cpp_compiler.get_supported_arguments(wd)
    add_project_arguments(disabled_warning, language: 'cpp')
  endforeach
endif

subdir('tools/extra_defs_gen')
subdir('MSVC_NMake/gendef')
subdir('pango')
subdir('MSVC_NMake/pangomm')
subdir('pango/pangomm')
subdir('docs/reference')

if not meson.is_subproject()
  # Add a ChangeLog file to the distribution directory.
  # (add_dist_script() is not allowed in a subproject)
  meson.add_dist_script(
    python3.path(), dist_cmd,
    python3.path(), dist_changelog,
    project_source_root,
  )
  # Add build scripts to the distribution directory, and delete .gitignore
  # files and an empty $MESON_DIST_ROOT/build/ directory.
  meson.add_dist_script(
    python3.path(), dist_cmd,
    python3.path(), dist_build_scripts,
    project_source_root,
    'untracked' / 'build_scripts',
  )
endif

# Print a summary.
real_maintainer_mode = ''
if maintainer_mode_opt == 'if-git-build'
  real_maintainer_mode = ' (@0@)'.format(maintainer_mode)
endif

real_build_documentation = ''
if build_documentation_opt == 'if-maintainer-mode'
  real_build_documentation = ' (@0@)'.format(build_documentation)
endif

summary = [
  '',
  '------',
  meson.project_name() + ' ' + meson.project_version(),
  '',
  '         Maintainer mode: @0@@1@'.format(maintainer_mode_opt, real_maintainer_mode),
  '       Compiler warnings: @0@'.format(warning_level),
  '    Build deprecated API: @0@'.format(build_deprecated_api),
  'Build HTML documentation: @0@@1@'.format(build_documentation_opt, real_build_documentation),
  'Directories:',
  '                  prefix: @0@'.format(install_prefix),
  '              includedir: @0@'.format(install_prefix / install_includedir),
  '       includepangommdir: @0@'.format(install_prefix / install_includedir / pangomm_pcname),
  '                  libdir: @0@'.format(install_prefix / install_libdir),
  '        includeconfigdir: @0@'.format(install_prefix / install_includeconfigdir),
  '                   m4dir: @0@'.format(install_prefix / install_m4dir),
  '            pkgconfigdir: @0@'.format(install_prefix / install_pkgconfigdir),
  '                 datadir: @0@'.format(install_prefix / install_datadir),
  '                  docdir: @0@'.format(install_prefix / install_docdir),
  '              devhelpdir: @0@'.format(install_prefix / install_devhelpdir),
  '------'
]

message('\n'.join(summary))
