---
name: win-long-path-delete
description: 本机删除超长路径目录（Electron/node_modules）：PowerShell 5.1 Remove-Item 会栽 260 限制，用 Git Bash rm -rf
metadata: 
  node_type: memory
  type: project
  originSessionId: 21ff2fcf-30f5-47f1-ac10-4784d30b0217
  modified: 2026-07-25T14:39:30.806Z
---

本机（Win11 + PowerShell 5.1）删除含超长路径的目录树（Electron 应用副本、devtools-frontend、深层 node_modules）时，`Remove-Item -Recurse -Force` 会报 "Could not find a part of the path" / "The directory is not empty" 而残留大量文件；调用方若吞错（如 codex-plusplus 卸载器的 SilentlyContinue）就表现为"清理成功但目录还在"。

**Why:** Win32 MAX_PATH 260 字符限制；PowerShell 5.1 不走长路径 API。

**How to apply:** 直接用 Git Bash 的 `rm -rf "/c/..."`（MSYS2 走 NT 长路径 API，实测一次删净 1.6GB Electron 副本）。robocopy 空目录 `/MIR` 镜像法也可行，但 `/MIR` 参数会被 Claude Code 沙盒误判为系统路径而拦截，需单独一条命令跑。见 [[codex-plusplus-uninstalled]]。
