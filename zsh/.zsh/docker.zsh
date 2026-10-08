# ── Docker ─────────────────────────────────────────────────

# shell into a container: dexec <name>, or pick from running ones
dexec() {
  local container=$1

  if [[ -z $container ]]; then
    local containers=(${(f)"$(docker ps --format '{{.Names}}')"})
    if (( ${#containers} == 0 )); then
      echo "No running containers."
      return 1
    fi
    echo "Running containers:"
    select container in $containers; do
      [[ -n $container ]] && break
    done
  fi

  # bash when available, sh on alpine/distroless images
  docker exec -it "$container" sh -c 'command -v bash >/dev/null && exec bash || exec sh'
}

# youtube-dl without installing anything: downloads into the current dir
yt-dl() {
  docker run --rm -i \
    -e PGID="$(id -g)" -e PUID="$(id -u)" \
    -v "$PWD":/workdir:rw \
    mikenye/youtube-dl "$@"
}
