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
