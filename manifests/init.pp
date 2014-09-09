
class jenkins (
	$version = undef,
	$context_path = undef,
	$http_port = undef,
	$https_port = undef,
	$java_cmd = undef,
	$apache_frontend = false
) {
	
	jenkins::repo {'add-repo':}
	
	package { "jenkins": 
		require	=> Jenkins::Repo['add-repo']
	}
	
	$jenkins_template = $operatingsystem ? {
      /(?i:CentOS|RedHat|Fedora)/	=> 'jenkins/jenkins/jenkins-redhat.erb',
      /(?i:Ubuntu|Debian|Mint)/		=> 'jenkins/jenkins/jenkins-debian.erb',
      default               		=> undef
    }
	$config_location = $operatingsystem ? {
      /(?i:CentOS|RedHat|Fedora)/	=> '/etc/sysconfig/jenkins',
      /(?i:Ubuntu|Debian|Mint)/		=> '/etc/default/jenkins',
      default               		=> undef
    }
	
	file { $config_location:
		ensure 	=> "present", 
		content	=> template($jenkins_template),
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
		require 	=> Package["jenkins"]
	}

}