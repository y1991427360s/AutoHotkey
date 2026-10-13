---
name: sub2api-claude-intermittent-504
description: "sub2api 上 Claude Code \"有的对话能用有的卡死\" 的根因——freemodel 上游 ALB ~60s 超时返回 504，非 sub2api 配置问题"
metadata: 
  node_type: memory
  type: project
  originSessionId: a3e05d96-03da-43ed-8e4c-fe4121402dc0
---

`sub2api.sen666.com` 只由 **sen3** 提供服务（4 号服务器的 sub2api 已于 2026-06-03 彻底下线：无容器/镜像/卷/目录/nginx 配置）。

**现象**：Claude Code（base_url=`https://sub2api.sen666.com`，模型 opus）有的对话秒回、有的卡几分钟后报错。**根因不是 sub2api 配置，也不是 [[freemodel-passthrough-fix]] 里的 <8KB 二次分发探针**（passthrough 已开）。

诊断结论（2026-06-03，6 小时窗口实测）：
- Claude 路由：api_key#3 → user#1 → **group#3(anthropic)**，可调度池 13 个 = **10 个 freemodel**（base `api-cc.freemodel.dev`，passthrough=true，ids 11/28-35/37）+ deepseek#19 / mimo#22 / mimo-q#41 三个非 Claude。另有 5 个 parked 不可调度。无账号被禁用或 cooldown。
- 失败来自 **freemodel 自家 AWS ALB 返回 504 `<center>alb</center>`**。ALB idle timeout ≈60s；opus 单轮推理慢，>60s 就被 ALB 掐断 → 504。每次失败重试约等 62s。
- **sen3 出网完全正常**：从 sen3 直连 + 经本地 SOCKS5（xray-local-proxies 20000-20033）curl `api-cc.freemodel.dev` POST /v1/messages 都 200 / ~0.6s；**无代理的 account 11 也同样 504** → 排除代理/网络/单账号/配额（监控面板 10/10 status=ok 有余额）。属上游提供方时段性过载，非本机问题。
- sub2api 行为：**sticky 会话粘账号 + 顺序 failover，max_switches=10**。504 风暴时一条请求顺着 10 个账号各等 ~62s，最坏 **~10.5 分钟后给客户端 502**。整体成功率仍 ~96.8%（361/362 opus 请求 200，13 条 502），成功轮平均 ~17s；失败轮平均 ~195s。
- 注意：nginx 里大量 503 是**红鲱鱼**——那是 OpenAI gpt-5.4 的 `/responses` 路径（group#2，"no available accounts"），与 Claude Code（group#3 `/v1/messages`）无关。

**缓解/修复方向**（按治本程度）：
1. 治本：给 group#3 加一个可靠的付费 Claude 上游并提高调度优先级（freemodel 免费源天然不稳）。
2. 客户端改用 **sonnet** 躲开 ALB 60s 超时（opus 最易触发 504）。
3. 调小 `max_switches`（10→2/3），让坏请求 ~2-3 分钟快速失败而非卡 10 分钟。
4. freemodel 504 多为时段性，等其 ALB 恢复。

**排查工具**：`sudo docker logs sub2api`（关键字 `[Anthropic Passthrough] Upstream error`、`failover_switch_account`、`sticky.account_selected`）；账号健康 `http://10.241.7.125:3355/api/accounts`；DB `sudo docker exec sub2api-postgres psql -U sub2api -d sub2api`。相关：[[freemodel-passthrough-fix]]、[[sub2api-no-content-storage]]。
