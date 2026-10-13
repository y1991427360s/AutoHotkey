---
name: Codex Apps 安装需要活跃 ChatGPT 订阅
description: Codex curated 插件（Gmail/GitHub/Cloudflare 等）装不上时先排查 ChatGPT Plus/Pro 订阅是否过期
type: project
originSessionId: e1b67847-5137-46f1-8046-6c281b25c0a8
---
Codex CLI 里 `openai-curated` 市场的插件（Gmail、GitHub、Cloudflare、build-web-apps、hyperframes 等 Apps）安装时**强制要求 ChatGPT 账户有活跃的 Plus/Pro 订阅**；本地 bundled 插件（browser / chrome / latex）和 primary-runtime 插件（documents / spreadsheets / presentations）不需要。

**Why:** 用户 2026-05-22 装不上 Gmail，排查发现 `~/.codex/auth.json` 里的 id_token 解码出 `chatgpt_subscription_active_until = 2026-05-20`，订阅已过期；id_token 的 scope 也缺少 Apps 安装相关条目（只剩 connectors.read/invoke），是订阅过期后服务端少签的。和 `model_provider`（中转站 mysub）无关——curated 插件的发现/安装走的是 ChatGPT 后端，看的是 token 里的订阅状态。

**How to apply:** 用户反馈"Codex 装不上 Gmail / 某 App"时，
1. 先 `cat ~/.codex/auth.json` 把 id_token 的 payload 段（第二段）base64 解码，看 `chatgpt_subscription_active_until` 是否过期、scope 里是否还有 Apps 相关项；
2. 过期则提示去 chatgpt.com 续 Plus，续费后 `codex logout && codex login` 重新拿 token；
3. 不要先怀疑 `model_provider`、网络或 marketplace 配置——除非订阅明确还在有效期内。
