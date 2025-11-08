# 🎨 Beautiful Terminal Theme Setup

This package includes all the configurations for a beautiful, color-coded terminal setup with Starship prompt!

## 📸 What You'll Get

- **Colorful command prompt** with git branch info
- **Syntax highlighting** while typing commands
- **Custom git colors** for better readability
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

## 📝 Manual Installation (if needed)

If the script doesn't work, you can manually:

1. Install dependencies:
   ```bash
   brew install starship zsh-autosuggestions zsh-syntax-highlighting fzf
   ```

2. Copy the included files:
   - `.zshrc` → `~/.zshrc`
   - `starship.toml` → `~/.config/starship.toml`

3. Run the git config commands from the script

## 🛠️ Customization

- **Change prompt colors**: Edit `~/.config/starship.toml`
- **Change command colors**: Edit the `ZSH_HIGHLIGHT_STYLES` in `~/.zshrc`
- **Change git colors**: Use `git config --global color.*` commands

## 🤝 Sharing

To share with others, just send them:
1. The `terminal-theme-setup.sh` script
2. This README

## 📱 VS Code Integration

The theme works automatically in VS Code's integrated terminal. For best results:

1. Use a font that supports icons (like "MesloLGS NF")
2. Restart VS Code after installation

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

---
Made with 💜 by Sonali