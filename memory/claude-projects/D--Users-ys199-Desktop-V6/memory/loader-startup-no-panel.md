---
name: loader-startup-no-panel
description: AICAD loader 应随 ZWCAD 自动加载插件本体，但不能在打开图纸时自动弹出替换面板
metadata: 
  node_type: memory
  type: project
  originSessionId: 33a1a682-d0f7-470f-8d31-f35fa5e9d4b4
  modified: 2026-07-20T05:52:21.506Z
---

AICAD 的 `aicad_aa_loader.lsp` 应保留在 ZWCAD Startup Suite 中自动加载，并在文件末尾执行 `(c:LOADAICADAA)` 来加载 `aicad_extension.lsp` 与 Ribbon DLL；但默认不能自动执行 `AICADREPLACEPANEL` 弹出替换面板。

**Why:** 用户要的是插件能力和 Ribbon 自动可用，但打开图纸时不要被替换框打扰；曾误解为“完全不自动加载插件”，导致插件入口消失。

**How to apply:** 修改启动行为时区分“加载插件本体”和“显示替换面板”。替换面板默认由用户手动执行 `AICADREPLACEPANEL` 或 `AICADREPLACEPANELSHOW` 打开；只有明确要求自动弹框时才改 `*AICAD_ReplacePanelOnLoad*`。

相关：[[ribbon-dll-build-lock]] [[ribbon-multi-replace-ipc]]
