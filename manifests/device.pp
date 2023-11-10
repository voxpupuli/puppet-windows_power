# @summary defined type to manage a Windows power device (physical, logical and virtual)
#
# @example let your mouse wake the system
#   windows_power::device { 'HID-compliant mouse (001)':
#     enable_wake => true
#   }
#
# @example don't allow Windows media player to keep system from turning off the display or from going to away mode
#   windows_power::device { 'wmplayer.exe':
#     power_request_overrides => {
#       process => {
#         display  => true,
#         awaymode => true
#       }
#     }
#   }
#
# @example don't allow your network card to wake the system, keep your display turned on or keep the system active
#   windows_power::device { 'Realtek PCIe GbE Family Controller':
#     enable_wake => false,
#     power_request_overrides => {
#       driver => {
#         display => true,
#         system  => true
#       }
#     }
#   }
#
# @example delete all power request overrides for/from vpn service
#   windows_power::device { 'VPN Service':
#     power_request_overrides => {
#       service => {
#         system  => false
#       }
#     }
#   }
#
# @param device
#   name of the device/driver/service/process to handle, defaulting to resource's title (no need to set this manually);
#   also see the shipped fact `power_devices`!
#   note that the term "device" covers several things (due to the nature of Windows' power management):
#   - physical devices build in or connected to the machine (such as a network card or a mouse)
#   - logical devices or device groups (such as "HID-compliant system controller" or even "Volume (005)")
#   - drivers or driver groups (such as "High Definition Audio Device")
#   - services (e.g. your remote management software's service name)
#   - processes (e.g. "your_media_player.exe")
#
# @param enable_wake
#   allow (or prohibit) the device to wake the system from a sleep state;
#   devices capable of waking the system do have `$facts['power_devices'][$device]['wake_programmable'] == true`;
#   devices currently allowed waking the system do have `$facts['power_devices'][$device]['wake_armed'] == true`;
#   it's safe to set `enable_wake => true` even if the device is not able to do;
#   defined type only activates wake-up functionality if the device is reported to be capable of doing so!
#
# @param power_request_overrides
#   set (or delete) one or more power request overrides for the device (see Microsoft documentation about power requests and overrides);
#   note that not defining a request type is similar to setting it to `false` but not defining any request type means "don't touch the
#   current state"; so explicitly setting (only) `false` values makes it possible to delete request overrides set outside of Puppet!
#   see examples for clarity.
define windows_power::device (
  String[1] $device = $title,
  Optional[Boolean] $enable_wake = undef,
  Optional[Hash[Enum['service', 'process', 'driver'], Hash[Enum['display', 'system', 'awaymode'], Boolean, 1, 3], 1, 3]] $power_request_overrides = undef,
) {
  if $enable_wake !~ Undef {
    if ($device in $facts['power_devices']) and ('wake_programmable' in $facts['power_devices'][$device]) and ($facts['power_devices'][$device]['wake_programmable']) {
      if ('wake_armed' in $facts['power_devices'][$device]) and $facts['power_devices'][$device]['wake_armed'] {
        if !($enable_wake) {
          exec { "disable_device_wake_${device}":
            provider => windows,
            path     => $facts['os']['windows']['system32'],
            command  => "powercfg /devicedisablewake \"${device}\"",
          }
        }
      }
      else {
        if $enable_wake {
          exec { "enable_device_wake_${device}":
            provider => windows,
            path     => $facts['os']['windows']['system32'],
            command  => "powercfg /deviceenablewake \"${device}\"",
          }
        }
      }
    }
  }

  if $power_request_overrides !~ Undef {
    $overrides = reduce($power_request_overrides, {}) |$prev, $now| {
      $filtered = filter($now[1]) |$key, $value| { $value }

      if empty($filtered) {
        $prev
      }
      else {
        $prev + { $now[0] => $filtered }
      }
    }

    if !($device in $facts['power_devices']) or !('power_request_overrides' in $facts['power_devices'][$device]) {
      if !empty($overrides) {
        each($overrides) |$key, $value| {
          $requests = join(keys($value), ' ')

          exec { "set_power_request_override_${key}_${device}":
            provider => windows,
            path     => $facts['os']['windows']['system32'],
            command  => "powercfg /requestsoverride ${key} \"${device}\" ${requests}",
          }
        }
      }
    }
    else {
      if $facts['power_devices'][$device]['power_request_overrides'] != $overrides {
        each($power_request_overrides) |$key, $value| {
          if $key in $overrides {
            $requests = join(keys($overrides[$key]), ' ')

            exec { "set_power_request_override_${key}_${device}":
              provider => windows,
              path     => $facts['os']['windows']['system32'],
              command  => "powercfg /requestsoverride ${key} \"${device}\" ${requests}",
            }
          }
          else {
            exec { "remove_power_request_override_${key}_${device}":
              provider => windows,
              path     => $facts['os']['windows']['system32'],
              command  => "powercfg /requestsoverride ${key} \"${device}\"",
            }
          }
        }
      }
    }
  }
}
