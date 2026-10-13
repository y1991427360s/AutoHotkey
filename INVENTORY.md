# 本机 AutoHotkey 配置清单

盘点日期：2026-08-06

## AutoHotkey 安装

- AutoHotkey v2 安装目录：`C:\Program Files\AutoHotkey\v2\`
- 默认解释器：`C:\Program Files\AutoHotkey\v2\AutoHotkey.exe`
- 64 位解释器：`C:\Program Files\AutoHotkey\v2\AutoHotkey64.exe`
- UIAccess 解释器也已安装。
- 安装程序自带 `WindowSpy.ahk`、帮助文件和 UX 脚本；这些属于程序安装文件，没有复制进项目。

## 用户脚本

原目录：`D:\Users\ys199\Documents\AutoHotkey\`

- `claude-injection-dialog-guard.ahk`：关闭已知终端管控 DLL 注入引起的 Claude Code“损坏的映像”弹窗。
- `dwg-peek.ahk`：资源管理器或桌面选中 DWG 后按空格，用 CAD快速看图打开。
- `excel-command-panel.ahk`：旧版 Excel 命令面板副本，不是当前现役主代码。
- `excel-dedupe-sort-b-column.ahk`：旧的 Excel B 列去重和分组脚本。
- `excel-prefix-selected-cells.ahk`：旧的 Excel 批量加前缀脚本。
- `voice-input/`：`Ctrl+Shift+Space` 录音、调用内网语音识别并粘贴结果。
- `disabled-startup-backup/`：两个已停用旧 Excel 脚本的启动项备份。

## 现役 Excel/WPS 面板

- 当前项目：`E:\366256\vibecoding\AutoHotkey\projects\excel-ahk-command-panel\`
- 主脚本：`src\excel-command-panel.ahk`
- 安装/重载：`install.ps1`
- 热键：`Ctrl+Shift+E`
- 面板支持选中 DWG 后选择 AutoCAD 2018、中望 CAD 2026 或 CAD快速看图打开。
- D 盘的 `excel-command-panel.ahk` 与现役主脚本内容不同，属于旧版。

## 开机启动

启动目录：`C:\Users\ys199\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\`

盘点时存在的 AutoHotkey 相关入口：

- `claude-injection-dialog-guard.lnk`
- `excel-command-panel.lnk`

盘点时未发现全局记忆中提到的 `dwg-peek.lnk` 和 `cad-chrome-anti-lag.lnk`；其中 `cad-chrome-anti-lag.ahk` 在约定的 D 盘脚本目录也不存在。

## 编辑器插件

检查了 VS Code、Cursor 和 Windsurf 的用户扩展目录，没有发现名称或扩展清单中声明 AutoHotkey 的专用扩展。已安装 AutoHotkey v2 运行环境，但没有发现可确认的 AutoHotkey 编辑器插件。

## AI 规则与记忆

- 全局 Claude 规则：`C:\Users\ys199\.claude\CLAUDE.md`
- 全局 Codex 规则：`C:\Users\ys199\.codex\AGENTS.md`
- 全局 Antigravity 规则：`C:\Users\ys199\.antigravity\ANTIGRAVITY.md`
- 三份全局规则盘点时大小均为 36047 字节，内容随后按哈希校验。
- Claude 项目记忆位于 `C:\Users\ys199\.claude\projects\<项目编码>\memory\`，并非单一文件。

## 本次集中方式

当前先复制、校验并保留原路径。原因是原文件正在被开机启动项、Claude Code、Codex 和 Antigravity 按固定路径读取。直接移动原件会立即破坏运行配置。
