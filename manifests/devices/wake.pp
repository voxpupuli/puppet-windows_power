# Author::    Liam Bennett (mailto:liamjbennett@gmail.com)
# Copyright:: Copyright (c) 2014 Liam Bennett
# License::   Apache-2.0

# == Define: windows_power::devices::wake
#
# This definition enables/disables the device to wake the computer from a sleep state
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
define windows_power::devices::wake (
  String[1] $device,
  Enum['enable', 'disable'] $ensure = 'enable',
) {
  include windows_power::params

  exec { "device ${device} ${ensure} wake":
    command  => "powercfg /device${ensure}wake \"${device}\"",
    provider => windows,
  }
}
