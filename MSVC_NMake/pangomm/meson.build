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
