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

# Function to show usage
show_usage() {
    echo "Usage: $0 [install|remove|status]"
    echo ""
    echo "Commands:"
    echo "  install  - Install and configure terminal theme (default)"
    echo "  remove   - Remove terminal theme configurations"
    echo "  status   - Check installation status"
    echo ""
}

# Function to check installation status
check_status() {
    echo -e "${BLUE}=== Colorful Carbon Installation Status ===${NC}"
    echo ""

    # Check theme files
    echo -e "${BLUE}Theme Components:${NC}"

    # Check commands
    local commands=("starship" "fzf")
    for cmd in "${commands[@]}"; do
        if command_exists "$cmd"; then
            echo -e "  $cmd: ${GREEN}✓ Installed${NC}"
        else
            echo -e "  $cmd: ${RED}✗ Not installed${NC}"
        fi
    done

    # Check brew packages
    local brew_packages=("zsh-autosuggestions" "zsh-syntax-highlighting")
    for pkg in "${brew_packages[@]}"; do
        if brew list "$pkg" &>/dev/null; then
            echo -e "  $pkg: ${GREEN}✓ Installed${NC}"
        else
            echo -e "  $pkg: ${RED}✗ Not installed${NC}"
        fi
    done

    # Check configuration files
    echo -e "\n${BLUE}Configuration Files:${NC}"
    if [ -f ~/.zshrc ] && grep -q "# Colorful Carbon Configuration" ~/.zshrc; then
        echo -e "  .zshrc: ${GREEN}✓ Configured${NC}"
    else
        echo -e "  .zshrc: ${RED}✗ Not configured${NC}"
    fi

    if [ -f ~/.config/starship.toml ]; then
        echo -e "  starship.toml: ${GREEN}✓ Exists${NC}"
    else
        echo -e "  starship.toml: ${RED}✗ Not found${NC}"
    fi

    # Check VS Code theme
    if [ -d "$HOME/Library/Application Support/Code/User/themes" ] && [ -f "$HOME/Library/Application Support/Code/User/themes/colorful-carbon.json" ]; then
        echo -e "  VS Code Theme: ${GREEN}✓ Installed${NC}"
    else
        echo -e "  VS Code Theme: ${RED}✗ Not installed${NC}"
    fi
}

# Function to remove configurations
remove_configurations() {
    echo -e "${YELLOW}This will remove Colorful Carbon terminal configurations.${NC}"
    read -p "Are you sure? (y/N): " confirm

    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        echo "Removal cancelled."
        return
    fi

    echo -e "\n${BLUE}Removing configurations...${NC}"

    # Remove from .zshrc
    if [ -f ~/.zshrc ]; then
        # Create backup
        cp ~/.zshrc ~/.zshrc.backup_removal_$(date +%Y%m%d_%H%M%S)

        # Remove our configuration block
        sed -i '' '/# Colorful Carbon Configuration - START/,/# Colorful Carbon Configuration - END/d' ~/.zshrc 2>/dev/null || \
        sed -i '/# Colorful Carbon Configuration - START/,/# Colorful Carbon Configuration - END/d' ~/.zshrc

        echo -e "${GREEN}✓ Removed from .zshrc${NC}"
    fi

    # Remove starship.toml if it's ours
    if [ -f ~/.config/starship.toml ]; then
        if grep -q "Custom Color-Coded Starship Theme" ~/.config/starship.toml; then
            rm ~/.config/starship.toml
            echo -e "${GREEN}✓ Removed starship.toml${NC}"
        else
            echo -e "${YELLOW}⚠ starship.toml appears to be customized, skipping removal${NC}"
        fi
    fi

    # Remove VS Code theme
    local vscode_theme="$HOME/Library/Application Support/Code/User/themes/colorful-carbon.json"
    if [ -f "$vscode_theme" ]; then
        rm "$vscode_theme"
        echo -e "${GREEN}✓ Removed VS Code theme${NC}"
    fi

    echo -e "\n${GREEN}✨ Removal complete! Restart your terminal to see changes.${NC}"
}

# Main installation function
install_theme() {
    # Step 1: Check platform
    echo -e "${BLUE}Step 1: Checking system requirements...${NC}"
    if [[ "$OSTYPE" != "darwin"* ]] && [[ "$OSTYPE" != "linux"* ]]; then
        echo -e "${RED}This script currently supports macOS and Linux only.${NC}"
        exit 1
    fi

    # Check for zsh
    if ! command_exists zsh; then
        echo -e "${RED}Zsh is not installed. Please install zsh first.${NC}"
        exit 1
    fi
    echo -e "${GREEN}✓ System requirements met${NC}"

    # Step 2: Install Homebrew if not installed
    echo -e "\n${BLUE}Step 2: Checking Homebrew...${NC}"
    if ! command_exists brew; then
        echo -e "${YELLOW}Installing Homebrew...${NC}"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Add Homebrew to PATH for this session
        if [[ -f /opt/homebrew/bin/brew ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
    else
        echo -e "${GREEN}✓ Homebrew already installed${NC}"
    fi

    # Step 3: Install required packages
    echo -e "\n${BLUE}Step 3: Installing required packages...${NC}"
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
            if ! brew install "$package"; then
                echo -e "${RED}Failed to install $package${NC}"
                exit 1
            fi
        fi
    done

    # Step 4: Backup existing configurations
    echo -e "\n${BLUE}Step 4: Backing up existing configurations...${NC}"
    timestamp=$(date +%Y%m%d_%H%M%S)
    if [ -f ~/.zshrc ]; then
        cp ~/.zshrc ~/.zshrc.backup_$timestamp
        echo -e "${GREEN}✓ Backed up .zshrc${NC}"
    fi
    if [ -f ~/.config/starship.toml ]; then
        cp ~/.config/starship.toml ~/.config/starship.toml.backup_$timestamp
        echo -e "${GREEN}✓ Backed up starship.toml${NC}"
    fi

    # Step 5: Create Starship configuration
    echo -e "\n${BLUE}Step 5: Creating Starship configuration...${NC}"
    mkdir -p ~/.config

    cat > ~/.config/starship.toml << 'EOF'
# Custom Color-Coded Starship Theme

format = """
$username\
$hostname\
$directory\
$git_branch\
$git_status\
$cmd_duration\
$time\
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
conflicted = "[#conflicts](bold red) "
ahead = "[↑${count}](bold green) "
behind = "[↓${count}](bold yellow) "
diverged = "[↑${ahead_count}](bold green)[↓${behind_count}](bold yellow) "
untracked = ""
stashed = ""
modified = ""
staged = ""
renamed = ""
deleted = ""
up_to_date = "[#synced](bold green) "

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

[time]
disabled = false
format = ' [$time](bold fg:241)'  # Gray color for time at the end
time_format = '%d %b %Y %H:%M'  # Format: 8 Nov 2024 22:45
utc_time_offset = 'local'

[cmd_duration]
min_time = 2000
format = 'took [$duration](bold yellow)'
EOF

    echo -e "${GREEN}✓ Created starship.toml${NC}"

    # Step 6: Update .zshrc configuration (append, don't overwrite)
    echo -e "\n${BLUE}Step 6: Updating .zshrc configuration...${NC}"

    # Check if our configuration already exists
    if grep -q "# Colorful Carbon Configuration" ~/.zshrc 2>/dev/null; then
        echo -e "${YELLOW}Configuration already exists in .zshrc, skipping...${NC}"
    else
        # Append our configuration
        cat >> ~/.zshrc << 'EOF'

# Colorful Carbon Configuration - START
# Added by Colorful Carbon terminal theme setup script

# Homebrew zsh plugins - tries multiple common locations
if [[ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
elif [[ -f /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
elif [[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

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
if [[ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [[ -f /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

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

# Colorful Carbon Configuration - END
EOF
        echo -e "${GREEN}✓ Updated .zshrc${NC}"
    fi

    # Step 7: Configure Git colors
    echo -e "\n${BLUE}Step 7: Configuring Git colors...${NC}"

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

    # Step 8: VS Code Theme Setup
    echo -e "\n${BLUE}Step 8: Setting up VS Code theme...${NC}"

    # Check if VS Code is installed
    if command_exists code || [ -d "$HOME/Library/Application Support/Code" ]; then
        # Get VS Code extensions directory
        if [ -d "$HOME/Library/Application Support/Code/User" ]; then
            VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"
        elif [ -d "$HOME/.config/Code/User" ]; then
            VSCODE_USER_DIR="$HOME/.config/Code/User"
        else
            echo -e "${YELLOW}⚠ Could not find VS Code user directory${NC}"
            VSCODE_USER_DIR=""
        fi

        if [ -n "$VSCODE_USER_DIR" ]; then
            # Backup existing VS Code settings
            if [ -f "$VSCODE_USER_DIR/settings.json" ]; then
                cp "$VSCODE_USER_DIR/settings.json" "$VSCODE_USER_DIR/settings.json.backup_$timestamp"
                echo -e "${GREEN}✓ Backed up VS Code settings${NC}"
            fi

            # Copy VS Code theme
            mkdir -p "$VSCODE_USER_DIR/themes"
            if [ -f "themes/vscode/colorful-theme.json" ]; then
                cp themes/vscode/colorful-theme.json "$VSCODE_USER_DIR/themes/colorful-carbon.json"
                echo -e "${GREEN}✓ Installed Colorful Carbon theme${NC}"
            else
                echo -e "${YELLOW}⚠ Theme file not found in themes/vscode/colorful-theme.json${NC}"
            fi

            # Update VS Code settings
            echo -e "${YELLOW}Please add these settings to your VS Code (Cmd+Shift+P > Preferences: Open Settings (JSON)):${NC}"
            echo ""
            echo '  "workbench.colorTheme": "Colorful Carbon",'
            echo '  "terminal.integrated.fontFamily": "MesloLGS NF, SF Mono, Monaco, '"'"'Courier New'"'"', monospace",'
            echo '  "terminal.integrated.fontSize": 13,'
            echo '  "terminal.integrated.lineHeight": 1.2,'
            echo '  "terminal.integrated.cursorStyle": "line",'
            echo '  "terminal.integrated.cursorBlinking": true,'
            echo ""
        fi
    else
        echo -e "${YELLOW}⚠ VS Code not installed. Skipping theme setup.${NC}"
    fi

    # Step 9: Final instructions
    echo -e "\n${GREEN}✨ Setup Complete! ✨${NC}"
    echo -e "\n${YELLOW}To apply the changes:${NC}"
    echo "1. Restart your terminal or run: source ~/.zshrc"
    echo "2. If using VS Code, restart it to see the changes"
    echo ""
    echo -e "${BLUE}Color Scheme Summary:${NC}"
    echo "• Commands: Green (when typing)"
    echo "• Directory: Blue"
    echo "• Git Branch: Pink (in prompt), Yellow (in git output)"
    echo "• Time: Gray (at the end of prompt)"
    echo "• Errors: Red"
    echo "• Success: Green"
    echo ""
    echo -e "${YELLOW}Useful Commands:${NC}"
    echo "• Check status: $0 status"
    echo "• Remove theme: $0 remove"
    echo ""
    echo "Enjoy your colorful terminal! 🎨"
}

# Main script logic
case "${1:-install}" in
    install)
        install_theme
        ;;
    remove)
        remove_configurations
        ;;
    status)
        check_status
        ;;
    -h|--help|help)
        show_usage
        ;;
    *)
        echo -e "${RED}Unknown command: $1${NC}"
        show_usage
        exit 1
        ;;
esac