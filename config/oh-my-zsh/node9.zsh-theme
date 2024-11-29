#                                  ______
#    _____________________________/::'   \
#   /:'   \::'    \::'    \::' _  \:' |   \
#  /:' |   \'  -   \'    | \'    __\_     / n9! -- [ oh-my-zsh ]
# +\___|___/_______/_______/_______/_____/------------------------------------------------------------------+

PROMPT=$'
%{$fg_bold[blue]%}[ %{$fg[magenta]%}%n@%m%{$fg[blue]%} ]%{$reset_color%}%{$fg[magenta]%}-///-%{$fg_bold[blue]%}%D{[ %X ]}%{$reset_color%}%{$fg[white]%}[ %~ ]%{$reset_color%} $(git_prompt_info)\
%{$fg_bold[blue]%}󰘍%{$fg_bold[blue]%} %#%{$reset_color%} '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[green]%}["
ZSH_THEME_GIT_PROMPT_SUFFIX="]%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}*%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""
