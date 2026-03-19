# Install TinyTeX if not already installed
if [ ! -d "$HOME/.TinyTeX" ]; then
    wget -qO- "https://yihui.org/tinytex/install-bin-unix.sh" | sh
    tlmgr install texcount
else
    tlmgr install texcount
fi

TEX_BIN="$HOME/.TinyTeX/bin/x86_64-linux"

# Update current session
export PATH="$TEX_BIN:$PATH"

# Only attempt to modify ~/.bashrc if running in bash
if [ -n "${BASH_VERSION-}" ]; then
    LINE="export PATH=\"$TEX_BIN:\$PATH\""
    if ! grep -Fxq "$LINE" ~/.bashrc; then
        echo "$LINE" >> ~/.bashrc
    fi
fi

tlmgr option repository https://mirror.ctan.org/systems/texlive/tlnet
tlmgr install babel-swedish babel-english biblatex biber listings
