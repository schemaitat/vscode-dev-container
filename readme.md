# How To

This repository is used to make the vscode devcontainer look and feel like my local environment.

Simply this into your .devcontainer/Dockerfile.

```Dockerfile
RUN cd /tmp && \
    git clone https://github.com/schemaitat/vscode-dev-container.git && \
    chmod -R +x /tmp/vscode-dev-container

USER 1000

RUN /tmp/vscode-dev-container/install.sh
```