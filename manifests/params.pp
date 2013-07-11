class windows_power::params {

  $template_schemes = { 'Balanced' => '381b4222-f694-41f0-9685-ff5bb260df2e',
                        'High Performance' => '8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c',
                        'Power Saver' => 'a1841308-3541-4fab-bc81-f71556f20b4a'
                      }

  $nasty_ps = "$items = [System.Collections.ArrayList]@(powercfg -l | %{ $a = [System.Collections.ArrayList]$_.Split('('); $a.RemoveAt(0); if( (![string]::IsNullOrEmpty($a[a])) -and (!$a[0].contains('* Active')) ) { $b = $a[0].Split(')')[0]; $b } }); $items.contains(${scheme_name})"
}