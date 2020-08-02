# Author::    Liam Bennett (mailto:liamjbennett@gmail.com)
# Copyright:: Copyright (c) 2014 Liam Bennett
# License::   Apache-2.0

# == Define: windows_power::global::hibernation
#
# This definition configures hibernation on a box
#
# === Requirements/Dependencies
#
# Currently reequires the puppetlabs/stdlib module on the Puppet Forge in
# order to validate much of the the provided configuration.
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
  $status,
) {
  include windows_power::params

  validate_re($status,'^(on|off)$','The status argument is not valid for hibernate')

  exec { 'update hibernate status':
    command  => "${windows_power::params::powercfg} -hibernate ${status}",
    provider => windows,
  }
}
