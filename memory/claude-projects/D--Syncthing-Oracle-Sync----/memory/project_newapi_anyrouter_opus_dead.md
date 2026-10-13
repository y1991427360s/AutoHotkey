---
name: project-newapi-anyrouter-opus-dead
description: sen3 newapi 上 opus-4-8 走 freemodel(对真cc可用)；anyrouter 的 opus 只认直连真cc、经 newapi 中转判伪不可用
metadata: 
  node_type: memory
  type: project
  originSessionId: 69788ad8-4198-444c-8aa6-a69132b1c11d
---

# sen3 newapi：opus-4-8 走 freemodel；anyrouter 的 opus 经中转不可用

**2026-06-03 排查**（完整文档：`D:\Syncthing\Oracle-Sync\服务器\newapi-anyrouter-opus48-排查与修复-20260603.md`）

new-api：容器 `new-api`，`127.0.0.1:3008`，对外 `newapi.sen666.com`，库容器 `new-api-postgres` / 库+用户 `newapi`。渠道：`freemodel1-8`(17-24, 上游 api-cc.freemodel.dev)、`any-skp`(29)/`any-zyx`(30)(上游 anyrouter.top)。

## 核心结论（纠正早前误判）
- **anyrouter 对 opus 做「逐字节真·Claude Code 请求」指纹校验**：只接受用户**直连**的原始 cc 请求。合成 curl（任意头/任意大小 body）一律 503；经 newapi 中转（即便开 `pass_through_body_enabled`、加 `[1m]`、设高优先级）也会被改写后判伪 → 不可用。**这是 anyrouter 侧策略，sen3 改不动。**
- 验证手法：本地起代理抓到「真 cc 直连 anyrouter」的请求 = 200；同 key 同模型同 beta 的合成请求 = 503。差别只在「是不是逐字节真 cc」。anyrouter 的 key 与 newapi any-skp(29) 是同一个。
- **opus-4-8 经 newapi 的可用路径 = freemodel**（对 newapi 转发的真 cc 请求放行；非真 cc 探测会回 `Please use Claude Code CLI`，正常）。newapi 内已有「claude cli trace」渠道亲和规则（`channel_affinity`，按 `metadata.user_id` gjson 匹配 + param_override）把真 cc 的 opus 导向 freemodel。
- 「开 1M」不是 anyrouter 网站开关，本质是发 `anthropic-beta: context-1m-2025-08-07`（cc 里 `/model` 选 `opus[1m]` 或 `CLAUDE_CODE_1M_CONTEXT=1`）。
- **用户个人「直连 anyrouter + opus[1m]」照常可用，排查中未改动。**

## 最终配置
`claude-opus-4-8` 启用渠道 = 17-24(freemodel)；`29/30` 仅 `claude-haiku-4-5-20251001`（haiku-4-5 目前只有这两渠道，不能删）。

## newapi 改渠道方法（无 admin access_token，走 DB）
- 改 `channels.models` + `abilities`(路由真相源，删/加要同步)，psql 用 `-c` 或 `-f`（**别用嵌套 heredoc**：`docker exec psql <<SQL` 套在 `ssh bash -s <<EOF` 里会抢 stdin、静默失败）。
- `INSERT INTO abilities ("group",model,channel_id,enabled,priority,weight,tag) VALUES ('default','claude-opus-4-8',29,true,0,0,'');`
- newapi 把 `model[1m]` 归一化成基础名路由（[1m] 是其 1M 标志）。
- 改完 **`sudo docker restart new-api`**（~30s healthy）才重载路由。
- admin 用户 `sen`(id=1) `access_token` 为空，管理 API 走不了，只能 DB。

## 抓真·cc 请求的办法（复用）
本地 python 代理记请求+转发；让 cc 用独立配置目录指向代理：`$env:CLAUDE_CONFIG_DIR="某临时目录"; claude --model "claude-opus-4-8[1m]" -p "hi"`（该目录放 settings.json 写 env.ANTHROPIC_BASE_URL/ANTHROPIC_AUTH_TOKEN + .claude.json 置 hasCompletedOnboarding）。CLAUDE_CONFIG_DIR 不会被 settings.json 覆盖；普通 env 会被 settings.json 的 env 块覆盖。
