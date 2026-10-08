# Copy to ~/.config/devstack/config.zsh and adjust. Do not version.

DEV_ROOT=~/Sites
COLIMA_CPU=6
COLIMA_MEM=12

# folders under $DEV_ROOT containing a docker-compose.yml
DEV_STACKS=(_proxy _infra)
DEV_PROJECTS=(project-a project-b)
DEV_NETWORKS=(proxy infra)

# database wait (leave DEV_DB_SERVICE empty to skip)
DEV_DB_STACK=_infra
DEV_DB_SERVICE=mariadb
DEV_DB_ROOT_PASSWORD=change-me

# printed at the end of `oi`
DEV_URLS=(
  "http://project-a.test"
  "http://project-b.test"
)
