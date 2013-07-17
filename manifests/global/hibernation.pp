# Define windows_power::global::hibernation
#
# This definition configures hibernation on a box
#
# Parameters:
#   [*status*]  - setting configuration (on/off)
#
# Usage:
#
#    windows_power::global::hibernation { 'enable hibernation':
#       status => 'on'
#    }
#
define windows_power::global::hibernation(
  $status
) {

  include windows_power::params

  validate_re($status,'^(on|off)$','The status argument is not valid for hibernate')

  exec { 'update hibernate status':
    command  => "${windows_power::params::powercfg} -hibernate ${status}",
    provider => windows
  }
}