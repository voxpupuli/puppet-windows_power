class windows_power::scheme (
	Pattern[/\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/] $guid,
	Optional[String[1]] $label = undef,
	Optional[Pattern[/\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/]] $template = undef,
	Optional[String[1]] $description = undef,
	Optional[Hash[Enum[
		'monitor-timeout-ac',
		'monitor-timeout-dc',
		'disk-timeout-ac',
		'disk-timeout-dc',
		'standby-timeout-ac',
		'standby-timeout-dc',
		'hibernate-timeout-ac',
		'hibernate-timeout-dc'
	], Integer[0], 1, 8]] $settings = undef,
) {
	if $template !~ Undef {
		if !($guid in $facts['power_schemes']) and ($template in $facts['power_schemes']) {
			exec { 'duplicate_existing_power_scheme':
				provider => windows,
				path     => $facts['os']['windows']['system32'],
				command  => "powercfg /duplicatescheme ${template} ${guid}",
			}
		}
	}

	if ($guid in $facts['power_schemes']) and !($facts['power_schemes'][$guid]['active']) {
		exec { 'activate_power_scheme':
			provider => windows,
			path     => $facts['os']['windows']['system32'],
			command  => "powercfg /setactive ${guid}",
		}
	}
	elsif !($guid in $facts['power_schemes']) {
		exec { 'activate_power_scheme':
			provider => powershell,
			command  => "& powercfg /setactive ${guid}",
			onlyif   => "([System.Collections.ArrayList]@(powercfg /l | % { if ($_ -match '^.*?([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}).*$') {\$matches[1]} })).contains('${guid}')",
		}
	}

	if $label !~ Undef {
		if ($guid in $facts['power_schemes']) and ($facts['power_schemes'][$guid]['name'] != $label) {
			if $description !~ Undef {
				exec { 'rename_power_scheme':
					provider => windows,
					path     => $facts['os']['windows']['system32'],
					command  => "powercfg /changename ${guid} \"${label}\" \"${description}\"",
				}
			}
			else {
				exec { 'rename_power_scheme':
					provider => windows,
					path     => $facts['os']['windows']['system32'],
					command  => "powercfg /changename ${guid} \"${label}\"",
				}
			}
		}
	}

	if ($guid in $facts['power_schemes']) and $facts['power_schemes'][$guid]['active'] {
		if $settings !~ Undef {
			each($settings) |$key, $value| {
				exec { "set_power_scheme_setting_${key}":
					provider => windows,
					path     => $facts['os']['windows']['system32'],
					command  => "powercfg /change ${key} ${value}",
				}
			}
		}
	}
}
