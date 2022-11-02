# This is only used for developing the zsh-in-docker script, but can be used as an example.

FROM debian:latest

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && apt-get update \
    && apt-get install -y sudo wget curl \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    #
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

USER $USERNAME

# RUN sh -c "$(wget -qO - https://raw.githubusercontent.com/schemaitat/vscode-dev-container/main/zsh-in-docker.sh)" -- \
#     -d https://raw.githubusercontent.com/schemaitat/dotfiles/master/.vimrc \
#     -d https://raw.githubusercontent.com/schemaitat/dotfiles/master/.tmux.conf \
#     -i vim -i tmux \
#     -p git -p git-auto-fetch \
#     -p https://github.com/zsh-users/zsh-autosuggestions \
#     -p https://github.com/zsh-users/zsh-completions \
#     -p https://github.com/zsh-users/zsh-syntax-highlighting \
#     -a 'CASE_SENSITIVE="true"' \
#     -a 'HYPHEN_INSENSITIVE="true"' \
#     -a 'export TERM=xterm-256color' \
#     -s https://raw.githubusercontent.com/schemaitat/vscode-dev-container/main/zshrc-personal.sh
  

COPY zsh-in-docker.sh /tmp/zsh-in-docker.sh
RUN sudo chmod +x /tmp/zsh-in-docker.sh && /tmp/zsh-in-docker.sh \
    -d https://raw.githubusercontent.com/schemaitat/dotfiles/master/.vimrc \
    -d https://raw.githubusercontent.com/schemaitat/dotfiles/master/.tmux.conf \
    -i vim -i tmux \
    -p git -p git-auto-fetch \
    -p https://github.com/zsh-users/zsh-autosuggestions \
    -p https://github.com/zsh-users/zsh-completions \
    -p https://github.com/zsh-users/zsh-syntax-highlighting \
    -a 'CASE_SENSITIVE="true"' \
    -a 'HYPHEN_INSENSITIVE="true"' \
    -a 'export TERM=xterm-256color' \
    -s https://raw.githubusercontent.com/schemaitat/vscode-dev-container/main/zshrc-personal.sh

ENTRYPOINT [ "/bin/zsh" ]