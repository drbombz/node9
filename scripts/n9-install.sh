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
DIR_DPLY="$DIR_HOME/node9"
DIR_DPLY_BUILD="$DIR_DPLY/builds"
DIR_DPLY_CFG="$DIR_DPLY/config"
DIR_GO="$DIR_HOME/go"
DIR_HOME_CFG="$DIR_HOME/.config"
DIR_HOME_SHARE="$DIR_HOME/.local/share"
DIR_HOME_ICONS="$DIR_HOME_SHARE/icons"
DIR_HOME_WPAPER="$DIR_HOME/.local/wallpapers"
DIR_HOME_SCRIPTS="$DIR_HOME/.n9-scripts"
DIR_SYS_SHARE="/usr/share"
DIR_SYS_APPLICATIONS="$DIR_SYS_SHARE/applications"
DIR_SYS_FONTS="$DIR_SYS_SHARE/fonts/truetype"
DIR_SYS_ICONS="$DIR_SYS_SHARE/icons"
DIR_SYS_SDDM="$DIR_SYS_SHARE/sddm"


# Deployment Directories
declare -a dirs_dply=(
	$DIR_HOME
	$DIR_DPLY
	$DIR_DPLY_BUILD
	$DIR_DPLY_CFG
	$DIR_HOME_CFG
	$DIR_HOME_ICONS
	$DIR_HOME_SCRIPTS
	$DIR_HOME_WPAPER
	$DIR_SYS_FONTS
	$DIR_SYS_ICONS
)

# Deployment Directory Names
declare -a dirs_dply_name=('home' 'deploy-root' 'deploy-build' 'deploy-config' 'local-config' 'local-icons' 'local-scripts' 'local-wallpaper' 'system-fonts' 'system-icons')

# Config Directories
declare -a dirs_cfg=('audacious' 'bashtop' 'cava' 'cmus' 'hypr' 'kitty' 'kvantum' 'neofetch' 'nfoview' 'remmina' 'rofi' 'sublime-text' 'swaync' 'swayosd' 'waybar' 'wlogout')

# Home Directories
declare -a dirs_home=('Documents' 'Downloads' 'Music' 'Pictures')

# Required Packages
declare -a pkg_req=('brightnessctl' 'caca-utils' 'cairo-devel' 'cairo-tools' 'cargo' 'file-devel' 'fmt-devel' 'freeglut-devel' 'fftw3-devel'
'go1.22' 'gobject-introspection' 'gobject-introspection-devel' 'gtk-layer-shell-devel' 'gtkmm3-devel' 'hyprlang-devel' 'libiniparser-devel' 'jsoncpp-devel' 'kf6-extra-cmake-modules'
'libappindicator3-1' 'libdbusmenu-gtk3-devel' 'libdisplay-info-devel' 'libdrm-tools' 'libevdev-devel' 'libjxl-devel' 'libKF5GuiAddons5' 'libmpdclient-devel' 'libopenssl1_1' 'libpng12-devel' 'libsdbus-c++1' 'librsvg' 'librsvg-devel' 
'libzip' 'libzip-devel' 'typelib-1_0-Gtk-4_0' 'libxkbregistry-devel' 'NetworkManager-connection-editor' 'NetworkManager-bluetooth' 'meson' 'mtpfs' 'mtp-tools' 'opi' 'pango-tools' 'playerctl-devel' 'pugixml-devel' 'pipewire-devel'
'pulseaudio-bash-completion' 'pulseaudio-zsh-completion' 'qt6-waylandclient-private-devel' 're2-devel' 'sassc' 'sdbus-cpp-devel' 'scdoc' 'sndio' 'sndio-devel' 'spdlog-devel' 'unrar' 'unzip' 'wayland-protocols-devel' 'xdg-desktop-portal-hyprland'
'ccache' 'gtest' 'libchromaprint-devel' 'libebur128-devel' 'libkeyfinder-devel' 'flac-devel' 'lame' 'libmp3lame-devel' 'libvorbis-devel' 'portaudio-devel' 'portmidi-devel' 'protobuf-devel'
'librubberband-devel' 'libsndfile-devel' 'libdjinterop0-devel' 'ffmpeg-7-libavcodec-devel' 'ffmpeg-7-libavdevice-devel' 'opusfile-devel' 'soundtouch-devel' 'libtag-devel' 'libupower-glib-devel'
'ms-gsl-devel' 'qtkeychain-qt5-devel' 'liblilv-0-devel' 'libmad-devel' 'libmodplug-devel' 'libusb-1_0-devel' 'libhidapi-devel' 'wavpack-devel' 'vamp-plugin-sdk' 'faad2-devel''sqlite3' 'sqlite3-devel')

# Optional Packages
declare -a pkg_opt=('cmake' 'gtk3-devel' 'libdrm-devel' 'libinput-devel' 'libqt5-qtwayland-devel' 'libqt5-qdbus' 'libqt5-qtsvg-devel'
'libQt5DBus-devel' 'libqt5-qttools' 'libwebp-devel' 'libxkbcommon-devel' 'libxkbcommon-x11-devel' 'libXcursor-devel' 'ninja' 'pam-devel'
'pango-devel' 'systemd-devel')

declare -a pkg_repo=('sway' 'audacious' 'cava' 'clapper' 'cmus' 'code' 'dconf-editor' 'grim' 'gthumb' 'hyprland' 'hyprpaper' 'hyprpicker' 'kitty'
'kvantum-qt5' 'kvantum-manager' 'lsd' 'nemo' 'neofetch' 'nfoview' 'remmina' 'rofi-wayland' 'sddm' 'sublime-text' 'swappy' 'swaync' 'waybar' 'zsh')

declare -a repo_file=('azhou' 'mantarimay' 'packman' 'repo-debug' 'repo-non-oss' 'repo-openh264' 'repo-oss' 'repo-source' 'repo-update'
'sublime-text' 'system_packagemanager' 'vscode')

declare -a repo_url=(
    'https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed'
    'https://download.opensuse.org/repositories/home:/mantarimay:/sway/standard/'
    'https://download.sublimetext.com/rpm/stable/x86_64'
    'https://packages.microsoft.com/yumrepos/vscode'
)

declare -a repo_name=('packman' 'repo-azhou' 'repo-mantarimay' 'sublime-text' 'vscode')

# Main
#==================================================================================
out_msg header
echo -e "\n${PURPLE}/// ${BLUE}Oh Hai ${GREEN}$ME${PURPLE}!${NC}"

# Create System Snapshot
#-----------------------------------------
out_msg title 'Creating System Snapsnot'
	SNAPNAME="Before N9 Deploy $(date '+%m-%d-%Y %H:%M')"
	out_msg task 'Creating Snapshot' "'${SNAPNAME}'"
		sudo snapper create --description "${SNAPNAME}"
out_msg complete

# Clone NODE9 Repo
#-----------------------------------------
out_msg title 'Clone node9 GIT'
	if [ ! -d $DIR_DPLY ]; then
		git clone https://www.github.com/drbombz/node9 $DIR_DPLY
	else
		out_msg task 'Clone node9' 'Skipping. Repo already cloned'
	fi
	out_msg complete

# Verify Deployment Directories
#-----------------------------------------
out_msg title 'Verifying Deployment Directories'
	for ((i=0; i<=(${#dirs_dply[@]}-1); i++))
	do
		out_msg task "${dirs_dply_name[$i]}" ${dirs_dply[$i]}
		verify_dir ${dirs_dply[$i]}
	done
out_msg complete

# Create Default HOME Directories
#-----------------------------------------
out_msg title 'Verifying Default HOME Directories'
	for ((i=0; i<=(${#dirs_home[@]}-1); i++))
	do
		out_msg task "${dirs_home[$i]}" $DIR_HOME/${dirs_home[$i]}
		verify_dir $DIR_HOME/${dirs_home[$i]}
	done
out_msg complete

# Add Required Repositories
#-----------------------------------------
out_msg title 'Adding Repositories'
	out_msg	task 'Removing Repos' All
		sudo rm -rf /etc/zypp/repos.d/*

		for ((i=0; i<=(${#repo_file[@]}-1); i++))
		do
			out_msg task in ${repo_file[$i]}
			sudo cp -rf $DIR_DPLY/repos/${repo_file[$i]}.repo /etc/zypp/repos.d/
		done
out_msg complete

# Update all Repositories
#-----------------------------------------
out_msg title 'Updating Repos'
	sudo zypper --non-interactive --no-gpg-checks --color refresh
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
	out_msg task in codecs
		opi -n codecs
		zypp in "Mesa-libGLESv3-devel Mesa-libGLESv2-devel libgbm-devel"
	out_msg complete

	# bashtop
	#------------------------------------------------------------
	out_msg title in bashtop
		cd $DIR_DPLY_BUILD
		git clone https://github.com/aristocratos/bashtop & cd bashtop
		sudo make install
	out_msg complete

	# sdbus
	#------------------------------------------------------------
	out_msg title in sdbus-cpp
		cd $DIR_DPLY_BUILD
		git clone https://github.com/Kistler-Group/sdbus-cpp && cd sdbus-cpp
		mkdir build && cd build
		cmake .. -DCMAKE_BUILD_TYPE=Release
		cmake --build .
		sudo cmake --build . --target install
	out_msg complete

	# aquamarine
	#------------------------------------------------------------
	out_msg title in aquamarine
		cd $DIR_DPLY_BUILD
		git clone https://github.com/hyprwm/aquamarine && cd aquamarine
		cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
		cmake --build ./build --config Release --target all -j`nproc 2>/dev/null || getconf _NPROCESSORS_CONF`
		sudo cmake --install ./build
	out_msg complete

	# hyprland-protocols
	#------------------------------------------------------------
	out_msg title in hyprland-protocols
		cd $DIR_DPLY_BUILD
		git clone https://github.com/hyprwm/hyprland-protocols && cd hyprland-protocols
		meson build
		sudo meson install -C build
	out_msg complete

	# hyprlang
	#------------------------------------------------------------
	out_msg title in hyprlang
		cd $DIR_DPLY_BUILD
		git clone https://github.com/hyprwm/hyprlang && cd hyprlang
		cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
		cmake --build ./build --config Release --target hyprlang -j`nproc 2>/dev/null || getconf _NPROCESSORS_CONF`
		sudo cmake --install ./build
	out_msg complete

	# hyprcursor
	#------------------------------------------------------------
	out_msg title in hyprcursor
		cd $DIR_DPLY_BUILD
		git clone https://github.com/hyprwm/hyprgraphics && cd hyprgraphics
			cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
			cmake --build ./build --config Release --target all -j`nproc 2>/dev/null || getconf NPROCESSORS_CONF`
			sudo cmake --install build
	out_msg complete

	# hyprland-qtutils
	#------------------------------------------------------------
	out_msg title in hyprland-qtutils
		cd $DIR_DPLY_BUILD
		git clone https://github.com/hyprwm/hyprland-qtutils && cd hyprland-qtutils
			cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
			cmake --build ./build --config Release --target all -j`nproc 2>/dev/null || getconf NPROCESSORS_CONF`
			sudo cmake --install build
	out_msg complete

	# hyprgraphics
	#------------------------------------------------------------
	out_msg title in hyprcursor
		cd $DIR_DPLY_BUILD
		git clone https://github.com/hyprwm/hyprcursor && cd hyprcursor
		cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
		cmake --build ./build --config Release --target all -j`nproc 2>/dev/null || getconf _NPROCESSORS_CONF`
		sudo cmake --install build
	out_msg complete

	# hyprsunset
	#------------------------------------------------------------
	out_msg title in hyprsunset
		cd $DIR_DPLY_BUILD
		git clone https://github.com/hyprwm/hyprsunset && cd hyprsunset
		cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
		cmake --build ./build --config Release --target all -j`nproc 2>/dev/null || getconf _NPROCESSORS_CONF`
		sudo cmake --install build
	out_msg complete

	# hyprwayland-scanner
	#------------------------------------------------------------
	out_msg title in hyprwayland-scanner
		cd $DIR_DPLY_BUILD
		git clone https://github.com/hyprwm/hyprwayland-scanner && cd hyprwayland-scanner
		cmake -DCMAKE_INSTALL_PREFIX=/usr -B build
		cmake --build build -j `nproc`
		sudo cmake --install build
	out_msg complete

	# hyprland
	#------------------------------------------------------------
	out_msg title in hyprland
		cd $DIR_DPLY_BUILD
		git clone --recursive https://github.com/hyprwm/Hyprland && cd hyprland
		make all && sudo make install
	out_msg complete


	# astal (io)
	#------------------------------------------------------------
	out_msg title in 'astal (io)'
		cd $DIR_DPLY_BUILD
		git clone https://github.com/aylur/astal.git && cd astal/lib/astal/io
		meson setup --prefix /usr build
		meson install -C build
	out_msg complete

	# astal (gtk3)
	#------------------------------------------------------------
	out_msg title in 'astal (gtk3)'
		cd $DIR_DPLY_BUILD/astal/lib/astal/gtk3
		meson setup --prefix /usr build
		meson install -C build
	out_msg complete

	# astal (gjs)
	#------------------------------------------------------------
	out_msg title in 'astal (gjs)'
		cd $DIR_DPLY_BUILD/astal/lang/gjs
		meson setup --prefix /usr build
		meson install -C build
	out_msg complete
	
	# ags
	#------------------------------------------------------------
	out_msg title in 'ags'
		cd $DIR_DPLY_BUILD
		git clone https://github.com/aylur/ags.git && cd ags
		go install -ldflags "\
			-X 'main.gtk4LayerShell=$(pkg-config --variable=libdir gtk4-layer-shell-0)/libgtk4-layer-shell.so' \
			-X 'main.astalGjs=$(pkg-config --variable=srcdir astal-gjs)'"
		sudo mv $DIR_GO/bin/ags /usr/bin/ags
		out_msg complete

	# hypridle
	#------------------------------------------------------------
	out_msg title in hypridle
		cd $DIR_DPLY_BUILD
		git clone https://github.com/hyprwm/hypridle && cd hypridle
		cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -S . -B ./build
		cmake --build ./build --config Release --target hypridle -j`nproc 2>/dev/null || getconf _NPROCESSORS_CONF`
		sudo cmake --install build
	out_msg complete

	# hyprlock
	#------------------------------------------------------------
	out_msg title in hyprlock
		cd $DIR_DPLY_BUILD
		git clone https://github.com/hyprwm/hyprlock && cd hyprlock
		cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -S . -B ./build
		cmake --build ./build --config Release --target hyprlock -j`nproc 2>/dev/null || getconf _NPROCESSORS_CONF`
		sudo cmake --install build
	out_msg complete

	# hyprpaper
	#------------------------------------------------------------
	out_msg title in hyprpaper
		cd $DIR_DPLY_BUILD
		git clone https://github.com/hyprwm/hyprutils && cd hyprpaper
		cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
		cmake --build ./build --config Release --target hyprpaper -j`nproc 2>/dev/null || getconf _NPROCESSORS_CONF`
		sudo cmake --install build
	out_msg complete

	# hyprutils
	#------------------------------------------------------------
	out_msg title in hyprutils
		cd $DIR_DPLY_BUILD
		git clone https://github.com/hyprwm/hyprutils && cd hyprutils
		cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
		cmake --build ./build --config Release --target all -j`nproc 2>/dev/null || getconf _NPROCESSORS_CONF`
		sudo cmake --install build
	out_msg complete



	# sway-audio-idle-inhibit
	#------------------------------------------------------------
	out_msg title in sway-audio-idle-inhibit
		cd $DIR_DPLY_BUILD
		git clone https://github.com/ErikReider/SwayAudioIdleInhibit && cd SwayAudioIdleInhibit
		meson build
		ninja -C build
		meson install -C build
	out_msg complete

	# swayosd
	#------------------------------------------------------------
	out_msg title in swayosd
		cd $DIR_DPLY_BUILD
		git clone https://github.com/ErikReider/swayosd && cd swayosd
		meson setup build
		ninja -C build
		sudo meson install -C build
	out_msg complete

	# wlogout
	#------------------------------------------------------------
	out_msg title in wlogout
		cd $DIR_DPLY_BUILD
		git clone https://github.com/ArtsyMacaw/wlogout && cd wlogout
		meson build
		ninja -C build
		sudo ninja -C build install
	out_msg complete

	# oh-my-zsh
	#------------------------------------------------------------
	out_msg title in oh-my-zsh
		sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh) --unattended"
	out_msg complete
	#------------------------------------------------------------

# Install Cursors/Fonts/Icons/Wallpaper
#-----------------------------------------
out_msg title 'Install Cursors/Fonts/Icons/Wallpaper'
	out_msg task in 'cursors: layan-white-cursors'
		cp -rf $DIR_DPLY/cursors/layan-white-cursors $DIR_HOME_ICONS
		sudo cp -rf $DIR_DPLY/cursors/layan-white-cursors /usr/share/icons

	out_msg task in "gtk: themes"
		verify_dir $DIR_HOME/.themes
		cp -r $DIR_DPLY_CFG/gtk/themes/* $DIR_HOME/.themes

	out_msg task in 'gtk: settings'
		verify_dir $DIR_HOME_CFG/gtk-3.0
		cp -rf $DIR_DPLY_CFG/gtk/gtk-3.0/* $DIR_HOME_CFG/gtk-3.0
		cp -rf $DIR_DPLY_CFG/gtk/gtk-2.0/.gtkrc-2.0 $DIR_HOME

		verify_dir $DIR_HOME_CFG/xsettingsd
		cp -rf $DIR_DPLY_CFG/gtk/xsettingsd.conf $DIR_HOME_CFG/xsettingsd

	out_msg task in 'fonts: (fira/font-awesome/iosevka/material-design/sf-compact)'
		cp -rf $DIR_DPLY/fonts/* $DIR_HOME_SHARE/fonts
		sudo cp -rf $DIR_DPLY/fonts/material-design $DIR_SYS_FONTS
	
	out_msg task in 'icons: (dracula-icons-main/kora-grey/zafiro-icons-light)'
		cp -rf $DIR_DPLY/icons/* $DIR_HOME_ICONS

	out_msg task in 'icons: n9-icons'
		verify_dir $DIR_HOME/.icons
		cp -rf $DIR_DPLY/icons/n9-icons $DIR_HOME/.icons

	out_msg task in 'wallpaper'
		cp -rf $DIR_DPLY/wallpaper/* $DIR_HOME_WPAPER
out_msg complete

# Verify User Config Directories
#-----------------------------------------
out_msg title 'Installing User Configs'
	for ((i=0; i<=(${#dirs_cfg[@]}-1); i++))
	do
		APPNAME=${dirs_cfg[$i]}
		out_msg task in $APPNAME
		verify_dir $DIR_HOME_CFG/$APPNAME
		cp -rf $DIR_DPLY_CFG/$APPNAME/* $DIR_HOME_CFG/$APPNAME
	done
	mv $DIR_HOME_CFG/kvantum $DIR_HOME_CFG/Kvantum
	out_msg task in oh-my-zsh
		verify_dir $DIR_HOME/.oh-my-zsh/themes
		cp -rf $DIR_DPLY_CFG/oh-my-zsh/* $DIR_HOME/.oh-my-zsh/themes
		cp -f $DIR_DPLY_CFG/zsh/.zshrc $DIR_HOME

	out_msg task in sddm
		sudo tar -xzf $DIR_DPLY_CFG/sddm/sugar-dark.tar.gz -C $DIR_SYS_SDDM/themes
		sudo cp -f $DIR_DPLY_CFG/sddm/theme.conf $DIR_SYS_SDDM/themes/sugar-dark
		sudo mkdir $DIR_SYS_SDDM/themes/sugar-dark/Backgrounds
		sudo cp -f $DIR_DPLY/wallpaper/purple-dark-fractal.png $DIR_SYS_SDDM/themes/sugar-dark/Backgrounds
		sudo cp -f $DIR_DPLY_CFG/sddm/sddm.conf /etc/sddm.conf.d
out_msg complete

# Set GTK Enviroment
#-----------------------------------------
out_msg title 'Configuring GTK Enviroment'
	while read -r LINE
	do
	if [[ $LINE == "["* ]] then
		echo -e "${RED}>> ${NC}${YELLOW}$LINE${NC}"
	elif [[ $LINE == '' ]] then
		echo
	else
		IFS='='; SETTING=(${LINE}); unset IFS
		out_msg task "${SETTING[0]}" "${SETTING[1]}"
		sleep 0.1
	fi
	done < "$DIR_HOME_CFG/gtk-3.0/gtk-settings.ini"

# Configure Firefox
#-----------------------------------------
out_msg title 'Configuring Firefox'
	firefox &
	sleep 1 && pkill -f firefox
	FFPROF=$(grep 'Path=' $DIR_HOME/.mozilla/firefox/profiles.ini | sed 's/^.*Path=//p' | tail -n1)
	DIR_FF="$DIR_HOME/.mozilla/firefox/$FFPROF"
	
	echo -e "${PURPLE}profile:${NC} ${BLUE}$FFPROF${NC}"
	out_msg task in 'firefox-profile'
		cp -rf $DIR_DPLY_CFG/firefox/* $DIR_FF
	out_msg complete

# Configure Misc Settings
#-----------------------------------------
out_msg title 'Configuring Misc Settings'
	out_msg task in grub.conf
		sudo cp -f $DIR_DPLY_CFG/grub/grub /etc/default
	
	out_msg task in applaunchers
		verify_dir $DIR_HOME_SHARE/applications
		sudo cp -rf $DIR_DPLY/applaunchers/sys/* $DIR_SYS_APPLICATIONS
		cp -rf $DIR_DPLY/applaunchers/user/* $DIR_HOME_SHARE/applications

	out_msg task in n9-scripts
		cp -rf $DIR_DPLY/scripts/* $DIR_HOME/.n9-scripts

	out_msg task Configure 'Setting ZSH to default shell'
		sudo chsh -s $(which zsh) $ME
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