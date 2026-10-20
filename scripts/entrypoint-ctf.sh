#!/bin/sh
# Native Linux KPDED2 launcher for Colors CTF.
set -eu

PORT="${KP_PORT:-31511}"

cp -f /kingpin/ctf/server.cfg.template /kingpin/ctf/server.cfg
/kingpin/apply-server-env.sh /kingpin/ctf/server.cfg

cd /kingpin
exec ./kpded2 \
	+set dedicated 1 \
	+set game ctf \
	+set port "$PORT" \
	+exec server.cfg
