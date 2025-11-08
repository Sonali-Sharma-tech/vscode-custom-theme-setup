#!/bin/bash

# Terminal Theme Setup Script
# This script sets up a beautiful color-coded terminal with Starship prompt

echo "🎨 Terminal Theme Setup Script"
echo "=============================="
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Step 1: Install Homebrew if not installed
echo -e "${BLUE}Step 1: Checking Homebrew...${NC}"
if ! command_exists brew; then
    echo -e "${YELLOW}Installing Homebrew...${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo -e "${GREEN}✓ Homebrew already installed${NC}"
fi

# Step 2: Install required packages
echo -e "\n${BLUE}Step 2: Installing required packages...${NC}"
packages=(
    "starship"
    "zsh-autosuggestions"
    "zsh-syntax-highlighting"
    "fzf"
)

for package in "${packages[@]}"; do
    if brew list "$package" &>/dev/null; then
        echo -e "${GREEN}✓ $package already installed${NC}"
    else
        echo -e "${YELLOW}Installing $package...${NC}"
        brew install "$package"
    fi
done

# Step 3: Backup existing configurations
echo -e "\n${BLUE}Step 3: Backing up existing configurations...${NC}"
timestamp=$(date +%Y%m%d_%H%M%S)
if [ -f ~/.zshrc ]; then
    cp ~/.zshrc ~/.zshrc.backup_$timestamp
    echo -e "${GREEN}✓ Backed up .zshrc${NC}"
fi
if [ -f ~/.config/starship.toml ]; then
    cp ~/.config/starship.toml ~/.config/starship.toml.backup_$timestamp
    echo -e "${GREEN}✓ Backed up starship.toml${NC}"
fi

# Step 4: Create Starship configuration
echo -e "\n${BLUE}Step 4: Creating Starship configuration...${NC}"
mkdir -p ~/.config

cat > ~/.config/starship.toml << 'EOF'
# Custom Color-Coded Starship Theme

format = """
$username\
$hostname\
$directory\
$git_branch\
$git_status\
$nodejs\
$python\
$ruby\
$golang\
$php\
$rust\
$java\
$kotlin\
$swift\
$docker_context\
$package\
$cmd_duration\
$line_break\
$character"""

[username]
style_user = "bold cyan"
style_root = "bold red"
format = '[$user]($style)'
disabled = false
show_always = true

[hostname]
ssh_only = false
format = '[@](white)[$hostname](bold cyan) '
disabled = false

[directory]
style = "bold blue"  # Blue for project/directory name
format = "[$path]($style) "
truncation_length = 3
truncation_symbol = "…/"
home_symbol = "~"
read_only = " 🔒"
read_only_style = "bold red"

[git_branch]
symbol = " "
style = "bold fg:205"  # Pink for branch name
format = 'on [$symbol$branch](bold fg:205) '

[git_status]
format = '([$all_status$ahead_behind]($style))'
conflicted = "[⚔️ ](bold red)"  # Red for conflicts
ahead = "[⇡${count}](bold green)"
behind = "[⇣${count}](bold yellow)"
diverged = "[⇕](bold orange)[⇡${ahead_count}](green)[⇣${behind_count}](yellow)"
untracked = "[?](bold purple)"  # Purple for untracked files
stashed = "[📦](bold yellow)"
modified = "[!](bold yellow)"  # Yellow for modified files
staged = '[+](bold green)'  # Green for staged files
renamed = "[➜](bold cyan)"
deleted = "[✗](bold red)"  # Red for deleted files

[nodejs]
symbol = " "
style = "bold green"
format = 'via [$symbol($version)]($style) '

[python]
symbol = "🐍 "
style = "bold yellow"
format = 'via [$symbol($version)(\($virtualenv\))]($style) '

[character]
success_symbol = '[❯](bold green)'  # Green for successful command
error_symbol = '[✖](bold red)'  # Red for failed command
vimcmd_symbol = '[❮](bold green)'

[line_break]
disabled = false
EOF

echo -e "${GREEN}✓ Created starship.toml${NC}"

# Step 5: Create .zshrc configuration
echo -e "\n${BLUE}Step 5: Creating .zshrc configuration...${NC}"

cat > ~/.zshrc << 'EOF'
# Path configurations (customize as needed)
export PATH="$HOME/.local/bin:$PATH"

# NVM (Node Version Manager) - if you use it
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Homebrew zsh plugins
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null || \
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null || \
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null

# Configure syntax highlighting colors BEFORE loading the plugin
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[command]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[function]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[default]='fg=green'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=green'
ZSH_HIGHLIGHT_STYLES[arg0]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[global-alias]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=green'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=green'

# zsh-syntax-highlighting (must be loaded last)
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null || \
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null || \
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null

# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Initialize Starship prompt
eval "$(starship init zsh)"

# Force color support for git
export TERM=xterm-256color

# Git color configuration
export GIT_PAGER='less -R'
export LESS='-R'

# Custom git wrapper to colorize specific lines
git() {
    if [[ "$1" == "status" ]]; then
        command git status "$@" | sed -E \
            -e "s/'origin\/([^']+)'/$(printf '\033[1;33m')'origin\/\1'$(printf '\033[0m')/g" \
            -e "s/no changes added to commit.*/$(printf '\033[35m')&$(printf '\033[0m')/" \
            -e "s/nothing to commit.*/$(printf '\033[35m')&$(printf '\033[0m')/"
    else
        command git "$@"
    fi
}
EOF

echo -e "${GREEN}✓ Created .zshrc${NC}"

# Step 6: Configure Git colors
echo -e "\n${BLUE}Step 6: Configuring Git colors...${NC}"

# Basic colors
git config --global color.ui auto
git config --global color.status always

# Branch colors
git config --global color.status.branch "yellow bold"
git config --global color.status.localBranch "yellow bold"
git config --global color.status.remoteBranch "yellow bold"

# Status text colors
git config --global color.status.header "magenta"
git config --global color.status.added "green"
git config --global color.status.changed "yellow"
git config --global color.status.untracked "yellow"
git config --global color.status.deleted "red"

# Diff colors
git config --global color.diff.meta "bold yellow"
git config --global color.diff.frag "magenta bold"
git config --global color.diff.old "red"
git config --global color.diff.new "green"

echo -e "${GREEN}✓ Git colors configured${NC}"

# Step 7: Final instructions
echo -e "\n${GREEN}✨ Setup Complete! ✨${NC}"
echo -e "\n${YELLOW}To apply the changes:${NC}"
echo "1. Restart your terminal or run: source ~/.zshrc"
echo "2. If using VS Code, restart it to see the changes"
echo ""
echo -e "${BLUE}Color Scheme Summary:${NC}"
echo "• Commands: Green (when typing)"
echo "• Directory: Blue"
echo "• Git Branch: Pink (in prompt), Yellow (in git output)"
echo "• Modified Files: Yellow"
echo "• Untracked Files: Purple"
echo "• Errors: Red"
echo "• Success: Green"
echo ""
echo -e "${YELLOW}Optional: Install Warp Terminal${NC}"
echo "brew install --cask warp"
echo ""
echo "Enjoy your colorful terminal! 🎨"