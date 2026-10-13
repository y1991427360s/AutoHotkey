---
name: agy GOGC=off 内存泄漏
description: agy.cmd 用 GOGC=off 绕开 Go runtime 启动崩溃，副作用是长时间运行内存只增不减，会撑爆 commit limit
type: project
originSessionId: f0fb36f7-5b18-4e5c-b590-25c38068d3c7
---
agy CLI 在 Windows 上的 wrapper `C:\Users\ys199\AppData\Local\agy\bin\agy.cmd` 设了 `set GOGC=off`，这是当初为了绕开 `fatal error: unknown caller pc` 启动崩溃加的，但同时把 Go runtime 的垃圾回收彻底禁掉了。

**已知后果（2026-05-27 实测两次）**：
- 17:12 系统事件 2004：agy-bin.exe PID 28196 用 46.8 GB，PID 46400 用 25.2 GB；
- 18:35:55 commit limit 撑爆（SystemCommitLimit ≈ 91 GB，charge ≈ 91 GB），agy-bin.exe PID 34708 单进程吃掉 **77 GB**，DingTalk + claude.exe 顺势把剩余顶满，电脑死机。
- 同时 RADAR_PRE_LEAK_64（Application 日志 Event 1001，Provider "Windows Error Reporting"）会反复记录 agy-bin.exe。

**Why**：GOGC=off 让分配只增不减，长时间挂机的 agy 会无限增长直至吃光提交内存。

**2026-05-27 已修复方案**（实测 agy 1.0.2）：
- 试过 `GOGC=100` —— **立即复现** `fatal error: unknown caller pc`，崩溃发生在 `enry/data.init()` 调用 `regexp.MustCompile` 时 GC 介入 scanstack，所以任何让 GC 在 init 阶段触发的设置都不可行。
- 最终 wrapper：保留 `GOGC=off` 让启动期不跑 GC，叠加 `GOMEMLIMIT=6GiB` 作为软上限。init 阶段总占用远低于 6GiB 不会触发 GC（绕过原 bug），但运行期一旦逼近上限 Go runtime 会强制 GC 回收，从而封顶。
  ```
  @echo off
  set GOGC=off
  set GOMEMLIMIT=6GiB
  "%~dp0agy-bin.exe" %*
  ```
- 验证：`agy --version` 返回 `1.0.2`，启动 OK。

**How to apply**：
1. 这是目前唯一已知可同时绕过启动崩溃 + 防止内存吃光的组合，不要随便去掉 `GOMEMLIMIT`。
2. 长时间挂着不用就显式退出 agy。
3. 如果以后 agy 升级后又复现启动崩溃，可以再上调 `GOMEMLIMIT`（init 早期占用更大）或暂时回退到纯 `GOGC=off`。
4. 排查类似事件的快速命令：`Get-WinEvent -LogName System | Where-Object Id -eq 2004` 会直接列出 Windows 诊断出来的内存大户。
