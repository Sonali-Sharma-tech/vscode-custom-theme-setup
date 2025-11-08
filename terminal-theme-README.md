# 🎨 Beautiful Terminal & VS Code Theme Setup

This package includes all the configurations for a beautiful, color-coded terminal setup with Starship prompt AND a custom VS Code theme!

## 📸 What You'll Get

- **Colorful command prompt** with git branch info
- **Syntax highlighting** while typing commands
- **Custom git colors** for better readability
- **Custom VS Code theme** matching your terminal colors
- **Works everywhere**: VS Code, Warp, Terminal.app, iTerm2

## 🚀 Quick Installation

1. **Download the setup script** (`terminal-theme-setup.sh`)

2. **Run it**:
   ```bash
   bash terminal-theme-setup.sh
   ```

3. **Restart your terminal**

That's it! 🎉

## 🎨 Color Scheme

- **Commands**: Green (when typing)
- **Directory**: Blue
- **Git Branch**: Pink (in prompt), Yellow (in git output)
- **Modified Files**: Yellow
- **Untracked Files**: Purple
- **Errors**: Red
- **Success Indicators**: Green

## 🖥️ VS Code Theme: Colorful Carbon

The package includes a custom VS Code theme that matches your terminal colors!

**Features:**
- Dark background with vibrant syntax highlighting
- Terminal colors that match your shell theme
- Git decorations with matching colors
- Smooth cursor animations and bracket pair colorization

**Installation:**
The theme is automatically installed by the setup script. If you need to manually install:
1. Copy `themes/vscode/colorful-theme.json` to `~/Library/Application Support/Code/User/themes/colorful-carbon.json`
2. In VS Code, open Command Palette (Cmd+Shift+P)
3. Type "Preferences: Color Theme"
4. Select "Colorful Carbon"

## 📝 Manual Installation (if needed)

If the script doesn't work, you can manually:

1. Install dependencies:
   ```bash
   brew install starship zsh-autosuggestions zsh-syntax-highlighting fzf
   ```

2. Copy the terminal configuration files:
   - Copy the `.zshrc` content to `~/.zshrc`
   - Copy the `starship.toml` content to `~/.config/starship.toml`

3. For VS Code theme:
   - Copy `themes/vscode/colorful-theme.json` to `~/Library/Application Support/Code/User/themes/colorful-carbon.json`
   - Copy or merge `configs/vscode-settings.json` with your VS Code settings

4. Run the git config commands from the script

## 🛠️ Customization

- **Change prompt colors**: Edit `~/.config/starship.toml`
- **Change command colors**: Edit the `ZSH_HIGHLIGHT_STYLES` in `~/.zshrc`
- **Change git colors**: Use `git config --global color.*` commands

## 🤝 Sharing

To share with others, just send them:
1. The `terminal-theme-setup.sh` script
2. This README

## 📱 VS Code Integration

The package includes a complete VS Code theme and settings!

**What's included:**
- Custom "Colorful Carbon" color theme
- Terminal settings that match your shell theme
- Font recommendations for icon support
- Editor settings for a better coding experience

**After installation:**
1. Restart VS Code to see all changes
2. The theme should be automatically selected
3. Your integrated terminal will match your external terminal

## 🐛 Troubleshooting

**Colors not showing?**
- Make sure your terminal supports 256 colors
- Try running: `echo $TERM` (should show `xterm-256color`)

**Starship not working?**
- Make sure it's in your PATH: `which starship`
- Check that `.zshrc` is being loaded

**Git colors not working?**
- The custom git wrapper might conflict with aliases
- Check `which git` to ensure it's using the function

**VS Code theme not showing?**
- Make sure the theme file was copied to the correct location
- Try manually selecting it: Cmd+Shift+P → "Preferences: Color Theme" → "Colorful Carbon"
- Check if the theme file exists: `ls ~/Library/Application\ Support/Code/User/themes/`