---
name: startup-folder-disabled-files
description: "启动文件夹里不能留任何非 .lnk 文件（如 .disabled），否则开机弹\"选择应用\"对话框"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: f58a6678-e45a-4ae1-b959-7881750a4c65
---

停用启动项时不要把文件改名成 `.disabled` 留在 `Startup` 文件夹里——Windows 开机会尝试打开启动文件夹里的每个文件，未知扩展名会弹"选择一个应用以打开此 .disabled 文件"对话框。

**Why:** 2026-06-12 实测：excel 旧脚本启动项改名 `.lnk.disabled` 留在原地，导致每次开机弹窗。

**How to apply:** 停用启动项直接把文件移出启动文件夹（备份目录 `D:\Users\ys199\Documents\AutoHotkey\disabled-startup-backup\`）。另：微信/钉钉自启动条目在 HKCU Run 键，路径分别为 `E:\366256\APP\Weixin\Weixin.exe` 和 `D:\DingDing\main\current\DingTalk.exe`，丢失时用 PowerShell Set-ItemProperty 补回。
