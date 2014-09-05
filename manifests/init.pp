
class jenkins (
	$version = undef,
	$context_path = undef,
	$http_port = 8080,
	$https_port = undef,
	$java_cmd = undef,
	$apache_frontend = false
) {
	
	jenkins::repo {'add-repo':}
	
	package { "jenkins": 
		require	=> Jenkins::Repo['add-repo']
	}
	
	$config_file = $operatingsystem ? {
      /(?i:CentOS|RedHat|Fedora)/	=> '/etc/sysconfig/jenkins',
      /(?i:Ubuntu|Debian|Mint)/		=> '/etc/default/jenkins',
      default               		=> undef
    }
	
	$_context_path = $context_path ? {
		undef	=> undef,
		""		=> undef,
		default	=> "set JENKINS_ARGS \"'--prefix=/${context_path}'\""
	}
	$_http_port = $http_port ? {
		undef	=> undef,
		""		=> undef,
		default	=> "set JENKINS_PORT \"'${http_port}'\""
	}
	augeas { 'set_context_path':
		lens	=> "Properties.lns",
		incl	=> "${config_file}",
		changes	=> delete_undef_values( [$_context_path, $_http_port] ),
		require	=> Package['jenkins'],
		notify	=> Service['jenkins']
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
	
	if($apache_frontend) {
		jenkins::apache { 'add_frontend': 
			jenkins_alias	=> $context_path,
			jenkins_port	=> $http_port
		}
	}
		
	service { "jenkins":
		ensure 		=> "running",
		subscribe 	=> [
			File["/var/lib/jenkins/config.xml"]
		],
		require 	=> Package["jenkins"]
	}

}