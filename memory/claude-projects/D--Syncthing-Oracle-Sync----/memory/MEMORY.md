# 服务器相关 memory（Syncthing 同步副本）

> 这是 `C:\Users\YYYYsen\.claude\projects\D--Syncthing-Oracle-Sync----\memory\` 下服务器相关条目的同步副本，目的是让其他电脑、其他 AI（Codex / Antigravity / 新装的 Claude Code）也能读到。
>
> **维护规则**：本地 memory 一旦新增/修改/删除任何**服务器相关**条目，必须同步到这里；反之亦然。其它（与服务器无关的）memory 不必拷过来。

## 当前条目

- [panel.sen666.cn 走 Cloudflare 缓存](project_panel_cloudflare_cache.md) — 改完前端静态资源必须加 querystring 版本号或 purge CF，否则边缘缓存 4 小时返回旧内容
- [panel.sen666.cn CPU 峰值进程归因](project_panel_cpu_spike_processes.md) — CPU 采样值 >=60% 时，`/opt/vps-panel/data/metrics.sqlite3` 的 `cpu_spike_processes` 表记录当时前 5 进程
- [sen3 new-api 用 docker-compose.local.yml](project_sen3_newapi_compose.md) — 不是默认的 .yml，两份 compose 共用 pg_data volume 但 UID 不同（70 vs 999），混用会损坏数据卷
- [sen3 nginx reload 不可靠](feedback_nginx_reload_proxy_sen666.md) — 改完站点配置必须 `systemctl restart nginx`，`reload` 实测有时不生效（auth_basic 改动）
- [服务器相关 memory 必须双写](feedback_server_memory_dual_write.md) — 本地 + `D:\Syncthing\Oracle-Sync\服务器\memory\` 各一份，跨电脑/跨 AI 共享
- [服务器备份使用 restic](project_server_restic_backup.md) — `E:\366256\服务器备份` 使用 WSL/restic；不要用 WSL rsync 首次逐文件写 NTFS；当前备份 1-4 号服务器
- [freemodel 反代理检测需要 sub2api 开启透传](project_freemodel_passthrough.md) — freemodel.dev 拦截非 passthrough 请求；开启 `accounts.extra.anthropic_passthrough` 修复；不要对 freemodel 跑测试探针
- [freemodel-usage-monitor 登录态与流畅 noVNC 桌面](project_freemodel_usage_monitor_login_session.md) — 旧逻辑登录用 `sessions/<id>-login`、刷新用 `sessions/<id>` 导致“登录了仍异常”；sen3 已改为共用正式会话目录，并将登录桌面切到 TigerVNC + openbox，推荐 noVNC URL 带 `autoconnect/resize/quality/compression`
- [freemodel-usage-monitor 外网只读朋友页](project_freemodel_usage_monitor_public_friend.md) — `https://binfree.sen666.com/friend` 只展示 `audience=friend` 账号额度；nginx 白名单只放只读页/API，管理接口不经该域名暴露
- [freemodel-usage-monitor 接入 AnyRouter](project_freemodel_usage_monitor_anyrouter.md) — 新增 `provider=anyrouter`，用网页登录态请求 `/api/status` + `/api/user/self` 读取 `quota/used_quota/request_count`；AnyRouter 人工登录默认直连打开网页
- [sub2api 不存对话正文](project_sub2api_no_content_storage.md) — sen3 sub2api 数据库只存计量元数据(token/费用/IP/UA)，无 prompt/response 正文；唯一口子是未启用的内容审核 input_excerpt
- [sub2api Claude Code 间歇卡死/502 根因](project_sub2api_claude_intermittent_504.md) — freemodel 上游 ALB ~60s 超时返 504（opus 最易触发），sticky+failover(max_switches=10) 致最坏卡 10 分钟；sen3 出网正常、非配置问题；4 号 sub2api 已下线，仅 sen3 在跑
- [newapi opus 走 freemodel；anyrouter opus 只认直连真cc](project_newapi_anyrouter_opus_dead.md) — anyrouter 对 opus 做逐字节真·cc 指纹校验，经 newapi 中转(即便开透传/[1m]/高优先级)必被判伪不可用（合成请求一律503）；newapi 上 opus 收敛到 freemodel(对真cc可用，已实测真实补全)；含本地代理抓真cc请求、改 channels+abilities 后 restart 的方法；用户直连 anyrouter 用 opus 照旧
- [work.sen666.cn 电缆原始/镜像配对](project_work_sen666_mirror_pairing.md) — 配对在 `repair_imported_mirror_flags`(每次 list 跑)按“原理号一致”判定；曾被强制全标原始，2026-06-07 已修，别再改回
- [sen3 xray-local-proxies 代理池](project_xray_local_proxies_pool.md) — 2026-06-29 `20040-20071` 已由 sing-box 覆盖为新节点，Xray 继续负责其余端口；内网入口仍是 `10.241.7.125/100.90.234.37:20000-20229`，公网 `159.54.181.175:20000-20229` 不可用
- [sen3 NetBird 自托管与透明出口](project_sen3_netbird_exit_proxy.md) — `netbird.sen666.com` 自托管控制面；sen3 是 Exit router，`ys199-devices` 是用户自动组；`netbird-transparent-proxy` 用 nftables tproxy 把 `wt0` TCP 流量送入现有 230 个代理池 outbound；不要直接写 NetBird sqlite 的 gob 字段
- [sen3 nginx 莫名 failed 多半是自动升级翻车](project_sen3_nginx_autoupgrade_outage.md) — apt-daily 自动升级 nginx 致 systemd 跟丢 PID+启动失败且无自愈，宕 13h；修复 reset-failed+start，已加 Restart=on-failure；服务器本地回环测 Cloudflare 域名会现 Akamai 400 假象
- [Sub2API 已复制到 5号服务器](project_sub2api_to_server5.md) — 2026-06-28 从 sen3(arm64) 完整复制到腾讯云 x86_64；sen3 自定义 arm64 镜像不可用，改用了官方 `weishaw/sub2api:latest`；使用 `docker-compose.local.yml` 本地目录管理；pg_dump 恢复 74 表 90 accounts
- [password.sen666.cn 已迁移到 5号服务器](project_password_vault_to_server5.md) — 2026-06-28 从 sen3 迁到腾讯云 sen5；Cloudflare 必须保持已代理，源站直连 443 不可靠且应用带 HSTS
- [sen3 Hermes Agent 第二微信实例](project_sen3_hermes_wx2.md) — 第二个微信用 `/home/ubuntu/.hermes/profiles/wx2` 独立 profile + `hermes-gateway-wx2.service`，私信开放、群聊禁用；多微信不要塞进同一个 gateway 进程
