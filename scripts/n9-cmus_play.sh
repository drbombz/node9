if [ -d $(pgrep cmus) ]; then
	kitty --session n9-music.session &
	sleep 1
fi
cmus-remote -C "cd ${1%/*}/"
cmus-remote -C "player-play ${1}"