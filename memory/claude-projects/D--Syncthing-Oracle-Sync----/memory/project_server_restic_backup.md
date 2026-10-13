---
name: project-server-restic-backup
description: 服务器备份使用 E 盘 restic 仓库；不要用 WSL rsync 首次逐文件写 NTFS，大目录会非常慢
metadata:
  node_type: memory
  type: project
  originSessionId: 019e807b-ea57-76f0-b15c-c97d4ab3b2a9
---

`D:\Syncthing\Oracle-Sync\服务器` 的服务器备份方案使用 WSL Ubuntu + restic，目标为 `E:\366256\服务器备份`。

当前可重复脚本：

- `backup_servers_restic.ps1`：Windows PowerShell 启动器
- `backup_servers_restic.sh`：WSL/restic 主脚本
- `verify_restic_server_backups.sh`：校验脚本
- `SERVER_BACKUP.md`：运行手册

截至 2026-06-01，备份范围为 1-4 号服务器；5 号服务器按用户要求不备份。

重要坑点：

- 不要用 WSL `rsync --link-dest` 作为大目录首次备份直接写 Windows NTFS 盘。3 号服务器 `/home/ubuntu` 小文件很多，逐文件写 `E:` 会极慢，看起来像卡死。
- 使用 restic staging：远端 `tar | gzip -1 --rsyncable` 生成较大的归档文件，再交给 restic 去重入库，后续增量由 restic 内容块复用。
- SQLite 一致性导出要排除 `.cache`、浏览器缓存、`node_modules`、venv 等目录；否则 Chromium/Mesa 缓存 `.db` 会被误判成业务数据库并留下失败标记。
- 3 号 ZeroTier SSH 曾在长时间备份后拒绝握手，脚本使用公网 IP `159.54.181.175` 备份 3 号。
