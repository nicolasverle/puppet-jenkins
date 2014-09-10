
class jenkins (
	$version = 'latest',
	$context_path = '',
	$http_port = '8080',
	$https_port = undef,
	$java_cmd = undef,
	$apache_frontend = false
) {

	$jenkins_template = $osfamily ? {
		'redhat'	=> 'jenkins/jenkins/jenkins-redhat.erb',
		'debian'	=> 'jenkins/jenkins/jenkins-debian.erb',
		default               		=> undef
    }
	$config_location = $osfamily ? {
		'redhat'	=> '/etc/sysconfig/jenkins',
		'debian'	=> '/etc/default/jenkins',
		default						=> undef
    }
	
	jenkins::repo {'add-repo': }
	
	if($version != 'latest' and $osfamily == 'redhat') {
		$_version = "${version}-1.1"
	} else {
		$_version = $version
	}
	
	if($osfamily == 'debian' and $_version != 'latest') {
		# Ugly workaround for debian since the jenkins debian repository seems to be buggy 
		# and only the latest jenkins version is available.
		# See https://issues.jenkins-ci.org/browse/INFRA-92
	
		exec { 'grab deb jenkins': 
			command	=> "wget -q http://pkg.jenkins-ci.org/debian/binary/jenkins_${_version}_all.deb -O /tmp/jenkins_${_version}_all.deb",
			creates	=> '/var/lib/jenkins/',
			path	=> ['/usr/bin'],
			require	=> Jenkins::Repo['add-repo']
		} -> 
		package { 'daemon': 
		} ->
		package { 'jenkins': 
			provider	=> 'dpkg',
			source		=> "/tmp/jenkins_${_version}_all.deb"
		}
	} else {
		package { 'jenkins': 
			ensure	=> $_version,
			require	=> Jenkins::Repo['add-repo']
		}
	}
	
	file { $config_location:
		ensure 	=> 'present', 
		content	=> template($jenkins_template),
		require => Package['jenkins']
	}
	
	file { '/var/lib/jenkins/plugins':
		ensure 	=> 'directory', 
		owner 	=> 'jenkins',
		require => Package['jenkins']
	}
	
	if($apache_frontend) {
		jenkins::apache { 'add_frontend': 
			jenkins_alias	=> $context_path,
			jenkins_port	=> $http_port
		}
	}
		
	service { 'jenkins':
		ensure 		=> 'running',
		require 	=> Package['jenkins']
	}

}