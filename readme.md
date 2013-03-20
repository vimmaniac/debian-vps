## Debian 6 VPS Script

Remove excess packages (apache2, sendmail, bind9, samba, nscd, etc) and install the basic components needed for a light-weight HTTP(S) web server:

 - dropbear (SSH)
 - iptables (firewall)
 - dash (replaces bash)
 - syslogd
 - MySQL (v5.5+ without Innodb, configured for lowend VPS)
 - PHP-FPM (v5.3+ with APC installed and configured)
 - exim4 (light mail server)
 - nginx (v1.2+ from dotdeb, configured for lowend VPS)
 - nano, mc, htop, iftop & iotop (more to come...)

Includes sample nginx config files for PHP sites. You can create a basic site shell (complete with nginx vhost) like this:

./deb-setup.sh site example.com

When running the iptables or dropbear install you must specify a SSH port. Remember, port 22 is the default. It's recomended that you change this from 22 just to save server load from attacks on that port.

## Usage (in recomended order)

### Warning! This script is self destructive, it'll overwrite previous configs during reinstallation.

	wget --no-check-certificate https://raw.github.com/perttierkkila/lowendscript/master/deb-setup.sh && chmod +x deb-setup.sh
	./deb-setup.sh dotdeb
	./deb-setup.sh locale 	# for OpenVZ
	./deb-setup.sh system
	./deb-setup.sh dropbear [port]
	./deb-setup.sh iptables [port]
	./deb-setup.sh mysql
	./deb-setup.sh nginx
	./deb-setup.sh php
	./deb-setup.sh exim4
	./deb-setup.sh site example.com
	./deb-setup.sh wordpress example.com
	./deb-setup.sh 3proxy 3128
	./deb-setup.sh 3proxyauth username password

#### ... and now time for some extras

##### Webmin

	./deb-setup.sh webmin

##### Classic Disk I/O and Network test

Run the classic Disk IO (dd) & Classic Network (cachefly) Test

	./deb-setup.sh test

##### Neat python script to report memory usage per app

Neat python script to report memory usage per app

	./deb-setup.sh ps_mem

##### sources.list updating (Ubuntu only)

Updates Ubuntu /etc/apt/sources.list to default based on whatever version you are running

	./deb-setup.sh apt

##### Info on Operating System, version and Architecture

	./deb-setup.sh info

##### SSH-Keys

Either you want to generate ssh-keys (id_rsa) or a custom key for something (rsync etc)
Note: argument is optional, if its left out, it will write "id_rsa" key

	./deb-setup.sh sshkey [optional argument_1]
    
## After installation

MySQL root is given a new password which is located in ~root/.my.cnf.
After installing the full set, ram usage reaches ~40-45Mb.
By default APC configured to use 16Mb for caching.
To reduce ram usage, you may disable APC by moving or deleting the following file - /etc/php5/conf.d/apc.ini
I recommend installing Ajenti and/or Webmin to manage your VPS.

## Credits

- [LowEndBox admin (LEA)](https://github.com/lowendbox/lowendscript)
- [Xeoncross](https://github.com/Xeoncross/lowendscript),
- [ilevkov](https://github.com/ilevkov/lowendscript),
- [asimzeeshan](https://github.com/asimzeeshan)
- and many others!

