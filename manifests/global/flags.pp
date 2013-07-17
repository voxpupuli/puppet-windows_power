# Define windows_power::global::flags
#
# This definition configured the battery alarm
#
# Parameters:
#   [*setting*] - the global power flag to configure
#   [*status*]  - setting configuration (on/off)
#
# Usage:
#
#    windows_power::global::flags { 'show battery icon':
#       setting => 'BatteryIcon',
#       status => 'on'
#    }
#
define windows_power::global::flags(
  $setting,
  $status
) {

  include windows_power::params

  validate_re($setting,$windows_power::params::globalpower_flags,'The setting argument does not match a valid globalpower flag')
  validate_re($status,'^(on|off)$',"The status argument is not valid for ${setting}")

  case $::operatingsystemversion {
    'Windows XP', 'Windows Server 2003', 'Windows Server 2003 R2': {
      exec { "set globalpowerflag ${setting}":
        command  => "${windows_power::params::powercfg} /globalpowerflag /option:${setting} ${status}",
        provider => windows
      }
    }
    default: {

    }
  }
}