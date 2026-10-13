---
name: AutoLISP / CAD 文件必须用 GBK + CRLF
description: 本项目所有 .lsp/.dcl/.scr/.mnl 等 CAD 文件必须是 ANSI/GBK 编码 + Windows CRLF，禁止 UTF-8
type: feedback
originSessionId: fac3c690-0b96-4384-9811-f565c88c716c
---
AutoCAD 2018 在读取 .lsp 等插件源文件时，只能正确识别 ANSI/GBK 编码的中文。本项目所有 `.lsp`、`.dcl`、`.scr`、`.mnl`、`.lin`、`.pat` 文件必须满足：
- 编码：ANSI / GBK（禁止 UTF-8、UTF-8 BOM、UTF-16）
- 换行：Windows CRLF（`\r\n`）
- 中文字符串在 AutoCAD 2018 里必须正常显示，出现乱码即视为严重 bug

**Why:** 用户使用 AutoCAD 2018（中文版），UTF-8 的 lsp 文件里的中文字符串、命令提示、错误消息在 CAD 里会显示成问号或方块，用户之前已经因此返工过多次。

**How to apply:**
- 修改任何本项目（或其它 CAD 相关）的 `.lsp/.dcl/...` 文件前，先检查编码（`open(p,'rb').read()[:3]` 查 BOM、尝试 GBK strict 解码）。
- 不要用 Edit/Write 工具直接编辑这些文件 — 那些工具按 UTF-8 读写，会破坏 GBK 字节（详见 `feedback_lsp_edit_method.md`）。
- 用 Python 生成/写文件时，必须显式 `encoding='gbk'`。
- 用 PowerShell 写文件时，禁止默认编码；用 `[System.Text.Encoding]::GetEncoding(936)` 或 `Out-File -Encoding Default`。
- C# 源码允许 UTF-8，但与 CAD 交互的字符串要验证 2018 中不乱码。
- 测试必须在 Windows 原生 AutoCAD 2018 中进行，WSL2 结果不作数。
