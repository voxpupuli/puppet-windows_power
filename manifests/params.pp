# Author::    Liam Bennett (mailto:liamjbennett@gmail.com)
# Copyright:: Copyright (c) 2014 Liam Bennett
# License::   Apache-2.0

# == Class windows_power::params
#
# This private class is meant to be called from `windows_power`
# It sets variables according to platform
#
class windows_power::params {
  $template_schemes = {
    'Balanced'         => '381b4222-f694-41f0-9685-ff5bb260df2e',
    'High Performance' => '8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c',
    'Power Saver'      => 'a1841308-3541-4fab-bc81-f71556f20b4a',
  }

  $batteryalarm_settings = {
    'activate'    => '^(on|off)$',
    'level'       => '^(0?[0-9]{1,2}0?0?)$',
    'text'        => '^(on|off)$',
    'sound'       => '^(on|off)$',
    'action'      => '^(none|shutdown|hibernate|standby)$',
    'forceaction' => '^(on|off)$',
    'program'     => '^(on|off)$',
  }

  $scheme_settings = {
    'monitor-timeout-ac'    => '^(0?[0-9]{1,4}0?0?)$',
    'monitor-timeout-dc'    => '^(0?[0-9]{1,4}0?0?)$',
    'disk-timeout-ac'       => '^(0?[0-9]{1,4}0?0?)$',
    'disk-timeout-dc'       => '^(0?[0-9]{1,4}0?0?)$',
    'standby-timeout-ac'    => '^(0?[0-9]{1,4}0?0?)$',
    'standby-timeout-dc'    => '^(0?[0-9]{1,4}0?0?)$',
    'hibernate-timeout-ac'  => '^(0?[0-9]{1,4}0?0?)$',
    'hibernate-timeout-dc'  => '^(0?[0-9]{1,4}0?0?)$',
    'processor-throttle-ac' => '^(NONE|CONSTANT|DEGRADE|ADAPTIVE)$',
    'processor-throttle-dc' => '^(NONE|CONSTANT|DEGRADE|ADAPTIVE)$',
  }

  $globalpower_flags = ['BatteryIcon','MultiBattery','ResumePassword','WakeOnRing','VideoDim']

  $nasty_ps = '$items = [System.Collections.ArrayList]@(powercfg /l | % { if ($_ -match "^.*GUID.*\((.*)\).*$") {$matches[1]} });'
}
