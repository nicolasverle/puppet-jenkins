require 'facter'
 
result = %x{/usr/sbin/httpd -v | /bin/grep 'Server version:'  | /bin/awk '{print $3}' | /usr/bin/tr -d 'Apache/'}

Facter.add('httpd_version') do
    setcode do
        result
    end
end