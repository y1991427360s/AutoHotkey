---
name: ribbon-dll-build-lock
description: 构建 AICADRibbonHostV6.dll 时被运行中的 ZWCAD 占用导致 CS0016，必须先关 CAD
metadata: 
  node_type: memory
  type: project
  originSessionId: 47b32f72-1521-459e-b3fe-05ab1b6ca8ba
---

`build_zwcad_ribbon.ps1` 重新生成 `AICADRibbonHostV6.dll` 时，如果 ZWCAD 还开着（DLL 已 NETLOAD），输出阶段会报 `error CS0016: 未能写入输出文件 ...AICADRibbonHostV6.dll --“另一个程序正在使用此文件”`。

**注意**：CS0016 是「源码已编译成功、仅卡在写文件」的标志，不是语法错误。

- 要发布正式 DLL：先**完全关闭 ZWCAD**再 `.\build_zwcad_ribbon.ps1`。
- 只想验证 C# 能否编译（CAD 还开着也行）：`.\build_zwcad_ribbon.ps1 -OutputName "AICADRibbonHostV6_test.dll"` 输出到临时名，验证完删掉。
- 重载到 ZWCAD 无需手动操作：loader（`aicad_aa_loader.lsp`）在 ZWCAD 启动时自动 NETLOAD 新 DLL 并加载 `aicad_extension.lsp`。改完构建后重开 CAD 即生效。

相关：[[ribbon-multi-replace-ipc]]
