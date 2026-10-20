# Kingpin servers (DM / CTF / Bagman)

Docker image builds from [kingpin.info](https://www.kingpin.info/download/) — KPDED2, Monkey Mod, Colors CTF, and the same community map packs as **kingpin-launcher**.

| Coolify app | Compose file | Hostname | UDP |
|-------------|--------------|----------|-----|
| kingpin-dm | `docker-compose.dm.yml` | Shavargo's Kingpin DM | 31510 |
| kingpin-ctf | `docker-compose.ctf.yml` | Shavargo's Kingpin CTF | 31511 |
| kingpin-bagman | `docker-compose.bagman.yml` | Shavargo's Kingpin Bagman | 31512 |

Repo: https://github.com/shavargo/kingpin-servers (private)

## Map packs (downloaded at image build)

- Official stock DM + BM maps
- **map-pack-n-yo-ass** parts 1–13
- **bagman_mappack.zip**
- **openrift_mappack.zip**
- Colors CTF v1.1 client maps

## Coolify (one application per mode)

1. Project **Kingpin** → **+ Add Resource** (repeat three times)
2. **Private Repository (with Deploy Key)** → `git@github.com:shavargo/kingpin-servers.git`
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
```

Configs: `configs/mmod_dm/`, `configs/mmod_bm/`, `configs/ctf/`.
