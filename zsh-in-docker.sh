#!/bin/sh

# this is an extension of
# https://github.com/deluan/zsh-in-docker/blob/master/zsh-in-docker.sh

set -e

THEME=default
PLUGINS=""
ZSHRC_APPEND=""
PACKAGES=""
DOTFILES=""
SCRIPTS=""

while getopts ":t:p:a:d:i:d:s:" opt; do
    case ${opt} in
        t)  THEME=$OPTARG
            ;;
        p)  PLUGINS="${PLUGINS}$OPTARG "
            ;;
        a)  ZSHRC_APPEND="$ZSHRC_APPEND\n$OPTARG"
            ;;
        i)  PACKAGES="${PACKAGES}$OPTARG "
            ;;
        d)  DOTFILES="${DOTFILES}$OPTARG "
            ;;
        s)  SCRIPTS="${SCRIPTS}$OPTARG "
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


cat << EOF 
Installing with:
    PACKAGES = $PACKAGES
    THEME   = $THEME
    PLUGINS = $PLUGINS
    DOTFILES = $DOTFILES
    SCRIPTS = $SCRIPTS
EOF

check_dist() {
    (
        . /etc/os-release
        echo $ID
    )
}

check_version() {
    (
        . /etc/os-release
        echo $VERSION_ID
    )
}

install_dependencies() {
    DIST=`check_dist`
    VERSION=`check_version`
    echo "###### Installing dependencies for $DIST"

    if [ "`id -u`" = "0" ]; then
        Sudo=''
    elif which sudo; then
        Sudo='sudo'
    else
        echo "WARNING: 'sudo' command not found. Skipping the installation of dependencies. "
        echo "If this fails, you need to do one of these options:"
        echo "   1) Install 'sudo' before calling this script"
        echo "OR"
        echo "   2) Install the required dependencies: git curl zsh"
        return
    fi

    PACKAGES="${PACKAGES} git curl zsh"

    case $DIST in
        alpine)
            $Sudo apk add --update --no-cache $PACKAGES
        ;;
        amzn)
            $Sudo yum update -y
            $Sudo yum install -y $PACKAGES
            $Sudo yum install -y ncurses-compat-libs # this is required for AMZN Linux (ref: https://github.com/emqx/emqx/issues/2503)
        ;;
        *)
            $Sudo apt-get update
            $Sudo apt-get -y install $PACKAGES locales
            if [ "$VERSION" != "14.04" ]; then
                $Sudo apt-get -y install locales-all
            fi
            $Sudo locale-gen en_US.UTF-8
    esac
}

zshrc_template() {
    _HOME=$1;
    _THEME=$2; shift; shift
    _PLUGINS=$*;

    if [ "$_THEME" = "default" ]; then
        _THEME="powerlevel10k/powerlevel10k"
    fi

    cat <<EOM
export LANG='en_US.UTF-8'
export LANGUAGE='en_US:en'
export LC_ALL='en_US.UTF-8'

##### Zsh/Oh-my-Zsh Configuration
export ZSH="$_HOME/.oh-my-zsh"

ZSH_THEME="${_THEME}"
plugins=($_PLUGINS)

EOM
    printf "$ZSHRC_APPEND"
    printf "\nsource \$ZSH/oh-my-zsh.sh\n"
}

powerline10k_config() {
    cat <<EOM
POWERLEVEL9K_SHORTEN_STRATEGY="truncate_to_last"
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(user dir vcs status)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()
POWERLEVEL9K_STATUS_OK=false
POWERLEVEL9K_STATUS_CROSS=true
EOM
}

install_dependencies

cd /tmp

# Install On-My-Zsh
if [ ! -d $HOME/.oh-my-zsh ]; then
    sh -c "$(curl https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended
fi

# Generate plugin list
plugin_list=""
for plugin in $PLUGINS; do
    if [ "`echo $plugin | grep -E '^http.*'`" != "" ]; then
        plugin_name=`basename $plugin`
        git clone $plugin $HOME/.oh-my-zsh/custom/plugins/$plugin_name
    else
        plugin_name=$plugin
    fi
    plugin_list="${plugin_list}$plugin_name "
done

# Handle themes
if [ "`echo $THEME | grep -E '^http.*'`" != "" ]; then
    theme_repo=`basename $THEME`
    THEME_DIR="$HOME/.oh-my-zsh/custom/themes/$theme_repo"
    git clone $THEME $THEME_DIR
    theme_name=`cd $THEME_DIR; ls *.zsh-theme | head -1`
    theme_name="${theme_name%.zsh-theme}"
    THEME="$theme_repo/$theme_name"
fi

# Generate .zshrc
zshrc_template "$HOME" "$THEME" "$plugin_list" > $HOME/.zshrc

# Install powerlevel10k if no other theme was specified
if [ "$THEME" = "default" ]; then
    git clone https://github.com/romkatv/powerlevel10k $HOME/.oh-my-zsh/custom/themes/powerlevel10k
    powerline10k_config >> $HOME/.zshrc
fi

# add dotfiles
for file in $DOTFILES; do
    cd && curl -sO $file
done

# run additional post scripts
for script in ${SCRIPTS}; do
    if [ "`echo $script | grep -E '^http.*'`" != "" ]; then
        echo "Installing $script"
        sh -c "$(wget -qO - $script)"
    else
        echo "Post scripts must be the url of the raw script."
    fi
done

# install tmux plugin manager if tmux is a packages
# see https://github.com/tmux-plugins/tpm/blob/master/docs/managing_plugins_via_cmd_line.md
if [ -z "${PACKAGES##*tmux*}" ]; then
    # set default shell for tmux
    echo "set-option -g default-shell /bin/zsh" >> ~/.tmux.conf

    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    # install plugins specified in ~/.tmux.conf
    ~/.tmux/plugins/tpm/bin/install_plugins
fi