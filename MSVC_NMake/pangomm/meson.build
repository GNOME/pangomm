# MSVC_NMake/pangomm

# Input: pkg_conf_data, pangommconfig_h
# Output: pangomm_rc

pangomm_rc = configure_file(
  input: 'pangomm.rc.in',
  output: '@BASENAME@',
  configuration: pkg_conf_data,
)

# Copy the generated configuration header into the MSVC project directory.
configure_file(
  input: pangommconfig_h,
  output: 'pangommconfig.h',
  copy: true,
)
