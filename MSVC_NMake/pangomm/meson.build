# MSVC_NMake/pangomm

# Input: pkg_conf_data, project_build_root
# Output: -

pangomm_rc = configure_file(
  input: 'pangomm.rc.in',
  output: '@BASENAME@',
  configuration: pkg_conf_data,
)

# Copy the generated configuration header into the MSVC project directory.
meson.add_postconf_script(
  'copy-pangommconfig-h.py',
  project_build_root,
  meson.current_build_dir(),
)

untracked_msvc_pangomm = 'untracked' / 'MSVC_NMake' / 'pangomm'
src_msvc_untracked_pangomm = project_source_root / untracked_msvc_pangomm
generated_panogmmconfig_h_orig = project_build_root / 'pango' / 'pangommconfig.h'
generated_pangomm_rc = meson.current_build_dir() / 'pangomm.rc'

if not meson.is_subproject()
  # Distribute built files.
  # (add_dist_script() is not allowed in a subproject)
  meson.add_dist_script(
    python3.path(), dist_cmd,
    python3.path(), generate_binding, 'dist_msvc_built_files',
    meson.current_build_dir(),
    untracked_msvc_pangomm,
    generated_pangomm_rc, generated_panogmmconfig_h_orig,
  )
endif
