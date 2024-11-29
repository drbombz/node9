#!/bin/bash
clear
resize -s 40 140 > /dev/null 2>&1
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
			echo -e "${PURPLE}                                 ______"
			echo -e "   _____________________________/::'   \\"
			echo -e "  /:'   \\\::'    \\\::'    \\\::' _  \\\:' |   \\"
			echo -e -n " /:' |   \\\'  -   \\\'    | \\\'    __\\\_     /${NC}"
			echo -e " ${BLUE}n9! -- [${NC} ${PURPLE}n9-deployment${NC} ${BLUE}]${NC}"
			echo -e -n "${PURPLE}+\\\___|___/_______/_______/_______/_____/--------------"
			echo -e "----------------------------------------------------+${NC}"
			get_sudo "Deployment requires ${RED}sudo${NC} ${YELLOW}for some actions${NC}"
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

user_in () {
	echo -e -n "\n${BLUE}[${NC} ${PURPLE}$1? (Y/n)${NC} ${BLUE}]:${NC}"
	read -p " " choice
	if [[ $choice = [Yy] ]] || [[ -z $choice ]]; then
		return 1
	elif [[ $choice = [Nn] ]]; then
		return 0
	else
		out_msg error 'Invaild option entered'
		user_in "$1"n
	fi
}

verify_dir () {
		if [ ! -d "$1" ]; then
		DIR_OUTP=$(mkdir $1 2>&1)
			if [ ! -d "$1" ]; then
				out_msg error "Failed to create directory [$DIR_OUTP]"
			else
				out_msg info "Created directory [$1]"
			fi
		fi
}

zypp () {
    if [[ $1 == 'ar' ]]; then
		echo -e "${PURPLE}::${BLUE}$3${NC}"
		out_msg line 40

		TEST="$(zypper lr "$2" &> /dev/null 2>$1)"
		if [[ "$?" -eq 0 ]]
		then
			out_msg info "Repository '$3' already exists"
		else
			sudo zypper ar -C -e -G -F $2 $3
		fi
	elif [[ $1 == 'in' ]]; then
		if [[ $2 == 'vlc' ]]; then
			zypp_in $2
			return
		fi
		TEST="$(which "$2" &> /dev/null)"
		if [[ "$?" -eq 0 ]]
		then
			out_msg info "Package '$2' is already installed"
		else
			sudo zypper --non-interactive --no-gpg-checks --color in $2
		fi
	fi
}

zypp_in () {
	sudo zypper --non-interactive --no-gpg-checks --color in $1
}

# Global Vars
#==================================================================================

echo "testing $(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep percentage | awk '{print $2}')"
