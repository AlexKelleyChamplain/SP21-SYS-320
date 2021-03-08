#!/bin/bash

#Arguments using the position, they start at $1
APACHE_LOG="$1"

#Check if file exists
if [[ ! -f ${APACHE_LOG} ]]
then
    echo "Please specify the log file"
    exit 1
fi

#looking for web scanners
sed -e "s/\[//g" -e "s/\"//g" ${APACHE_LOG} | \
egrep -i "test|shell|echo|passwd|select|phpmyadmin|setup|admin|w00t" | \
awk '{print $1}' | \
sort -u | \
tee badIPs.txt
echo "Creating IPtables"
for eachIP in $(cat badIPs.txt)
do
    #linux
    echo "iptables -A INPUT -s ${eachIP} -j DROP" | tee -a linuxip.iptables
done
echo "Creating windows firewall rule"
for eachIP in $(cat badIPs.txt)
do
   #windows
    echo "netsh advfirewall firewall add rule name=\""BLOCK IP ADDRESS - ${eachIP}\"" dir=in action=block remoteip=${eachIP}" | tee -a windowsip.bat
done

echo "Generation is complete, the files are located in this directoy"
