define jenkins::apache(
	$jenkins_alias = undef,
	$jenkins_port = undef
) {
	
	case $operatingsystem {
		/(?i:CentOS|RedHat|Fedora)/: {
			
			ensure_resource('package', 'httpd', {'ensure' => 'present'})
			
			if(versioncmp('2.2.18', $httpd_version) > 0) {
				warning("Your current version of Apache Server is ${httpd_version} which might be not fully compatible with apache frontend jenkins requirement !
For instance 'AllowEncodedSlashes' option cannot be set to 'NoDecode' with versions prior to 2.2.18. 
See https://wiki.jenkins-ci.org/display/JENKINS/Jenkins+says+my+reverse+proxy+setup+is+broken for further details.")
			}
			
			file { '/etc/httpd/conf.d/jenkins.conf': 
				ensure	=> 'present',
				content	=> template('jenkins/apache/jenkins.conf.erb'),
				notify	=> Service['httpd']
			}
			
			service { 'httpd': 
				enable	=> "true",
				ensure	=> "running"
			}
			
		}
		/(?i:Ubuntu|Debian|Mint)/ : {
			
			
			
		} 
		default: { fail("Sorry, but this module doesn't support ${operatingsystem} OS") }
    }

}