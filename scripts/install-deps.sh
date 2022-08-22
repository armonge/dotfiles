#!/bin/bash
set -euo pipefail
set -x
if command -v apt &>/dev/null; then
	sudo apt-get update --quiet --quiet
	sudo apt-get install --yes --quiet --quiet make build-essential libssl-dev zlib1g-dev \
		libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
		libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev \
		neovim \
		exa \
		libdbus-glib-1-dev \
		libglib2.0-dev \
		libcairo2-dev \
		libpango1.0-dev \
		libgdk-pixbuf-2.0-dev \
		libgraphene-1.0-dev \
		libgtk-4-dev \
		libadwaita-1-dev \
		libssl-dev \
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
		jq
fi

if command dnf &>/dev/null; then
	sudo dnf install --assumeyes make gcc zlib-devel bzip2 bzip2-devel \
		readline-devel sqlite sqlite-devel openssl-devel tk-devel \
		libffi-devel xz-devel patch libX11-devel libXi-devel \
		neovim \
		bat \
		exa
fi

if [ ! -d "$HOME/.cargo" ]; then
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

cargo install git-delta

if [ ! -d "$HOME/.pyenv" ]; then
	curl https://pyenv.run | bash
fi

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

pyenv install --skip-existing 2.7.18
pyenv install --skip-existing 3.10.4

pyenv shell 3.10.4
python -m pip install --upgrade pip wheel dbus-python devtools[pygments]

pyenv shell 2.7.18
python -m pip install --upgrade pip wheel

pyenv virtualenv --force 2.7.18 nvim2
pyenv shell nvim2
python -m pip install --upgrade pip wheel pynvim ranger-fm pillow pygments nord-pygments

pyenv install --skip-existing 3.10.4
pyenv virtualenv --force 3.10.4 nvim3
pyenv shell nvim3
python -m pip install --upgrade pip wheel pynvim ranger-fm pillow ueberzug pygments nord-pygments devtools[pygments]

# Install and activate NVM
if [ ! -d "$HOME/.config/nvm" ]; then
	unset NVM_DIR
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
fi

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

nvm install lts/gallium lts/erbium lts/fermium lts/gallium
npm install --global --upgrade npm neovim bash-language-server dockerfile-language-server-nodejs
