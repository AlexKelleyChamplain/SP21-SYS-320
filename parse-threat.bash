#!nan/bin/bash

# Storyline: Extract IPs from  emergingthreats.net and create a firewall ruleset

#alert tcp [2.59.200.0/22,5.134.128.0/19,5.180.4.0/22,5.181.84.0/22,5.183.60.0/22,5.188.10.0/23,24.137.16.0/20,24.170.208.0/20,24.233.0.0/19,24.236.0.0/19,27.126.160.0/20,27.146.0.0/16,31.14.65.0/24,31.14.66.0/23,31.40.156.0/22,31.40.164.0/22,36.0.8.0/21,36.37.48.0/20,36.116.0.0/16,36.119.0.0/16] any -> $HOME_NET any (msg:"ET DROP Spamhaus DROP Listed Traffic Inbound group 1"; flags:S; reference:url,www.spamhaus.org/drop/drop.lasso; threshold: type limit, track by_src, seconds 3600, count 1; classtype:misc-attack; flowbits:set,ET.Evil; flowbits:set,ET.DROPIP; sid:2400000; rev:2805; metadata:affected_product Any, attack_target Any, deployment Perimeter, tag Dshield, signature_severity Minor, created_at 2010_12_30, updated_at 2021_02_19;)



#regex to extract the networks
#5.           134.              128.            0/         19

#wget https://rules.emergingthreats.net/blockrules/emerging-drop.suricata.rules -O /tmp/emerging-drop.suricata.rules


egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.0/[0-9]{1,2}' /tmp/emerging-drop.suricata.rules | sort -u | tee badIPs.txt

#for mac
#echo '
#scrub-anchor "come.apple/*"
#nat-anchor "come.apple/*"
#rdr-anchor "come.apple/*"
#dummynet-anchor "come.apple/*"
#anchor "come.apple/*"
#load anchor "com.apple" from "/etc/pf.anchors/com.apple"

 #'  | tee pf.conf


# create a firewall ruleset
for eachIP in $(cat badIPs.txt)
do
	#mac
	#echo "block in from ${eachIP} to any" | tee -a  pf.conf

	echo "iptables -A INPUT -s ${eachIP} -j DROP"  | tee -a  badIPS.iptables

done



#_________________________________________________________________________________________________________________________________


# filename variable
pFile="/tmp/emerging-drop.suricata.rules"

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
                echo "Downloading the blocked ip file..."

        # if the admin doesnt specift a y or n then error.
        else
                echo "Invalid Value"
                exit 1

        fi
fi
