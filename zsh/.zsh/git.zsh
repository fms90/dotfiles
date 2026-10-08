# ── Git ────────────────────────────────────────────────────

# hard-reset the current branch to its upstream, discarding local changes
grh() {
  local up
  up=$(git rev-parse --abbrev-ref '@{u}' 2>/dev/null) || { echo "no upstream"; return 1; }
  read -q "?reset --hard to $up? [y/N] " || { echo; return 1; }
  echo
  git fetch --all --prune && git reset --hard "$up"
}

# delete local branches already merged
gclean() {
  git fetch -p
  git branch --merged | grep -vE '^\*|^\s*(main|master|develop)$' | xargs -n1 git branch -d
}

# draft PR with title/body from commits
pr() { gh pr create --fill --draft "$@"; }
