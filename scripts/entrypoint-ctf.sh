#!/bin/sh
# Native Linux KPDED2 launcher for Colors CTF.
set -eu

PORT="${KP_PORT:-31511}"

cp -f /kingpin/ctf/server.cfg.template /kingpin/ctf/server.cfg
/kingpin/apply-server-env.sh /kingpin/ctf/server.cfg

RCON_ARG=""
if [ -n "${KP_RCON_PASSWORD:-}" ]; then
	RCON_ARG="+set rcon_password $KP_RCON_PASSWORD"
fi

cd /kingpin
exec stdbuf -oL -eL ./kpded2 \
	+set dedicated 1 \
	+set game ctf \
	+set port "$PORT" \
	$RCON_ARG \
	+exec server.cfg
