#Windows Power module for Puppet

##Overview

Puppet module for managing windows power settings

This module is also available on the [Puppet Forge](https://forge.puppetlabs.com/liamjbennett/windows_power)

[![Build
Status](https://secure.travis-ci.org/liamjbennett/puppet-windows_power.png)](http://travis-ci.org/liamjbennett/puppet-windows_power)
[![Dependency
Status](https://gemnasium.com/liamjbennett/puppet-windows_power.png)](http://gemnasium.com/liamjbennett/puppet-windows_power)

##Module Description

The purpose of this module is to manage each of the windows power schemes and the various global power settings

##Usage

    windows_power::schemes::scheme { 'test scheme':
       scheme_name     => 'test',
       scheme_guid     => '381b4222-f694-41f0-9685-ff5bbxx65ddx',
       template_scheme => '381b4222-f694-41f0-9685-ff5bb260df2e',
       activation      => 'active',
       ensure          => 'present'
    }

##Development
Copyright (C) 2013 Liam Bennett - <liamjbennett@gmail.com> <br/>
Distributed under the terms of the Apache 2 license - see LICENSE file for details. <br/>
Further contributions and testing reports are extremely welcome - please submit a pull request or issue on [GitHub](https://github.com/liamjbennett/puppet-windows_power) <br/>

##Release Notes

__0.0.1__ <br/>
The initial version