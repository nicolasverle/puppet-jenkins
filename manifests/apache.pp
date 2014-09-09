define jenkins::apache(
	$jenkins_alias = undef,
	$jenkins_port = undef
) {
	
	$apache_service = $operatingsystem ? {
		/(?i:CentOS|RedHat|Fedora)/	=> 'httpd',
		/(?i:Ubuntu|Debian|Mint)/	=> 'apache2',
		default						=> undef
    }
	
	ensure_resource('package', $apache_service, {'ensure' => 'present'})
	
	if(versioncmp('2.2.18', $toto_version) > 0) {
		warning("Your current version of Apache Server is ${toto_version} which might be not fully compatible with apache frontend jenkins requirement !
For instance 'AllowEncodedSlashes' option cannot be set to 'NoDecode' with versions prior to 2.2.18. 
See https://wiki.jenkins-ci.org/display/JENKINS/Jenkins+says+my+reverse+proxy+setup+is+broken for further details.")
	}
	
	case $operatingsystem {
		/(?i:CentOS|RedHat|Fedora)/: {
			
			file { '/etc/httpd/conf.d/jenkins.conf': 
				ensure	=> 'present',
				content	=> template('jenkins/apache/jenkins.conf.erb'),
				notify	=> Service[$apache_service]
			}
			
		}
		/(?i:Ubuntu|Debian|Mint)/ : {
			
			file { '/etc/apache2/sites-available/jenkins.conf': 
				ensure	=> 'present',
				content	=> template('jenkins/apache/jenkins.conf.erb')
			} -> 
			file { '/etc/apache2/sites-enabled/jenkins.conf': 
				ensure	=> 'link',
				target	=> '/etc/apache2/sites-available/jenkins.conf',
				notify	=> Service[$apache_service]
			}

			
		} 
		default: { fail("Sorry, but this module doesn't support ${operatingsystem} OS") }
    }
	
	service { $apache_service: 
		enable	=> "true",
		ensure	=> "running"
	}

}