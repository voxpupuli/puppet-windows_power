# Author::    Liam Bennett (mailto:liamjbennett@gmail.com)
# Copyright:: Copyright (c) 2014 Liam Bennett
# License::   Apache-2.0

# == Define: windows_power::devices::wake
#
# This definition enables/disables the device to wake the computer from a sleep state
#
# === Requirements/Dependencies
#
# Currently reequires the puppetlabs/stdlib module on the Puppet Forge in
# order to validate much of the the provided configuration.
#
# === Parameters
#
# [*device*]
# Specifies the device name
#
# [*ensure*]
# Enable or disable the device for waking
#
# === Examples
#
#    windows_power::devices::wake { 'VMBus Enumerator (001)':
#       device => 'VMBus Enumerator (001)',
#       ensure => 'enable',
#    }
#
define windows_power::devices::wake(
  $device,
  $ensure = 'enable',
) {

  include ::windows_power::params

  validate_string($device)
  validate_re($ensure,'^(enable|disable)$','The ensure argument does not match: enable or disable')

  exec { "device ${device} ${ensure} wake":
    command  => "${windows_power::params::powercfg} /device${ensure}wake \"${device}\"",
    provider => windows,
  }
}
