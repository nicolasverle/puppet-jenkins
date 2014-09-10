define jenkins::repo {

	case $osfamily {
		'debian': { 
			
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
		'redhat': {
			
			yumrepo { 'jenkins':
				baseurl		=> "http://pkg.jenkins-ci.org/redhat",
				descr		=> 'jenkins repository',
				gpgcheck	=> 1
			}
			
			exec { 'jenkins_key_RH': 
				command	=> "rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key",
				path	=> ["/bin", "/usr/bin"],
				creates	=> "/etc/yum.repos.d/jenkins.repo",
				require	=> Yumrepo["jenkins"]
			}
			
		}
		default: { fail("Sorry, but this module doesn't support ${osfamily} OS") }
	}
}