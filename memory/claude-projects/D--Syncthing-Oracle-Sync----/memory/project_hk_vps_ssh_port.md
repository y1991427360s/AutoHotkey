---
name: project-hk-vps-ssh-port
description: 5号服务器（HK，185.216.116.24）厂商工单写的 15351 端口是预装 Windows 的 RDP 端口，重装 Ubuntu 后 SSH 走默认 22
metadata: 
  node_type: memory
  type: project
  originSessionId: 2dd3aaca-57e8-4464-b37d-66916b09c380
---

5 号服务器（HK，赞云 cn2 香港）`香港云服务器cn2.txt` 工单里写 "SSH 端口 15351" —— **这是预装 Windows 时的 RDP 端口，不是 SSH**。重装 Ubuntu 24.04 后 SSH 在默认 22，15351 上没有任何服务（外部探测会 connection refused）。

**Why:** 2026-05-26 初次接入时浪费了一轮排查，TCP 从家用 IP 看 15351 显示 OPEN（厂商前置有 SYN proxy 对管理 IP 放行所有端口的 SYN），但 banner 拿不到。从 sen3 探则直接 refused，对照之后才发现 22 才开着。

**How to apply:** 任何接 HK 这台机器、调端口扫描或者改 sshd 端口前，先记得这条；不要被工单里的 15351 误导。其他赞云 cn2 同款套餐大概率同理。