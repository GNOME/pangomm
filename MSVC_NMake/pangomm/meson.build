# MSVC_NMake/pangomm

# Input: pkg_conf_data, pangommconfig_h_meson
# Output: pangomm_rc

pangomm_rc = configure_file(
  input: 'pangomm.rc.in',
  output: '@BASENAME@',
  configuration: pkg_conf_data,
)

# Make a copy of the generated configuration header in the MSVC project directory.
configure_file(
  input: pangommconfig_h_meson,
  output: 'pangommconfig.h',
  configuration: pkg_conf_data,
)
