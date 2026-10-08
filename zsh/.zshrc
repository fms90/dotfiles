export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git zsh-autosuggestions)
source "$ZSH/oh-my-zsh.sh"

export PATH="$HOME/bin:$HOME/.local/bin:$HOME/.composer/vendor/bin:$PATH"

# modules: docker, git, dev, macos, php, runtimes
for f in ~/.zsh/*.zsh(N); do source "$f"; done

# secrets, work aliases and machine-specific PATH (kept out of the repo)
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
