# Kingpin servers (DM / CTF / Bagman)

Docker images build from [kingpin.info](https://www.kingpin.info/download/) — KPDED2, Monkey Mod / Botmatch, Colors CTF, and the same community map packs as **kingpin-launcher**.

| Coolify app | Compose file | Hostname | UDP | Runtime |
|-------------|--------------|----------|-----|---------|
| kingpin-dm | `docker-compose.dm.yml` | Shavargo's Kingpin DM | 31510 | Wine + Hypov8 Botmatch v37 |
| kingpin-ctf | `docker-compose.ctf.yml` | Shavargo's Kingpin CTF | 31511 | Native Linux KPDED2 |
| kingpin-bagman | `docker-compose.bagman.yml` | Shavargo's Kingpin Bagman | 31512 | Wine + Hypov8 Botmatch v37 |

Repo: https://github.com/shavargo/kingpin-servers

**Bots (DM / Bagman):** AceBots only ship as a Windows `gamex86.dll`, so those two apps use `Dockerfile.bots` (Wine + Xvfb). Bots spawn after the first human joins. CTF stays on the Linux Monkey/CTF image (`Dockerfile`).

## Map packs (downloaded at image build)

- Official stock DM + BM maps
- **map-pack-n-yo-ass** parts 1–13
- **bagman_mappack.zip**
- **openrift_mappack.zip**
- Colors CTF v1.1 client maps (CTF image)

## Coolify (one application per mode)

1. Project **Kingpin** → **+ Add Resource** (repeat three times)
2. **Public Repository** → `https://github.com/shavargo/kingpin-servers.git` (no deploy key)
3. Build pack: **Docker Compose**
4. Compose file: `/docker-compose.dm.yml` (then `.ctf.yml`, then `.bagman.yml`)
5. Name each app `kingpin-dm` / `kingpin-ctf` / `kingpin-bagman`
6. Deploy each (first build downloads map packs — slow; later builds use cache)
7. Open host firewall **UDP 31510–31512**

## Local / VPS CLI

```bash
# All three
docker compose up -d --build

# One mode
docker compose -f docker-compose.dm.yml up -d --build
docker compose -f docker-compose.bagman.yml up -d --build
docker compose -f docker-compose.ctf.yml up -d --build
```

Configs: `configs/compbots/` (DM/Bagman bots), `configs/ctf/`, legacy `configs/mmod_*` (Linux Monkey Mod).

## Environment variables (Coolify)

Set these on each Coolify app (or in compose). Unset = keep baked-in `server_*.cfg` defaults. Restart/redeploy after changes.

| Variable | Applies to | Example |
|----------|------------|---------|
| `KP_HOSTNAME` | all | `Shavargo's Kingpin DM` |
| `KP_PORT` | all | `31510` |
| `KP_MAXCLIENTS` / `KP_MAX_PLAYERS` | all | `16` |
| `KP_PUBLIC` | all | `1` |
| `KP_MASTER` | all | `master0.kingpin.info master1.kingpin.info master2.kingpin.info master3.kingpin.info` |
| `KP_MAP` | all | `kpdm5` / `team_pv` / `ctf_terminal` |
| `KP_FRAGLIMIT` | all | `30` |
| `KP_TIMELIMIT` | all | `20` |
| `KP_DMFLAGS` | all | `788` |
| `KP_PROPS` | all | `1` |
| `KP_IDLE_CLIENT` | all | `120` |
| `KP_BOTSKILL` | DM / Bagman | `2` (0–4) |
| `KP_BOT_MAX` | DM / Bagman | `8` |
| `KP_BOT_MAX_PLAYERS` | DM / Bagman | `12` |
| `KP_CASHLIMIT` | Bagman | `3000` |
| `KP_CAPTURELIMIT` | CTF | `0` |
| `KP_MODE` | bots image | `dm` or `bm` |

See `.env.example`.
