Puppet module : jenkins
==============

## Overview

This is a Puppet module for installing and configuring a jenkins-ci server.

This module provides those functionnalities : 

* Installs a specific version or the latest jenkins server
* Configures some options (context path, java command path, http or https port...)
* Downloads and installs jenkins plugins
* Sets up an Apache frontend for jenkins-ci

## Usage

Download and installs latest jenkins-ci version on port 8080 :

```puppet
    class { 'jenkins':  }
```
