# ── Dev environment ────────────────────────────────────────
# oi    start colima → networks → base stacks → projects
# tchau stop everything (-f also stops colima)
#
# Per-machine config in ~/.config/devstack/config.zsh
# (template in devstack/config.example.zsh)

DEVSTACK_CONFIG=${DEVSTACK_CONFIG:-$HOME/.config/devstack/config.zsh}
[[ -f $DEVSTACK_CONFIG ]] && source "$DEVSTACK_CONFIG"

: ${DEV_ROOT:=$HOME/Sites}
: ${COLIMA_CPU:=4}
: ${COLIMA_MEM:=8}
(( ${+DEV_NETWORKS} )) || DEV_NETWORKS=(proxy infra)
(( ${+DEV_STACKS} ))   || DEV_STACKS=(_proxy _infra)
(( ${+DEV_PROJECTS} )) || DEV_PROJECTS=()
(( ${+DEV_URLS} ))     || DEV_URLS=()

_dc() { docker compose -f "$DEV_ROOT/$1/docker-compose.yml" "${@:2}"; }

_dev_wait_db() {
  [[ -z $DEV_DB_SERVICE ]] && return 0
  echo -n "▸ waiting for $DEV_DB_SERVICE"
  local i
  for i in {1..60}; do
    if _dc "$DEV_DB_STACK" exec -T -e MYSQL_PWD="$DEV_DB_ROOT_PASSWORD" \
        "$DEV_DB_SERVICE" mariadb-admin ping -uroot --silent &>/dev/null; then
      echo
      return 0
    fi
    echo -n "."
    sleep 1
  done
  echo
  echo "✗ $DEV_DB_SERVICE did not respond"
  _dc "$DEV_DB_STACK" logs "$DEV_DB_SERVICE" --tail 30
  return 1
}

oi() {
  local force=0
  [[ "$1" == "-f" || "$1" == "--restart-vm" ]] && force=1

  # 1. Colima
  if [[ $force -eq 1 ]] || ! colima status &>/dev/null; then
    echo "▸ colima (${COLIMA_CPU} cpu / ${COLIMA_MEM}g)"
    colima stop --force 2>/dev/null
    colima start --vm-type=vz --vz-rosetta \
      --cpu "$COLIMA_CPU" --memory "$COLIMA_MEM" || return 1
  else
    echo "▸ colima already running"
  fi

  # 2. Daemon
  echo -n "▸ waiting for docker"
  local i
  for i in {1..30}; do
    docker info &>/dev/null && break
    echo -n "."
    sleep 1
  done
  echo
  docker info &>/dev/null || { echo "✗ docker did not start"; return 1; }

  # 3. Shared networks
  local net
  for net in $DEV_NETWORKS; do
    docker network inspect "$net" &>/dev/null || {
      echo "▸ creating network $net"
      docker network create "$net" >/dev/null
    }
  done

  # 4. Base stacks (proxy, database, mail...)
  local stack
  for stack in $DEV_STACKS; do
    echo "▸ $stack"
    _dc "$stack" up -d --remove-orphans || { echo "✗ $stack failed"; return 1; }
  done

  # 5. Database
  _dev_wait_db || return 1

  # 6. Projects
  local p
  for p in $DEV_PROJECTS; do
    echo "▸ $p"
    _dc "$p" up -d --remove-orphans || echo "✗ $p failed"
  done

  echo
  docker ps --format 'table {{.Names}}\t{{.Status}}'
  (( ${#DEV_URLS} )) && { echo; printf '  %s\n' $DEV_URLS; }
}

tchau() {
  local p stack
  for p in $DEV_PROJECTS; do _dc "$p" down; done
  for stack in ${(Oa)DEV_STACKS}; do _dc "$stack" down; done
  [[ "$1" == "-f" ]] && colima stop
}

# shortcuts for the base stacks
infra() { _dc _infra "$@"; }
proxy() { _dc _proxy "$@"; }
