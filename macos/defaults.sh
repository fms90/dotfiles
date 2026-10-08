#!/usr/bin/env bash
# macOS tweaks. Review before running: ./install.sh --macos
set -euo pipefail

# Finder
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Keyboard: fast key repeat
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Screenshots: clipboard by default; dedicated folder when switched to file (shotto file)
mkdir -p "$HOME/Pictures/Screenshots"
defaults write com.apple.screencapture location -string "$HOME/Pictures/Screenshots"
defaults write com.apple.screencapture target -string clipboard

killall Finder SystemUIServer 2>/dev/null || true
echo "done — keyboard settings apply after logout"
