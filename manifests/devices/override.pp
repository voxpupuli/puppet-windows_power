# Author::    Liam Bennett (mailto:liamjbennett@gmail.com)
# Copyright:: Copyright (c) 2014 Liam Bennett
# License::   Apache-2.0

# == Define: windows_power::devices::override
#
# This definition manages a Power Request override for a particular Process, Service, or Driver.
#
# === Parameters
#
# [*type*]
# Specifies one of the following caller types: PROCESS, SERVICE, DRIVER
#
# [*request*]
# Specifies one or more of the following Power Request Types: Display, System, Awaymode
#
# === Examples
#
#    windows_power::devices::override { 'wmplayer.exe':
#       type    => 'PROCESS',
#       request => 'Display',
#    }
#
define windows_power::devices::override (
  Enum['PROCESS', 'SERVICE', 'DRIVER'] $type,
  Enum['Display', 'System', 'Awaymode'] $request,
) {
  include windows_power::params

  case $facts['operatingsystemversion'] {
    'Windows XP', 'Windows Server 2003', 'Windows Server 2003 R2': {
      err("${facts['operatingsystemversion']} does not support requestsoverride")
    }
    default: {
      exec { "request override for ${name}":
        command  => "${windows_power::params::powercfg} /requestsoverride ${type} ${name} ${request}",
        provider => windows,
      }
    }
  }
}
