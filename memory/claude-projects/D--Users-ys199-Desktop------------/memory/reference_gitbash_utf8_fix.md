---
name: reference-gitbash-utf8-fix
description: 本机 Git Bash 中文/UTF-8 一劳永逸配置，及 Claude Bash 工具用非交互非登录 shell 的关键事实
metadata:
  type: reference
---

本机是 **Windows + MSYS2/Git Bash (MINGW64)**，git 2.53。中文路径"在 bash 里乱码"的真相与永久修复（2026-06-02 实测）：

**关键事实：Claude Code 的 Bash 工具每次开的是「非交互、非登录」shell（`login_shell off`），不读 `~/.bashrc`/`~/.bash_profile`/`~/.profile`。** 所以让它永久带环境变量的**唯一可靠途径是 Windows 用户级环境变量**（被 Claude Code 进程继承 → 子 bash 继承），且**改完要重启 Claude Code 才对其 Bash 工具生效**。交互式 Git Bash 终端才读 `~/.bashrc`。

**已落地的三层永久修复：**
1. Windows 用户环境变量（`[Environment]::SetEnvironmentVariable(name,val,'User')`）：`LANG=zh_CN.UTF-8`、`PYTHONUTF8=1`、`PYTHONIOENCODING=utf-8`。
2. `~/.bashrc`（+ `~/.bash_profile` 里 `. ~/.bashrc`）：同样的 export，供交互终端立即生效；含 `gbk()` 助手。
3. `git config --global core.quotepath false` + `i18n.commitEncoding/logOutputEncoding=utf-8`。

**各问题根因：**
- 文件名读写本来就正常（FS 层是 UTF-8，`ls`/`find`/node 都对）。
- **Python 中文输出乱码**：`LANG` 空 + 原生 Windows Python 把非 TTY 的 stdout 退回系统 ANSI 代码页 **936(GBK)**（`sys.stdout.encoding=gbk`）。`PYTHONUTF8=1` 修复。
- **git 显示 `\351\241...` 八进制**：`core.quotepath` 默认 true。
- **原生控制台程序（cmd/ipconfig 等）输出 GBK**：无 env 可改其行为，用管道转码。

**两个坑：**
- 本机 Git Bash **没装 `iconv`**（`command not found`），所以 `gbk()` 转码回退用 python：`... | python -c "import sys;sys.stdout.reconfigure(encoding='utf-8');sys.stdout.write(sys.stdin.buffer.read().decode('gbk','replace'))"`。
- MSYS 参数路径转换：`cmd /c chcp` 里 `/c` 被转成 `C:\` 导致 cmd 进交互态。要用 `cmd //c ...` 或 `MSYS_NO_PATHCONV=1`。

已于 2026-06-02 提升到全局 CLAUDE.md/AGENTS.md/ANTIGRAVITY.md（六处副本已同步），跨工程/跨机器可直接复用。
