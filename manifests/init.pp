
class jenkins (
	$version = undef,
	$context_path = undef,
	$port = undef
) {
	
	class { "::java": }
	
	jenkins::repo {'add-repo':}
	
	package { "jenkins": 
		require	=> Jenkins::Repo['add-repo']
	}
	
	$config_file = $operatingsystem ? {
      /(?i:CentOS|RedHat|Fedora)/	=> '/etc/sysconfig/jenkins',
      /(?i:Ubuntu|Debian|Mint)/		=> '/etc/default/jenkins',
      default               		=> undef
    }
	
	if ($context_path != undef) {
		$_context_path = "\"--prefix=/${context_path}\""
		augeas { 'set_context_path':
			lens	=> "Properties.lns",
			incl	=> "${config_file}",
			changes	=> "set JENKINS_ARGS '$_context_path'",
			require	=> Package['jenkins']
		}
	}
	
	if ($port != undef) {
		$_port = "\"${port}\""
		augeas { 'set_port':
			lens	=> "Properties.lns",
			incl	=> "${config_file}",
			changes	=> "set JENKINS_PORT '$_port}'",
			require	=> Package['jenkins']
		}
	}
	
	file { "/var/lib/jenkins/config.xml": 
		ensure 	=> "present",
		group 	=> "jenkins",
		owner 	=> "jenkins",
		source 	=> "puppet:///modules/jenkins/config.xml",
		require => Package["jenkins"]
	}
	
	file { "/var/lib/jenkins/hudson.tasks.Maven.xml": 
		ensure 	=> "present",
		source 	=> "puppet:///modules/jenkins/hudson.tasks.Maven.xml",
		group 	=> "jenkins",
		owner 	=> "jenkins",
		require => Package["jenkins"]
	}
	
	file { "/var/lib/jenkins/plugins":
		ensure 	=> "directory", 
		group 	=> "jenkins",
		owner 	=> "jenkins",
		require => Package["jenkins"]
	}
		
	service { "jenkins":
		ensure 		=> "running",
		subscribe 	=> [
			File["/var/lib/jenkins/config.xml"]
		],
		require 	=> Package["jenkins"]
	}

}