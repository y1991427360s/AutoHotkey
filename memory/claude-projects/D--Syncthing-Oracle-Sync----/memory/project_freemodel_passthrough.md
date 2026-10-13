---
name: freemodel-passthrough-fix
description: freemodel.dev 反二次分发检测及 sub2api passthrough 修复方案
metadata:
  type: project
---

freemodel.dev 于 2026-06-02 起对 sub2api 转发的请求执行反代理/反二次分发检测。两种拦截模式：

1. **"请求小于8k…监控探针已被拦截"** — sub2api 的账号健康探测（`"hi"` + 55 字节系统提示词）被拒绝，payload 远不足 8KB。
2. **"检测到非标准 Claude Code 客户端，禁止二次分发"** / **"请求体疑似被篡改，请打开透传请求头和透传请求体"** — 真实 `/v1/messages` 转发被拦。

**根因**：freemodel 账号未开启 `anthropic_passthrough`。非透传路径走 `buildUpstreamRequest`，Go HTTP 客户端的 TLS 指纹和请求构造被 freemodel 检测为非真实 Claude Code 客户端。

**修复**（2026-06-02 已对全部 10 个 freemodel Anthropic 账号执行）：
```sql
UPDATE accounts SET extra = extra || '{"anthropic_passthrough": true}'
WHERE name LIKE '%freemodel%' AND platform = 'anthropic' AND deleted_at IS NULL;
```
即时生效，无需重启 sub2api 容器。执行后 5 分钟内 23 个请求全部 200 OK，零拦截。

**原理**：透传模式下 sub2api 使用 `forwardAnthropicAPIKeyPassthrough` → `buildUpstreamRequestAnthropicAPIKeyPassthrough`，直接复制客户端 raw headers（User-Agent、x-app、anthropic-beta、x-stainless-*、x-claude-code-session-id 等，经 `allowedHeaders` 白名单）和 body 到上游，仅替换 auth header 为上游 API key。非透传路径走 `buildUpstreamRequest` 会做指纹注入、metadata 重写等额外处理。

**注意事项**：
- 不要在 sub2api 管理后台对 freemodel 账号点"测试连接"按钮——探测包 <8KB，freemodel 一见就拦。不影响实际转发。
- 如果透传开关开启后仍有部分请求被拦，可能是 TLS 指纹（JA3/JA4）检测。Go 标准库的 TLS fingerprint 与 Claude Code 真实客户端（Rust/tokio）不同，需引入 uTLS。
- 相关源码：`IsAnthropicAPIKeyPassthroughEnabled()` in `account.go:1315`；`forwardAnthropicAPIKeyPassthroughWithInput` in `gateway_service.go:4989`；`buildUpstreamRequestAnthropicAPIKeyPassthrough` in `gateway_service.go:5214`。
