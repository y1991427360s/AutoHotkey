---
name: powershell-ps1-gbk-encoding
description: Windows PowerShell 5.1 reads .ps1 files as GBK — UTF-8 Chinese comments break parsing
metadata: 
  node_type: memory
  type: feedback
  originSessionId: f30a6bf0-66cd-4134-9c18-a83933235d5d
---

给这台 Windows 机器写 `.ps1` 脚本并用 `powershell.exe`（Windows PowerShell 5.1）跑时：**无 BOM 的 UTF-8 文件会被按系统 ANSI 代码页 GBK/936 解码**。脚本里只要有中文注释/字符串，多字节序列就被读乱，引号/括号失配，触发一连串 `表达式中缺少右")"` 之类的解析错误（错误行号往往指向中文之后的纯英文行，有迷惑性）。

2026-06-02 实测：纯英文内容的探针脚本全部正常，唯独带中文注释的 `gpu_spike_catcher.ps1` 解析失败退出码 1。

**Why:** powershell.exe 5.1 不像 PowerShell 7（pwsh，默认 UTF-8）那样默认按 UTF-8 读脚本文件。这和全局 CLAUDE.md「Git Bash 中文 / UTF-8 编码」小节记的 **stdout 输出编码**问题是不同层面——那个是输出编码，这个是脚本文件被**解析时的输入编码**。

**How to apply:** 给这台机写 `.ps1` 时，要么**正文全用 ASCII**（注释/Write-Host 用英文，中文只放进 `Add-Content` 写出的数据里，并配 `[Console]::OutputEncoding=[Text.Encoding]::UTF8`）；要么把文件存成**带 BOM 的 UTF-8**。最省心是纯 ASCII 脚本。写完先用 `[System.Management.Automation.PSParser]::Tokenize()` 验一遍语法再跑，避免白等。
