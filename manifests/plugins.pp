define jenkins::plugins (
	$plugins = undef,
	$update_url = undef
) {
	create_resources(plugins::grab, $plugins)
}

define plugins::grab (
	$version = undef,
	$update_url = undef
) {

	if($update_url == undef) {
		$_update_url = "http://updates.jenkins-ci.org/download/plugins"
	} else {
		$_update_url = $update_url
	}

	if($version == undef) {
		$_version = "latest"
	} else {
		$_version = $version
	}
	
	exec { "Grab ${name} plugin (${_version})":
        command	=> "wget ${_update_url}/${name}/${_version}/${name}.hpi -O /var/lib/jenkins/plugins/${name}.hpi",
        creates	=> "/var/lib/jenkins/plugins/${name}/",
		path	=> ["/usr/bin"]
     } ->
	 file { "/var/lib/jenkins/plugins/${name}.hpi": 
		ensure	=> "present",
		owner	=> "jenkins",
		mode	=> "0644"
	 }
}