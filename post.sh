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


prepend(){
    file=$1
    what=$2
    tmp=/tmp/.prep
    echo $what > $tmp
    cat $file >> $tmp
    cat $tmp > $file
}

# install tmux plugin manager if tmux is installed
# see https://github.com/tmux-plugins/tpm/blob/master/docs/managing_plugins_via_cmd_line.md
if [ -x "$(command -v tmux)" ]; then
    # set default shell for tmux
    prepend "$HOME/.tmux.conf" "set-option -g default-shell /bin/zsh"

    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    # install plugins specified in ~/.tmux.conf
    ~/.tmux/plugins/tpm/bin/install_plugins
fi

install_bin(){
    path=$1
    if [ -z $2 ]; then
        install_as=$2
    else
        install_as="$(basename $1)"
    fi
    sudo install -o root -g root -m 0755 $path /usr/local/bin/$install_as
}

# install binaries
bin_k9s="https://github.com/derailed/k9s/releases/download/v0.26.7/k9s_Linux_x86_64.tar.gz"
bin_kubectl="https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

mkdir -p /tmp/bin && cd /tmp/bin

curl -LO $bin_k9s && \
    tar -xzf "$(basename $bin_k9s)" && \
    install_bin "/tmp/bin/k9s"

curl -LO $bin_kubectl && \
    install_bin "/tmp/bin/kubectl"

rm -rf /tmp/bin