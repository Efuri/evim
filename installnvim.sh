sudo apt update
sudo apt install ninja-build gettext cmake unzip curl build-essential git
git clone https://github.com/neovim/neovim.git
cd neovim
git checkout master
sudo make install
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
