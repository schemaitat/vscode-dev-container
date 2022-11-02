#!/bin/sh
set -ex 

SCRIPT_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

PACKAGES=""
DOTFILES=""

while getopts ":i:d:" opt; do
    case ${opt} in
        i)  PACKAGES="${PACKAGES}$OPTARG "
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

echo "restliche argumente:"
echo $@

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

sh -c "$(wget -qO - ${GITHUB}/vscode-dev-container/main/zsh-in-docker.sh)" -- $@

sh -c "$(wget -qO - ${GITHUB}/vscode-dev-container/main/zshrc-personal.sh)"