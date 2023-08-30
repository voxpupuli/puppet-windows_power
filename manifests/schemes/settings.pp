# Author::    Liam Bennett (mailto:liamjbennett@gmail.com)
# Copyright:: Copyright (c) 2014 Liam Bennett
# License::   Apache-2.0

# == Define: windows_power::schemes::settings
#
# This definition configures settings for a specific scheme
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
#       setting     => 'monitor-timeout-ac',
#       value       => '10',
#    }
#
define windows_power::schemes::settings (
  String[1] $scheme_name,
  String[1] $setting,
  String[1] $value,
) {
  include windows_power::params

  $settings_regex = join(keys($windows_power::params::scheme_settings), '|')

  if $setting !~ "^${settings_regex}$" {
    fail('The setting argument does not match a valid scheme setting')
  }

  if $value !~ $windows_power::params::scheme_settings[$setting] {
    fail("The value provided is not appropriate for the ${setting} setting")
  }

  exec { "modify ${setting} setting for ${scheme_name}":
    command   => "& powercfg /change ${setting} ${value}",
    provider  => powershell,
    logoutput => true,
    unless    => "${windows_power::params::nasty_ps} \$items.contains('${scheme_name}')",
  }
}
