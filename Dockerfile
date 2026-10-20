FROM i386/debian:bookworm-slim

RUN apt-get update \
	&& apt-get install -y --no-install-recommends ca-certificates curl unzip findutils \
	&& rm -rf /var/lib/apt/lists/*

WORKDIR /kingpin

ARG KP_BASE=https://www.kingpin.info/download/kingpin

# Core server binaries + mods + CTF (from kingpin.info)
RUN set -eux; \
	mkdir -p /tmp/dl /kingpin/main/maps; \
	curl -fsSL "$KP_BASE/server/unofficial/kpded2/linux/kpded2-linux.zip" -o /tmp/dl/kpded2.zip; \
	unzip -qo /tmp/dl/kpded2.zip -d /tmp/dl/kpded2; \
	cp /tmp/dl/kpded2/kpded2 /kingpin/kpded2; \
	chmod +x /kingpin/kpded2; \
	curl -fsSL "$KP_BASE/server/mods/monkey_mod/server_files/linux/monkeymod200-linux.zip" -o /tmp/dl/mmod.zip; \
	unzip -qo /tmp/dl/mmod.zip -d /tmp/dl/mmod; \
	cp -a /tmp/dl/mmod/mmod /kingpin/mmod_dm; \
	cp -a /tmp/dl/mmod/mmod /kingpin/mmod_bm; \
	curl -fsSL "$KP_BASE/server/mods/colors_ctf/server_files/ctf_v16_server_linux.zip" -o /tmp/dl/ctf_srv.zip; \
	unzip -qo /tmp/dl/ctf_srv.zip -d /tmp/dl/ctf_srv; \
	cp -a /tmp/dl/ctf_srv/ctf /kingpin/ctf; \
	curl -fsSL "$KP_BASE/server/mods/colors_ctf/client_files/ctf_v11_client.zip" -o /tmp/dl/ctf_cli.zip; \
	unzip -qo /tmp/dl/ctf_cli.zip -d /tmp/dl/ctf_cli; \
	cp -a /tmp/dl/ctf_cli/ctf/. /kingpin/ctf/; \
	printf '\n' > /kingpin/mmod_dm/default.cfg; \
	printf '\n' > /kingpin/mmod_bm/default.cfg; \
	printf '\n' > /kingpin/ctf/default.cfg; \
	rm -rf /tmp/dl

# Community map packs (same yo-ass + bagman set as kingpin-launcher)
COPY scripts/download-maps.sh /tmp/download-maps.sh
RUN chmod +x /tmp/download-maps.sh \
	&& /tmp/download-maps.sh /kingpin /tmp/mapdl \
	&& rm -f /tmp/download-maps.sh

# Server configs (hostnames, limits, admin)
COPY configs/mmod_dm/server.cfg configs/mmod_dm/comp.ini /kingpin/mmod_dm/
COPY configs/mmod_bm/server.cfg configs/mmod_bm/comp.ini /kingpin/mmod_bm/
COPY configs/ctf/server.cfg configs/ctf/comp.ini /kingpin/ctf/
COPY configs/ctf/server.cfg /kingpin/ctf/server.cfg.template
COPY scripts/apply-server-env.sh scripts/entrypoint-ctf.sh /kingpin/

# Keep generated map rotation files if present; fall back to config copies
COPY configs/mmod_bm/maps_bm.txt /kingpin/mmod_bm/maps_bm.txt.bak
RUN if [ ! -s /kingpin/mmod_bm/maps_bm.txt ]; then cp /kingpin/mmod_bm/maps_bm.txt.bak /kingpin/mmod_bm/maps_bm.txt; fi \
	&& cp -f /kingpin/mmod_bm/maps_bm.txt /kingpin/mmod_bm/maps.txt \
	&& rm -f /kingpin/mmod_bm/maps_bm.txt.bak \
	&& chmod +x /kingpin/entrypoint-ctf.sh /kingpin/apply-server-env.sh \
	&& chown -R nobody:nogroup /kingpin

USER nobody
ENV KP_PORT=31511
ENTRYPOINT ["/kingpin/entrypoint-ctf.sh"]
