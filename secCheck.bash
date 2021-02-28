#!/bin/bash

#script for local security checks

function checks() {
	if [[ $2 != $3 ]]
	then

		echo -e "\e[1;31mThe $1 policy is not compliant. The current policy should be: $2, the current value is: $3.\e[0m"
		work=0 

	else

		echo -e "\e[1;32mThe $1 is compliant. Current value $3.\e[0m"
		work=1
	fi

}
#Check the password max days policy

pmax=$(egrep -i '^PASS_MAX_DAYS' /etc/login.defs | awk ' {print $2} ')
# Checks for password max
#           $1              $2       $3
checks "Password Max Days" "365" "${pmax}"
if [[ $is_compliant = 0 ]]
then
        echo -e "Set the PASS_MAX_DAYS parameter to conform to site policy in /etc/login.defs : \n PASS_MAX_DAYS 365 \n Modify user parameters for all users with a password set to match: \n chage --maxdays 365 <user>"
fi

# Check the  pass min days between changes
pmin=$(egrep -i '^PASS_MIN_DAYS' /etc/login.defs | awk ' {print $2} ')
checks "Password Min Days" "14" "${pmin}"
if [[ $is_compliant = 0 ]]
then
        echo -e "Set the PASS_MIN_DAYS parameter to conform to site policy in /etc/login.defs : \n PASS_MIN_DAYS 14"
fi

# chacks the pass warn age
pwarn=$(egrep -i '^PASS_WARN_AGE' /etc/login.defs | awk ' {print $2} ')
checks "Password Warn AGE" "7" "${pwarn}"
if [[ $is_compliant = 0 ]]
then
        echo -e "Set the PASS_WARN_AGE parameter to conform to site policy in /etc/login.defs : \n PASS_WARN_AGE 7"
fi

#checks the SSH USePam configuration
chkSSHPAM=$(egrep -i "^UsePAM" /etc/ssh/sshd_config | awk ' { print $2 }' )
checks "SSH UsePAM" "yes" "${chkSSHPAM}"
if [[ $is_compliant = 0 ]]
then
        echo -e "what is Usepam"
fi
#Checks the ipv4 forwarding status 
ip_forward=$(sysctl net.ipv4.ip_forward | awk '{print $3}')
checks "IP forwarding" "0" "$ip_forward"
if [[ "0" != ${ip_forward} ]]
	then
	echo -e "Edit /etc/sysctl.conf and set: \nnet.ipv4.ip_forward=1\nto\nnet.ipv4.ip_forward=0.\nThen run: \n sysctl -w"
fi

# check permissions on users home directory 
echo ""
for eachDIR in $(ls -l /home | egrep '^d' | awk ' {print $3 } ')
do

	chDIR=$(ls -ld /home/${eachDIR} | awk ' { print $1 } ')
	checks "Home directory ${eachDir}" "drwx------" "${eachDIR}"


done

#Checks crontab permissions are set up
#cron_chk=$(stat /etc/crontab | egrep -i "^Access" | awk ' { print $5 , $6 , $7 , $8 , $9 , $10 } ')
#checks "Access" "0/ root) 0/ root)" "${cron_chk}"

#Checks crontab permissions are set up
cron_chk=$(stat /etc/crontab | egrep -i "^Access" | head -n 1)
if [[ ${cron_chk} =  "Access: (0600/-rw-------) Uid: ( 0/ root) Gid: ( 0/ root)" ]]
then
p=0
else
p=1
fi
checks " Checking Crontab permissions /etc/crontab" "0" "${p}"
if [[ $work = 0 ]]
then 
	echo -e "run these commands for /etc/crontab as sudo: \n chown root:root /etc/crontab \n chmod og-rwx /etc/crontab \n"
fi

#Checks cron.hourly permissions are set up
 cronH_chk=$(stat /etc/cron.hourly | egrep -i "^Access" | head -n 1)
 if [[ ${cronH_chk} =  "Access: (0700/drwx------) Uid: ( 0/ root) Gid: ( 0/ root)" ]]
 then
 p=0
 else
 p=1
 fi
 checks " Checking Cron.hourly permissions /etc/cron.hourly" "0" "${p}"
 if [[ $work = 0 ]]
 then 
     echo -e "run these commands for /etc/cron.hourly as sudo: \n chown root:root /etc/cron.hourly \n chmod og-rwx /etc/cron.houlry \n"
 fi



#Checks cron.daily permissions are set up
  cronD_chk=$(stat /etc/cron.daily | egrep -i "^Access" | head -n 1)
  if [[ ${cronD_chk} =  "Access: (0700/drwx------) Uid: ( 0/ root) Gid: ( 0/ root)" ]]
  then
  p=0
  else
  p=1
  fi
  checks " Checking Cron.daily permissions /etc/cron.daily" "0" "${p}"
  if [[ $work = 0 ]]
  then 
      echo -e "run these commands for /etc/cron.daily as sudo: \n chown root:root /etc/cron.daily \n chmod og-rwx /etc/cron.daily \n"
  fi

#Checks cron.weekly permissions are set up
  cronW_chk=$(stat /etc/cron.weekly | egrep -i "^Access" | head -n 1)
  if [[ ${cronW_chk} =  "Access: (0700/drwx------) Uid: ( 0/ root) Gid: ( 0/ root)" ]]
  then
  p=0
  else
  p=1
  fi
  checks " Checking cron.weekly permissions /etc/cron.weekly" "0" "${p}"
  if [[ $work = 0 ]]
  then 
      echo -e "run these commands for /etc/cron.weekly as sudo: \n chown root:root /etc/cron.weekly \n chmod og-rwx /etc/cron.weekly \n"
  fi




#Checks cron.monthly permissions are set up
cronM_chk=$(stat /etc/cron.weekly | egrep -i "^Access" | head -n 1)
if [[ ${cronW_chk} =  "Access: (0700/drwx------) Uid: ( 0/ root) Gid: ( 0/ root)" ]]
then
p=0
else
p=1
fi
checks " Checking cron.monthly permissions /etc/cron.monthly" "0" "${p}"
if [[ $work = 0 ]]
then 
     echo -e "run these commands for /etc/cron.monthly as sudo: \n chown root:root /etc/cron.monthly \n chmod og-rwx /etc/cron.monthly \n"
 fi




 #Checks PASSWD permissions are set up
 passwd_chk=$(stat /etc/passwd | egrep -i "^Access" | head -n 1)
 if [[ ${passwd_chk} =  "Access: (0644/-rw-r--r--) Uid: ( 0/ root) Gid: ( 0/ root)" ]]
 then
 p=0
 else
 p=1
 fi
 checks " Checking passwd permissions /etc/passwd" "0" "${p}"
 if [[ $work = 0 ]]
 then 
      echo -e "run these commands for /etc/passwd as sudo: \n chown root:root /etc/passwd \n chmod 644 /etc/passwd \n"
 fi




#Checks shadow permissions are set up
  shadow_chk=$(stat /etc/shadow | egrep -i "^Access" | head -n 1)
  if [[ ${shadow_chk} =  "Access: (0640/-rw-r-----) Uid: ( 0/ root) Gid: ( 42/ shadow)" ]]
  then
  p=0
  else
  p=1
  fi
  checks " Checking shadow permissions /etc/shadow" "0" "${p}"
  if [[ $work = 0 ]]
  then 
      echo -e "run these commands for /etc/shadow as sudo: \n chown root:shadow /etc/shadow \n  chmod o-rwx,g-wx /etc/shadow  \n"


fi

#Checks group permissions are set up
  group_chk=$(stat /etc/group | egrep -i "^Access" | head -n 1)
  if [[ ${group_chk} =  "Access: (0644/-rw-r--r--) Uid: ( 0/ root) Gid: ( 0/ root)" ]]
  then
    p=0
  else
  p=1
  fi
  checks " Checking group permissions /etc/group" "0" "${p}"
  if [[ $work = 0 ]]
  then 
        echo -e "run these commands for /etc/group as sudo: \n chown root:root /etc/group \n  chmod 644 /etc/group  \n"

fi
#Checks gshadow permissions are set up
   gshadow_chk=$(stat /etc/gshadow | egrep -i "^Access" | head -n 1)
   if [[ ${gshadow_chk} =  "Access: (0640/-rw-r-----) Uid: ( 0/ root) Gid: ( 42/ shadow)" ]]
   then
   p=0
   else
   p=1
   fi
   checks " Checking gshadow permissions /etc/gshadow" "0" "${p}"
   if [[ $work = 0 ]]
   then 
       echo -e "run these commands for /etc/gshadow as sudo: \n chown root:shadow /etc/gshadow \n  chmod o-rwx,g-wx /etc/gshadow  \n"

fi
#Checks PASSWD- permissions are set up
 passwd1_chk=$(stat /etc/passwd- | egrep -i "^Access" | head -n 1)
  if [[ ${passwd1_chk} =  "Access: (0644/-rw-r--r--) Uid: ( 0/ root) Gid: ( 0/ root)" ]]
  then
  p=0
  else
  p=1
  fi
  checks " Checking passwd- permissions /etc/passwd-" "0" "${p}"
  if [[ $work = 0 ]]
  then 
       echo -e "run these commands for /etc/passwd- as sudo: \n chown root:root /etc/passwd- \n chmod u-x,go-wx /etc/passwd \n"
  fi

#Checks shadow- permissions are set up
shadow1_chk=$(stat /etc/shadow | egrep -i "^Access" | head -n 1)
if [[ ${shadow1_chk} =  "Access: (0640/-rw-r-----) Uid: ( 0/ root) Gid: ( 42/ shadow)" ]]
then
p=0
else
P=1
fi
checks " Checking shadow- permissions /etc/shadow-" "0" "${p}"
if [[ $work = 0 ]]
then 
 echo -e "run these commands for /etc/shadow- as sudo: \n chown root:shadow /etc/shadow- \n  chmod o-rwx,g-wx /etc/shadow-  \n"
fi


#Checks group- permissions are set up
 group1_chk=$(stat /etc/group- | egrep -i "^Access" | head -n 1)
 if [[ ${group1_chk} =  "Access: (0644/-rw-r--r--) Uid: ( 0/ root) Gid: ( 0/ root)" ]]
 then
  p=0
   else
 p=1
   fi
    checks " Checking group- permissions /etc/grou-p" "0" "${p}"
 if [[ $work = 0 ]]
 then 
       echo -e "run these commands for /etc/group- as sudo: \n chown root:root /etc/group- \n  chmod u-x,go-wx /etc/group  \n"


fi
 #Checks gshadow- permissions are set up
 gshadow1_chk=$(stat /etc/gshadow- | egrep -i "^Access" | head -n 1)
  if [[ ${gshadow1_chk} =  "Access: (0640/-rw-r-----) Uid: ( 0/ root) Gid: ( 42/ shadow)" ]]
  then
  p=0
  else
  p=1
  fi
  checks " Checking gshadow- permissions /etc/gshadow-" "0" "${p}"
  if [[ $work = 0 ]]
   then 
     echo -e "run these commands for /etc/gshadow- as sudo: \n chown root:shadow /etc/gshadow- \n  chmod o-rwx,g-wx /etc/gshadow-  \n"


fi
#Checks if ICMP redirects have been turned off
icmp_redirect_chk=$(sysctl net.ipv4.conf.all.accept_redirects | awk '{print $3}')
checks " ICMP redirecting" "0" "${icmp_redirect_chk}"
if [[ $work = 0 ]]
then
echo -e "Set the following parameters in /etc/sysctl.conf or a /etc/sysctl.d/* file: \nnet.ipv4.conf.all.accept_redirects = 0 \nnet.ipv4.conf.default.accept_redirects = 0\n"
fi

#Ensure no legacy "+" entries exist in /etc/passwd
legacy1=$(grep '^\+:' /etc/passwd)
checks " legacy entries check in /etc/passwd" "" "${legacy1}"
if [[ $work = 0 ]]
then
        echo -e "Remove any legacy '+' entries from /etc/passwd if they exist."
fi

#Ensure no legacy "+" entries exist in /etc/shadow
legacy2=$(grep '^\+:' /etc/shadow)
checks " legacy entries check in /etc/shadow" "" "${legacy2}"
if [[ $work = 0 ]]
then
        echo -e "Remove any legacy '+' entries from /etc/shadow if they exist."
fi

#Ensure no legacy "+" entries exist in /etc/group
legacy3=$(grep '^\+:' /etc/group)
checks " legacy entries check in /etc/group" "" "${legacy3}"
if [[ $work = 0 ]]
then
        echo -e "Remove any legacy '+' entries from /etc/group if they exist."
fi

#Ensure root is the only UID 0 account
root_chk=$(cat /etc/passwd | awk -F: '($3 == 0) { print $1 }')
checks " UID 0 check" "root" "${root_chk}"
if [[ $work = 0 ]]
then
        echo -e "Remove any users other than root with UID 0 or assign them a new UID if appropriate."
fi
