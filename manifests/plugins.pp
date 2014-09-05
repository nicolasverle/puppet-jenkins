define jenkins::plugins (
	$version = undef
) {

	exec { "grab ${name}": 
		command	=> "wget -q http://updates.jenkins-ci.org/download/plugins/${name}/${version}/${name}.hpi -O /var/lib/jenkins/plugins/${name}.hpi",
		onlyif	=> "test ! -f /var/lib/jenkins/plugins/${name}.hpi",
		path	=> ["/bin", "/usr/bin", "/usr/sbin"]	
	}

	

}