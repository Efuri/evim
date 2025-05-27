wget -q https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.tar.gz
tar xzvf nvim-linux-x86_64.tar.gz
ln -s nvim-linux-x86_64/bin/nvim nvim
rm nvim-linux-x86_64.tar.gz
./nvim
