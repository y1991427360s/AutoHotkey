---
name: 禁止用 Edit/Write 直接改 GBK 文件，必须用 Python 字节级读写
description: Claude Code 的 Edit/Write 工具按 UTF-8 处理文件，会把 GBK 文件中的中文字节批量替换成 \xef\xbf\xbd 导致整文件不可逆损坏
type: feedback
originSessionId: fac3c690-0b96-4384-9811-f565c88c716c
---
Claude Code 的 `Edit` 和 `Write` 工具内部以 UTF-8 编解码文件。对 GBK 编码的 `.lsp`/`.dcl`/`.scr` 等文件直接调用这两个工具，会把所有无法用 UTF-8 解析的中文字节替换成 U+FFFD (`\xef\xbf\xbd`)，**一次操作就能损坏整个文件的中文**，且原字节不可恢复。

**Why:** 实际发生过 — 2026-05-12 本会话在 `AA整合版本.lsp` 上一次 Edit 操作，造成 134 处损坏字节、438 行乱码，最终只能回滚到 5 天前的备份并丢失了中间改动。

**How to apply:**
- 对任何 GBK 编码的 CAD 相关文件（`.lsp/.dcl/.scr/.mnl/.lin/.pat`），**禁止使用** `Edit`、`Write`、`NotebookEdit` 工具。
- 必须用 `Bash` 调 Python 做字节级读写：
  ```python
  text = open(path, 'rb').read().decode('gbk')   # 读
  # ...修改 text...
  out = text.replace('\n', '\r\n').encode('gbk') # 写
  open(path, 'wb').write(out)
  ```
- 补丁内容含中文时，优先用 GBK 字节字面量（`b'\xb8\xfc\xd0\xc2'`）再 `.decode('gbk')` 生成字符串，避免 Edit 工具路径上的任何 UTF-8 转换。
- 每次写完立即验证：
  - `b'\xef\xbf\xbd' not in data`（无 UTF-8 替换字符）
  - `data.decode('gbk')` strict 解码不抛错
  - `b'\r\n' in data` 且无遗留 LF-only
- 改大文件前先 `cp` 一份 `.bak_YYYYMMDD` 备份，Python `shutil.copy` 也可。
- 一旦发现文件被 UTF-8 化，立刻停手从备份恢复，不要在损坏文件上继续打补丁。
