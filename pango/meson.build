# pango

# Input: pangomm_pcname, install_libdir, build_deprecated_api,
#        pangomm_major_version, pangomm_minor_version, pangomm_micro_version
# Output: pkg_conf_data, install_includeconfigdir, pangommconfig_h_meson

pkg_conf_data = configuration_data()
pkg_conf_data.set('PACKAGE_VERSION', meson.project_version())
pkg_conf_data.set('PANGOMM_MODULE_NAME', pangomm_pcname)

if not build_deprecated_api
  pkg_conf_data.set('PANGOMM_DISABLE_DEPRECATED', true)
endif
pkg_conf_data.set('PANGOMM_MAJOR_VERSION', pangomm_major_version)
pkg_conf_data.set('PANGOMM_MINOR_VERSION', pangomm_minor_version)
pkg_conf_data.set('PANGOMM_MICRO_VERSION', pangomm_micro_version)

pangommconfig_h_meson = files('pangommconfig.h.meson')
install_includeconfigdir = install_libdir / pangomm_pcname / 'include'
configure_file(
  input: pangommconfig_h_meson,
  output: 'pangommconfig.h',
  configuration: pkg_conf_data,
  install: true,
  install_dir: install_includeconfigdir,
  install_tag: 'devel',
)
