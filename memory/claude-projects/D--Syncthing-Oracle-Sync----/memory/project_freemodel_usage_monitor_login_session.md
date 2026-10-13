---
name: project_freemodel_usage_monitor_login_session
description: freemodel-usage-monitor 旧版登录态写入临时目录，导致登录后仍异常；sen3 已改为共用正式会话目录
metadata:
  node_type: memory
  type: project
---

2026-06-11 在 sen3 `/home/ubuntu/freemodel-usage-monitor` 排查 `freemodel12`：用户多次登录后面板仍显示异常，接口记录为 `email=null`、`status=error`、错误“未登录或登录态已过期”。

根因：旧版 `server.js` 的登录按钮把 Chromium 持久化目录放在 `sessions/<account-id>-login`，而后台刷新用的是 `sessions/<account-id>`。点“完成登录”时 `closeLoginContext()` 还会删除 `*-login` 目录，所以用户登录得到的 Cookie 从未进入后台检测使用的正式目录。

已修复：

- `/api/accounts/:id/login` 改为直接使用 `accountSessionDir(account)`。
- `closeLoginContext()` 不再删除登录会话目录。
- 登录时如果该账号正在后台检测，返回 409，避免同一个 Chromium profile 被两个进程同时打开导致 `ProcessSingleton` 错误。

验证：`freemodel-usage-monitor.service` 重启后为 active；`/api/accounts` 正常返回。已有旧登录态无法恢复，受影响账号需要重新登录一次，之后 Cookie 会写入正式会话目录。
