# == Define: windows_power::global::hibernation
#
# This definition configures hibernation on a box
#
# === Parameters
#
# [*status*]
# Setting configuration (on/off)
#
# === Examples
#
#    windows_power::global::hibernation { 'enable hibernation':
#       status => 'on',
#    }
#
define windows_power::global::hibernation (
  Enum['on', 'off'] $status,
) {
  include windows_power::params

  exec { 'update hibernate status':
    command  => "powercfg /hibernate ${status}",
    provider => windows,
  }
}
