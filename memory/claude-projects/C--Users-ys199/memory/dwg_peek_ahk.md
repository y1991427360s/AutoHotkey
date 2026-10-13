---
name: DWG 空格预览 AHK 脚本
description: D:\Users\ys199\Documents\AutoHotkey\dwg-peek.ahk 在 Win11 上的关键设计约束，避免再次踩坑
type: project
originSessionId: d09b9e5a-b9c4-4aea-9d9f-67aff72def8d
---
`dwg-peek.ahk`：在文件资源管理器/桌面里选中 .dwg 后按空格，用 CAD快速看图打开。

**为什么用剪贴板而不是 Shell.Application COM**：
Win11 22H2+（包含 26200）的多标签 Explorer 存在 stale-tab bug —— `Shell.Application.Windows` 枚举到的 `Document.FocusedItem` / `SelectedItems[0]` 会返回别的 tab 或历史残留项，不是当前选中文件。亲测点 DWG 拿到的是上次操作过的 PDF。

**Why**：COM 接口在多 tab 下不可靠；`Ctrl+C` 永远作用于前台活动 tab 的真实选中项。
**How to apply**：以后写 "拿 Explorer 选中项" 的 AHK，跳过 Shell COM，直接走剪贴板法。

**为什么要 disable/enable CopyQ**：
用户装了 CopyQ（路径 `D:\CopyQ\copyq.exe`），脚本 Ctrl+C 取路径时会被 CopyQ 抓到，污染剪贴板历史（出现 `file:///...dwg` 条目）。脚本用 `copyq disable` → Ctrl+C → 还原剪贴板 → `copyq enable` 包住整段操作。

**How to apply**：任何用 AHK 临时借剪贴板取数据的脚本，如果用户机上跑着 CopyQ，都要这样包一下；否则 CopyQ 历史会被污染。
