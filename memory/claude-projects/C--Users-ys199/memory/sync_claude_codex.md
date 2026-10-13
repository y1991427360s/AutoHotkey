---
name: Sync global memory between Claude, Codex, and Syncthing backup
description: CLAUDE.md / AGENTS.md / Syncthing 备份三处必须保持一致，改一处立即同步另外两处
type: feedback
originSessionId: 5b841f13-a31d-45ce-b2a1-b4c67f085d96
---
三个文件必须始终内容一致：
1. `C:\Users\ys199\.claude\CLAUDE.md`（Claude Code 全局记忆）
2. `C:\Users\ys199\.codex\AGENTS.md`（Codex 全局记忆）
3. `D:\Syncthing\Oracle-Sync\公司的电脑\CLAUDE.md` 和 `D:\Syncthing\Oracle-Sync\公司的电脑\AGENTS.md`（跨电脑 Syncthing 备份源）

**Why:** 用户同时使用 Claude Code 和 Codex，希望两个工具共享同一套全局上下文；同时通过 Syncthing 把备份分发到多台电脑，所以 Syncthing 目录里的副本也必须随时是最新版本。

**How to apply:** 任何对全局记忆的修改（新增/调整/删除）写完后，立即用 `cp` 把同一份内容覆盖到另外两个位置，并用 `diff` 验证三处完全一致后再结束任务。命令模板：
```
cp /c/Users/ys199/.claude/CLAUDE.md /c/Users/ys199/.codex/AGENTS.md
cp /c/Users/ys199/.claude/CLAUDE.md "/d/Syncthing/Oracle-Sync/公司的电脑/CLAUDE.md"
cp /c/Users/ys199/.codex/AGENTS.md  "/d/Syncthing/Oracle-Sync/公司的电脑/AGENTS.md"
```
