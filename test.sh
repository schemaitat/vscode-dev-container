source ./assert.sh
set -e

trap 'docker-compose stop -t 1' EXIT INT

test_suite() {
    image_name=$1
    echo
    echo "########## Testing in a $image_name container"
    echo

    set -x
    docker-compose rm --force --stop test-$image_name || true

    docker-compose up -d test-$image_name
    # container="$(basename $(pwd))-test-${image_name}-1"
    container="test_$image_name"
    docker cp zsh-in-docker.sh ${container}:/tmp
    docker exec ${container} sh /tmp/zsh-in-docker.sh \
        -d https://raw.githubusercontent.com/schemaitat/dotfiles/master/.vimrc \
        -d https://raw.githubusercontent.com/gpakosz/.tmux/master/.tmux.conf \
        -i vim -i tmux \
        -p git -p git-auto-fetch \
        -p https://github.com/zsh-users/zsh-autosuggestions \
        -p https://github.com/zsh-users/zsh-completions \
        -p https://github.com/zsh-users/zsh-syntax-highlighting \
        -a 'CASE_SENSITIVE="true"' \
        -a 'HYPHEN_INSENSITIVE="true"' \
        -a 'export TERM=xterm-256color' \
        -s https://raw.githubusercontent.com/schemaitat/vscode-dev-container/main/zshrc-personal.sh
    set +x

    echo
    VERSION=$(docker exec ${container} zsh --version)
    ZSHRC=$(docker exec ${container} cat /root/.zshrc)
    VIMRC=$(docker exec ${container} cat /root/.vimrc)
    echo "########################################################################################"
    echo "$ZSHRC"
    echo "########################################################################################"
    echo "Test: zsh 5 was installed" && assert_contain "$VERSION" "zsh 5" "!"
    echo "Test: ~/.zshrc was generated" && assert_contain "$ZSHRC" 'ZSH="/root/.oh-my-zsh"' "!"
    echo "Test: theme was configured" && assert_contain "$ZSHRC" 'ZSH_THEME="powerlevel10k/powerlevel10k"' "!"
    echo "Test: plugins were configured" && assert_contain "$ZSHRC" 'plugins=(git git-auto-fetch zsh-autosuggestions zsh-completions zsh-syntax-highlighting )' "!"
    echo "Test: line 1 is appended to ~/.zshrc" && assert_contain "$ZSHRC" 'CASE_SENSITIVE="true"' "!"
    echo "Test: line 2 is appended to ~/.zshrc" && assert_contain "$ZSHRC" 'HYPHEN_INSENSITIVE="true"' "!"
    echo "Test: newline is expanded when append lines" && assert_not_contain "$ZSHRC" '\nCASE_SENSITIVE="true"' "!"
    echo "Test: zshrc-personal.sh was appended" && assert_contain "$ZSHRC" "function his" "!"
    echo "Test: vimrc was installed" && assert_contain "$VIMRC" "set number" "!"
    echo "Test: vim was installed" && assert_contain "$(docker exec $container which vim)" "vim" "!"

    echo
    echo "######### Success! All tests are passing for ${image_name}"

    docker-compose stop -t 1 test-$image_name
}

# images=${*:-"alpine ubuntu ubuntu-14.04 debian amazonlinux"}
images=${*:-"ubuntu-14.04"}

for image in $images; do
    test_suite $image
done
