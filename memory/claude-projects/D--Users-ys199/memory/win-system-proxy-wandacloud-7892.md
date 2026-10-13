---
name: win-system-proxy-wandacloud-7892
description: Windows 系统级 HTTP_PROXY/HTTPS_PROXY=127.0.0.1:7892 是万达云写入的，换/关代理软件后 Codex 等走代理程序连不上；sub2api 中转直连即可
metadata: 
  node_type: memory
  type: reference
  originSessionId: 63b74d24-f8a2-4e43-a00a-879dcd82620c
  modified: 2026-08-06T00:19:11.258Z
---

2026-08-06 排查用户 Codex 连不上 `sub2api.sen666.com` 的根因：

- **系统级环境变量**（`HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment`）里有 `HTTP_PROXY=http://127.0.0.1:7892`、`HTTPS_PROXY=http://127.0.0.1:7892`，这是万达云软件写入的。`7892` 端口只有万达云（`wandacloudCore`）在监听；Clash Verge 监听 `7893`。
- 症状链条：关掉万达云 → 7892 无监听 → Codex/Claude Code 等强制走失效代理 → 报 `error sending request` / `stream disconnected before completion` / `无法建立连接(DNS/连接/TLS/超时)`。即使目标域名直连可达，程序也被环境变量绑死走失效代理。
- `sub2api.sen666.com` 解析到 `159.54.181.175`（Oracle Cloud 硅谷机房，用户自己的 VPS），大陆直连稳定 ~0.5s，**根本不需要代理**。`sub2api2.sen666.com` 无 DNS 记录（历史里 `sub2api2` 只是 CC Switch 配置模板名，base_url 实际指向 `sub2api.sen666.com`）。
- 已修复：用户级 `NO_PROXY=sen666.com,localhost,127.0.0.1`（用 `[Environment]::SetEnvironmentVariable('NO_PROXY','sen666.com,localhost,127.0.0.1','User')` 写入），使 sen666.com 全系域名绕过代理直连，不再依赖万达云 7892。相关：[[clash-verge-fakeip-ipv6-wechat]] 里 Clash 透明代理影响腾讯域名的排查逻辑类似。
