#!/bin/bash
clear
resize -s 40 140 > /dev/null 2>&1

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
DIR_LOCAL_SHARE="$DIR_HOME/.local/share"
DIR_DPLY="$DIR_HOME/node9"
DIR_DPLY_BUILD="$DIR_DPLY/builds"
DIR_DPLY_CFG="$DIR_DPLY/config"
DIR_LOCAL_CFG="$DIR_HOME/.config"
DIR_LOCAL_ICONS="$DIR_LOCAL_SHARE/icons"
DIR_LOCAL_WPAPER="$DIR_HOME/.local/wallpapers"
DIR_LOCAL_SCRIPTS="$DIR_HOME/.n9-scripts"
DIR_SYS_SHARE="/usr/share"
DIR_SYS_FONTS="$DIR_SYS_SHARE/fonts/truetype"
DIR_SYS_ICONS="$DIR_SYS_SHARE/icons"
DIR_SYS_SDDM="$DIR_SYS_SHARE/sddm"


# Deployment Directories
declare -a dirs_dply=(
	$DIR_HOME
	$DIR_DPLY
	$DIR_DPLY_BUILD
	$DIR_DPLY_CFG
	$DIR_LOCAL_CFG
	$DIR_LOCAL_ICONS
	$DIR_LOCAL_SCRIPTS
	$DIR_LOCAL_WPAPER
	$DIR_SYS_FONTS
	$DIR_SYS_ICONS
)

# Deployment Directory Names
declare -a dirs_dply_name=(
	"home"
	"deploy-root"
	"deploy-build"
	"deploy-config"
	"local-config"
	"local-icons"
	"local-scripts"
	"local-wallpaper"
	"system-fonts"
	"system-icons"
)

# Config Directories
declare -a dirs_cfg=(
	"audacious"
	"bashtop"
	"bashtop/themes"
	"cava"
	"cmus"
	"hypr"
	"hyprpaper"
	"kitty"
	"Kvantum"
	"neofetch"
	"rofi"
	"rofi/themes"
	"sublime-text"
	"swaync"
	"swayosd"
	"waybar"
	"wlogout"
)

# Required Packages
declare -a pkg_req=(
	"cairo-devel"
	"cairo-tools"
	"file-devel"
	"fmt-devel"
	"freeglut-devel"
	"go1.22"
	"gobject-introspection"
	"gtk-layer-shell-devel"
	"gtkmm3-devel"
	"hyprlang-devel"
	"jsoncpp-devel"
	"kf6-extra-cmake-modules"
	"libappindicator3-1"
	"libdrm-tools"
	"libevdev-devel"
	"libKF5GuiAddons5"
	"libpng12-devel"
	"libxkbregistry-devel"
	"meson"
	"mtpfs"
	"mtp-tools"
	"opi"
	"pango-tools"
	"pulseaudio-bash-completion"
	"pulseaudio-zsh-completion"
	"rust1.78"
	"sassc"
	"scdoc"
	"wayland-protocols-devel"
)

# Optional Packages
declare -a pkg_opt=(
	"cmake"
	"gtk3-devel"
	"libdrm-devel"
	"libinput-devel"
	"libqt5-qtwayland-devel"
	"libqt5-qdbus"
	"libqt5-qtsvg-devel"
	"libQt5DBus-devel"
	"libqt5-qttools"
	"libwebp-devel"
	"libxkbcommon-devel"
	"libxkbcommon-x11-devel"
	"libXcursor-devel"
	"ninja"
	"pam-devel"
	"pango-devel"
	"systemd-devel"
)

declare -a pkg_repo=(
	"sway"
	"audacious"
	"cava"
	"cmus"
	"code"
	"dconf-editor"
	"grim"
	"hyprland"
	"vlc"
	"hyprpaper"
	"kitty"
	"kvantum-qt5"
	"kvantum-manager"
	"nemo"
	"neofetch"
	"remmina"
	"rofi-wayland"
	"sddm"
	"sublime-text"
	"swappy"
	"swaync"
	"waybar"
	"zsh"
)

declare -a repo_file=(
	"azhou"
	"mantarimay"
	"packman"
	"repo-debug"
	"repo-non-oss"
	"repo-openh264"
	"repo-oss"
	"repo-source"
	"repo-update"
	"sublime-text"
	"system_packagemanager"
	"vscode"
)

declare -a repo_url=(
    "https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed"
    "https://download.opensuse.org/repositories/home:/AZhou/openSUSE_Tumbleweed"
    "https://download.opensuse.org/repositories/home:/mantarimay:/sway/standard/"
    "https://download.sublimetext.com/rpm/stable/x86_64"
    "https://packages.microsoft.com/yumrepos/vscode"
)

declare -a repo_name=(
    "packman"
    "repo-azhou"
    "repo-mantarimay"
    "sublime-text"
    "vscode"
)

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
			if [ -z "$2" ]; then
				LEN=70
			else
				LEN=$2
			fi

			echo -e -n ${PURPLE}
			for((l=1;l <= $LEN; l++)) do
				echo -e -n "-"
			done
			echo -e ${NC}
		;;

		task)
			if [[ $2 == "in" ]]; then
				out_msg task 'Installing' "$3"
			elif [[ $2 == "in_conf" ]]; then
				echo -e "${PURPLE}Installing:${NC} ${BLUE}Config/Themes${NC}"
			else
				echo -e "${PURPLE}$2:${NC} ${BLUE}$3${NC}"
			fi
		;;

		title)
			if [[ $2 == "in" ]]; then
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
			sudo zypper --non-interactive --no-gpg-checks in $2
		fi
	fi
}

zypp_in () {
	sudo zypper --non-interactive --no-gpg-checks in $1
}

# Main
#==================================================================================
out_msg header
echo -e "\n${PURPLE}/// ${BLUE}Oh Hai ${GREEN}$ME${PURPLE}!${NC}"

# Clone NODE9 Repo
#-----------------------------------------
out_msg title 'Clone node9 GIT'
	if [ ! -d $DIR_DPLY ]; then
		git clone https://www.github.com/drbombz/node9 $DIR_DPLY
	else
		out_msg task 'Clone node9' 'Skipping. Repo already cloned'
	fi
	out_msg complete

# Verify all Directories/Create
#-----------------------------------------
out_msg title 'Verifying Deployment Directories'
	for ((i=0; i<=(${#dirs_dply[@]}-1); i++))
	do
		out_msg task "${dirs_dply_name[$i]}" ${dirs_dply[$i]}
		verify_dir ${dirs_dply[$i]}
	done
out_msg complete

# Add Required Repositories
#-----------------------------------------
out_msg title 'Adding Repositories'
	out_msg	task 'removing repos' 'all'
		sudo rm -rf /etc/zypp/repos.d/*

		for ((i=0; i<=(${#repo_file[@]}-1); i++))
		do
			out_task in ${repo_file[$i]}
			sudo cp -rf $DIR_DPLY/repos/${repo_file[$i]}.repo /etc/zypp/repos.d/
		done
out_msg complete

# Add Required Repositories
#-----------------------------------------
#out_msg title 'Adding Repositories'
#	echo
#	for ((i=0; i<=(${#repo_name[@]}-1); i++))
#	do
#		zypp ar ${repo_url[$i]} ${repo_name[$i]}
#		out_msg complete
#	done

# Update all Repositories
#-----------------------------------------
out_msg title 'Updating Repos'
	sudo zypper --no-gpg-checks refresh
out_msg complete

# Install all Required Pkgs
#-----------------------------------------
out_msg title 'Installing Required Packages'
	echo
	for x in "${pkg_req[@]}"
	do
		out_msg title in $x
		zypp in $x
		out_msg complete
	done

# Install Applications/Configs
#-----------------------------------------
out_msg title 'Installing Applications'

	# Install all Repo Applications
	#-----------------------------------------
	echo
	for x in "${pkg_repo[@]}"
	do
		out_msg title in $x
			zypp in "$x"
		out_msg complete
	done

	# codecs
	#------------------------------------------------------------
	out_msg task in 'codecs'
		opi -n codecs
		zypp in "Mesa-libGLESv3-devel Mesa-libGLESv2-devel libgbm-devel"
	out_msg complete

	# bashtop
	#------------------------------------------------------------
	out_msg title in 'bashtop'
		cd $DIR_DPLY_BUILD
		git clone https://github.com/aristocratos/bashtop
		cd bashtop
		sudo make install
	out_msg complete

	# hyprlock
	#------------------------------------------------------------
	out_msg title in 'hyprlock'
		cd $DIR_DPLY_BUILD
		git clone https://github.com/hyprwm/hyprlock
		cd hyprlock
		cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -S . -B ./build
		cmake --build ./build --config Release --target hyprlock -j`nproc 2>/dev/null || getconf _NPROCESSORS_CONF`
		sudo cmake --install build
	out_msg complete

	# swayosd
	#------------------------------------------------------------
	out_msg title in 'swayosd'
		cd $DIR_DPLY_BUILD
		git clone https://github.com/ErikReider/swayosd
		cd swayosd
		meson setup build
		ninja -C build
		sudo meson install -C build
	out_msg complete

	# wlogout
	#------------------------------------------------------------
	out_msg title in 'wlogout'
		cd $DIR_DPLY_BUILD
		git clone https://github.com/ArtsyMacaw/wlogout
		cd wlogout
		meson build
		ninja -C build
		sudo ninja -C build install
	out_msg complete

	# zsh
	#------------------------------------------------------------
	#out_msg title in 'zsh'
	#	zypp in zsh
	out_msg task 'Configure' 'Setting ZSH to default shell'
		sudo chsh -s $(which zsh) $ME
	out_msg complete

	# oh-my-zsh
	#------------------------------------------------------------
	out_msg title in 'oh-my-zsh'
		sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh) --unattended

"
	out_msg complete
	#------------------------------------------------------------

# Install Cursors/Fonts/Icons/Wallpaper
#-----------------------------------------
out_msg title 'Install Cursors/Fonts/Icons/Wallpaper'
	out_msg task in 'Cursors: layan-white-cursors'
		cp -rf $DIR_DPLY/cursors/layan-white-cursors $DIR_LOCAL_ICONS
		sudo cp -rf $DIR_DPLY/cursors/layan-white-cursors /usr/share/icons

	out_msg task in "GTK: Themes"
		verify_dir $DIR_HOME/.themes
		cp -r $DIR_DPLY_CFG/gtk/themes/* $DIR_HOME/.themes

	out_msg task in 'GTK: Settings'
		verify_dir $DIR_LOCAL_CFG/gtk-3.0
		cp -f /$DIR_DPLY_CFG/gtk/bookmarks $DIR_LOCAL_CFG/gtk-3.0
		cp -rf $DIR_DPLY_CFG/gtk/.gtkrc-2.0 $DIR_HOME
		
		verify_dir $DIR_HOME/.icons
		verify_dir $DIR_HOME/.icons/default
		cp -rf $DIR_DPLY_CFG/gtk/index.theme $DIR_HOME/.icons/default
		
		verify_dir $DIR_LOCAL_CFG/xsettingsd
		cp -rf $DIR_DPLY_CFG/gtk/xsettingsd.conf $DIR_LOCAL_CFG/xsettingsd

	out_msg task in 'Font: All [LOCAL]'
		cp -rf $DIR_DPLY/fonts/* $DIR_FONTS_LOCAL

	out_msg task in 'Font: fira'
		sudo cp -rf $DIR_DPLY/fonts/fira/* $DIR_SYS_FONTS

	out_msg task in 'Font: font-awesome'
		sudo cp -rf $DIR_DPLY/fonts/font-awesome/* $DIR_SYS_FONTS

	out_msg task in 'Font: iosevka'
		sudo cp -rf $DIR_DPLY/fonts/iosevka/* $DIR_SYS_FONTS

	out_msg task in 'Font: material-design'
		sudo cp -rf $DIR_DPLY/fonts/material-design/* $DIR_SYS_FONTS

	out_msg task in 'Font: sf-compact'
		sudo cp -rf $DIR_DPLY/fonts/sf-compact/* $DIR_SYS_FONTS

	out_msg task in 'Icons: dracula-icons-main'
		cp -rf $DIR_DPLY/icons/dracula-icons-main $DIR_LOCAL_ICONS

	out_msg task in 'Icons: flatery-blue-dark'
		cp -rf $DIR_DPLY/icons/flatery-blue-dark $DIR_LOCAL_ICONS

	out_msg task in 'Wallpaper'
		cp -rf $DIR_DPLY/wallpaper/* $DIR_LOCAL_WPAPER
out_msg complete

# Verify User Config Directories
#-----------------------------------------
out_msg title 'Verifying User Config Directories'
	for ((i=0; i<=(${#dirs_cfg[@]}-1); i++))
	do
		out_msg task "${dirs_cfg[$i]}" $DIR_LOCAL_CFG/${dirs_cfg[$i]}
		verify_dir "$DIR_LOCAL_CFG/${dirs_cfg[$i]}"
	done
	out_msg task "oh-my-zsh/themes" $DIR_HOME/.oh-my-zsh/themes
	verify_dir $DIR_HOME/.oh-my-zsh/themes
out_msg complete

# Install User Configs
#-----------------------------------------
out_msg title 'Installing User Configs'
	cd $DIR_DPLY_CFG
	out_msg task in 'audacious'
		cp -rf ./audacious/* $DIR_LOCAL_CFG/audacious

	out_msg task in 'bashtop'
		cp -f ./bashtop/bashtop.cfg $DIR_LOCAL_CFG/bashtop
		cp -f ./bashtop/node9.theme $DIR_LOCAL_CFG/bashtop/themes

	out_msg task in 'cava'
		cp -rf ./cava/* $DIR_LOCAL_CFG/cava

	out_msg task in 'cmus'
		cp -rf ./cmus/* $DIR_LOCAL_CFG/cmus

	out_msg task in 'code'
		sudo cp -f ./code/code.desktop $DIR_SYS_SHARE/applications

	out_msg task in 'hyprland'
		cp -f ./hypr/hyprland.conf $DIR_LOCAL_CFG/hypr

	out_msg task in 'hyprlock'
		cp -f ./hypr/hyprlock.conf $DIR_LOCAL_CFG/hypr

	out_msg task in 'hyprpaper'
		cp -f ./hyprpaper/hyprpaper.conf $DIR_LOCAL_CFG/hyprpaper

	out_msg task in 'kitty'
		cp -rf ./kitty/* $DIR_LOCAL_CFG/kitty

	out_msg task in 'kvantum'
		cp -rf ./kvantum/* $DIR_LOCAL_CFG/Kvantum

	out_msg task in 'neofetch'
		cp -rf ./neofetch/* $DIR_LOCAL_CFG/neofetch

	out_msg task in 'oh-my-zsh'
		cp -rf ./oh-my-zsh/* $DIR_HOME/.oh-my-zsh/themes
		cp -f ./zsh/.zshrc $DIR_HOME

	out_msg task in 'rofi'
		cp -f ./rofi/config.rasi $DIR_LOCAL_CFG/rofi
		cp -rf ./rofi/themes/* $DIR_LOCAL_CFG/rofi/themes

	out_msg task in 'sddm'
		sudo tar -xzf ./sddm/sugar-dark.tar.gz -C $DIR_SYS_SDDM/themes
		sudo cp -f ./sddm/theme.conf $DIR_SYS_SDDM/themes/sugar-dark
		sudo mkdir $DIR_SYS_SDDM/themes/sugar-dark/Backgrounds
		sudo cp -f $DIR_DPLY/wallpaper/purple-planet.png $DIR_SYS_SDDM/themes/sugar-dark/Backgrounds
		sudo cp -f ./sddm/sddm.conf /etc/sddm.conf.d

	out_msg task in 'sublime-text'
		cp -rf ./sublime-text/* $DIR_LOCAL_CFG/sublime-text

	out_msg task in 'swaync'
		cp -rf ./swaync/* $DIR_LOCAL_CFG/swaync

	out_msg task in 'swayosd'
		cp -rf ./swayosd/* $DIR_LOCAL_CFG/swayosd

	out_msg task in 'waybar'
		cp -rf ./waybar/* $DIR_LOCAL_CFG/waybar

	out_msg task in 'wlogout'
		cp -f ./wlogout/layout $DIR_LOCAL_CFG/wlogout
		cp -f ./wlogout/style.css $DIR_LOCAL_CFG/wlogout
		cp -rf ./wlogout/icons $DIR_LOCAL_CFG/wlogout
out_msg complete

# Set GTK Enviroment
#-----------------------------------------
out_msg title 'Configuring GTK Enviroment'
	out_msg task 'theme' 'dracula'
		gsettings set org.gnome.desktop.interface gtk-theme dracula
		gsettings set org.gnome.desktop.wm.preferences theme dracula

	out_msg task 'cusor theme' 'layan-white-cursors'
		gsettings set org.gnome.desktop.interface cursor-theme layan-white-cursors

	out_msg task 'cusor size' '36'
		gsettings set org.gnome.desktop.interface cursor-size 36

	out_msg task 'font' 'sf-compact-rounded 12'
		gsettings set org.gnome.desktop.interface font-name 'SF Compact Rounded 12'
		gsettings set org.gnome.desktop.interface document-font-name 'SF Compact Rounded 12'

	out_msg task 'icon theme' 'flatery-blue-dark'
		gsettings set org.gnome.desktop.interface icon-theme flatery-blue-dark

	out_msg task 'text-scaling-factor' '1.25'
		gsettings set org.gnome.desktop.interface text-scaling-factor 1.25

	out_msg task 'perfered color scheme' 'perfer-dark'
		gsettings set org.gnome.desktop.interface color-scheme prefer-dark
out_msg complete

# Configure Nemo
#-----------------------------------------
out_msg title 'Configuring Nemo'
	out_msg task "list-view/${YELLOW}default-zoom${PURPLE}" standard
		gsettings set org.nemo.list-view default-zoom-level small

	out_msg task "desktop/${YELLOW}background-fade${PURPLE}" 'false'
		gsettings set org.nemo.desktop background-fade false

	out_msg task "preferences/${YELLOW}confirm-trash${PURPLE}" 'false'
		gsettings set org.nemo.preferences confirm-trash false

	out_msg task "preferences/${YELLOW}default-folder-viewer${PURPLE}" 'false'
		gsettings set org.nemo.preferences default-folder-viewer list-view

	out_msg task "preferences/${YELLOW}never-queue-file-ops${PURPLE}" 'true'
		gsettings set org.nemo.preferences never-queue-file-ops true

	out_msg task "preferences/${YELLOW}selection-menu-copy-to${PURPLE}" 'true'
		gsettings set org.nemo.preferences.menu-config selection-menu-copy-to true

	out_msg task "preferences/${YELLOW}selection-menu-copy-to${PURPLE}" 'true'
		gsettings set org.nemo.preferences.menu-config selection-menu-move-to true

	out_msg task "preferences/${YELLOW}show-advanced-permissions${PURPLE}" 'true'
		gsettings set org.nemo.preferences show-advanced-permissions true

	out_msg task "preferences/${YELLOW}show-compact-view-icon-toolbar${PURPLE}" 'false'
		gsettings set org.nemo.preferences show-compact-view-icon-toolbar false

	out_msg task "preferences/${YELLOW}show-edit-icon-toolbar${PURPLE}" 'false'
		gsettings set org.nemo.preferences show-edit-icon-toolbar false

	out_msg task "preferences/${YELLOW}show-full-path-titles${PURPLE}" 'true'
		gsettings set org.nemo.preferences show-full-path-titles true

	out_msg task "preferences/${YELLOW}show-hidden-files${PURPLE}" 'true'
		gsettings set org.nemo.preferences show-hidden-files true

	out_msg task "preferences/${YELLOW}show-location-entry${PURPLE}" 'true'
		gsettings set org.nemo.preferences show-location-entry true

	out_msg task "preferences/${YELLOW}show-reload-icon-toolbar${PURPLE}" 'true'
		gsettings set org.nemo.preferences show-reload-icon-toolbar true

	out_msg task "preferences/${YELLOW}show-directory-item-counts${PURPLE}" 'always'
		gsettings set org.nemo.preferences show-directory-item-counts always
out_msg complete

# Configure Firefox
#-----------------------------------------
out_msg title 'Configuring Firefox'
	firefox &
	sleep 1
	pkill -f firefox
	FFPROF=$(grep 'Path=' $DIR_HOME/.mozilla/firefox/profiles.ini | sed 's/^.*Path=//p' | tail -n1)
	DIR_FF="$DIR_HOME/.mozilla/firefox/$FFPROF"
	echo -e "${PURPLE}profile:${NC} ${BLUE}$FFPROF${NC}"
	out_msg task in 'firefox-profile'
		cp -rf ./firefox/* $DIR_FF
	out_msg complete

# Configure Misc Settings
#-----------------------------------------
out_msg title 'Configuring Misc Settings'
	out_msg task in 'user-places'
		cp -f $DIR_DPLY_CFG/misc/user-places.xbel $DIR_LOCAL_SHARE

	out_msg task in 'n9-scripts'
		cp -rf $DIR_DPLY/scripts/* $DIR_HOME/.n9-scripts
out_msg complete

# Finished!
#-----------------------------------------
user_in 'Reboot the system'
if [[ $? == 1 ]]; then
	echo -e -n "\n${RED}SYSTEM REBOOTING ${NC}" 
	for ((i=4; i!=0; i--))
	do
		echo -e -n "${PURPLE}$i"
		if [ $i != 1 ]; then
			echo -e -n "${PURPLE}.."
		fi
		sleep 1
	done
	echo -e " ///${NC} ${BLUE}goodbye!"
	sleep 2
	sudo systemctl reboot
else
	echo -e "\n${PURPLE}///${NC} ${BLUE}Enjoi your new${NC} ${GREEN}n9-system${NC}${BLUE} goodbye!${NC}\n"
fi
exit