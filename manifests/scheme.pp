# @summary class to manage Windows power scheme
#
# @example activate the "High performance" system scheme
#   class { 'windows_power::scheme':
#     guid => '8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c'
#   }
#
# @example activate the "Balanced" system scheme and set some monitor timeouts
#   class { 'windows_power::scheme':
#     guid     => '381b4222-f694-41f0-9685-ff5bb260df2e',
#     settings => {
#       monitor-timeout-ac => 30,
#       monitor-timeout-dc => 10
#     }
#   }
#
# @example create a custom template inheriting "High performance" and tweak on that
#   class { 'windows_power::scheme':
#     guid     => 'a1582e9e-9c9d-46fd-afdf-4d989292a073',
#     label    => 'really full power',
#     template => '8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c',
#     settings => {
#       disk-timeout-ac      => 0,
#       disk-timeout-dc      => 0,
#       standby-timeout-ac   => 0,
#       standby-timeout-dc   => 0,
#       hibernate-timeout-ac => 0,
#       hibernate-timeout-dc => 0
#     }
#   }
#
# @param guid
#   GUID of the scheme to create/activate;
#   to activate/handle an existing scheme (e.g. the ones provided by the system) don't define a template;
#   to create (and activate and handle) a new scheme (derived from an existing one) define the template.
#
# @param label
#   desired label/name/title of the scheme (optional, recommended for custom schemes)
#
# @param template
#   GUID of the template scheme to use for creating a new custom scheme (optional);
#   if the template does not exist no action is performed; so it's safe to define a template that will appear later somehow.
#
# @param description
#   desired descriptive text of the scheme (optional)
#
# @param settings
#   settings to change (optional);
#   settings are applied to the active scheme and only if this matches the declared GUID; this way accidential configuration of the wrong
#   scheme is avoided but it might need more than one puppet run to complete all tasks.
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
      exec { 'activate_duplicated_power_scheme':
        provider => windows,
        path     => $facts['os']['windows']['system32'],
        command  => "powercfg /setactive ${guid}",
        require  => Exec['duplicate_existing_power_scheme'],
      }
    }
  }

  if ($guid in $facts['power_schemes']) and !($facts['power_schemes'][$guid]['active']) {
    exec { 'activate_existing_power_scheme':
      provider => windows,
      path     => $facts['os']['windows']['system32'],
      command  => "powercfg /setactive ${guid}",
    }
  }

  if $label !~ Undef {
    $rename_command = $description ? {
      Undef   => "powercfg /changename ${guid} \"${label}\"",
      default => "powercfg /changename ${guid} \"${label}\" \"${description}\"",
    }
    if ($guid in $facts['power_schemes']) and ($facts['power_schemes'][$guid]['name'] != $label) {
      exec { 'rename_power_scheme':
        provider => windows,
        path     => $facts['os']['windows']['system32'],
        command  => $rename_command,
      }
    }
    elsif !($guid in $facts['power_schemes']) {
      # rename the newly duplicated and activated scheme in one puppet run
      exec { 'rename_power_scheme':
        provider    => windows,
        path        => $facts['os']['windows']['system32'],
        command     => $rename_command,
        subscribe   => Exec['activate_duplicated_power_scheme'],
        refreshonly => true,
      }
    }
  }

  if ($guid in $facts['power_schemes']) and $facts['power_schemes'][$guid]['active'] {
    if $settings !~ Undef {
      each($settings) |$key, $value| {
        # facts power_settings is the value in seconds
        if $facts['power_settings'][$key] != $value * 60 {
          exec { "set_power_scheme_setting_${key}":
            provider => windows,
            path     => $facts['os']['windows']['system32'],
            command  => "powercfg /change ${key} ${value}",
          }
        }
      }
    }
  }
}
