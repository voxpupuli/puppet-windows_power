# Author::    Liam Bennett (mailto:liamjbennett@gmail.com)
# Copyright:: Copyright (c) 2014 Liam Bennett
# License::   Apache-2.0

# == Define: windows_power::global::flags
#
# This definition configured the battery alarm
#
# === Parameters
#
# [*setting*]
# The global power flag to configure
#
# [*status*]
# Setting configuration (on/off)
#
# === Examples
#
#    windows_power::global::flags { 'show battery icon':
#       setting => 'BatteryIcon',
#       status => 'on',
#    }
#
define windows_power::global::flags (
  String[1] $setting,
  Enum['on', 'off'] $status,
) {
  include windows_power::params

  if ! ($setting in $windows_power::params::globalpower_flags) {
    fail('The setting argument does not match a valid globalpower flag')
  }

  case $facts['operatingsystemversion'] {
    'Windows XP', 'Windows Server 2003', 'Windows Server 2003 R2': {
      exec { "set globalpowerflag ${setting}":
        command  => "${windows_power::params::powercfg} /globalpowerflag /option:${setting} ${status}",
        provider => windows,
      }
    }
    default: {}
  }
}
