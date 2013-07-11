define windows_power::settings(
  $scheme_name,
  $setting,
  $value
) {

  exec { "modify ${setting} setting for ${scheme_name}":
    command => "& C:\\Windows\\System32\\powercfg.exe -${setting} ${value}",
    provider  => powershell,
    logoutput => true,
    unless => $windows_power::params::nasty_ps,
  }
}