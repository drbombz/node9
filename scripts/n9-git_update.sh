#!/bin/zsh
clear

autoload -U colors && colors
ROOT_DIR="/home/upgrad3/.git/node9"
CONFIG_DIR="$ROOT_DIR/config"
SCRIPTS_DIR="$ROOT_DIR/scripts"

out_complete () {
	print -P "%{$fg_bold[magenta] ---[ %{$fg[blue]Complete! %{$fg_bold[magenta]]-------------------------"
}

out_copy () {
	print -P " %{$fg_bold[magenta]Copying: %{$fg_bold[blue] $1"
}

out_gitcmd () {
	print -P " %{$fg_bold[magenta]$1...%{$fg_bold[yellow]"
}

out_title () {
	print -P -l "\n%{$fg_bold[blue] [ %{$fg_bold[magenta]$1%{$fg_bold[blue] ]"
	print -P "%{$fg_bold[magenta] ----------------------------"
}

print -P "%{$fg_bold[magenta]%                                   ______"
print -P "    _____________________________/::'   \\"
print -P "   /:'   \\\::'    \\\::'    \\\::' _  \\\:' |   \\"
print -P "  /:' |   \\\'  -   \\\'    | \\\'    __\\\_     / %F{blue}n9! -- [%F{magenta} Update: GIT/node9 %F{blue}]%F{magenta}"
print -P " +\\\___|___/_______/_______/_______/_____/------------------------------------------------------------------+%{$reset_color%}"
sleep 2

out_title 'Syincing Dots'
	out_copy audacious
		cp ~/.config/audacious/config $CONFIG_DIR/audacious
		cp ~/.config/audacious/playlist-state $CONFIG_DIR/audacious
		cp ~/.config/audacious/plugin-registry $CONFIG_DIR/audacious
		cp ~/.config/audacious/QtUi.conf $CONFIG_DIR/audacious

	out_copy bashtop
		cp ~/.config/bashtop/bashtop.cfg $CONFIG_DIR/bashtop
		cp ~/.config/bashtop/user_themes/node9.theme $CONFIG_DIR/bashtop

	out_copy cava
		cp ~/.config/cava/config $CONFIG_DIR/cava

	out_copy cmus
		cp ~/.config/cmus/autosave $CONFIG_DIR/cmus
		cp ~/.config/cmus/rc $CONFIG_DIR/cmus

	out_copy dolphin
		cp ~/.config/dolphinrc $CONFIG_DIR/dolphin

	out_copy firefox
		FFPROF=$(grep 'Path=' ~/.mozilla/firefox/profiles.ini | sed 's/^.*Path=//p' | tail -n1)
		cp ~/.mozilla/firefox/$FFPROF/addons.json $CONFIG_DIR/firefox
		cp ~/.mozilla/firefox/$FFPROF/addonStartup.json.lz4 $CONFIG_DIR/firefox
		cp ~/.mozilla/firefox/$FFPROF/extension-preferences.json $CONFIG_DIR/firefox
		cp ~/.mozilla/firefox/$FFPROF/extension-settings.json $CONFIG_DIR/firefox
		cp ~/.mozilla/firefox/$FFPROF/prefs.js $CONFIG_DIR/firefox/user.js
		cp ~/.mozilla/firefox/$FFPROF/permissions.sqlite $CONFIG_DIR/firefox
		cp ~/.mozilla/firefox/$FFPROF/content-prefs.sqlite $CONFIG_DIR/firefox
		cp ~/.mozilla/firefox/$FFPROF/search.json.mozlz4 $CONFIG_DIR/firefox
		cp ~/.mozilla/firefox/$FFPROF/handlers.json $CONFIG_DIR/firefox
	
	out_copy gtk
		cp -r ~/.themes/dracula $CONFIG_DIR/gtk/themes
		cp ~/.config/gtk-3.0/settings.ini $CONFIG_DIR/gtk
		cp ~/.gtkrc-2.0 $CONFIG_DIR/gtk
		cp ~/.icons/default/index.theme $CONFIG_DIR/gtk
		cp ~/.config/xsettingsd/xsettingsd.conf $CONFIG_DIR/gtk
		cp ~/.config/gtk-3.0/bookmarks $CONFIG_DIR/gtk

	out_copy hyprland
		cp -rf ~/.config/hypr/* $CONFIG_DIR/hypr

	out_copy hyprpaper
		cp ~/.config/hyprpaper/hyprpaper.conf $CONFIG_DIR/hyprpaper
		cp ~/.config/hyprpaper/wallpaper.png $CONFIG_DIR/hyprpaper

	out_copy kitty
		cp ~/.config/kitty/* $CONFIG_DIR/kitty

	out_copy krusader
		cp ~/.config/krusaderrc $CONFIG_DIR/krusader

	out_copy kvantum
		cp -rf ~/.config/Kvantum/node9 $CONFIG_DIR/kvantum
		cp ~/.config/Kvantum/kvantum.kvconfig $CONFIG_DIR/kvantum

	out_copy neofetch
		cp ~/.config/neofetch/config.conf $CONFIG_DIR/neofetch

	out_copy misc
		cp ~/.local/share/user-places.xbel $CONFIG_DIR/misc

	out_copy nwg-look
		cp ~/.config/nwg-look/* $CONFIG_DIR/nwg-look

	out_copy oh-my-zsh
		cp ~/.oh-my-zsh/themes/node9.zsh-theme $CONFIG_DIR/oh-my-zsh

	out_copy remmina
		cp ~/.config/remmina/remmina.pref $CONFIG_DIR/remmina

	out_copy rofi
		cp ~/.config/rofi/config.rasi $CONFIG_DIR/rofi
		cp ~/.config/rofi/themes/* $CONFIG_DIR/rofi/themes

	out_copy sddm--sugar-dark-theme
		cp /usr/share/sddm/themes/sugar-dark/theme.conf $CONFIG_DIR/sddm

	out_copy sublime-text
		cp -r ~/.config/sublime-text/Installed\ Packages/ $CONFIG_DIR/sublime-text
		cp -r ~/.config/sublime-text/Packages $CONFIG_DIR/sublime-text

	out_copy swaync
		cp ~/.config/swaync/* $CONFIG_DIR/swaync

	out_copy swayosd
		cp ~/.config/swayosd/* $CONFIG_DIR/swayosd

	out_copy waybar
		cp ~/.config/waybar/config $CONFIG_DIR/waybar
		cp ~/.config/waybar/style.css $CONFIG_DIR/waybar

	out_copy wlogout
		cp ~/.config/wlogout/layout $CONFIG_DIR/wlogout
		cp ~/.config/wlogout/style.css $CONFIG_DIR/wlogout
		cp ~/.config/wlogout/icons/* $CONFIG_DIR/wlogout/icons

	out_copy zsh
		cp ~/.zshrc $CONFIG_DIR/zsh
out_complete

out_title 'Syincing Misc'
	out_copy 'Scripts'
		cp ~/.n9-scripts/* $SCRIPTS_DIR
out_complete

cd $ROOT_DIR

out_title 'Pushing GIT'
	out_gitcmd 'Adding Files'
		git add --all >/dev/null

	out_gitcmd 'Committing'
		git commit -m 'Updated' >/dev/null

	out_gitcmd 'Pushing'
		git push origin master 2>/dev/null
out_complete

print -P -n "\n %{$fg_bold[blue]All done!"

for i in $(seq 1 5)
do
	echo -n ' .'
	sleep 1
done