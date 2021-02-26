#!/bin/bash

#Storyline: Menu for admin, Vpn, and Security functions

function invalid_opt() {

echo ""
echo "Invalid option"
echo ""
sleep 2

}

function menu() {

	#clears the screen
	clear
	
	echo "[1] Admin Menu"
	echo "[2] Security Menu"
	echo "[3] Exit"
	read -p "Please enda a choice above: "  choice
	
	case "$choice" in 
	
		1) admin_menu
		;;

		2) security_menu
		;;

		3) exit 0
		;;

		*)

			invalid_opt
			# call the main menu
			menu
		;;

	esac

 }

function admin_menu() {
	clear
	echo "[L]ist Running Processes"
        echo "[N]etwork Sockets"
        echo "[V]PN Menu"
	echo "[4] Exit"
        read -p "Please enter a choice above: "  choice

	case "$choice" in
	
		L|l) ps -ef |less
		;;
		N|n) netstat -an --inet |less
		;;
		V|v) vpn_menu
		;;
		4) exit 0
		;;
		*)
			invalid_opt
			
			admin_menu
		;;
			

	esac
admin_menu
}


function vpn_menu() {

	
	clear
	echo "[A]dd a peer"
	echo "[D]elete a peer"
	echo "[B]ack to admin menu"
	echo "[M]ain menu"
	echo "[E]xit"
	read -p "Please select an option: " choice 

	case "$choice" in
		
		A|a) bash peer.bash
		     tail -6 wg0.conf |less
		;;
		D|d) #create a prompt fo the user
			#call the manage-user.bash and pass the proper switch and argument
			# to delet user
			echo -n "What user do you want to delete: "
			read ${t_user}
			echo ${t_user}
			bash manager-users.bash -d -U "${t_user}"
		;;
		B|b) admin_menu
		;;
		M|m) menu
		;;
		E|e) exit 0
		;;
		*)

		invalid_opt
		
	;;
	
	esac

vpn_menu




} 



# call the main function
menu




function security_menu() {

        #clears the screen
        clear

        echo "[L]ist open network sockets"
        echo "[C]heck for users with UID 0"
        echo "[S]ee last ten logged in users"
	echo "[O]nline users"
	echo "[E]xit"
        read -p "Please enda a choice above: "  choice

        case "$choice" in 

                L|l) ss -l | less 
                ;;

                C|c) id | less
                ;;

		S|s) last -10 |less
		;;

		O|o) who |less
		;;


                E|e) exit 0
                ;;

                *)

                        invalid_opt
                ;;

        esac

security_menu
 }


function Block_List_Menu()
	clear
	echo "[C}isco BlockList Generator"
	echo "[D]omain URL Blocklist Generator"
	echo "[N}etscreen Blocklist Generator"
	echo "[W]indows Blocklist Generator"
	echo "[E]xit"
	read -p "Please enter a choice abover: " choice

	case "$choice" in

		C|c)
		;;
		D|d)
		;;
		N|n)
		;;
		w|w)
		;;
		E|e)
		;;
		*)
			invalid_opt

			Block_List_Menu

		;;

	esac

security_menu
}




menu
