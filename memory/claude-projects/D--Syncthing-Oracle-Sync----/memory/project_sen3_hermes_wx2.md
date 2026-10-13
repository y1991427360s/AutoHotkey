---
name: project-sen3-hermes-wx2
description: sen3 Hermes Agent 第二微信实例使用独立 wx2 profile 和 user systemd 服务
metadata:
  node_type: memory
  type: project
  originSessionId: codex-20260630
---

# sen3 Hermes Agent 第二微信实例

2026-06-30 在 sen3 给 Hermes Agent 增加第二套微信网关实例：

- 默认 Hermes home：`/home/ubuntu/.hermes`，默认 user service：`hermes-gateway.service`，绑定第一个微信。
- 第二微信 profile：`/home/ubuntu/.hermes/profiles/wx2`，user service：`hermes-gateway-wx2.service`，通过 `HERMES_HOME=/home/ubuntu/.hermes/profiles/wx2` 独立运行。
- Hermes 单个 Weixin adapter 只读取一组 `WEIXIN_ACCOUNT_ID` / `WEIXIN_TOKEN`，所以两个个人微信不能直接挂在同一个 gateway 进程里；后续新增微信也按“独立 profile + 独立 user service”处理。
- `wx2` profile 已清理克隆来的第一个微信 `WEIXIN_*` 配置，避免误用第一个微信 token。
- `wx2` 已扫码绑定到 `a4c07a7ac874@im.bot`。
- `wx2` 私信策略开放：`WEIXIN_DM_POLICY=open`、`WEIXIN_ALLOW_ALL_USERS=true`；群聊策略禁用：`WEIXIN_GROUP_POLICY=disabled`。
- `wx2` home channel：`o9cq809f1qSkycrONjCbKFcqGiOM@im.wechat`。

常用维护命令：

```bash
systemctl --user status hermes-gateway.service
systemctl --user status hermes-gateway-wx2.service
journalctl --user -u hermes-gateway-wx2.service -f
/home/ubuntu/.local/bin/hermes -p wx2 gateway status
```

排查时优先看 `journalctl --user -u hermes-gateway-wx2.service -n 100`。此前已确认 `wx2` 能连接 Weixin、收到消息 `hi` 并生成回复。
