sudo apt install tmux ripgrep fd-find nodejs npm unzip build-essential xclip
echo "set -g base-index 1" >> ~/.tmux.conf
echo "set -g pane-base-index 1" >> ~/.tmux.conf
echo "set -s escape-time 0" >> ~/.tmux.conf
echo "export NVIM_LOG_LEVEL=info" >> ~/.bashrc
# Function to ensure a line exists in a file
ensure_line() {
    local line="$1"
    local file="$2"
    
    touch "$file"
    grep -qF -- "$line" "$file" || echo "$line" >> "$file"
}

ensure_line "set -g base-index 1" ~/.tmux.conf
ensure_line "set -g pane-base-index 1" ~/.tmux.conf
ensure_line "set -s escape-time 0" ~/.tmux.conf
ensure_line "export NVIM_LOG_LEVEL=info" ~/.bashrc
