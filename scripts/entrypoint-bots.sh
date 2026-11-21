#!/bin/sh
# Native Linux KPDED2 launcher for Hypov8 Botmatch.
set -eu

MODE="${KP_MODE:-dm}"
PORT="${KP_PORT:-31510}"

case "$MODE" in
	dm|bm) ;;
	*)
		echo "KP_MODE must be dm or bm (got: $MODE)" >&2
		exit 1
		;;
esac

cp -f "/kingpin/compbots/comp_${MODE}.ini" /kingpin/compbots/comp.ini
cp -f "/kingpin/compbots/server_${MODE}.cfg" /kingpin/compbots/server.cfg
/kingpin/apply-server-env.sh /kingpin/compbots/server.cfg

RCON_ARG=""
if [ -n "${KP_RCON_PASSWORD:-}" ]; then
	RCON_ARG="+set rcon_password $KP_RCON_PASSWORD"
fi

cd /kingpin
exec stdbuf -oL -eL ./kpded2 \
	+set dedicated 1 \
	+set game compbots \
	+set port "$PORT" \
	$RCON_ARG \
	+exec server.cfg
