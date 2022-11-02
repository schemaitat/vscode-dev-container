# How To

This repository is used to make a vscode devcontainer look and feel like my local setup. This is derived from https://github.com/deluan/zsh-in-docker.

Simply this into your .devcontainer/Dockerfile.

```Dockerfile
USER 1000

RUN sh -c "$(wget -qO - https://raw.githubusercontent.com/schemaitat/vscode-dev-container/main/install.sh)"
```