# @summary class to manage Windows hibernate settings
#
# @example disable hibernation system wide
#   class { 'windows_power::hibernate':
#     enable => false
#   }
#
# @example enable hibernation with default settings
#   class { 'windows_power::hibernate':
#     enable => true
#   }
#
# @example enable and configure hibernation
#   class { 'windows_power::hibernate':
#     enable         => true,
#     hiberfile_size => 100,
#     hiberfile_type => 'full'
#   }
#
# @param enable
#   enable/disable the hibernate feature
#
# @param hiberfile_size
#   set desired hiberfile size (percentage of total memory, 40-100)
#
# @param hiberfile_type
#   set desired hiberfile type (`reduced`/`full`)
class windows_power::hibernate (
	Boolean $enable,
	Optional[Integer[40, 100]] $hiberfile_size = undef,
	Optional[Enum['reduced', 'full']] $hiberfile_type = undef,
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
