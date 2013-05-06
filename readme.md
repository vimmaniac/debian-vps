## Debian 6 VPS Script

Remove excess packages (apache2, sendmail, bind9, samba, nscd, etc) and install the basic components needed for a light-weight HTTP(S) web server:

 - dropbear (SSH)
 - iptables (firewall)
 - dash (replaces bash)
 - syslogd
 - MySQL (v5.5+ without Innodb, configured for lowend VPS)
 - PHP-FPM (v5.3+ with APC installed and configured)
 - exim4 (light mail server)
 - nginx (v1.2+ from dotdeb)
 - nano, mc, htop, iftop & iotop

Includes sample nginx config files for PHP sites. You can create a basic site shell (complete with nginx vhost) like this:

./deb-setup.sh site www.example.com

When running the iptables or dropbear install you must specify a SSH port. Remember, port 22 is the default. It's recommended that you change this from 22 just to save server load from attacks on that port.

## Usage (in recommended order)

### Warning! This script will overwrite previous configs during reinstallation.

	wget --no-check-certificate https://raw.github.com/perttierkkila/debian-vps/master/deb-setup.sh
	chmod +x deb-setup.sh
	./deb-setup.sh dotdeb
	./deb-setup.sh locale   # for OpenVZ
	./deb-setup.sh system
	./deb-setup.sh dropbear [port]
	./deb-setup.sh iptables [port]
	./deb-setup.sh mysql
	./deb-setup.sh nginx
	./deb-setup.sh php
	./deb-setup.sh exim4
	./deb-setup.sh site [site url]
	./deb-setup.sh mysqluser [site url]
	./deb-setup.sh wordpress [site url]

##### Zabbix

For agent, enter Zabbix-server IP to configure agent and iptables to allow connections. Host name refers configured name at Zabbix-server (required to get active checks working). Server installs main server, frontend and local agent. Running server+frontend requires around 100Mb extra memory and modifications to PHP-settings, so 150Mb+ memory is required. Agent takes around 4Mb.

	wget --no-check-certificate https://raw.github.com/perttierkkila/debian-vps/master/deb-zabbix.sh
	chmod +x deb-zabbix.sh
	./deb-zabbix.sh agent [server ip] [host name]
	./deb-zabbix.sh server [host name]

##### 3proxy

	wget --no-check-certificate https://raw.github.com/perttierkkila/debian-vps/master/deb-3proxy.sh
	chmod +x deb-3proxy.sh
	./deb-3proxy.sh install [port]
	./deb-3proxy.sh auth [username] [password]

##### Webmin

	./deb-setup.sh webmin

##### Classic Disk I/O and Network test

Run the classic Disk IO (dd) & Classic Network (cachefly) Test

	./deb-setup.sh test

##### Neat python script to report memory usage per app

Neat python script to report memory usage per app

	./deb-setup.sh ps_mem

##### Info on Operating System, version and Architecture

	./deb-setup.sh info

##### SSH-Keys

Either you want to generate ssh-keys (id_rsa) or a custom key for something (rsync etc)
Note: argument is optional, if its left out, it will write "id_rsa" key

	./deb-setup.sh sshkey [optional argument_1]
    
## After installation

- MySQL root is given a new password which is located in ~root/.my.cnf
- after installing the full set, ram usage reaches ~40-45Mb.
- by default APC is configured to use 16Mb for caching
- to reduce ram usage, you may disable APC by moving or deleting file /etc/php5/conf.d/apc.ini
- I recommend installing Ajenti and/or Webmin to manage your VPS

## Credits

- [LowEndBox admin (LEA)](https://github.com/lowendbox/lowendscript)
- [Xeoncross](https://github.com/Xeoncross/lowendscript),
- [ilevkov](https://github.com/ilevkov/lowendscript),
- [asimzeeshan](https://github.com/asimzeeshan)
- and many others!

