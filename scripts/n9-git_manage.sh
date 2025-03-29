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
DIR_LOCAL_SHARE="$DIR_HOME/.local/share"
DIR_GIT="$DIR_HOME/.git/node9"
DIR_GIT_CFG="$DIR_GIT/config"

# Functions
#==================================================================================
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
			echo -e " ${PURPLE}n9! -- [${NC} ${BLUE}git-update${NC} ${PURPLE}]${NC}"
			echo -e -n "${BLUE}+\\\___|___/_______/_______/_______/_____/--------------"
			echo -e "----------------------------------------------------+${NC}"
			#get_sudo "Deployment requires ${RED}sudo${NC} ${YELLOW}for some actions${NC}"
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
			if [[ $2 == 'sync' ]]; then
				out_msg task 'Syncing' "$3"
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

# Main
#==================================================================================
out_msg header
echo -e "\n${PURPLE}/// ${BLUE}Oh Hai ${GREEN}$ME${PURPLE}!${NC}"

case $1 in
	sync)
		out_msg title 'Syincing Dots'
		out_msg task sync audacious
			cp $DIR_LOCAL_CFG/audacious/config $DIR_GIT_CFG/audacious
			cp $DIR_LOCAL_CFG/audacious/playlist-state $DIR_GIT_CFG/audacious
			cp $DIR_LOCAL_CFG/audacious/plugin-registry $DIR_GIT_CFG/audacious
			cp $DIR_LOCAL_CFG/audacious/QtUi.conf $DIR_GIT_CFG/audacious

		out_msg task sync bashtop
			cp $DIR_LOCAL_CFG/bashtop/bashtop.cfg $DIR_GIT_CFG/bashtop
			cp $DIR_LOCAL_CFG/bashtop/themes/* $DIR_GIT_CFG/bashtop/themes

		out_msg task sync cava
			cp $DIR_LOCAL_CFG/cava/config $DIR_GIT_CFG/cava

		out_msg task sync cmus
			cp $DIR_LOCAL_CFG/cmus/autosave $DIR_GIT_CFG/cmus
			cp $DIR_LOCAL_CFG/cmus/rc $DIR_GIT_CFG/cmus

		out_msg task sync firefox
			FFPROF=$(grep 'Path=' ~/.mozilla/firefox/profiles.ini | sed 's/^.*Path=//p' | tail -n1)
			cp -rf ~/.mozilla/firefox/$FFPROF/chrome $DIR_GIT_CFG/firefox
			cp ~/.mozilla/firefox/$FFPROF/addons.json $DIR_GIT_CFG/firefox
			cp ~/.mozilla/firefox/$FFPROF/addonStartup.json.lz4 $DIR_GIT_CFG/firefox
			cp ~/.mozilla/firefox/$FFPROF/extension-preferences.json $DIR_GIT_CFG/firefox
			cp ~/.mozilla/firefox/$FFPROF/extension-settings.json $DIR_GIT_CFG/firefox
			cp ~/.mozilla/firefox/$FFPROF/prefs.js $DIR_GIT_CFG/firefox/user.js
			cp ~/.mozilla/firefox/$FFPROF/permissions.sqlite $DIR_GIT_CFG/firefox
			cp ~/.mozilla/firefox/$FFPROF/content-prefs.sqlite $DIR_GIT_CFG/firefox
			cp ~/.mozilla/firefox/$FFPROF/search.json.mozlz4 $DIR_GIT_CFG/firefox
			cp ~/.mozilla/firefox/$FFPROF/handlers.json $DIR_GIT_CFG/firefox
		
		out_msg task sync icons
			cp ~/.icons/*.png $DIR_GIT/icons/n9-icons

		out_msg task sync gtk
			cp -rf ~/.themes/* $DIR_GIT_CFG/gtk/themes
			cp $DIR_LOCAL_CFG/gtk-3.0/* $DIR_GIT_CFG/gtk/gtk-3.0
			cp $DIR_HOME/.gtkrc-2.0 $DIR_GIT_CFG/gtk/gtk-2.0
			cp $DIR_LOCAL_CFG/xsettingsd/xsettingsd.conf $DIR_GIT_CFG/gtk

		out_msg task sync hypr
			cp -rf $DIR_LOCAL_CFG/hypr/* $DIR_GIT_CFG/hypr

		out_msg task sync kitty
			cp $DIR_LOCAL_CFG/kitty/* $DIR_GIT_CFG/kitty

		out_msg task sync lsd
			cp -rf $DIR_LOCAL_CFG/lsd/* $DIR_GIT_CFG/lsd

		out_msg task sync n9-scripts
			cp ~/.n9-scripts/* $DIR_GIT/scripts

		out_msg task sync nemo
			cp -rf $DIR_LOCAL_CFG/nemo/* $DIR_GIT_CFG/nemo
			
		out_msg task sync neofetch
			cp $DIR_LOCAL_CFG/neofetch/config.conf $DIR_GIT_CFG/neofetch

		out_msg task sync nfoview
			verify_dir $DIR_GIT_CFG/nfoview
			cp -r $DIR_LOCAL_CFG/nfoview/* $DIR_GIT_CFG/nfoview

		out_msg task sync oh-my-zsh
			cp ~/.oh-my-zsh/themes/node9.zsh-theme $DIR_GIT_CFG/oh-my-zsh

		out_msg task sync remmina
			cp $DIR_LOCAL_CFG/remmina/remmina.pref $DIR_GIT_CFG/remmina

		out_msg task sync rofi
			cp $DIR_LOCAL_CFG/rofi/config.rasi $DIR_GIT_CFG/rofi
			cp $DIR_LOCAL_CFG/rofi/themes/* $DIR_GIT_CFG/rofi/themes
				
		out_msg task sync sddm--sugar-dark-theme
			cp /usr/share/sddm/themes/sugar-dark/theme.conf $DIR_GIT_CFG/sddm

		out_msg task sync sublime-text
			cp -r $DIR_LOCAL_CFG/sublime-text/Installed\ Packages/ $DIR_GIT_CFG/sublime-text
			cp -r $DIR_LOCAL_CFG/sublime-text/Packages $DIR_GIT_CFG/sublime-text

		out_msg task sync swappy
			cp $DIR_LOCAL_CFG/swappy/config $DIR_GIT_CFG/swappy

		out_msg task sync swaync
			cp -rf $DIR_LOCAL_CFG/swaync/* $DIR_GIT_CFG/swaync

		out_msg task sync swayosd
			cp $DIR_LOCAL_CFG/swayosd/* $DIR_GIT_CFG/swayosd

		out_msg task sync applaunchers
			cp $DIR_LOCAL_SHARE/applications/* $DIR_GIT/applaunchers

		out_msg task sync waybar
			#cp $DIR_LOCAL_CFG/waybar/config $DIR_GIT_CFG/waybar
			#cp $DIR_LOCAL_CFG/waybar/style.css $DIR_GIT_CFG/waybar
			cp -rf $DIR_LOCAL_CFG/waybar/* $DIR_GIT_CFG/waybar

		out_msg task sync wlogout
			cp $DIR_LOCAL_CFG/wlogout/layout $DIR_GIT_CFG/wlogout
			cp $DIR_LOCAL_CFG/wlogout/style.css $DIR_GIT_CFG/wlogout
			cp $DIR_LOCAL_CFG/wlogout/icons/* $DIR_GIT_CFG/wlogout/icons

		out_msg task sync zsh
			cp ~/.zshrc $DIR_GIT_CFG/zsh
	out_msg complete

	out_msg title 'Syncing GIT'
		cd $DIR_GIT_CFG
		out_msg task 'Adding Files' All
			git add --all >/dev/null

		out_msg task Committing "Comment 'Update'"
			git commit -m 'Updated' >/dev/null

		out_msg task Pushing 'Origin - Master'
			git push origin master >/dev/null 2>&1
	out_msg complete
	;;

	refresh)
		out_msg title 'Refreshing GIT'
		cd $DIR_GIT
		out_msg task checkout latest_branch
			git checkout --orphan latest_branch >/dev/null 2>&1

		out_msg task add 'all files'
			git add -A >/dev/null 2>&1

		out_msg task commit "message 'updated'"
			git commit -am 'Updated' >/dev/null 2>&1

		out_msg task branch delete
			git branch -D master >/dev/null 2>&1

		out_msg task branch rename
			git branch -m master >/dev/null 2>&1

		out_msg task push master
			git push -f origin master >/dev/null 2>&1
	;;
esac

if [[ $1 == 'sync' ]]; then
	echo -e -n "\n${BLUE}Local Git ${GREEN}Synced / GitHub Repo Updated${NC}"
else
	echo -e -n "\n${BLUE}GitHub Repo ${GREEN}Refreshed${NC}"
fi

for i in $(seq 1 3)
do
	echo -e -n "${PURPLE} ."
	sleep 1
done
echo -e " ///${NC} ${BLUE}goodbye!"
sleep 3