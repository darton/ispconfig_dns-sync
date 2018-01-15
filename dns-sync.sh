#!/bin/bash

master_dns=192.168.1.253

sshurl=slavens@ispconfig.example.com

dsource="mysql -s -u slavens dbispconfig -e \"select origin from dns_soa;\""

domain_list=`ssh $sshurl "$dsource |sed -e 's/\.$//'"`


current_domain_list=$(cat /tmp/domain_list |sha1sum)
new_domain_list=$(echo $domain_list |sha1sum)


    if [ "$current_domain_list" != "$new_domain_list" ]
        then
        	echo "There is a new list of domains."
        	echo $domain_list > /tmp/domain_list
        	cp /dev/null /etc/named/slave-zones

            for domain in $domain_list
            do

                echo "zone \"$domain\" IN { type slave; file \"slaves/$domain\"; masters { $master_dns; }; }; " >> /etc/named/slave-zones
            done
                echo "I am restarting the dns server."
                systemctl restart named

        else
            echo "The list of domains has not changed."
            
    fi
