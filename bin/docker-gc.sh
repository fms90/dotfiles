#!/bin/bash
set -e
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

colima status >/dev/null 2>&1 || exit 0

echo "== $(date) =="
# stopped containers created more than 7 days ago
docker container prune -f --filter "until=168h"
# unused images created more than 7 days ago
docker image prune -a -f --filter "until=168h"
docker builder prune -f --filter "until=168h"

# give disk space back to macOS
colima ssh -- sudo fstrim -a
