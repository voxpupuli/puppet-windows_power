# Changelog

All notable changes to this project will be documented in this file.
Each new release typically also includes the latest modulesync defaults.
These should not affect the functionality of the module.

## [v5.0.0](https://github.com/voxpupuli/puppet-windows_power/tree/v5.0.0) (2026-07-22)

[Full Changelog](https://github.com/voxpupuli/puppet-windows_power/compare/v4.0.0...v5.0.0)

This release greatly improves handling/detecting various settings and reduces the necessity of repeatingly enforcing the same (already in place) configuration. Thanks to [WeiterWeiterFertigstellen](https://github.com/WeiterWeiterFertigstellen) for digging into this topic.

To achieve this:
  - add facts `hibernation_enabled` and `power_settings`
  - use facts' data to decide if settings need to get applied
  - improve relationships between commands to reduce unneeded executions

**Maintenance changes:**

- Add support for Windows 2025
- Drop dependencies to `puppetlabs/powershell` and `puppetlabs/pwshlib` as they're not needed anymore

**Breaking changes:**

- Drop Puppet 7 support
- Require OpenVox >= 8.19.0 (instead of Puppet)

**Closed issues:**

- This module creates a corrective change every Puppet run [\#57](https://github.com/voxpupuli/puppet-windows_power/issues/57)

**Merged pull requests:**

- #57 fix corrective changes + duplicate/rename scheme in one puppet run [\#58](https://github.com/voxpupuli/puppet-windows_power/pull/58) ([WeiterWeiterFertigstellen](https://github.com/WeiterWeiterFertigstellen))

## [v4.0.0](https://github.com/voxpupuli/puppet-windows_power/tree/v4.0.0) (2024-05-10)

[Full Changelog](https://github.com/voxpupuli/puppet-windows_power/compare/v3.0.2...v4.0.0)

This is a complete module rewrite/modernization (almost from scratch, but being inspired by what has been there before).

Beyond the Puppet language modernization (and corresponding module redesign) we can summarize the relevant (and breaking) changes as follows:
- drop support for legacy windows systems
- remove functionality targeting those legacy systems
- rework shell/powershell commands and codes accordingly
- correct datatypes and values to match up-to-date systems
- drop dependency to liamjbennett/puppet-win_facts
- update general dependencies/requirements
- add facts `power_schemes` and `power_devices` and structure the module around them

**Breaking changes:**

- great rework [\#54](https://github.com/voxpupuli/puppet-windows_power/pull/54) ([Lightning-](https://github.com/Lightning-))
- Drop Puppet 6 support [\#51](https://github.com/voxpupuli/puppet-windows_power/pull/51) ([bastelfreak](https://github.com/bastelfreak))
- modulesync 2.7.0 and drop puppet 4 [\#33](https://github.com/voxpupuli/puppet-windows_power/pull/33) ([bastelfreak](https://github.com/bastelfreak))

**Closed issues:**

- Settings can only be changed for the currently active scheme [\#36](https://github.com/voxpupuli/puppet-windows_power/issues/36)
- Use in-built Windows Facter facts [\#9](https://github.com/voxpupuli/puppet-windows_power/issues/9)

**Merged pull requests:**

- drop stdlib dependency [\#53](https://github.com/voxpupuli/puppet-windows_power/pull/53) ([Lightning-](https://github.com/Lightning-))
- Remove duplicate CONTRIBUTING.md file [\#38](https://github.com/voxpupuli/puppet-windows_power/pull/38) ([dhoppe](https://github.com/dhoppe))

## [v3.0.2](https://github.com/voxpupuli/puppet-windows_power/tree/v3.0.2) (2018-10-20)

[Full Changelog](https://github.com/voxpupuli/puppet-windows_power/compare/v3.0.1...v3.0.2)

**Merged pull requests:**

- modulesync 2.2.0 and allow puppet 6.x [\#28](https://github.com/voxpupuli/puppet-windows_power/pull/28) ([bastelfreak](https://github.com/bastelfreak))

## [v3.0.1](https://github.com/voxpupuli/puppet-windows_power/tree/v3.0.1) (2018-09-06)

[Full Changelog](https://github.com/voxpupuli/puppet-windows_power/compare/v3.0.0...v3.0.1)

**Merged pull requests:**

- allow puppetlabs/stdlib 5.x [\#25](https://github.com/voxpupuli/puppet-windows_power/pull/25) ([bastelfreak](https://github.com/bastelfreak))
- Remove docker nodesets [\#22](https://github.com/voxpupuli/puppet-windows_power/pull/22) ([bastelfreak](https://github.com/bastelfreak))
- drop EOL OSs; fix puppet version range [\#21](https://github.com/voxpupuli/puppet-windows_power/pull/21) ([bastelfreak](https://github.com/bastelfreak))

## [v3.0.0](https://github.com/voxpupuli/puppet-windows_power/tree/v3.0.0) (2017-11-17)

[Full Changelog](https://github.com/voxpupuli/puppet-windows_power/compare/v2.0.0...v3.0.0)

**Merged pull requests:**

- bump puppet version dependency to \>= 4.7.1 \< 6.0.0 [\#17](https://github.com/voxpupuli/puppet-windows_power/pull/17) ([bastelfreak](https://github.com/bastelfreak))

## [v2.0.0](https://github.com/voxpupuli/puppet-windows_power/tree/v2.0.0) (2017-02-11)

This is the last release with Puppet3 support!
* Drop of ruby187 support!
* Fix several rubocop issues
* rubocop: fix RSpec/ImplicitExpect
* Modulesync

## 2015-03-23 Release 1.0.0
- Initial module release to voxpupuli
