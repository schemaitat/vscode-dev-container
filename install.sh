#!/bin/sh

sudo apt-get update && export DEBIAN_FRONTEND=noninteractive
sudo apt-get -y install --no-install-recommends vim

cp .vimrc $HOME/.vimrc

./zsh-in-docker.sh \
    -p git -p git-auto-fetch \
    -p https://github.com/zsh-users/zsh-autosuggestions \
    -p https://github.com/zsh-users/zsh-completions \
    -p https://github.com/zsh-users/zsh-syntax-highlighting \
    -p colorize \
    -a 'CASE_SENSITIVE="true"' \ 
    -a 'HYPHEN_INSENSITIVE="true"' \
    -a "export TERM=xterm-256color"

./zshrc-personal.sh