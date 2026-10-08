#!/usr/bin/env bash
# Symlinks the dotfiles. Idempotent.
#   ./install.sh            links only
#   ./install.sh --brew     + brew bundle
#   ./install.sh --launchd  + daily docker-gc (03:00)
#   ./install.sh --macos    + macos/defaults.sh
set -euo pipefail

DOT="$(cd "$(dirname "$0")" && pwd)"
TS=$(date +%Y%m%d%H%M%S)

link() {
  local src="$DOT/$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [[ -L $dst && $(readlink "$dst") == "$src" ]]; then
    return
  fi
  if [[ -e $dst || -L $dst ]]; then
    mv "$dst" "$dst.bak.$TS"
    echo "backup  $dst.bak.$TS"
  fi
  ln -s "$src" "$dst"
  echo "link    $dst"
}

# git: current identity becomes ~/.gitconfig.local instead of a backup
if [[ -f ~/.gitconfig && ! -L ~/.gitconfig && ! -e ~/.gitconfig.local ]]; then
  mv ~/.gitconfig ~/.gitconfig.local
  echo "moved   ~/.gitconfig -> ~/.gitconfig.local"
fi

link zsh/.zshrc ~/.zshrc
for f in "$DOT"/zsh/.zsh/*.zsh; do
  link "zsh/.zsh/$(basename "$f")" ~/.zsh/"$(basename "$f")"
done
link git/.gitconfig ~/.gitconfig
link git/ignore ~/.config/git/ignore
link bin/docker-gc.sh ~/bin/docker-gc.sh

if [[ ! -e ~/.config/devstack/config.zsh ]]; then
  mkdir -p ~/.config/devstack
  cp "$DOT/devstack/config.example.zsh" ~/.config/devstack/config.zsh
  echo "created ~/.config/devstack/config.zsh (edit it)"
fi

for arg in "$@"; do
  case $arg in
    --brew)
      brew bundle --file="$DOT/Brewfile"
      ;;
    --launchd)
      plist=com.fausto.docker-gc.plist
      dst=~/Library/LaunchAgents/$plist
      sed "s#__HOME__#$HOME#g" "$DOT/launchd/$plist" > "$dst"
      launchctl bootout "gui/$(id -u)" "$dst" 2>/dev/null || true
      launchctl bootstrap "gui/$(id -u)" "$dst"
      echo "launchd $plist"
      ;;
    --macos)
      bash "$DOT/macos/defaults.sh"
      ;;
    *)
      echo "unknown option: $arg" >&2
      exit 1
      ;;
  esac
done

[[ -f ~/.zshrc.local ]] || echo "tip: create ~/.zshrc.local (template in zsh/.zshrc.local.example)"
