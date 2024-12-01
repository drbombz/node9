#                                  ______
#    _____________________________/::'   \
#   /:'   \::'    \::'    \::' _  \:' |   \
#  /:' |   \'  -   \'    | \'    __\_     / n9! -- [ zshrc ]
# +\___|___/_______/_______/_______/_____/------------------------------------------------------------------+

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="node9"
#ZSH_THEME="duellj"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)
autoload -U colors && colors
source $ZSH/oh-my-zsh.sh
export LANG=en_US.UTF-8
alias nnn='~/.local/bin/nnn -de' # -d for details and -e to open files in $VISUAL (for other options, see 'man nnn'...)
alias z='sudo zypper'
alias l='lsd -l --date "+%b %d %H:%M" --size short -a --group-directories-first'
alias ls='lsd'
#-----
export NNN_OPTS="H"
export NNN_FIFO="/tmp/nnn.fifo" # temporary buffer for the previews
export NNN_PLUG='p:preview-tui,c:cmusq' # many other plugins are available here: https://github.com/jarun/nnn/tree/master/plugins
export SPLIT='v'
#-----
n () # to cd on quit
{
    if [ -n $NNNLVL ] && [ "${NNNLVL:-0}" -ge 1 ]; then
        echo "nnn is already running"
        return
    fi
    export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
    nnn "$@"
    if [ -f "$NNN_TMPFILE" ]; then
            . "$NNN_TMPFILE"
            rm -f "$NNN_TMPFILE" > /dev/null
    fi
}

#print -P "%{$fg_bold[magenta]%                                   ______"
#print -P "    _____________________________/::'   \\"
#print -P "   /:'   \\\::'    \\\::'    \\\::' _  \\\:' |   \\"
#print -P "  /:' |   \\\'  -   \\\'    | \\\'    __\\\_     / %F{blue}n9!%F{magenta}"
#print -P " +\\\___|___/_______/_______/_______/_____/------------------------------------------------------------------+"

SPACE_TOTAL=$(df -h --output=size "$HOME" | tail -n1 | xargs)
SPACE_AVAIL=$(df -h --output=avail "$HOME" | tail -n1 | xargs)
SESSION_DESKTOP=$(echo $DESKTOP_SESSION)
SESSION_TYPE=$(echo $XDG_SESSION_TYPE)
BLUE='\033[0;36m'$(tput bold)
PURPLE='\033[0;35m'$(tput bold)

print -P "${BLUE}          ______"
print -P "    _____/::'   \\"
print -P "   /:'   \\\:' |   \\\ %F{magenta}n9! "
print -P "${BLUE} +/:' |   \\\_     /--------------------------------------------------------------------------------------+"
print -n -P "  \\\___|___/_____/ "
print -n -P "%F{magenta}-- %F{blue}[ %F{magenta}Storage_${BLUE}${SPACE_AVAIL}%F{magenta}/${BLUE}${SPACE_TOTAL}%F{blue} ]"
print -P "%F{blue}[ %F{magenta}Session_${BLUE}${SESSION_TYPE}%F{magenta}/${BLUE}${SESSION_DESKTOP}%F{blue} ]"

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# bun completions
[ -s "/home/upgrad3/.bun/_bun" ] && source "/home/upgrad3/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
