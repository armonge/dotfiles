#!/bin/bash
set -euo pipefail
# set -x
if command -v apt &>/dev/null; then
	sudo apt-get update --quiet --quiet
	sudo apt-get install --yes --quiet --quiet make build-essential libssl-dev zlib1g-dev \
		libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
		libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev \
		exa \
		libglib2.0-dev \
		libcairo2-dev \
		libpango1.0-dev \
		libgdk-pixbuf-2.0-dev \
		libgraphene-1.0-dev \
		libgtk-4-dev \
		libadwaita-1-dev \
		duf \
		bat \
		silversearcher-ag \
		fzf \
		exuberant-ctags \
		net-tools \
		aria2 \
		direnv \
		prettyping \
		traceroute \
		ldnsutils \
		miller \
		shellcheck \
		caca-utils libimage-exiftool-perl catdoc mediainfo calibre \
		fontforge \
		gnupg ca-certificates git \
		gcc-multilib g++-multilib cmake pkg-config meson guile-3.0-dev \
		libcanberra-gtk-dev libcanberra-gtk3-dev librsvg2-dev \
		libfreetype6-dev libasound2-dev libexpat1-dev libxcb-composite0-dev \
		libsndio-dev freeglut3-dev libxmu-dev libxi-dev libfontconfig1-dev \
		libxcursor-dev \
		visidata
fi

if command dnf &>/dev/null; then
	sudo dnf install --assumeyes make gcc zlib-devel bzip2 bzip2-devel \
		readline-devel sqlite sqlite-devel openssl-devel tk-devel \
		libffi-devel xz-devel patch libX11-devel libXi-devel \
		bat \
		exa \
		ShellCheck \
		fzf ripgrep fd-find \
		cmake
fi

if [ ! -d "$HOME/.cargo" ]; then
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

rustup update
cargo install git-delta difftastic tree-sitter-cli silicon jless

if [ ! -d "$HOME/.pyenv" ]; then
	curl https://pyenv.run | bash
fi

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

pyenv install --skip-existing 2.7:latest
pyenv install --skip-existing 3.10:latest

pyenv shell 3.10
python -m pip install -qq --upgrade pip wheel
python -m pip install -qq --upgrade devtools[pygments] build black[d]

pyenv shell 2.7
python -m pip install -qq --upgrade pip wheel
python -m pip install -qq --upgrade build

pyenv virtualenv --force 2.7 nvim2
pyenv shell nvim2
python -m pip install -qq --upgrade pip wheel
python -m pip install -qq --upgrade pynvim ranger-fm pillow pygments nord-pygments build isort rope

pyenv install --skip-existing 3.10
pyenv virtualenv --force 3.10 nvim3
pyenv shell nvim3
python -m pip install -qq --upgrade pip wheel
python -m pip install -qq --upgrade pynvim ranger-fm pillow ueberzug pygments nord-pygments devtools[pygments] build jsx-lexer isort darker rope

# Install and activate NVM
if [ ! -d "$HOME/.config/nvm" ]; then
	unset NVM_DIR
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
fi

NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
export NVM_DIR
[ -s "${NVM_DIR}/nvm.sh" ] && \. "${NVM_DIR}/nvm.sh"                   # This loads nvm
[ -s "${NVM_DIR}/bash_completion" ] && \. "${NVM_DIR}/bash_completion" # This loads nvm bash_completion

nvm install lts/gallium lts/erbium lts/fermium lts/gallium
nvm install lts/*
nvm alias default stable
nvm use stable
npm install --global --upgrade npm neovim bash-language-server dockerfile-language-server-nodejs @elm-tooling/elm-language-server elm-format nodemon

bash $HOME/dotfiles/nerd-fonts/install.sh -C JetBrainsMono

if ! [ -x "$(command -v starship)" ]; then
	curl -sS https://starship.rs/install.sh | BIN_DIR=~/.local/bin/ sh
fi

if ! [ -x "$(command -v nvim)" ]; then
	curl --location https://github.com/neovim/neovim/releases/download/stable/nvim.appimage --output "${HOME}/.local/bin/nvim"
	chmod +x "${HOME}/.local/bin/nvim"
fi

if ! [ -x "$(command -v jq)" ]; then
	curl --location https://github.com/jqlang/jq/releases/latest/download/jq-linux64 --output "${HOME}/.local/bin/jq"
	chmod +x "${HOME}/.local/bin/jq"
fi
