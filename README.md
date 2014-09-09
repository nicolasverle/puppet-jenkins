Puppet module : jenkins
==============

## Overview

This is a Puppet module for installing and configuring a jenkins-ci server.

This module provides following functionnalities : 

* Installs a specific version or the latest jenkins server
* Configures some options (context path, java command path, http or https port...)
* Downloads and installs jenkins plugins
* Sets up an Apache frontend for jenkins-ci

##Requirement

**This module requires :**

* puppet >= 3.6
* augeas >= 1.0.0
* puppet stdlib module (https://forge.puppetlabs.com/puppetlabs/stdlib)

## Usage

* Download and install latest jenkins-ci version on port 8080 :

```puppet
	class { 'jenkins':  }
```

* Set jenkins-ci context path to "jenkins" and deploy it on 9081 port : 

```puppet
	class { 'jenkins':  
		http_port    => '9081',
        context_path => 'jenkins'
	}
```

* Install jenkins-ci and adds apache configuration frontend to serve jenkins on port 80

```puppet
	class { 'jenkins':  
		context_path	=> 'jenkins',
        apache_frontend => true
	}
```

* Download scp and groovy jenkins plugin and put them to plugins folder : 

```puppet
	jenkins::plugins { 'install plugins':
		plugins	=> {
			'scp'		=> { version => 'latest'},
			'groovy'	=> { version => '1.20'}
		},
		notify => Service['jenkins']
	}
```

* Download a plugin from specific repository : 

```puppet
	jenkins::plugins { 'install plugins':
		plugins	=> {
			'my-plugin' => { version => 'latest', update_url => 'http://my.repo.org/download/plugins'}
		},
		notify => Service['jenkins']
	}
```

## Compatibility

This module is made for red hat and debian OS.
It has been tested on CentOS 6.5 and Ubuntu 14.04