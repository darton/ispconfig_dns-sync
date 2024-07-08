#!/usr/bin/env bash

#  Author : Dariusz Kowalczyk
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License Version 2 as
#  published by the Free Software Foundation.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.

this_nsip="192.168.1.1"
shadow_master_dns="192.168.1.253"
master_dns="$shadow_master_dns; 10.10.10.1;"
sshurl=slavens@$shadow_master_dns

dsource="mysql -s -u slavens dbispconfig -e\" SELECT origin FROM dns_soa WHERE active='Y' AND xfer LIKE '%$this_nsip%';\""

timeout 10 ssh "${sshurl}" "${dsource}" || { echo "Can not connect to database"; exit 1; }

domain_list=$(ssh $sshurl "$dsource |sed -e 's/\.$//'")

named_conf_dir=/etc/named

slave_zones_file=$shadow_master_dns-slave-zones

touch /tmp/domain_list


current_domain_list=$(cat /tmp/domain_list |sha1sum)
new_domain_list=$(echo $domain_list |sha1sum)


    if [ "$current_domain_list" != "$new_domain_list" ]
        then
        	echo "There is a new list of domains."
        	echo $domain_list > /tmp/domain_list
        	> $named_conf_dir/$slave_zones_file

            for domain in $domain_list
            do

                echo "zone \"$domain\" IN { type slave; file \"slaves/$domain\"; masters { $master_dns }; allow-transfer { trusted-servers; }; }; " >> $named_conf_dir/$slave_zones_file
            done
                echo "I am restarting the dns server."
                systemctl restart named

        else
            echo "The list of domains has not changed."
            
    fi
