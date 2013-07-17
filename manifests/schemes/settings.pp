# Define windows_power::schemes::settings
#
# This definition configures settings for a specific scheme
#
# Parameters:
#   [*scheme_name*] - the name of the scheme to configure
#   [*setting*]     - the setting to configure
#   [*value*]       - the value set the setting to - minutes or throttle
#
# Usage:
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