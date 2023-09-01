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

  exec { "request override for ${name}":
    provider => windows,
    command  => "powercfg /requestsoverride ${type} ${name} ${request}",
  }
}
