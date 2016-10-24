#!/bin/bash
#file     :crontab_script.sh
#author   :Luis Gustavo Bier Schüler

#run file :new_container.sh
#params   :
#   -d|--domain
#   -h|--hostname
#   -u|--username
#  -up|--user_pass
#  -rp|--root_pass
# -mrp|--mysql_root_pass

# Get data from API
output=$(curl --silent -H 'Accept: application/vnd.twitchtv.v3+json' -X GET http://api.naughtyhost.com/clientes)

# Get number of registers
max=$( echo "$output" | jq length )

# Create containers
for i in `seq 1 $max`
do
	
	z=$(echo $(( i - 1 )))

	_payd=$( echo "$output" | jq --arg z $z '.[$z | tonumber]["pago"]' )
	
	if [[ "$_payd" == '"1"' ]]
	then

		_domain=$( echo "$output" | jq --arg z $z '.[$z | tonumber]["host"]' )
		_hostname=$( echo "$output" | jq --arg z $z '.[$z | tonumber]["uuid"]' )
		_username=$( echo "$output" | jq --arg z $z '.[$z | tonumber]["email"]' )
		_user_pass=$( echo "$output" | jq --arg z $z '.[$z | tonumber]["senhasenha"]' )
		_root_pass=$( echo "$output" | jq --arg z $z '.[$z | tonumber]["senharoot"]' )
		_mysql_root_pass=$( echo "$output" | jq --arg z $z '.[$z | tonumber]["senhamysql"]' )

		./new_container.sh -d $_domain -h $_hostname -u $_username -up $_user_pass -rp $_root_pass -mrp $_mysql_root_pass
		
		echo 'DOMAIN BEING CREATED:'
		echo 'DOMAIN: ' $_domain
		echo 'HOSTNAME: ' $_hostname
		echo 'USERNAME: ' $_username
		echo 'USER_PASS: ' $_user_pass
		echo 'ROOT_PASS:' $_root_pass
		echo 'MYSQL_ROOT_PASS: ' $_mysql_root_pass 
		
	fi

done
