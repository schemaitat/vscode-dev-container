#!/bin/sh
set -ex 

SCRIPT_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"


PACKAGES=""
DOTFILES=""

while getopts ":p:d:" opt; do
    case ${opt} in
        p)  PACKAGES="${PACKAGES}$OPTARG "
            ;;
        d)  DOTFILES="${DOTFILES}$OPTARG "
        ;;
        \?)
            echo "Invalid option: $OPTARG" 1>&2
            ;;
        :)
            echo "Invalid option: $OPTARG requires an argument" 1>&2
            ;;
    esac
done
shift $((OPTIND -1))

echo
echo "Installing packages and dotfiles:"
echo "    PACKAGES: ${PACKAGES}"
echo "    DOTFILES: ${DOTFILES}"
echo

sudo apt-get update && export DEBIAN_FRONTEND=noninteractive
sudo apt-get -y install --no-install-recommends ${PACKAGES}


for file in $DOTFILES; do
    cd && curl -sO $file
done

GITHUB=https://raw.githubusercontent.com/schemaitat

sh -c "$(wget -qO - ${GITHUB}/vscode-dev-container/main/zsh-in-docker.sh)" -- \
    -p git -p git-auto-fetch \
    -p https://github.com/zsh-users/zsh-autosuggestions \
    -p https://github.com/zsh-users/zsh-completions \
    -p https://github.com/zsh-users/zsh-syntax-highlighting \
    -a 'CASE_SENSITIVE="true"' \
    -a 'HYPHEN_INSENSITIVE="true"' \
    -a 'export TERM=xterm-256color'

sh -c "$(wget -qO - ${GITHUB}/vscode-dev-container/main/zshrc-personal.sh)"