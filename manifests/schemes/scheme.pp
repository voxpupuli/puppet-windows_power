# == Define: windows_power::schemes::scheme
#
# This definition configures a specific power scheme
#
# === Parameters
#
# [*scheme_name*]
# The name of the scheme to configure
#
# [*scheme_guid*]
# The windows guid used to uniquely identify the power scheme
#
# [*template_scheme*]
# The windows guid of an existing scheme to be used as a template for the current scheme
#
# [*activation*]
# Set the current scheme as the active scheme
#
# [*ensure*]
# Configure if the scheme is present or absent
#
# === Examples
#
#    windows_power::schemes::scheme { 'test scheme':
#       scheme_name     => 'test',
#       scheme_guid     => '381b4222-f694-41f0-9685-ff5bbxx65ddx',
#       template_scheme => '381b4222-f694-41f0-9685-ff5bb260df2e',
#       activation      => 'active',
#       ensure          => 'present',
#    }
#
define windows_power::schemes::scheme (
  String[1] $scheme_name,
  Pattern[/\A[A-Za-z0-9]{8}-[A-Za-z0-9]{4}-[A-Za-z0-9]{4}-[A-Za-z0-9]{4}-[A-Za-z0-9]{12}\z/] $scheme_guid,
  String[1] $template_scheme,
  Enum['active', 'inactive'] $activation,
  Enum['present', 'absent'] $ensure = 'present',
) {
  include windows_power::params

  if $ensure == 'present' {
    case $facts['operatingsystemversion'] {
      'Windows XP', 'Windows Server 2003', 'Windows Server 2003 R2': {
        exec { "create power scheme ${scheme_name}":
          command   => "& powercfg /create '${scheme_name}'",
          provider  => powershell,
          logoutput => true,
          onlyif    => "${windows_power::params::nasty_ps} \$items.contains('${scheme_name}')",
        }
      }
      default: {
        exec { "create power scheme ${scheme_name}":
          command   => "& powercfg /duplicatescheme ${template_scheme} ${scheme_guid}",
          provider  => powershell,
          logoutput => true,
          unless    => "powercfg /query ${scheme_guid}",
        }

        exec { "rename scheme to ${scheme_name}":
          command   => "& powercfg /changename ${scheme_guid} '${scheme_name}'",
          provider  => powershell,
          logoutput => true,
          onlyif    => "if (Get-CimInstance -Namespace root\\cimv2\\power -ClassName win32_powerplan -Filter \"ElementName = '${scheme_name}'\" | Where -property InstanceID -eq 'Microsoft:PowerPlan\\{${scheme_guid}}') { exit 1 } else { exit 0 }",
          require   => Exec["create power scheme ${scheme_name}"],
        }
      }
    }
  }
  elsif $ensure == 'absent' {
    exec { "delete power scheme ${scheme_name}":
      command   => "& powercfg /delete ${scheme_guid}",
      provider  => powershell,
      logoutput => true,
      onlyif    => "powercfg /query ${scheme_guid}",
    }
  }

  if $activation == 'active' {
    exec { "set ${scheme_name} scheme as active":
      command   => "& powercfg /setactive ${scheme_guid}",
      provider  => powershell,
      logoutput => true,
      onlyif    => "if (Get-CimInstance -Namespace root\\cimv2\\power -ClassName win32_powerplan -Filter \"IsActive = True\" | Where -property InstanceID -eq 'Microsoft:PowerPlan\\{${scheme_guid}}') { exit 1 }",
    }
  }
}
