---
name: Windows 上用 python 而不是 python3
description: 在该用户的 Windows 环境里调用 Python 必须用 `python`，不要用 `python3`
type: feedback
originSessionId: 1e05c591-5b7d-47c6-9419-66331eb759dc
---
在该用户 Windows 机器的 bash 里运行 Python 脚本时，必须用 `python`，不要用 `python3`。

**Why:** `python3` 会触发 Microsoft Store 的占位符（exit code 49），而该用户的 Microsoft Store 连不上网，无法安装。系统里已经装好了可用的 `python`，直接用即可。用户明确说过：不要用 Microsoft Store 下载东西。

**How to apply:** 任何需要执行 Python 脚本的场景（含 heredoc、`-c`、脚本文件）都用 `python xxx`。如果误用 `python3` 拿到 exit 49 或弹出 Store，立即切到 `python` 重试，不要尝试安装。需要新软件包时也优先用其它来源（官网、winget 等），避免 Store。
