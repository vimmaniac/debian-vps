#!/bin/bash

############################################################
# core functions
############################################################

function check_install {
	if [ -z "`which "$1" 2>/dev/null`" ]
	then
		executable=$1
		shift
		while [ -n "$1" ]
		do
			DEBIAN_FRONTEND=noninteractive apt-get -q -y install "$1"
			print_info "$1 installed for $executable"
			shift
		done
	else
		print_warn "$2 already installed"
	fi
}

function check_sanity {
	# Do some sanity checking.
	if [ $(/usr/bin/id -u) != "0" ]
	then
		die 'Must be run by root user'
	fi

	if [ ! -f /etc/debian_version ]
	then
		die "Distribution is not supported"
	fi
}

function die {
	echo "ERROR: $1" > /dev/null 1>&2
	exit 1
}

function print_info {
	echo -n -e '\e[1;36m'
	echo -n $1
	echo -e '\e[0m'
}

function print_warn {
	echo -n -e '\e[1;33m'
	echo -n $1
	echo -e '\e[0m'
}


############################################################
# applications
############################################################

function install_agent {

	if [ -z "$1" ] || [ -z "$2" ]
	then
		die "Usage: `basename $0` agent [server ip] [host name]"
	fi

	check_install zabbix-agent zabbix-agent

 if [ -f /etc/zabbix/zabbix_agentd.conf ]
	then
		# Passive checks, accept connections from
		sed -i \
			"s/^Server=127.0.0.1/Server=$1/" \
			/etc/zabbix/zabbix_agentd.conf
		# Active checks, accept connections from
		sed -i \
			"s/^ServerActive=127.0.0.1/ServerActive=$1/" \
			/etc/zabbix/zabbix_agentd.conf
		# Active checks, match with configured name at zabbix server
		sed -i \
			"s/^Hostname=Zabbix server/Hostname=$2/" \
			/etc/zabbix/zabbix_agentd.conf

		invoke-rc.d zabbix-agent restart
 fi

 if [ -f /etc/iptables.up.rules ]
	then
		# Open port only for zabbix server, default port 10050
		sed -i \
			"s/^COMMIT$/-A INPUT -p tcp -s $1 --dport 10050 -j ACCEPT\nCOMMIT/" \
			/etc/iptables.up.rules

		iptables -F
		iptables-restore < /etc/iptables.up.rules
 fi
	print_warn "Zabbix-agent installed to listen server $1 at name $2"

}

function update_timezone {
	echo "Europe/Helsinki" > /etc/timezone
	dpkg-reconfigure -f noninteractive tzdata
}


######################################################################## 
# START OF PROGRAM
########################################################################
export PATH=/bin:/usr/bin:/sbin:/usr/sbin

check_sanity
case "$1" in
agent)
	install_agent $2 $3
	;;
server)
	install_server
	install_agent 127.0.0.1 $2
	;;
*)
	echo '  '
	echo 'Usage:' `basename $0` '[option] [argument]'
	echo '- agent [server ip] [host name]   (install zabbix agent and configure it)'
	echo '- server [host name]              (install zabbix server+frontend and agent)'
	echo '  '
	;;
esac
