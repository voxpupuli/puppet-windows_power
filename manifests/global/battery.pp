# Author::    Liam Bennett (mailto:liamjbennett@gmail.com)
# Copyright:: Copyright (c) 2014 Liam Bennett
# License::   Apache-2.0

# Define windows_power::global::battery
#
# This definition configured the battery alarm
#
# === Requirements/Dependencies
#
# Currently reequires the puppetlabs/stdlib module on the Puppet Forge in
# order to validate much of the the provided configuration.
#
# === Parameters
#
# [*setting*]
# Battery alarm setting to configure
#
# [*status*]
# Setting configuration (on/off) or percentage (in the case of the level setting)
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
  $setting,
  $status,
  $criticality = 'LOW',
) {
  include windows_power::params

  validate_re($setting,keys($windows_power::params::batteryalarm_settings),'The setting argument does not match a valid batteryalarm setting')
  validate_re($status,$windows_power::params::batteryalarm_settings[$setting],"The status argument is not valid for ${setting}")
  validate_re($criticality,'^(LOW|HIGH)$','The status argument does not match: LOW or HIGH')

  case $facts['operatingsystemversion'] {
    'Windows XP', 'Windows Server 2003', 'Windows Server 2003 R2': {
      exec { "set batteryalarm ${setting}":
        command  => "${windows_power::params::powercfg} /batteryalarm ${criticality} /${setting} ${status}",
        provider => windows,
      }
    }
    default: {}
  }
}
