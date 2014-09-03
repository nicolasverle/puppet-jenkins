define jenkins::plugin (
	$version = undef,
	$config = undef
) {

	wget::fetch { "dl plugin ${name}": 
		source => "wget -q http://updates.jenkins-ci.org/download/plugins/${name}/${version}/${name}.hpi",
		destination => "/var/lib/jenkins/plugins/",
		timeout => 0,
		verbose => false
	}

}