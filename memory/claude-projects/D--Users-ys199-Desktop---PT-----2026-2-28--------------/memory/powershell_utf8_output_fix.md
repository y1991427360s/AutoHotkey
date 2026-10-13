---
name: powershell-utf8-output-fix
description: 从 Git Bash 调 PowerShell 中文乱码的修复——强制 UTF-8 输出
metadata: 
  node_type: memory
  type: reference
  originSessionId: 56dd801d-21c4-42fe-bc4a-a80ba59e37aa
---

从 Bash 工具调用 PowerShell 时，中文报错/输出乱码（`�޷�` 这类）。根因：系统 locale zh-CN，PowerShell 默认 GBK(936) 输出，Git Bash 按 UTF-8 解码。

**修复（每次调用都加，最可靠）**：命令最前面加
`[Console]::OutputEncoding=[System.Text.Encoding]::UTF8; <命令>`

即：`powershell -NoProfile -Command "[Console]::OutputEncoding=[System.Text.Encoding]::UTF8; ..."`

注意 agent 的 Bash 工具用 `-NoProfile`，所以 profile 对它无效，必须每次内联前缀。已为交互式终端创建 `D:\Users\ys199\Documents\WindowsPowerShell\profile.ps1`（内含同一行），那个只对手动开的 PowerShell 生效。

**跑 .ps1 脚本文件时**：不要用 `-File`（没法在前面插编码设置），改用 `-Command "[Console]::OutputEncoding=[System.Text.Encoding]::UTF8; & 'D:\path\xxx.ps1'"`。

**不要套 `cmd.exe /c "powershell ... -File \"...\""`**：三层引号会把路径搞坏，PowerShell 报"路径含非法字符"+exit 127。直接从 bash 调 powershell，不需要 cmd 这层。

环境见 [[user-platform-windows-wezterm]]。
