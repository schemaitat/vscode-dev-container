#!/bin/sh

add_template() {
    cat <<'EOF'
alias ls="ls -alhG"

function his (){
    [ -z $1 ] && echo "Usage: his search-string." && return 1
    history | grep -i $1 | awk '{$1=""}1'
}

function lls (){
    [ -z $1 ] && echo "Usage: his search-string." && return 1
    ls -alGhr |grep -i $1
}
EOF
}

if [ -f $HOME/.zshrc ]; then 
    add_template >> $HOME/.zshrc
else
    echo "No ~/.zshrc file found." 
fi