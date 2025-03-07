#!/bin/bash
clear

# Global Vars
#==================================================================================

# Colors
PURPLE='\033[0;35m'$(tput bold)
BLUE='\033[0;36m'$(tput bold)
YELLOW='\033[1;33m'$(tput bold)
GREEN='\033[1;32m'$(tput bold)
RED='\033[0;31m'$(tput bold)
NC='\033[0m'

# Main Directories
ME=$(whoami)
DIR_HOME="/home/$ME"
DIR_LOCAL_CFG="$DIR_HOME/.config"

RUNNING=$(pgrep nzbget)

# Functions
#==================================================================================
get_sudo() {
	echo
	out_msg info "$1"
	echo -e -n "\n${BLUE}[${NC} ${PURPLE}Enter Password for sudo${NC} ${BLUE}]:${NC}"
	read -s -p " " sudoPW
	echo $sudoPW | sudo -S zypper lr >/dev/null 2>&1
	echo
}
out_msg() {
	case $1 in
		complete)
			echo -e -n ${PURPLE}
			for((l=1;l <= 29; l++)) do
				echo -e -n "-"
			done
			echo -e -n "[${NC} ${GREEN}Complete${NC} ${PURPLE}]"
			for((l=1;l <= 29; l++)) do
				echo -e -n "-"
			done
			echo -e "\n${NC}"
		;;

		error)
			echo -e "${RED}[ERROR]: $MSG${NC}"
		;;

		header)
			echo -e "${BLUE}                                 ______"
			echo -e "   _____________________________/::'   \\"
			echo -e "  /:'   \\\::'    \\\::'    \\\::' _  \\\:' |   \\"
			echo -e -n " /:' |   \\\'  -   \\\'    | \\\'    __\\\_     /${NC}"
			echo -e " ${PURPLE}n9! -- [${NC} ${BLUE}$2${NC} ${PURPLE}]${NC}"
			echo -e -n "${BLUE}+\\\___|___/_______/_______/_______/_____/--------------"
			echo -e "----------------------------------------------------+${NC}"
			if [ $3 ]; then
				get_sudo "This script requires ${RED}sudo${NC} ${YELLOW}for some actions${NC}"
			fi
			sleep 1
		;;

		info)
			echo -e "${YELLOW}[INFO]: $2${NC}"
			;;

		line)
			if [ $2 ]; then
				LEN=$2
			else
				LEN=70
			fi

			echo -e -n ${PURPLE}
			for((l=1;l <= $LEN; l++)) do
				echo -e -n "-"
			done
			echo -e ${NC}
		;;

		task)
			if [[ $2 == 'in' ]]; then
				out_msg task 'Installing' "$3"
			elif [[ $2 == "in_conf" ]]; then
				echo -e "${PURPLE}Installing:${NC} ${BLUE}Config/Themes${NC}"
			else
				echo -e "${PURPLE}$2:${NC} ${BLUE}$3${NC}"
			fi
		;;

		title)
			if [[ $2 == 'in' ]]; then
				out_msg task 'Installing' $3
				out_msg line 40
			else
				echo -e "\n${BLUE}[${NC} ${PURPLE}$2${NC} ${BLUE} ]${NC}"
				out_msg line
				sleep 1
			fi
		;;
	esac
}

# Main
#==================================================================================

if [ $# -eq 0 ]; then
	PS3="Please enter your choice: "
	OPTIONS=("Start Daemon" "Stop Daemon" "Opt3" "Quit")
	select opt in "${OPTIONS[@]}"
	do
		case $opt in
			"Opt1")
				DO="Start"
				;;
			"Opt2")
				DO="Stop"
				;;
			"Opt3")
				echo "you chose choice $REPLY which is $opt"
				;;
			"Quit")
				break
				;;
			*) echo "invalid option $REPLY";;
		esac
	done
else
	DO=$1
fi
case $1 in
	start)
		out_msg header 'Nzbget Management: Start Daemon/GUI'
		
		out_msg title 'Starting Daemon'
			#if [[ $RUNNING ]]
			#then
		#		out_msg info 'Nzbget is already runnning'
	#		else
				out_msg task 'Using Config' "${DIR_LOCAL_CFG}/nzbget/nzbget.conf"
					nzbget -D -c ~/.config/nzbget/nzbget.conf
				out_msg complete
				sleep 1
	#		fi
		
		out_msg title 'Opening GUI'
			out_msg task 'URL' 'http://127.0.0.1:6789'
			firefox http://127.0.0.1:6789
		out_msg complete
	;;
	
	stop)
		out_msg header 'Nzbget Management: Stop Daemon'
		out_msg title 'Stopping Daemon'
			out_msg task 'Using Config' "${DIR_LOCAL_CFG}/nzbget/nzbget.conf"
			nzbget -Q -c ~/.config/nzbget/nzbget.conf &> /dev/null 2>$1
		out_msg complete
	;;
esac

echo -e -n "${RED}All Done! ${NC}" 
sleep 2
echo -e " ///${NC} ${BLUE}goodbye!"
sleep 1for ((i=3; i!=0; i--))
do
	echo -e -n "${PURPLE}$i"
	if [ $i != 1 ]; then
		echo -e -n "${PURPLE}.."
	fi
	sleep 1
done