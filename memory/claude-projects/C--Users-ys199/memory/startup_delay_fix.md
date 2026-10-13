---
name: startup-delay-fix
description: Windows 开机自启动慢——关掉启动文件夹的 ~10 秒全局延迟
metadata: 
  node_type: memory
  type: reference
  originSessionId: 4a928657-0f3d-4665-8130-38208a033f52
---

Windows 10/11 对「启动文件夹（shell:startup）+ 注册表 Run 键」里的程序**有意延迟启动**：默认开机后约 10 秒才开始拉起，且是串行逐个启动。这是设计行为，不是电脑卡。

关掉全局延迟：注册表 `HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize` 下新建 DWORD `StartupDelayInMSec = 0`（该 `Serialize` 键默认不存在，需先 New-Item 创建），**重启生效**，可逆（删值即恢复默认）。

PowerShell 一键：
```
$p='HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize'; if(-not (Test-Path $p)){New-Item -Path $p -Force|Out-Null}; Set-ItemProperty $p -Name StartupDelayInMSec -Value 0 -Type DWord
```

局限：去延迟后**仍是串行排队**，启动项之间一个接一个，不并行。要并行 + 各自精确控时，需改用任务计划程序「登录时触发」，把 .lnk 逐个迁过去。

2026-06-05 已在 ys199 机器设置（启动文件夹有 ClipboardSaver/CopyQ/dwg-peek/桌宠/ShareX/Snipaste/mouse_counter/ZeroTier 等 8 项）。相关：[[windows_profile_paths]]。
