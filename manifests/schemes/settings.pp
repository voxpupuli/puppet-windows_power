# Author::    Liam Bennett (mailto:liamjbennett@gmail.com)
# Copyright:: Copyright (c) 2014 Liam Bennett
# License::   MIT

# == Define: windows_power::schemes::settings
#
# This definition configures settings for a specific scheme
#
# === Requirements/Dependencies
#
# Currently reequires the puppetlabs/stdlib module on the Puppet Forge in
# order to validate much of the the provided configuration.
#
# === Parameters
#
# [*scheme_name*]
# The name of the scheme to configure
#
# [*setting*]
# The setting to configure
#
# [*value*]
# The value set the setting to - minutes or throttle
#
# === Examples
#
#    windows_power::schemes::settings { 'set monitor timeout':
#       scheme_name => 'test',
#       setting => 'monitor-timeout-ac',
#       value => '10'
#    }
#
define windows_power::schemes::settings(
  $scheme_name,
  $setting,
  $value
) {

  include windows_power::params

  validate_string($scheme_name)

  $settings_regex = join(keys($windows_power::params::scheme_settings), '|')
  validate_re($setting, "^(${settings_regex})$", 'The setting argument does not match a valid scheme setting')

  validate_re($value, $windows_power::params::scheme_settings[$setting], "The value provided is not appropriate for the ${setting} setting")

  exec { "modify ${setting} setting for ${scheme_name}":
    command   => "& ${windows_power::params::powercfg} /change ${setting} ${value}",
    provider  => powershell,
    logoutput => true,
    unless    => "${windows_power::params::nasty_ps} \$items.contains(${scheme_name})",
  }
}
