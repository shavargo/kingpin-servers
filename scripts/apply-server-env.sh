#!/bin/sh
# Apply KP_* environment overrides to a Kingpin/Quake2 server.cfg.
# Usage: apply-server-env.sh /path/to/server.cfg
# Empty/unset vars leave the template value unchanged.
set -eu

cfg="${1:?usage: apply-server-env.sh <server.cfg>}"
[ -f "$cfg" ] || {
	echo "apply-server-env: missing $cfg" >&2
	exit 1
}

# Prefer KP_MAXCLIENTS; accept KP_MAX_PLAYERS as alias.
if [ -z "${KP_MAXCLIENTS:-}" ] && [ -n "${KP_MAX_PLAYERS:-}" ]; then
	KP_MAXCLIENTS=$KP_MAX_PLAYERS
fi

tmp="${cfg}.envtmp"
map_line=$(grep -E '^map ' "$cfg" | tail -1 || true)

# Start from template without the trailing map line (re-added last).
grep -v -E '^map ' "$cfg" >"$tmp" || true

# Replace an existing "set <cvar> ..." line, or append if missing.
set_cvar() {
	cvar=$1
	val=$2
	[ -n "$val" ] || return 0
	grep -v "^set ${cvar} " "$tmp" >"${tmp}.2" || true
	mv -f "${tmp}.2" "$tmp"
	printf 'set %s "%s"\n' "$cvar" "$val" >>"$tmp"
}

set_cvar hostname "${KP_HOSTNAME:-}"
set_cvar maxclients "${KP_MAXCLIENTS:-}"
set_cvar public "${KP_PUBLIC:-}"
set_cvar fraglimit "${KP_FRAGLIMIT:-}"
set_cvar timelimit "${KP_TIMELIMIT:-}"
set_cvar cashlimit "${KP_CASHLIMIT:-}"
set_cvar capturelimit "${KP_CAPTURELIMIT:-}"
set_cvar dmflags "${KP_DMFLAGS:-}"
set_cvar sv_botskill "${KP_BOTSKILL:-}"
set_cvar sv_bot_max "${KP_BOT_MAX:-}"
set_cvar sv_bot_max_players "${KP_BOT_MAX_PLAYERS:-}"
set_cvar idle_client "${KP_IDLE_CLIENT:-}"
set_cvar props "${KP_PROPS:-}"

if [ -n "${KP_MASTER:-}" ]; then
	grep -v '^setmaster ' "$tmp" >"${tmp}.2" || true
	mv -f "${tmp}.2" "$tmp"
	printf 'setmaster %s\n' "$KP_MASTER" >>"$tmp"
fi

if [ -n "${KP_MAP:-}" ]; then
	printf 'map %s\n' "$KP_MAP" >>"$tmp"
elif [ -n "$map_line" ]; then
	printf '%s\n' "$map_line" >>"$tmp"
fi

mv -f "$tmp" "$cfg"
echo "apply-server-env: wrote $cfg"
