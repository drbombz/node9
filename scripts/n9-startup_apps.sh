#!/bin/bash
NETTEST="$(ping www.google.com -c 1 -q | grep '1 received')"
sleep 1
if [ "$NETTEST" ]; then
	firefox http://nodenine.mooo.com:5689 &
else
	code &
fi
sleep 3
kitty &
nemo &