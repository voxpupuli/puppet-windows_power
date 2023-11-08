class windows_power (
	Optional[Hash[String[1], Hash[Pattern[/^[a-z][a-z0-9_]*$/], Data, 1], 1]] $devices,
) {
	if $devices !~ Undef {
		each($devices) |$key, $value| {
			windows_power::device { $key:
				* => $value,
			}
		}
	}
}
