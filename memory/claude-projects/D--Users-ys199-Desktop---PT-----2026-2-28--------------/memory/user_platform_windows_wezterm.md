---
name: user-platform-windows-wezterm
description: 用户的终端环境是 Windows + WezTerm，从不用 Mac
metadata: 
  node_type: memory
  type: user
  originSessionId: 56dd801d-21c4-42fe-bc4a-a80ba59e37aa
---

用户在 **Windows 上使用 WezTerm** 作为终端，**没有 Mac、永远不会用 Mac**。任何排查终端/快捷键/编码问题时，只考虑 Windows + WezTerm + Git Bash (MINGW64) 的场景，不要给 macOS 的方案或假设。

PowerShell 中文输出乱码的根因：系统 locale 是 zh-CN，PowerShell 报错/输出走 GBK(936)，而 Git Bash 终端按 UTF-8 解码 → `�޷�` 这类乱码。修复见 [[powershell-utf8-output-fix]]。
