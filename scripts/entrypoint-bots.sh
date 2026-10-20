#!/bin/sh
# Wine + Xvfb launcher for Hypov8 Botmatch (Windows gamex86.dll).
set -eu

export WINEPREFIX="${WINEPREFIX:-/kingpin/.wine}"
export WINEARCH=win32
export WINEDEBUG="${WINEDEBUG:--all}"

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

cd /kingpin
exec xvfb-run -a wine kpded2.exe \
	+set basedir 'Z:\kingpin' \
	+set dedicated 1 \
	+set game compbots \
	+set port "$PORT" \
	+exec server.cfg
