# Define windows_power::devices::override
#
# This definition manages a Power Request override for a particular Process, Service, or Driver.
#
# Parameters:
#   [*type*]    - specifies one of the following caller types: PROCESS, SERVICE, DRIVER
#   [*request*] - specifies one or more of the following Power Request Types: Display, System, Awaymode
#
# Usage:
#
#    windows_power::devices::override { 'wmplayer.exe':
#       type    => 'PROCESS',
#       request => 'Display'
#    }
#
define windows_power::devices::override(
  $type,
  $request
) {

  include windows_power::params

  validate_re($type,'^(PROCESS|SERVICE|DRIVER)$','The caller type argument does not match: PROCESS, SERVICE or DRIVER')
  validate_re($request,'^(Display|System|Awaymode)$','The request type argument does not match: Display, System or Awaymode')

  case $::operatingsystemversion {
    'Windows XP', 'Windows Server 2003', 'Windows Server 2003 R2': {
      err("${::operatingsystemversion} does not support requestsoverride")
    }
    default: {
      exec { "request override for ${name}":
        command  => "${windows_power::params::powercfg} /requestsoverride ${type} ${name} ${request}",
        provider => windows
      }
    }
  }
}