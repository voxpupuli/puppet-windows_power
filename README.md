**This module is deprecated. Do not use it anymore**

# puppet-windows_power

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What is the windows_power module?](#module-description)
3. [Setup - The basics of getting started with windows_power](#setup)
    * [What windows_power affects](#what-power-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with windows_power](#beginning-with-power)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

Puppet module for managing windows power settings

[![Build Status](https://travis-ci.org/voxpupuli/puppet-windows_power.svg?branch=master)](https://travis-ci.org/voxpupuli/puppet-windows_power)
## Module Description

The purpose of this module is to manage each of the windows power schemes and the various global power settings

## Setup

### What windows_power affects

* Creates new power schemes (which will alter registry settings)

### Beginning with windows_power

Create new power scheme:

```puppet
windows_power::schemes::scheme { 'test scheme':
  scheme_name     => 'test',
  scheme_guid     => '381b4222-f694-41f0-9685-ff5bbxx65ddx',
  template_scheme => '381b4222-f694-41f0-9685-ff5bb260df2e',
  activation      => 'active',
  ensure          => 'present',
}
```

Set monitor timeout in 'Balanced' power scheme to 10 minutes:

```puppet
windows_power::schemes::settings { 'set monitor timeout':
  scheme_name => 'SCHEME_BALANCED',
  setting     => 'monitor-timeout-ac',
  value       => '10',
}

```

## Usage

### Classes and Defined Types:

#### Defined Type: `windows_power::schemes::scheme`

**Parameters within `windows_power::schemes::scheme`:**

##### `scheme_name`

The name of the scheme to configure

##### `scheme_guid`

The windows guid used to uniquely identify the power scheme

##### `template_scheme`

The windows guid of an existing scheme to be used as a template for the current scheme

##### `activation`

Set the current scheme as the active scheme

##### `ensure`

Configure if the scheme is present or absent
The initial version

#### Defined Type: `windows_power::schemes::settings`

**Parameters within `windows_power::schemes::settings`:**

##### `scheme_name`

The name of the scheme to configure

##### `setting`

The setting to configure

##### `value`

The value set the setting to - minutes or throttle

#### Defined Type: `windows_power::global::battery`

**Parameters within `windows_power::global::battery`:**

##### `setting`

Battery alarm setting to The initial versionconfigure

##### `status`

Setting configuration (on/off) or percentage (in the case of the level setting)

##### `criticality`

The level of battery criticality at which to provide an alarm. LOW or HIGH.

#### Defined Type: `windows_power::global::flags`

**Parameters within `windows_power::global::flags`:**

##### `setting`

The global power flag to configure

##### `status`

Setting configuration (on/off)

#### Defined Type: `windows_power::global::hiberation`

**Parameters within `windows_power::global::hibernation`:**

##### `status`

Setting configuration (on/off)

#### Defined Type: `windows_power::devices::override`

**Parameters within `windows_power::devices::override`:**

##### `type`

Specifies one of the following caller types: PROCESS, SERVICE, DRIVER

##### `request`

Specifies one or more of the following Power Request Types: Display, System, Awaymode

#### Defined Type: `windows_power::devices::wake`

**Parameters within `windows_power::devices::wake`:**

##### `device`

Specifies the device name

##### `ensure`

Enable or disable the device for waking

## Reference

### Defined Types:

#### Public Defined Types:

* [`windows_power::schemes::scheme`](#define-schemes-scheme): Guides the management of windows power schemes
* [`windows_power::schemes::settings`](#define-schemes-settings): Configures individual settings with a given scheme.
* [`windows_power::global::battery`](#define-global-battery): Configure power battery alarms.
* [`windows_power::global::flags`](#define-global-flags): Configure the global settings for windows power schemes
* [`windows_power::global::hiberation`](#define-global-hibernation): Configure the hibernation setting
* [`windows_power::devices::override`](#define-devices-override): Configure power overrides for certain devices
* [`windows_power::devices::wake`](#define-devices-wake): Configure the device wake settings

## Limitations

This module is tested on the following platforms:

* Windows 2008 R2

It is tested with the OSS version of Puppet only.

## Development

### Contributing

Please read CONTRIBUTING.md for full details on contributing to this project.
