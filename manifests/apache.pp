define jenkins::apache(
	$jenkins_alias = '',
	$jenkins_port = undef
) {
	
	$apache_service = $operatingsystem ? {
		/(?i:CentOS|RedHat|Fedora)/	=> 'httpd',
		/(?i:Ubuntu|Debian|Mint)/	=> 'apache2',
		default						=> undef
    }
	
	ensure_resource('package', $apache_service, {'ensure' => 'present'})
	
	case $operatingsystem {
		/(?i:CentOS|RedHat|Fedora)/: {
			
			file { '/etc/httpd/conf.d/jenkins.conf': 
				ensure	=> 'present',
				content	=> template('jenkins/apache/jenkins.conf.erb'),
				require => Package[$apache_service],
				notify	=> Service[$apache_service]
			}
			
		}
		/(?i:Ubuntu|Debian|Mint)/ : {
			
			exec { 'a2enmod proxy': 
				path	=> ['/usr/sbin', '/usr/bin'], 
				require	=> Package[$apache_service] 
			} -> 
			exec { 'a2enmod proxy_http': 
				path	=> ['/usr/sbin', '/usr/bin'] 
			} -> 
			file { '/etc/apache2/conf-available/jenkins.conf': 
				ensure	=> 'present',
				content	=> template('jenkins/apache/jenkins.conf.erb')
			} -> 
			exec { 'a2enconf jenkins.conf': 
				path	=> ['/usr/sbin', '/usr/bin'], 
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