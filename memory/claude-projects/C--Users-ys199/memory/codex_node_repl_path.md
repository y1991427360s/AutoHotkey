---
name: codex-node-repl-path
description: Codex 更新后 node_repl MCP 报 os error 3，因 config.toml 指向被轮换掉的旧哈希二进制目录
metadata: 
  node_type: memory
  type: reference
  originSessionId: 2d88679f-045c-43f9-b18c-4d1c6e1ada28
---

Codex CLI 每次自动更新（如 0.130→0.135）会在 `C:\Users\ys199\AppData\Local\OpenAI\Codex\bin\<内容哈希>\` 下生成**新哈希**子目录并删掉旧哈希目录，但 `~/.codex/config.toml` 里 `[mcp_servers.node_repl]` 块仍指向旧哈希路径 → 启动时报 `MCP client for node_repl failed to start: 系统找不到指定的路径 (os error 3)`。Codex **不会**自愈这个块。

**修复**：把 node_repl 块里失效的路径重指向当前最新（mtime 最新、与运行版本匹配）的哈希二进制：
- `command` → `...\bin\<新hash>\node_repl.exe`
- `[mcp_servers.node_repl.env].CODEX_CLI_PATH` → `...\bin\<新hash>\codex.exe`
- `NODE_REPL_NODE_PATH` → 现有 node.exe（node 版本通常不变，旧哈希可能仍在，先 Test-Path）

**坑**：不要图省事指向 `bin\` 顶层的 `node_repl.exe / codex.exe / node.exe` —— 那是旧版残留（实测顶层 codex.exe 是 0.130，而运行的是 0.135），版本会不匹配。要选 mtime 最新、与运行版本一致的哈希目录。改完**重启 Codex** 才生效。

定位命令：`Glob C:\Users\ys199\AppData\Local\OpenAI\Codex\bin\**\*.exe` 看现存哈希目录，再用 PowerShell `Get-Item` 比 mtime/大小。详见 [[codex_apps_subscription]] 同属 Codex 运维。
