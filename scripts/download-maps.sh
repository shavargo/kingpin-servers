#!/bin/sh
# Same community packs as kingpin-launcher (maps only ? no player models).
set -eu
KP_DL="${KP_DL:-https://www.kingpin.info/download/index.php}"
ROOT="${1:-/kingpin}"
TMP="${2:-/tmp/mapdl}"

mkdir -p "$ROOT/main/maps" "$TMP"

fetch() {
	dir="$1"
	file="$2"
	out="$TMP/$file"
	echo "Downloading $file ..."
	curl -fsSL "${KP_DL}?dir=${dir}&file=${file}" -o "$out"
	# Sanity: reject HTML error pages
	if head -c 15 "$out" | grep -qi '<!DOCTYPE\|<html'; then
		echo "ERROR: got HTML instead of zip for $file" >&2
		exit 1
	fi
	unzip -qo "$out" -d "$ROOT"
	rm -f "$out"
}

YOASS_OLD="kingpin/main/maps/map-packs/map-pack-n-yo-ass/all_maps_1999-2007/"
YOASS_NEW="kingpin/main/maps/map-packs/map-pack-n-yo-ass/death_match_maps_2007-2017/"

i=1
while [ "$i" -le 11 ]; do
	fetch "$YOASS_OLD" "bcs_map_pack_n_yo_ass-$i.zip"
	i=$((i + 1))
done
fetch "$YOASS_NEW" "bcs_map_pack_n_yo_ass-12.zip"
fetch "$YOASS_NEW" "bcs_map_pack_n_yo_ass-13.zip"

fetch "kingpin/main/maps/map-packs/" "bagman_mappack.zip"
fetch "kingpin/main/maps/map-packs/" "openrift_mappack.zip"
fetch "kingpin/server/official/" "original_dm_maps.zip"
fetch "kingpin/server/official/" "original_bm_maps.zip"

# Official stock zips unpack to $ROOT/maps/ — game expects main/maps/
if [ -d "$ROOT/maps" ]; then
	for f in "$ROOT/maps"/*.bsp; do
		[ -f "$f" ] || continue
		cp -n "$f" "$ROOT/main/maps/$(basename "$f")" 2>/dev/null || cp -f "$f" "$ROOT/main/maps/$(basename "$f")"
	done
fi

# Move any other loose BSPs sitting in wrong places into main/maps
find "$ROOT" -type f -iname '*.bsp' ! -path "$ROOT/main/maps/*" ! -path "$ROOT/ctf/*" -print0 |
	while IFS= read -r -d '' f; do
		mv -f "$f" "$ROOT/main/maps/$(basename "$f")"
	done || true

# DM rotation: non-team / non-ctf maps
find "$ROOT/main/maps" -maxdepth 1 -type f -iname '*.bsp' -printf '%f\n' 2>/dev/null |
	sed 's/\.[Bb][Ss][Pp]$//' |
	grep -viE '^(team_|ctf)' |
	sort -u > "$ROOT/mmod_dm/maps.txt" || true

# Bagman rotation
find "$ROOT/main/maps" -maxdepth 1 -type f -iname '*.bsp' -printf '%f\n' 2>/dev/null |
	sed 's/\.[Bb][Ss][Pp]$//' |
	grep -iE '^(team_|.*bag)' |
	sort -u > "$ROOT/mmod_bm/maps_bm.txt" || true
cp -f "$ROOT/mmod_bm/maps_bm.txt" "$ROOT/mmod_bm/maps.txt"

echo "Maps ready. BSP in main/maps: $(find "$ROOT/main/maps" -maxdepth 1 -iname '*.bsp' 2>/dev/null | wc -l)"
