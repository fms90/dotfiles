# ── PHP ────────────────────────────────────────────────────

# switch Homebrew PHP version: phpv 8.3 | phpv 8.4
phpv() {
  brew unlink php@8.3 php@8.4 &>/dev/null
  brew link --force --overwrite "php@$1" && php -v | head -1
}

# artisan inside the "app" container of the current compose project
art() { docker compose exec app php artisan "$@"; }
