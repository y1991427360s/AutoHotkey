---
name: ribbon-multi-replace-ipc
description: 文字替换面板支持多组词，ribbon→LISP 用 COUNT+索引环境变量传多组
metadata: 
  node_type: memory
  type: project
  originSessionId: 47b32f72-1521-459e-b3fe-05ab1b6ca8ba
---

文字替换面板（`ReplacePanelForm`）已支持「一次填多组词、一次性替换」。设计要点（非显而易见，改这块前先看这里）：

- **输入约定**：查找框/替换框都是多行 TextBox，第 N 行 ↔ 第 N 行配对。回车=换行（加一组），Ctrl+Enter 或点「替换」按钮才执行。查找行为空整组跳过；替换行留空=删除该词。
- **传参约定（C#→LISP）**：不能走单组的 `AICAD_RIBBON_REPLACE_SEARCH/VALUE` 老变量传多行——因为 `EscapeForLisp` 会把 `\r\n` 换成空格，换行会丢。所以 `ExecuteReplace` 把多行拆成组后，用 `AICAD_RIBBON_REPLACE_COUNT` + `AICAD_RIBBON_REPLACE_SEARCH_<i>` / `..._VALUE_<i>`（i 从 1 起）一组组下发，每个值都是单行。
- **LISP 端**：`aicad:command-ribbon-replace` 读 COUNT 循环取索引变量拼 pairs（保留老单组变量的兼容分支），交给 `aicad:run-ribbon-replacement-pairs` → `aicad:apply-text-replacements`（该函数本就支持多组 pairs，是这次复用的基础）。
- 底层 RETXT 走 bridge 的路径用的是另一套键名 `REPLACE_COUNT` / `REPLACE_PAIR_<i>_SEARCH|REPLACE`（见 `aicad:replace-pairs-from-result`），别和 ribbon 这套环境变量名混淆。

相关：[[ribbon-dll-build-lock]]
