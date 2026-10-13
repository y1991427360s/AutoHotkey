---
name: project-panel-cloudflare-cache
description: panel.sen666.cn（及其它 *.sen666.cn / *.sen666.com）走 Cloudflare 代理，静态资源默认被边缘缓存 4 小时，改完前端必须加版本号或 purge
metadata: 
  node_type: memory
  type: project
  originSessionId: 14fa3907-86c7-41d4-96f1-0caf051bd910
---

panel.sen666.cn 的静态资源（`/static/style.css`、`/static/app.js` 等）经过 Cloudflare：响应头会带 `cf-cache-status: HIT` + `Cache-Control: max-age=14400`（4 小时）。源站（服务器 3 `/opt/vps-panel`）发了新文件后，**边缘节点仍会继续返回旧内容**，浏览器和 curl 拿到的都是旧版本。

**Why:** 2026-05-20 优化 panel 前端后线上仍显示旧深蓝主题；排查发现源站 CSS 是新的，但 CF 边缘 HIT 旧文件（last-modified 还是 4 月 26 日）。

**How to apply:** 改 `*.sen666.cn` / `*.sen666.com` 任何静态资源后，二选一：
1. 在引用处加 querystring 版本号，例如 `<link href="/static/style.css?v=20260520-2">`（最简单、不需要 CF 凭证）。base.html / login.html 这种被 Jinja 渲染的模板改完需要 `sudo systemctl restart vps-panel` 让模板重读。
2. 在 CF 控制台 Purge 该 URL 缓存。

验证：`curl -skI <url>` 看 `cf-cache-status` 是否为 `MISS` / `EXPIRED`，以及 `last-modified` 是否更新到改文件的时间。

关联：[[panel-sen666-cn-frontend-style]]（如果以后写）
