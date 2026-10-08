# dotfiles

The terminal tools I use every day on macOS: zsh + oh-my-zsh, Docker via Colima, PHP/Laravel, Node and Cloudflare.

## Highlights

**`oi` / `tchau`**: start and stop the whole local environment with one command. Boots Colima, waits for the daemon, creates the shared networks, starts the proxy and infra stacks, waits for the database and starts the projects.

```sh
oi          # start everything
oi -f       # restart the colima VM first
tchau       # stop projects and base stacks
tchau -f    # and stop colima
```

**`docker-gc.sh` + launchd**: daily cleanup at 03:00. Prunes containers, images and build cache older than 7 days and runs `fstrim` inside the Colima VM, giving disk space back to macOS.

**`dexec`**: menu of running containers; shells into the chosen one. Uses bash, falls back to sh on alpine images.

## Commands

| Command | What it does |
|---|---|
| `oi` / `tchau` | start / stop the dev environment |
| `infra …` / `proxy …` | `docker compose` on the base stacks |
| `dexec [name]` | shell into a container |
| `yt-dl <url>` | youtube-dl via Docker, nothing to install |
| `grh` | reset current branch to its upstream, with confirmation |
| `gclean` | delete local branches already merged |
| `pr` | draft PR via `gh` |
| `port 3000` / `killport 3000` | who is using the port / kill it |
| `tunnel 8000` | temporary public URL via Cloudflare Tunnel |
| `devcert app.test` | trusted local certificate (mkcert) |
| `flushdns` | flush macOS DNS cache |
| `phpv 8.4` | switch Homebrew PHP version |
| `art …` | `php artisan` inside the `app` container |
| `shotto clipboard\|file` | screenshot target: clipboard or ~/Pictures/Screenshots |
| `jsonfmt` | pretty-print the JSON in the clipboard |
| `vid2gif video.mov` | convert a video to GIF |
| `pdftxt file.pdf` | extract text from a PDF |
| `mkcd`, `serve`, `sites` | small helpers |

Automatic Node switching via `.nvmrc` is the official [nvm](https://github.com/nvm-sh/nvm) snippet.

## Layout

```
zsh/.zshrc              loads oh-my-zsh, modules and ~/.zshrc.local
zsh/.zsh/*.zsh          docker, git, dev, macos, php, runtimes
devstack/               config template for oi/tchau
bin/docker-gc.sh        Docker/Colima cleanup
launchd/                docker-gc schedule
git/                    .gitconfig and global ignore
macos/defaults.sh       system tweaks
Brewfile                packages
```

## Install

```sh
git clone https://github.com/fms90/dotfiles ~/dotfiles
cd ~/dotfiles
./install.sh                 # symlinks (backs up existing files)
./install.sh --brew          # + packages
./install.sh --launchd       # + daily docker-gc
./install.sh --macos         # + macOS defaults
```

Then edit `~/.config/devstack/config.zsh`.

## Secrets

Nothing sensitive lives in this repo. Tokens, work aliases and machine-specific PATH go in `~/.zshrc.local`; git identity goes in `~/.gitconfig.local`. Both are ignored. Templates: `zsh/.zshrc.local.example` and `devstack/config.example.zsh`.
