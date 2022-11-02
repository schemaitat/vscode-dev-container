#!/bin/sh
set -ex 

SCRIPT_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

sudo apt-get update && export DEBIAN_FRONTEND=noninteractive
sudo apt-get -y install --no-install-recommends vim tmux

GITHUB=https://raw.githubusercontent.com/schemaitat

curl -s ${GITHUB}/dotfiles/master/.vimrc > $HOME/.vimrc
curl -s ${GITHUB}/dotfiles/master/.tmux.conf > $HOME/.tmux.conf

sh -c "$(wget -qO - ${GITHUB}/vscode-dev-container/main/zsh-in-docker.sh)" -- \
    -p git -p git-auto-fetch \
    -p https://github.com/zsh-users/zsh-autosuggestions \
    -p https://github.com/zsh-users/zsh-completions \
    -p https://github.com/zsh-users/zsh-syntax-highlighting \
    -a 'CASE_SENSITIVE="true"' \
    -a 'HYPHEN_INSENSITIVE="true"' \
    -a 'export TERM=xterm-256color'

sh -c "$(wget -qO - ${GITHUB}/vscode-dev-container/main/zshrc-personal.sh)"