define windows_power::scheme(
  $template_scheme = '',
  $scheme_name = '',
  $scheme_guid = '',
  $activation = '',
  $ensure = 'present'
) {

  $template_guid = $windows_power::params::template_schemes[$template_scheme]

  if $ensure == 'present' {
    exec { "create power scheme ${scheme_name}":
      command => "& C:\\Windows\\System32\\powercfg.exe -duplicatescheme ${template_guid}",
      provider  => powershell,
      logoutput => true,
      onlyif    => $windows_power::params::nasty_ps
    }

    exec { "rename scheme to ${scheme_name}":
      command => "& C:\\Windows\\System32\\powercfg.exe -changename ${scheme_guid} ${scheme_name}"
      provider  => powershell,
      logoutput => true,
      onlyif => $windows_power::params::nasty_ps,
      require => Exec["rename scheme to ${scheme_name}"]
    }
  }
  elsif $ensure == 'absent' {
    exec { "delete power scheme ${scheme_name}":
      command => "& C:\\Windows\\System32\\powercfg.exe -delete ${scheme_guid}",
      provider  => powershell,
      logoutput => true,
      unless => $windows_power::params::nasty_ps,
    }
  }

  if $actiation == 'active' {
    exec { "set ${scheme_name} scheme as active":
      command => "& C:\\Windows\\System32\\powercfg.exe -setactive ${scheme_guid}",
      provider  => powershell,
      logoutput => true,
      unless => $windows_power::params::nasty_ps,
    }
  }
}