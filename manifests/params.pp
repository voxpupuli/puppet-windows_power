# == Class windows_power::params
#
# This private class is meant to be called from `windows_power`
# It sets variables according to platform
#
class windows_power::params {
  $nasty_ps = '$items = [System.Collections.ArrayList]@(powercfg /l | % { if ($_ -match "^.*GUID.*\((.*)\).*$") {$matches[1]} });'
}
