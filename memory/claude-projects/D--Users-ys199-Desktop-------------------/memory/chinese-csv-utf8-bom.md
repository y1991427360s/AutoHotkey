---
name: chinese-csv-utf8-bom
description: 给 Excel 用的中文 CSV 必须写带 BOM 的 UTF-8（utf-8-sig），Write 工具默认裸 UTF-8 会导致 Excel 乱码
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 6da54a04-97e1-4b49-9c6d-3979249e39e5
---

凡是要给 Excel 双击打开的中文 CSV/文本文件，必须写成带 BOM 的 UTF-8（`utf-8-sig`），绝不能写裸 UTF-8。

**Why:** 中文 Windows 的 Excel 双击打开 CSV 时默认按 GBK（代码页 936）解析，裸 UTF-8 的中文必定乱码；带 BOM 后 Excel 才会按 UTF-8 读。Claude Code 的 Write/Edit 工具写文件默认是不带 BOM 的 UTF-8，2026-06-10 在多氟多电缆工具项目里用 Write 创建 `参数.csv`、`柜名别名.csv`、`强制规则.csv` 就踩了这个坑，用户打开全乱码。

**How to apply:** 创建/修改中文 CSV 时不要用 Write 工具，改用 python：`Path(...).write_text(text, encoding='utf-8-sig')` 或 `open(..., 'w', encoding='utf-8-sig', newline='')`。程序读 CSV 用 `utf-8-sig` 优先（自动剥 BOM），需兼容历史文件时按 `utf-8-sig → gbk → utf-16` 顺序尝试。此规则已写入用户全局记忆六处（[[global-memory-sync-rule]]：.claude/CLAUDE.md、.codex/AGENTS.md、.antigravity/ANTIGRAVITY.md 及 Syncthing 副本）。
