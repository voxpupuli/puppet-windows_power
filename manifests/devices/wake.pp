# Define windows_power::devices::wake
#
# This definition enables/disables the device to wake the computer from a sleep state
#
# Parameters:
#   [*device*]    - specifies the device name
#   [*ensure*]    - enable or disable the device for waking
#
# Usage:
#
#    windows_power::devices::wake { 'VMBus Enumerator (001)':
#       device => 'VMBus Enumerator (001)',
#       ensure => 'enable'
#    }
#
define windows_power::devices::wake(
  $device,
  $ensure = 'enable'
) {

  include windows_power::params

  validate_string($device)
  validate_re($ensure,'^(enable|disable)$','The ensure argument does not match: enable or disable')

  exec { "device ${device} ${ensure} wake":
    command  => "${windows_power::params::powercfg} /device${ensure}wake \"${device}\"",
    provider => windows
  }
}