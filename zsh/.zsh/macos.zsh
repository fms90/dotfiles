# ── macOS / utilities ──────────────────────────────────────

# ports
port()     { lsof -nP -iTCP:"$1" -sTCP:LISTEN; }
killport() { lsof -ti tcp:"$1" | xargs kill; }
flushdns() { sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder; }

# temporary public URL for a local service
tunnel()   { cloudflared tunnel --url "http://localhost:${1:-8000}"; }

# trusted certificate for a local domain (mkcert)
devcert()  { mkcert -cert-file "$1.pem" -key-file "$1-key.pem" "$1" "*.$1"; }

# screenshot target: shotto clipboard | shotto file | shotto (show current)
shotto() {
  if [[ -z $1 ]]; then
    defaults read com.apple.screencapture target 2>/dev/null || echo file
    return
  fi
  [[ $1 == clipboard || $1 == file ]] || { echo "usage: shotto clipboard|file"; return 1; }
  defaults write com.apple.screencapture target -string "$1"
  killall SystemUIServer
  echo "screenshot → $1"
}

# files and clipboard
mkcd()     { mkdir -p "$1" && cd "$1"; }
serve()    { python3 -m http.server "${1:-8000}"; }
jsonfmt()  { pbpaste | jq . | pbcopy; }
pdftxt()   { pdftotext -layout "$1" -; }
vid2gif()  { ffmpeg -i "$1" -vf "fps=12,scale=720:-1:flags=lanczos" -loop 0 "${1%.*}.gif"; }

alias sites='cd ~/Sites'
