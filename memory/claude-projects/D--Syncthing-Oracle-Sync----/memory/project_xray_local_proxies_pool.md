---
name: xray-local-proxies-pool
description: sen3 xray-local-proxies 本地 SOCKS5 代理池端口范围与内网使用方式
metadata:
  type: project
---

sen3 的 `xray-local-proxies.service` 读取 `/home/ubuntu/xray-local-proxies.json`，提供本地 SOCKS5 代理池。

2026-06-11 已从 `D:\Syncthing\Oracle-Sync\服务器\CF代理节点.txt` 测试并追加 97 个可用 VLESS WS TLS 节点：端口范围从 `20000-20033` 扩展为 `20000-20130`，共 131 个 SOCKS5 入站。跳过 `CF官方优选65`（超时）和 `CF官方优选74`（TLS 失败）。原配置备份在 sen3：`/home/ubuntu/xray-local-proxies.json.bak-20260611_103003`。

给本机或 ZeroTier 内网工具使用时，代理地址应写 `socks5://10.241.7.125:<port>`，不要写公网 `159.54.181.175:<port>`。2026-06-11 实测公网入口 TCP 可连但 SOCKS 请求会超时；ZeroTier 入口 `10.241.7.125:20034` 访问 `http://httpbin.org/ip`、`https://httpbin.org/ip`、`https://api.ipify.org` 均正常。

本地代理列表文件：`D:\Syncthing\Oracle-Sync\proxy-list.txt`，当前应包含 `socks5://10.241.7.125:20000` 到 `socks5://10.241.7.125:20130`。
