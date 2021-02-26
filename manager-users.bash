#!/bin/bash 

# storyline:scrip to add and delte vpn peers

while getopts 'hdau:' OPTION ; do

	case "$OPTION" in
	
		d) u_del=${OPTION}
		;;
		a) u_add=${OPTION}
		;;
		u) t_user=${OPTARG}
		;;
		h)

			echo ""
			echo "Usage: $(basename $0) [-a]|[-d] -u username"
			echo ""
			exit 1
		;;
		
		*)
		
			echo "invalid value."
			exit 1
		
		;;
	esac
done

# Check to  see if the -a and -d are empty or if they ar4e both specified throw an error
if [[ (${u_del} == "" && ${u_add} == "") || (${u_del} != "" && ${u_add} != "")    ]]
then

	echo "Please specidy -a or -d and the -u and the username."

fi 

# check to ensure -u is specidied
if [[ (${u_del} != "" ||  ${u_add} != "") && ${t_user} == "" ]]
 then
	echo "Please specify a user (-u) !"
	echo "Usage: $(basename $0) [-a][-d] [-u username]"
	exit 1

fi 

# Delete a user
if [[ ${u_del} ]]
then

	echo "Deleting user..."
	sed -i  "/# ${t_user} begin/,/# {$t_user} end/d" wg0.conf


fi

# add a user
if [[ ${u_add} ]]
then
	
	echo "Create the User..."
	bash peer.bash ${t_user}

fi
