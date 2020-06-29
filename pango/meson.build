# pango

# Input: install_prefix, install_datadir, install_includedir,
#        pangomm_pcname, pangomm_api_version, pangomm_requires,
#        install_pkgconfigdir, install_libdir, build_deprecated_api,
#        pangomm_major_version, pangomm_minor_version, pangomm_micro_version,
#        msvc14x_toolset_ver
# Output: pkg_conf_data, install_includeconfigdir, pangommconfig_h

pkg_conf_data = configuration_data()
pkg_conf_data.set('prefix', install_prefix)
pkg_conf_data.set('exec_prefix', '${prefix}')
pkg_conf_data.set('libdir', '${exec_prefix}' / install_libdir)
pkg_conf_data.set('datarootdir', '${prefix}' / install_datadir)
pkg_conf_data.set('datadir', '${datarootdir}')
pkg_conf_data.set('includedir', '${prefix}' / install_includedir)
pkg_conf_data.set('srcdir', meson.current_source_dir())
pkg_conf_data.set('PACKAGE_TARNAME', meson.project_name())
pkg_conf_data.set('PACKAGE_VERSION', meson.project_version())
pkg_conf_data.set('PANGOMM_MODULE_NAME', pangomm_pcname)
pkg_conf_data.set('PANGOMM_API_VERSION', pangomm_api_version)
pkg_conf_data.set('PANGOMM_MODULES', pangomm_requires)
pkg_conf_data.set('MSVC_TOOLSET_VER', msvc14x_toolset_ver)

if not build_deprecated_api
  pkg_conf_data.set('PANGOMM_DISABLE_DEPRECATED', true)
endif
pkg_conf_data.set('PANGOMM_MAJOR_VERSION', pangomm_major_version)
pkg_conf_data.set('PANGOMM_MINOR_VERSION', pangomm_minor_version)
pkg_conf_data.set('PANGOMM_MICRO_VERSION', pangomm_micro_version)

configure_file(
  input: 'pangomm.pc.in',
  output: pangomm_pcname + '.pc',
  configuration: pkg_conf_data,
  install_dir: install_pkgconfigdir,
)

configure_file(
  input: 'pangomm-uninstalled.pc.in',
  output: pangomm_pcname + '-uninstalled.pc',
  configuration: pkg_conf_data,
)

install_includeconfigdir = install_libdir / pangomm_pcname / 'include'
pangommconfig_h = configure_file(
  input: 'pangommconfig.h.meson',
  output: 'pangommconfig.h',
  configuration: pkg_conf_data,
  install_dir: install_includeconfigdir,
)
