define jenkins::installation (
	$install_name = undef,
	$home = undef,
	$properties = undef
) {

	if($properties == undef) {
		$_properties = ""
	} else {
		$_properties = $properties
	}

	case $name {
		"maven": {
			augeas { "update_maven_installations": 
				lens 	=> "Xml.lns",
				incl 	=> "/var/lib/jenkins/hudson.tasks.Maven.xml",
				context => "/files/var/lib/jenkins/hudson.tasks.Maven.xml/hudson.tasks.Maven_-DescriptorImpl",
				changes => [
					"set installations/hudson.tasks.Maven_-MavenInstallation[last()+1]/name/#text ${install_name}",
					"set installations/hudson.tasks.Maven_-MavenInstallation[name/#text='${install_name}']/home/#text ${home}",
					"set installations/hudson.tasks.Maven_-MavenInstallation[name/#text='${install_name}']/properties ''"
				],
				require => File["/var/lib/jenkins/hudson.tasks.Maven.xml"]
			}
		}
		"jdk": {
			augeas { "update_config": 
				lens 	=> "Xml.lns",
				incl 	=> "/var/lib/jenkins/config.xml",
				context => "/files/var/lib/jenkins/config.xml/hudson",
				changes => [
					"set jdks/jdk[last()+1]/name/#text ${install_name}",
					"set jdks/jdk[name/#text='${install_name}']/home/#text ${home}",
					"set jdks/jdk[name/#text='${install_name}']/properties ''"
				]
			}
		}
	}

}