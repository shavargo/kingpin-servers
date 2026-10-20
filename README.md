# Kingpin servers — DM / CTF / Bagman

| Server | Mode       | UDP port | Connect              |
|--------|------------|----------|----------------------|
| DM     | Deathmatch | 31510    | `connect IP:31510`   |
| CTF    | Colors CTF | 31511    | `connect IP:31511`   |
| Bagman | Monkey Mod | 31512    | `connect IP:31512`   |

## Recommended on this PC: native Windows

Docker Desktop + 32-bit Linux is unreliable for Kingpin UDP. Use the Windows KPDED2 setup:

```
%USERPROFILE%\kingpin-servers\windows\
```

**Start all three:** double-click `start-all.bat`  
**Stop all:** `stop-all.bat`  
Or use `start-dm.bat` / `start-ctf.bat` / `start-bagman.bat` individually.

Configs:

- `windows\mmod_dm\server.cfg` — DM hostname / fraglimit / maps  
- `windows\mmod_bm\server.cfg` — Bagman cashlimit / maps  
- `windows\ctf\server.cfg` — CTF settings  
- `windows\*\comp.ini` — admin password, map voting, MOTD  

`windows\main` is a junction to your Steam `Kingpin\main` folder (game data).

Forward **UDP 31510–31512** on your router for public play. Servers register with `master.kingpin.info`.

## Docker (Linux VPS)

For a real Linux host / VPS:

```bash
cd ~/kingpin-servers   # copy this project over
docker compose up -d --build
```

Optional host networking:

```bash
docker compose -f docker-compose.yml -f docker-compose.linux.yml up -d --build
```

Edit `game/*/server.cfg`, then `docker compose up -d --build` (configs are baked into the image).
