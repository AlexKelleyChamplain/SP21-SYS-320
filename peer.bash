#!/bin/bash

#storyline create peer vpn config file


if [[ $1 == '' ]]
then

	# what is peers name
	echo - n "what is the Peer's name?"
	read  the_client
else
	
	the _client="$1"

fi

# filename variable
pFile="${the_client}-wg0.conf"

#check to see if the peer file exitsts 
if [[ -f "${pFile}"  ]]
then

	#prompt if we need to overwrite
	echo "the file ${pFile} exists."
	echo -n "Do you want to overwrite it? [y|N]"
	read to_overwrite

	if [[ "$to_overwrite}" == "N" || "${to_overwrite}" == "n" ]]
	then
		echo "Exit..."
		exit 0

	elif [[ "${to_overwrite}" == "y" ]]
	then
		echo "creating the wireguard Config file..."
	
	# if the admin doesnt specift a y or n then error.
	else
		echo "Invalid Value"
		exit 1

	fi
fi

#Create private key
p="$(wg genkey)"

#create public key
clientPub="$(echo ${p} | wg pubkey)"


#Generate preshared key
pre="$(wg genpsk)"

# Endpoinmt
end="$(head -1 wg0.conf | awk ' { print $3 } ' ) "

#server public key
pub="$(head -1 wg0.conf | awk ' { print $4 } ' ) "


#dns
dns="$(head -1 wg0.conf | awk ' { print $5 } ' ) "

#MTU
mtu="$(head -1 wg0.conf | awk ' { print $6 } ' ) "

#KeepAlive
keep="$(head -1 wg0.conf | awk ' { print $7 } ' ) "

#listenPort
lport="$(shuf -n1 -i 40000-50000)"


# Defualt routs for VPN
routes="$(head -1 wg0.conf | awk ' { print $8 } ' ) "

# check if the ip based on the network 

#Generate the ip addr
tempIP=$(grep AllowedIPs wg0.conf | sort -u | tail -1 | cut -d\. -f4 | cut -d\/ -f1)
ip=$(expr ${tempIP} + 1)

# create  the client config file
echo "[Interface]
Address = 10.254.132.${ip}/24
DNS = ${dns}
ListenPort = ${lport}
MTU = ${mtu}
PrivateKey = ${p}

[peer]
AllowedIPs = ${routes}
PeersistentKeppAlive = ${keep}
preshared key = ${pre}
Public key = ${pub}
Endpoint = ${end}

" > ${pFile}

#add our peer config to the server config
echo "
# ${the_client} begin
[Peer]
Publickey = ${clientPub}
PreSharedKey = ${pre}
AllowedIPs = 10.254.132.${ip}/32
# ${the_client} end " | tee -a wg0.conf

