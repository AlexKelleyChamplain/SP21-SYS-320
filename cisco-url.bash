#! /bin/bash

#storyline:extract domains form https://raw.githubusercontent.com/botherder/targetedthreats/master/targetedthreats and crate a firewall ruleset 



wget https://raw.githubusercontent.com/botherder/targetedthreats/master/targetedthreats.csv  -O /tmp/targetedthreats.csv



awk -F/ '{print $3}' /tmp/targetedthreats.csv | tee badCiscoUrl.csv


#create firewall ruleset
for eachDomain in $(cat BadCiscoURL.txt)
do

	echo " class-map match-any BAD_URLS"
	echo " " | tee -a 


