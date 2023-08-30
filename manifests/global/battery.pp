# Author::    Liam Bennett (mailto:liamjbennett@gmail.com)
# Copyright:: Copyright (c) 2014 Liam Bennett
# License::   Apache-2.0

# Define windows_power::global::battery
#
# This definition configured the battery alarm
#
# === Parameters
#
# [*setting*]
# Battery alarm setting to configure
#
# [*status*]
# Setting configuration
#
# [*criticality*]
# The level of battery criticality at which to provide an alarm. LOW or HIGH.
#
# === Examples
#
#    windows_power::global::battery { 'activate battery alarm':
#       setting => 'activate',
#       status  => 'on',
#    }
#
define windows_power::global::battery (
  String[1] $setting,
  String[1] $status,
  Enum['LOW', 'HIGH'] $criticality = 'LOW',
) {
  include windows_power::params

  if ! ($setting in $windows_power::params::batteryalarm_settings) {
    fail('The setting argument does not match a valid batteryalarm setting')
  }

  if $status !~ $windows_power::params::batteryalarm_settings[$setting] {
    fail("The status argument is not valid for ${setting}")
  }

  case $facts['operatingsystemversion'] {
    'Windows XP', 'Windows Server 2003', 'Windows Server 2003 R2': {
      exec { "set batteryalarm ${setting}":
        command  => "powercfg /batteryalarm ${criticality} /${setting} ${status}",
        provider => windows,
      }
    }
    default: {}
  }
}
