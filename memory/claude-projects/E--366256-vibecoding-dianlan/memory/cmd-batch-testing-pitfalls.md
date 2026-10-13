---
name: cmd-batch-testing-pitfalls
description: 本机 Windows 批处理/exe 的坑合集：裸文件名不解析、sed 剥 CR、%~dp0 尾反斜杠转义引号、GBK 编码要求、运行中 exe 用改名法替换
metadata: 
  node_type: memory
  type: reference
  originSessionId: 33102085-96a1-42d0-ad53-ce82ed10c3c0
---

在 Git Bash 里测试 Windows 批处理（2026-07-16 实测，dianlan 项目）：

1. 本机设置了环境变量 `NoDefaultCurrentDirectoryInExePath=1`，`cmd /c foo.cmd` 这种**裸文件名不会从当前目录解析**，报"不是内部或外部命令"。必须用完整路径：`MSYS_NO_PATHCONV=1 cmd /c 'E:\完整\路径\foo.cmd'`。双击运行（Explorer 传完整路径）不受影响。
2. `MSYS_NO_PATHCONV=1` 和 `//c` 不要叠用：设了环境变量后 `//c` 不会被转换成 `/c`，cmd 会进交互模式假装执行了。二选一。
3. Git Bash 的 `sed` 处理 CRLF 文件会把 `\r` 剥掉输出 LF-only，而 **cmd.exe 解析 LF-only 批处理会把命令截碎**（如 `setlocal` 变 `se`）。生成/修改 .cmd 测试副本要用 python 按字节处理并保留 `\r\n`。
4. 含中文提示的 .cmd 要存 GBK（控制台默认 936）；纯 ASCII 的 .cmd 可用 `chcp 65001` 配合 Python 的 UTF-8 输出。
5. cmd 里传 `"%~dp0"` 参数：尾反斜杠会转义右引号，进程收到 `...路径"`（带引号的坏路径）。规避：`cd /d "%~dp0"` 后不传参、或传 `"%~dp0."`。
6. 替换正在运行的 exe：写入被锁（拒绝访问）但**改名不锁**——把旧 exe `mv` 成别名腾位、新 exe 顶上，运行中的进程不受影响；旧文件等进程退出后再删（2026-07-16 重打包 电缆统计.exe 时实测）。
