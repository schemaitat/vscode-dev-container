# How To

This repository is used to make a vscode devcontainer look and feel like my local setup. This is derived from https://github.com/deluan/zsh-in-docker.

The zsh-in-docker.zsh accepts the following parameters, see also the example below.

```
    -i) to add packages
    -d) to add raw dotfiles (which will be put in $HOME)
    -p) to add oh-my-zsh packages
    -a) to append lines to .zshrc
    -t) to set a zsh theme
    -s) to run raw post scripts 
```

Simply put this into your .devcontainer/Dockerfile. 

```Dockerfile
USER 1000

RUN sh -c "$(wget -qO - https://raw.githubusercontent.com/schemaitat/vscode-dev-container/main/zsh-in-docker.sh)" -- \
    -d https://raw.githubusercontent.com/schemaitat/dotfiles/master/.vimrc \
    -d https://raw.githubusercontent.com/schemaitat/dotfiles/master/.tmux.conf \
    -i vim -i tmux \
    -p git -p git-auto-fetch \
    -p https://github.com/zsh-users/zsh-autosuggestions \
    -p https://github.com/zsh-users/zsh-completions \
    -p https://github.com/zsh-users/zsh-syntax-highlighting \
    -a 'CASE_SENSITIVE="false"' \
    -a 'HYPHEN_INSENSITIVE="true"' \
    -a 'export TERM=xterm-256color' \
    -s https://raw.githubusercontent.com/schemaitat/vscode-dev-container/main/zshrc-personal.sh
```