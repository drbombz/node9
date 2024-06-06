#!/bin/zsh
clear
autoload -U colors && colors

out_complete () {
	print -P "%{$fg_bold[magenta] ---[ %{$fg[blue]Complete! %{$fg_bold[magenta]]-------------------------"
}

out_line () {
	print -P " %{$fg_bold[magenta]$1...%{$fg_bold[yellow]"
}

out_title () {
	print -P -l "\n%{$fg_bold[blue] [ %{$fg_bold[magenta]$1%{$fg_bold[blue] ]"
	print -P "%{$fg_bold[magenta] ----------------------------"
}

out_task () {
	print -P " %{$fg_bold[magenta]$1...%{$fg_bold[yellow]"
}

print -P "%{$fg_bold[magenta]%                                   ______"
print -P "    _____________________________/::'   \\"
print -P "   /:'   \\\::'    \\\::'    \\\::' _  \\\:' |   \\"
print -P "  /:' |   \\\'  -   \\\'    | \\\'    __\\\_     / %F{blue}n9! -- [%F{magenta} nzbget %F{blue}]%F{magenta}"
print -P " +\\\___|___/_______/_______/_______/_____/------------------------------------------------------------------+%{$reset_color%}"


STATUS="$(systemctl is-active --quiet nzbget)" 
if [[ "${STATUS}" == "active" ]] then
    print -P "\n%{$fg_bold[blue] [ % %{$fg_bold[magenta]% nzbget is %{$fg_bold[green]RUNNING%{$fg_bold[blue] ]"
else
    print -P "\n%{$fg_bold[blue] ++ % %{$fg_bold[magenta]% nzbget is %{$fg_bold[yellow]NOT RUNNING%{$fg_bold[blue] ++"
fi


out_title 'Start/Stop nzbget daemon'
    print -P " 1. Start"
    print -P " 2. Stop"
    print -P "%{$fg_bold[magenta] ----------------------------"
    read  "option? Selection : "

    if [[ "$option" == "1" ]] then
        out_title 'Starting nzbget'
        out_task 'Daemon starting up'
        ~/Documents/builds/nzbget-git/nzbget -D
        out_complete
    elif [[ "$option" == "2" ]] then
        out_title 'Stopping nzbget'
        out_task 'Daemon shutting down'
        ~/Documents/builds/nzbget-git/nzbget -Q
        out_complete
    else
        print -P '\n Invaild option!'
    fi