---
name: feedback-nginx-reload-proxy-sen666
description: 在 sen3 上 nginx reload 对 proxy.sen666.com 的 auth_basic 改动没生效，restart 才行
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 2dd3aaca-57e8-4464-b37d-66916b09c380
---

在 sen3 改 `/etc/nginx/sites-available/proxy.sen666.com`（含 `auth_basic` 块）并 `nginx -t && systemctl reload nginx` 后，401 没启用、客户端拿到 200。改用 `systemctl restart nginx` 立刻生效。

**Why:** 2026-05-26 从 sen1 迁 proxy.sen666.com 到 sen3 时实测——`install -m 644` 原子替换文件、`nginx -t` 通过、`reload` 后 worker 仍然按旧配置返回 200；只有 `restart` 才生效。具体原因没排出来（reload 通常会重读配置），不排除是 systemd unit、`include` 关系或 worker shutdown 行为的某种交互。

**How to apply:** 改 sen3 上 nginx 站点配置（尤其涉及 `auth_basic` / `auth_basic_user_file` / 新增/启用 site）后，**优先 `systemctl restart nginx` 验证**，不要光靠 `reload`。若一定要 reload（不想短暂中断），改完用 `curl -i` 真请求确认 401/header 是否切换；看到行为没换立刻 restart。