---
name: project_sub2api_no_content_storage
description: sen3 上 sub2api.sen666.com 不持久化对话正文，仅存计量元数据
metadata:
  type: project
---

3 号服务器（sen3）上的 sub2api（中转站，容器 `sub2api` / `sub2api-postgres` / `sub2api-redis`，库名 `sub2api`，用户 `sub2api`）**不保存用户对话正文和大模型回答内容**，数据库里只有计量/运行元数据。2026-06-03 逐表核查结论：

- `usage_logs`：计费元数据（user_id、模型、token 数、费用、duration、**client IP**、**User-Agent**、时间戳），**无 prompt/response 正文**。
- `ops_system_logs`：系统运行日志（"http request completed"），`extra` jsonb 只有 status_code/path/model/method/client_ip/latency_ms 等，**无正文**。
- `content_moderation_logs`：**有 `input_excerpt`(text) 字段会存用户输入片段**，但内容审核未启用，全表 0 行。⚠️ 若哪天后台开启内容审核，被判违规的请求会把输入摘录写库——这是唯一可能落库正文的口子。
- `settings` 无"记录请求体/调试"开关；`ops_runtime_log_config` 日志级别 info，不打正文。

前提：① 转发瞬间正文经过服务器内存（中转必需），但不写盘；② 上游厂商（Anthropic/OpenAI）仍收到并可能留存正文，与本机无关。

查询用：`sudo docker exec sub2api-postgres psql -U sub2api -d sub2api -c '\dt'`（postgres 库的 role 是 `sub2api` 不是 `postgres`）。相关 [[project_freemodel_passthrough]]。
