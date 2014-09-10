define jenkins::repo(
	$version = undef
) {

	case $operatingsystem {
		/(?i:Ubuntu|Debian|Mint)/: { 
			
			apt::key { 'jenkins_key':
				key        => 'D50582E6',
				key_source => 'http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key'
			}
			
			apt::source { 'jenkins':
				location	=> 'http://pkg.jenkins-ci.org/debian',
				release		=> 'binary/',
				repos		=> '',
				comment		=> 'Jenkins debian repository',
				include_src => false,
				require		=> Apt::Key['jenkins_key']
			}
			
		}
		/(?i:CentOS|RedHat|Fedora)/: {
			
			yumrepo { 'jenkins':
				baseurl		=> $baseurl,
				descr		=> 'http://pkg.jenkins-ci.org/redhat',
				gpgcheck	=> 1
			}
			
			exec { 'jenkins_key_RH': 
				command	=> "rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key",
				path	=> ["/bin", "/usr/bin"],
				creates	=> "/etc/yum.repos.d/jenkins.repo",
				require	=> Yumrepo["jenkins"]
			}
			
		}
		default: { fail("Sorry, but this module doesn't support ${operatingsystem} OS") }
	}
}