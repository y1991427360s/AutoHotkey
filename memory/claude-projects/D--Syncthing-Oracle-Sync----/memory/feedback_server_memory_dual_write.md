---
name: feedback-server-memory-dual-write
description: 服务器相关的 memory 必须同时写到 D:\Syncthing\Oracle-Sync\服务器\memory\，让其它电脑和 AI 也能读到
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 2dd3aaca-57e8-4464-b37d-66916b09c380
---

任何关于服务器（sen1/sen2/sen3/sen4/sen5、域名 sen666.com/sen666.cn、nginx/docker/cron/proxy 等）的 memory，**必须同步写到两个地方**：

1. 本地：`C:\Users\YYYYsen\.claude\projects\D--Syncthing-Oracle-Sync----\memory\`
2. Syncthing：`D:\Syncthing\Oracle-Sync\服务器\memory\`

两份内容完全一致（同样的 frontmatter、同样的 body）。两份各自的 `MEMORY.md` 索引也要同步加/删条目。

**Why:** 2026-05-26 用户要求——本地 memory 只在当前电脑，其它电脑（公司电脑、未来的新电脑）以及 Codex/Antigravity 等其它 AI 看不到。Syncthing 那份才能跨电脑、跨 AI 共享。

**How to apply:**

- 新增/修改服务器相关 memory：先在本地写完，再 `cp` 到 Syncthing 目录，最后同步两份 `MEMORY.md`。
- 删除：两边都删。
- 非服务器相关的 memory（比如个人偏好、跟服务器无关的项目）**不必**拷到 Syncthing 目录，保留本地即可，避免噪音。
- 不确定是否算"服务器相关"时，倾向于拷过去——多一份不损失什么。