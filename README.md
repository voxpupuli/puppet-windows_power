# puppet-windows_power

## Module description

Puppet module for managing Windows hibernation settings, power schemes and power devices (or power request overrides respectively).

## Setup, Usage, Reference

Summary:
- use class `windows_power` to manage Windows power devices (physical, logical and virtual); this wraps the defined type `windows_power::device`
- use class `windows_power::hibernate` to manage Windows hibernate settings
- use class `windows_power::scheme` to manage Windows power scheme
- shipped fact `power_devices` contains all kind of system's power devices, their various wakeup capabilities and their power request overrides
- shipped fact `power_schemes` contains the system's power schemes and their activation state

See [REFERENCE.md](REFERENCE.md) for further details and practical examples.

## Special notice for v4.0.0

Version 4.0.0 is a complete rewrite and modernization of the previous module and breaks with configuration compatibility.

It also drops support for legacy Windows systems and removes functionality targeting those legacy systems. If you have any of those systems in place (such as Windows XP or Windows Server 2008) don't update.

## Limitations

Due to the nature of Windows' way to configure things, we can't just write a config file with desired settings and tell Windows to apply that (or something similar). As well we're not able to determine the current state of some settings (e.g. the timeouts in a power scheme) at all.

Therefore, some commands are applied with every Puppet run to ensure the desired state. Additionally, it might need more than one Puppet run to achieve the final state.

We know that this is very bad Puppet style and we did our best to keep this as minimal as possible. As well we put a lot of effort into making the module fail-safe (e.g. not configuring the wrong power scheme if a new one was created but hasn't been successfully activated yet) at the cost of "might need more than one run".

This module assumes that your system is not managed by an Active Directory controller. We have no way of testing what happens if your system (or parts of it including the power management) is controlled this way and you should use the AD's capabilities of managing power-things then anyways.

Also note that device names, scheme names and similar are subjected to localization (whyever ...). This means that you will have a device `System timer` on an English system and a `Systemzeitgeber` on a German system for example. Configuring devices and overrides in an environment with mixed installation languages is probably quite annoying as you will have to create different profiles for different languages with the corresponding device names.

If you have any ideas, suggestions, improvements ... please get in touch with us.

## Development

Development happens on GitHub in the well known way (fork, PR, issue, etc.).

Please feel free to report problems, suggest improvements, drop new ideas or teach us how to handle things better.
