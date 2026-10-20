#!/bin/sh
# Download community map packs from kingpin.info (same set as kingpin-launcher).
set -eu
KP_BASE="${KP_BASE:-https://www.kingpin.info/download/kingpin}"
MAPS_DIR="${1:-/kingpin/main/maps}"
TMP="${2:-/tmp/mapdl}"

mkdir -p "$MAPS_DIR" "$TMP"

download_unzip() {
	url="$1"
	name="$2"
	echo "Downloading $name..."
	curl -fsSL "$url" -o "$TMP/$name"
	unzip -qo "$TMP/$name" -d "$TMP/extract"
	# Flatten common zip layouts into main/maps
	find "$TMP/extract" -type f \( -iname '*.bsp' -o -iname '*.pcx' -o -iname '*.tga' -o -iname '*.wal' -o -iname '*.wav' \) -print0 |
		while IFS= read -r -d '' f; do
			rel="${f#"$TMP/extract/"}"
			# Prefer files already under a maps/ path
			case "$rel" in
			*/maps/*) dest="$MAPS_DIR/$(basename "$f")" ;;
			*.bsp|*.BSP) dest="$MAPS_DIR/$(basename "$f")" ;;
			*)
				# Keep supporting assets under main/ when possible
				case "$rel" in
				*/textures/*|*/env/*|*/sound/*|*/pics/*)
					# skip extras for slim server image ? maps only
					continue
					;;
				*) dest="$MAPS_DIR/$(basename "$f")" ;;
				esac
				;;
			esac
			cp -f "$f" "$dest"
		done
	rm -rf "$TMP/extract" "$TMP/$name"
}

YOASS="$KP_BASE/main/maps/map-packs/map-pack-n-yo-ass"
OLD="$YOASS/all_maps_1999-2007"
NEW="$YOASS/death_match_maps_2007-2017"

i=1
while [ "$i" -le 11 ]; do
	download_unzip "$OLD/bcs_map_pack_n_yo_ass-$i.zip" "yoass-$i.zip"
	i=$((i + 1))
done
download_unzip "$NEW/bcs_map_pack_n_yo_ass-12.zip" "yoass-12.zip"
download_unzip "$NEW/bcs_map_pack_n_yo_ass-13.zip" "yoass-13.zip"

download_unzip "$KP_BASE/main/maps/map-packs/bagman_mappack.zip" "bagman_mappack.zip"
download_unzip "$KP_BASE/main/maps/map-packs/openrift_mappack.zip" "openrift_mappack.zip"
download_unzip "$KP_BASE/server/official/original_dm_maps.zip" "original_dm_maps.zip"
download_unzip "$KP_BASE/server/official/original_bm_maps.zip" "original_bm_maps.zip"

# Rotation lists for Monkey Mod
find "$MAPS_DIR" -maxdepth 1 -type f -iname '*.bsp' -printf '%f\n' |
	sed 's/\.[Bb][Ss][Pp]$//' |
	grep -viE '^(team_|ctf|bagman)' |
	sort -u > /kingpin/mmod_dm/maps.txt || true

find "$MAPS_DIR" -maxdepth 1 -type f -iname '*.bsp' -printf '%f\n' |
	sed 's/\.[Bb][Ss][Pp]$//' |
	grep -iE '^(team_|.*bagman|.*bm_)' |
	sort -u > /kingpin/mmod_bm/maps_bm.txt || true
cp -f /kingpin/mmod_bm/maps_bm.txt /kingpin/mmod_bm/maps.txt

echo "Map download done. BSP count: $(find "$MAPS_DIR" -maxdepth 1 -iname '*.bsp' | wc -l)"
