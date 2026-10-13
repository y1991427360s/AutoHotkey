---
name: AutoHotkey setup
description: 用户已装 AHK v2，脚本统一放在 D:\Users\ys199\Documents\AutoHotkey，开机自启通过 Startup 文件夹快捷方式
type: reference
originSessionId: 5b841f13-a31d-45ce-b2a1-b4c67f085d96
---
- AutoHotkey v2 已安装。
- 用户的 AHK 脚本目录：`D:\Users\ys199\Documents\AutoHotkey\`（已有 `VolumeToRCtrl.ahk`、`dwg-peek.ahk`）。
- 开机自启方式：在 `C:\Users\ys199\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\` 放快捷方式（`.lnk`），用 PowerShell 的 `WScript.Shell` COM 对象创建即可。

How to apply: 写新 AHK 脚本时直接放进该目录；要让脚本开机自启就在 Startup 文件夹建 .lnk，不要修改注册表 Run 键。
