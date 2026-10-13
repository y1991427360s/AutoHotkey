---
name: codex-plusplus-uninstalled
description: 用户曾装 codex-plusplus（Codex 桌面应用 tweak 注入器），2026-07-25 已彻底卸载
metadata: 
  node_type: memory
  type: project
  originSessionId: 21ff2fcf-30f5-47f1-ac10-4784d30b0217
  modified: 2026-07-25T14:39:30.009Z
---

用户电脑曾安装 GitHub `b-nnett/codex-plusplus`（给微软商店 OpenAI.Codex 桌面应用打补丁加载 tweak 的注入系统，装在 `~/.codex-plusplus`，补丁作用于自建应用副本 `%LOCALAPPDATA%\codex-plusplus\store-apps\`，正版应用不受影响）。2026-07-25 已按官方 `uninstall --purge` 彻底卸载并手动清除三处目录（`~/.codex-plusplus`、`%APPDATA%\codex-plusplus`、`%LOCALAPPDATA%\codex-plusplus`），释放约 2.2GB；快捷方式、右键菜单键、watcher 计划任务、PATH 均确认无残留。商店正版 Codex 应用与 npm 版 Codex CLI 均未动。若用户再提 "codex++"/"Codex++"，指的就是这个工具。删除超长路径目录的坑见 [[win-long-path-delete]]。
