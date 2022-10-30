#!/bin/sh

SCRIPT_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

sudo apt-get update && export DEBIAN_FRONTEND=noninteractive
sudo apt-get -y install --no-install-recommends vim

cp $SCRIPT_PATH/.vimrc $HOME/.vimrc

$SCRIPT_PATH/zsh-in-docker.sh \
    -p git -p git-auto-fetch \
    -p https://github.com/zsh-users/zsh-autosuggestions \
    -p https://github.com/zsh-users/zsh-completions \
    -p https://github.com/zsh-users/zsh-syntax-highlighting \
    -p colorize \
    -a 'CASE_SENSITIVE="true"' \ 
    -a 'HYPHEN_INSENSITIVE="true"' \
    -a "export TERM=xterm-256color"

$SCRIPT_PATH/zshrc-personal.sh