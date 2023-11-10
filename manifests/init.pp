# @summary class to manage Windows power devices (physical, logical and virtual)
#
# @see windows_power::device
#
# @example basic usage
#   class { 'windows_power':
#     devices => {
#       'HID-compliant mouse (001)' => {
#         enable_wake => true
#       },
#       'wmplayer.exe' => {
#         power_request_overrides => {
#           process => {
#             display  => true,
#             awaymode => true
#           }
#         }
#       },
#       'Realtek PCIe GbE Family Controller' => {
#         enable_wake => false,
#         power_request_overrides => {
#           driver => {
#             display => true,
#             system  => true
#           }
#         }
#       }
#     }
#   }
#
# @param devices
#   hash of devices/drivers/services/tools to manage and what/how
class windows_power (
  Optional[Hash[String[1], Hash[Pattern[/^[a-z][a-z0-9_]*$/], Data, 1], 1]] $devices = undef,
) {
  if $devices !~ Undef {
    each($devices) |$key, $value| {
      windows_power::device { $key:
        * => $value,
      }
    }
  }
}
