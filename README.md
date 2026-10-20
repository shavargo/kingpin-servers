# Kingpin servers (DM / CTF / Bagman)

Docker image builds from [kingpin.info](https://www.kingpin.info/download/) — KPDED2, Monkey Mod, Colors CTF, and the same community map packs as **kingpin-launcher**.

| Service | Mode | UDP port |
|---------|------|----------|
| dm | Deathmatch | 31510 |
| ctf | Colors CTF | 31511 |
| bagman | Bagman | 31512 |

Repo: https://github.com/shavargo/kingpin-servers (private)

## Map packs (downloaded at image build)

- Official stock DM + BM maps
- **map-pack-n-yo-ass** parts 1–13
- **bagman_mappack.zip**
- **openrift_mappack.zip**
- Colors CTF v1.1 client maps

## Coolify

1. Project **Kingpin** → **+ Add Resource**
2. **Private Repository (with Deploy Key)** → `https://github.com/shavargo/kingpin-servers`
3. Build pack: **Docker Compose**, file `docker-compose.yml`
4. Deploy (first build ~2 GB map download — slow)
5. Open host firewall **UDP 31510–31512**

## Local / VPS CLI

```bash
docker compose up -d --build
```

Configs: `configs/mmod_dm/`, `configs/mmod_bm/`, `configs/ctf/`.
