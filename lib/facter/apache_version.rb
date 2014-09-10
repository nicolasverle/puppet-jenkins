require 'facter'

if(Facter.value(:osfamily) == "redhat") 
	result = %x{/usr/sbin/httpd -v | /bin/grep 'Server version:'  | /bin/awk '{print $3}' | /usr/bin/tr -d 'Apache/'}
else 
	result = %x{/usr/sbin/apache2 -v | /bin/grep 'Server version:'  | /usr/bin/awk '{print $3}' | /usr/bin/tr -d 'Apache/'}
end

Facter.add('apache_version') do
    setcode do
        result
    end
end