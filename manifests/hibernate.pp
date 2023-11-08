class windows_power::hibernate (
	Boolean $enable,
	Optional[Integer[40, 100]] $hiberfile_size,
	Optional[Enum['reduced', 'full']] $hiberfile_type,
) {
	if $enable {
		exec { 'enable_hibernate':
			provider => windows,
			path     => $facts['os']['windows']['system32'],
			command  => 'powercfg /hibernate on',
		}

		if $hiberfile_size !~ Undef {
			exec { 'set_hiberfile_size':
				provider => windows,
				path     => $facts['os']['windows']['system32'],
				command  => "powercfg /hibernate /size ${hiberfile_size}",
			}
		}

		if $hiberfile_type !~ Undef {
			exec { 'set_hiberfile_type':
				provider => windows,
				path     => $facts['os']['windows']['system32'],
				command  => "powercfg /hibernate /type ${hiberfile_type}",
			}
		}
	}
	else {
		exec { 'disable_hibernate':
			provider => windows,
			path     => $facts['os']['windows']['system32'],
			command  => 'powercfg /hibernate off',
		}
	}
}
