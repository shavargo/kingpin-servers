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
/kingpin/apply-server-env.sh /kingpin/compbots/server.cfg

# xvfb-run + wine double-fork leaves a dead server; start Xvfb ourselves.
rm -f /tmp/.X99-lock /tmp/.X11-unix/X99 2>/dev/null || true
Xvfb :99 -screen 0 640x480x16 -nolisten tcp >/tmp/xvfb.log 2>&1 &
export DISPLAY=:99
i=0
while [ "$i" -lt 20 ]; do
	if [ -e /tmp/.X11-unix/X99 ] || [ -e /tmp/.X99-lock ]; then
		break
	fi
	i=$((i + 1))
	sleep 0.25
done
sleep 0.5

cd /kingpin
exec wine kpded2.exe \
	+set basedir 'Z:\kingpin' \
	+set dedicated 1 \
	+set game compbots \
	+set port "$PORT" \
	+exec server.cfg
