#!/bin/bash
set -euo pipefail
set -x
unameOut="$(uname -a)"
if grep -q "Darwin" <<<"$unameOut"; then
	# Pillow
	export LDFLAGS="-L/opt/homebrew/opt/zlib/lib"
	export CPPFLAGS="-I/opt/homebrew/opt/zlib/include"

	brew install --quiet libjpeg libtiff little-cms2 openjpeg webp \
		pkg-config fontconfig cairo libmagic

	brew install --quiet make wget direnv cmake fzf xz jq \
		miller git git-lfs bat nvim gpg awscli \
		aws-iam-authenticator the_silver_searcher fd \
		django-completion podman httpie chafa pgformatter jd \
		composer
	brew install --cask wezterm
	brew install jstkdng/programs/ueberzugpp
	brew install git-absorb duckdb
	brew install neilotoole/sq/sq
	brew install difftastic
	brew install tectonic
	brew install imagemagick ghostscript pngpaste
elif command -v apt &>/dev/null; then
	sudo apt-get update --quiet --quiet
	sudo apt-get install --yes --quiet --quiet make build-essential \
		libssl-dev zlib1g-dev libbz2-dev libreadline-dev \
		libsqlite3-dev \
		wget curl llvm libncursesw5-dev xz-utils tk-dev libxml2-dev \
		libxmlsec1-dev libffi-dev liblzma-dev \
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
		caca-utils libimage-exiftool-perl catdoc mediainfo calibre \
		fontforge \
		gnupg ca-certificates git \
		gcc-multilib g++-multilib cmake pkg-config meson guile-3.0-dev \
		libcanberra-gtk-dev libcanberra-gtk3-dev librsvg2-dev \
		libfreetype6-dev libasound2-dev libexpat1-dev \
		libxcb-composite0-dev libsndio-dev freeglut3-dev libxmu-dev \
		libxi-dev libfontconfig1-dev \
		libxcursor-dev \
		visidata \
		javac golang luarocks julia ruby composer \
		watchman
elif grep -q "fedora" <<<"$unameOut"; then

	sudo dnf --assumeyes copr enable wezfurlong/wezterm-nightly
	sudo dnf install --assumeyes make gcc zlib-devel bzip2 bzip2-devel \
		readline-devel sqlite sqlite-devel openssl-devel tk-devel \
		libffi-devel xz-devel patch libX11-devel libXi-devel \
		bat lua \
		fzf ripgrep fd-find \
		cmake g++ \
		tldr \
		the_silver_searcher \
		wl-clipboard \
		git git-lfs \
		chafa \
		difftastic \
		lynx cowsay fortune-mod libxcb-devel \
		wezterm \
		direnv \
		golang-bin \
		luarocks \
		texlive-latex \
		lua5.1
fi

if [ ! -d "$HOME/.cargo" ]; then
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

rustup update
cargo install git-delta tree-sitter-cli jless eza viu

sudo luarocks install --lua-version 5.1 tiktoken_core

# Python
curl -LsSf https://astral.sh/uv/install.sh | sh
uv python install
(
	mkdir -p ~/.config/nvim
	cd ~/.config/nvim
	uv venv --seed --python 3.12
	source .venv/bin/activate
	python -m pip install neovim
)

(
	cd ~/dotfiles
	uv venv --seed --python 3.12
	source .venv/bin/activate
	python -m pip install dotdrop
)

# Install and activate NVM
if [ ! -d "$HOME/.config/nvm" ]; then
	unset NVM_DIR
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
fi

NVM_DIR="$([ "${XDG_CONFIG_HOME-}" = "" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
export NVM_DIR
[ -s "${NVM_DIR}/nvm.sh" ] && \. "${NVM_DIR}/nvm.sh"                   # This loads nvm
[ -s "${NVM_DIR}/bash_completion" ] && \. "${NVM_DIR}/bash_completion" # This loads nvm bash_completion

nvm install lts/gallium lts/erbium lts/fermium lts/gallium
nvm install lts/*
nvm alias default stable
nvm use stable
npm install --global --upgrade npm neovim @mermaid-js/mermaid-cli

if [ ! -f "${HOME}/.local/share/fonts/ttf/JetBrainsMonoNLNerdFont-Regular.ttf" ]; then
	wget -O /tmp/JetBrainsMono.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
	cd /tmp
	unzip JetBrainsMono.zip
	mkdir -p "${HOME}/.local/share/fonts/ttf/"
	mv JetBrainsMono*.ttf "${HOME}/.local/share/fonts/ttf/"
fi

if ! [ -x "$(command -v starship)" ]; then
	mkdir -p ~/.local/bin
	curl -sS https://starship.rs/install.sh | BIN_DIR=~/.local/bin/ sh
fi
