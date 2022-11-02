# How To

This repository is used to make a vscode devcontainer look and feel like my local setup. This is derived from https://github.com/deluan/zsh-in-docker.

Simply this into your .devcontainer/Dockerfile. Use -p to add debian packages and -d to add raw dotfiles (which will be put in $HOME).

```Dockerfile
USER 1000

RUN sh -c "$(wget -qO - https://raw.githubusercontent.com/schemaitat/vscode-dev-container/main/install.sh)" -- \
    -d https://raw.githubusercontent.com/schemaitat/dotfiles/main/.vimrc \
    -d https://raw.githubusercontent.com/schemaitat/dotfiles/main/.tmux.conf \
    -p vim -p tmux
```