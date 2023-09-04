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
  Enum[
    'monitor-timeout-ac',
    'monitor-timeout-dc',
    'disk-timeout-ac',
    'disk-timeout-dc',
    'standby-timeout-ac',
    'standby-timeout-dc',
    'hibernate-timeout-ac',
    'hibernate-timeout-dc'
  ] $setting,
  Integer[0] $value,
) {
  include windows_power::params

  exec { "modify ${setting} setting for ${scheme_name}":
    provider  => powershell,
    command   => "& powercfg /change ${setting} ${value}",
    logoutput => true,
    unless    => "([System.Collections.ArrayList]@(powercfg /l | % { if ($_ -match '^.*GUID.*\((.*)\).*$') {\$matches[1]} })).contains('${scheme_name}')",
  }
}
