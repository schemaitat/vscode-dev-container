# How To

This repository is used to make a vscode devcontainer look and feel like my local setup. This is derived from https://github.com/deluan/zsh-in-docker.

Simply this into your .devcontainer/Dockerfile. Use -i to add debian packages and -d to add raw dotfiles (which will be put in $HOME). Use -p to add oh-my-zsh packages, -a to append stuff to .zshrc and -t to set a zsh theme.

```Dockerfile
USER 1000

RUN sh -c "$(wget -qO - https://raw.githubusercontent.com/schemaitat/vscode-dev-container/main/install.sh)" -- \
    -d https://raw.githubusercontent.com/schemaitat/dotfiles/master/.vimrc \
    -d https://raw.githubusercontent.com/schemaitat/dotfiles/master/.tmux.conf \
    -i vim -i tmux \
    -p git -p git-auto-fetch \
    -p https://github.com/zsh-users/zsh-autosuggestions \
    -p https://github.com/zsh-users/zsh-completions \
    -p https://github.com/zsh-users/zsh-syntax-highlighting \
    -a 'CASE_SENSITIVE="true"' \
    -a 'HYPHEN_INSENSITIVE="true"' \
    -a 'export TERM=xterm-256color'
```