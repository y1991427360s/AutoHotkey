---
name: WSH s.Run + powershell -WindowStyle Hidden 在本机被拦截
description: 公司电脑 SJY-14000048 上 VBS 用 WshShell.Run 启动 `powershell.exe -WindowStyle Hidden` 会返回 0x80070312，疑似 Defender ASR
type: project
originSessionId: 4c0212ac-609a-4b29-b7d5-43c2874ca2e1
---
公司电脑 SJY-14000048（用户 ys199）上，VBS 脚本通过 `WshShell.Run "powershell.exe ... -WindowStyle Hidden -File ..."` 启动 PowerShell 时会失败：

```
Windows Script Host 错误 0x80070312
源: (null)
```

去掉 `-WindowStyle Hidden` 后立刻可用。`WshShell.Run` 第二个参数传 `0`（SW_HIDE）本来就够隐藏窗口，不需要再传 `-WindowStyle Hidden`。

**Why:** 几乎可以确定是 Defender 的 ASR 规则 "Block execution of potentially obfuscated scripts" 把 `-WindowStyle Hidden` 当成可疑模式拦了。直接跑 `powershell -WindowStyle Hidden ...` 正常，只有从 wscript/cscript 通过 `s.Run` 间接启动时才触发。

**How to apply:** 在这台电脑（以及任何同步过来的 .vbs 启动脚本）写 VBS 拉 PowerShell 时，不要加 `-WindowStyle Hidden`，靠 `s.Run cmd, 0, False` 隐藏即可。2026-05-25 已修复 `tools\pet.vbs` 和 `tools\open-sync-folder.vbs`。
