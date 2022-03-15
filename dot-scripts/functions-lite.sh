
# The reaaaal basics

alias ls='ls --color=auto --group-directories-first'
alias ll='ls -lha'
alias la='ls -a'

alias cd..='cd ..'
alias mkdir='mkdir -pv'

# Using 'del' instead of 'rm'

alias rm="echo \"Use 'del', the real path (i.e. '/usr/bin/rm') or 'realrm'\""
alias rmdir="echo \"Who actually uses rmdir? Use del -r instead please\""
alias realrm="/usr/bin/rm"
alias del="rmtrash"

# Aliases for often used programs

if command -v 'nvim' &> /dev/null; then
    alias vim='nvim'
fi
alias vi='vim'

alias calc="/usr/bin/env python"
alias grep='grep --color=auto'
alias now='date +"%d-%m-%Y   %T"'
alias sudo='sudo '

# Some broader things

. "$KDOT_DIR/dot-scripts/util-networking.sh"
. "$KDOT_DIR/dot-scripts/util-general.sh"
. "$KDOT_DIR/dot-scripts/util-develop.sh"
