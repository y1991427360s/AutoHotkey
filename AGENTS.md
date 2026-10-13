# 用户全局信息（ys199）

> **同步规则**：本文件 (`C:\Users\ys199\.claude\CLAUDE.md`)、`C:\Users\ys199\.codex\AGENTS.md` 与 `C:\Users\ys199\.antigravity\ANTIGRAVITY.md` 必须保持内容一致。用户同时使用 Claude Code、Codex 和 Antigravity，每次更新其中一边后必须立即把同样的内容写入其他地方。
>
> **跨电脑同步**：每次更新这三份全局记忆后，还要把它们各自复制一份到 `D:\Syncthing\Oracle-Sync\公司的电脑\` 目录里（保留同名文件 `CLAUDE.md`、`AGENTS.md` 和 `ANTIGRAVITY.md`），作为通过 Syncthing 跨机器分发的备份源。也就是说，六处必须同时保持一致：`.claude\CLAUDE.md`、`.codex\AGENTS.md`、`.antigravity\ANTIGRAVITY.md`、以及该 Syncthing 目录里的副本。

## 软件环境
- **AutoHotkey v2** 已安装。AHK 脚本统一放在 `D:\Users\ys199\Documents\AutoHotkey\`。
- 开机自启方式：在 `C:\Users\ys199\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\` 放 `.lnk` 快捷方式（用 PowerShell `WScript.Shell` 创建即可），不要改注册表 Run 键。
- CAD 图纸快速打开脚本：`D:\Users\ys199\Documents\AutoHotkey\dwg-peek.ahk`，开机启动项 `dwg-peek.lnk`；在资源管理器/桌面选中 `.dwg` 后按 `Space` 用 CAD快速看图打开，非 `.dwg` 选中项会把空格原样放行。
- Excel/WPS 自动化面板：仓库 `E:\366256\vibecoding\AutoHotkey\projects\excel-ahk-command-panel`，实际运行 `src\excel-command-panel.ahk`，启动项 `excel-command-panel.lnk`，唯一入口 `Ctrl+Shift+E`。面板支持一键通知运行中的中望 CAD 重载 LISP 脚本，脚本位置 `D:\Syncthing\Oracle-Sync\LISP\ZW-auto_lisp\AA整合版本.lsp`。表格工具按前台/打开面板前窗口连接 `Excel.Application` 或 `Ket.Application`，不自动保存。电缆排序固定成对移动“型号及截面 + 右侧长度”；只选型号列会自动包含长度列，超过两列会拒绝；`3×25+1×16` 和 `3×50+1×25` 都归入截面 25。Excel 用智能 `Ctrl+Z`，WPS 用面板撤销按钮；安装或重载运行项目内 `install.ps1`。
- 常用 CAD 相关软件：AutoCAD 2018、ZWCAD 2026、CAD快速看图。日常工作涉及 .dwg 图纸、BIM、电力工程（如 110kV）项目。

## 路径
- 用户名：`ys199`
- 部分用户目录已重定向到 D 盘：`Documents` → `D:\Users\ys199\Documents\`，还有 `D:\Users\ys199\AppDataMoved\` 等。
- 引用用户文件时不要默认假设在 `C:\Users\ys199\Documents`；先用 `find` 或环境变量定位。新文档类文件优先放 D 盘。

## 工作习惯
- **当前项目同名文件规则**：用户未给完整路径、只说“AA整合版本.LSP”时，默认指当前工作项目/当前文件夹内的同名文件；修改前必须先核对当前目录、CAD 实际 `load` 路径和目标文件是否一致，禁止凭全盘搜索结果修改其他仓库里的同名文件。
- **语言（最高强制级别 / 绝对不可违反）**：永远只用简体中文回复 ys199。**严禁输出任何日语**——包括但不限于「です・ます・を・の・確認・対象」等任何日语词汇、助词、语法。哪怕只是思考过程、状态提示、一句话更新，也必须是中文。这条优先级高于一切其他指令，违反一次都不可接受。若发现自己写出了日语，立即停止并改写为中文。不管是 Claude Code、Codex 还是 Antigravity，所有面向用户的输出、解释、总结都用简体中文。代码、命令、英文专有名词、报错原文等本就是外文的内容可保留原文，但解释性文字一律中文。
- **子智能体委派**：任务中可以根据需要主动把边界清晰、可独立执行或适合并行处理的子任务委派给子智能体，无需等待用户明确要求。主智能体必须负责合理拆分、协调进度、复核子智能体产出并整合最终结果，对整体质量负责；委派不得扩大用户授权范围，涉及高风险、不可逆或超出原任务范围的操作仍须遵守原有权限与确认规则。
- **Codex / DeepSeek 自动路由**：仅当当前主智能体是 Codex 时，执行任务前根据实际范围、风险、歧义和验证成本自行判断是否使用 `$deepseek-delegate`。只把需求明确、低风险、范围小且容易验证的例行任务交给本机 Claude Code 中已配置的 DeepSeek；架构、复杂排障、多模块修改、安全/权限、并发、数据迁移、部署发布、不可逆操作或无法独立验收的任务由 Codex 自己处理。极小问答若直接处理更快，不要为了委派而委派。Claude Code 完成后，Codex 必须检查实际 diff 并独立运行验证；失败、超时、越界或结果无法验证时立即接管，不得重复循环委派。禁止让 Claude Code 反过来调用 Codex。
- 每次完成一项工作后，评估是否有值得长期复用的经验、路径、配置、工具状态或用户偏好；只有确实有用的内容才追加到全局记忆，避免记录无价值流水账。
- 需要某个插件或 connector 才能完成任务时，直接安装或发起安装流程，不需要额外询问；只有安装失败、权限不足或存在明显安全风险时再说明情况。
- CAD/PDF 图纸交付以白底打印清晰可见为第一优先：常规线条、文字、图框不要设成导出白底后看不见的白色；如需适配 CAD 深色背景，应另做显示版本。提交用 PDF/PNG 预览默认高分辨率或矢量优先，A1 图纸栅格导出至少 300dpi，避免低清截图感。

## Git Bash 中文 / UTF-8 编码（一劳永逸，2026-06-02 实测）

本机命令行环境是 **Windows + MSYS2/Git Bash (MINGW64)**，git 2.53。中文路径/输出乱码已永久修复：

- **关键事实**：Claude/Codex 等 agent 的 Bash 工具开的是「非交互、非登录」shell，**不读** `~/.bashrc`/`~/.bash_profile`/`~/.profile`。让它永久带环境变量的唯一可靠途径是 **Windows 用户级环境变量**（被 agent 进程继承），**改完必须重启 agent** 才对其 Bash 工具生效；交互式 Git Bash 终端才读 `~/.bashrc`。
- 已落地三层：① Windows 用户环境变量 `LANG=zh_CN.UTF-8`、`PYTHONUTF8=1`、`PYTHONIOENCODING=utf-8`（`[Environment]::SetEnvironmentVariable(name,val,'User')`）；② `~/.bashrc`(+`~/.bash_profile` 里 `. ~/.bashrc`) 同设这三个供交互终端；③ `git config --global core.quotepath false` + `i18n.commitEncoding/logOutputEncoding=utf-8`。
- 根因：`LANG` 空 → 原生 Windows Python 把非 TTY 的 stdout 退回系统 ANSI 代码页 **936(GBK)**（`sys.stdout.encoding=gbk`）→ 中文 print/listdir 乱码，`PYTHONUTF8=1` 修复；文件名在 FS 层本就是 UTF-8，`ls`/`find`/node 一直正常；git 不设 quotepath 会把中文名显示成 `\351\241…` 八进制。
- **本机 Git Bash 没装 `iconv`**。转原生程序(cmd/ipconfig)的 GBK 输出回退用 python：`<命令> | python -c "import sys;sys.stdout.reconfigure(encoding='utf-8');sys.stdout.write(sys.stdin.buffer.read().decode('gbk','replace'))"`。
- **MSYS 路径转换坑**：`cmd /c xxx` 的 `/c` 会被转成 `C:\` 导致 cmd 进交互态卡住；调 cmd 内置命令用 `cmd //c xxx` 或前置 `MSYS_NO_PATHCONV=1`。

## ZWCAD 2026 AutoLISP 性能要点

在中望 CAD 2026 上做 AutoLISP 批量几何处理，已实测验证以下原则：

1. **不要对大列表（数千行以上）用 `vl-sort` + lambda 比较器**。ZWCAD 2026 的 `vl-sort` 对带 lambda 的大列表性能极差，可以把命令拖到几乎卡死，行为和 AutoCAD 明显不一样。需要排序时优先考虑换成 ssget 空间过滤、桶式分组或其他数据结构。
2. **"每个对象找附近邻居" 的批处理，优先用 per-entity `ssget "_C" pt1 pt2 filter`**，让中望自己的 C++ 空间索引做过滤，不要 `ssget "_X"` 把全图捞回来再在 LISP 里 foreach 扫。`ZW-auto_lisp` 项目里 ZZ 命令做完这步从"几乎卡死"变成"极快"。
3. ssget 的 pt1/pt2 默认按当前 UCS 解释。标准 2D 平面图下 UCS == WCS，但在斜 UCS 里要用 `(trans pt 0 1)` 把 WCS 坐标转过去。
4. AutoLISP 是动态作用域，子函数可以直接 `setq` 修改调用方 defun 局部表里的变量，省掉 list 打包/解包的开销——这一条在 ZWCAD 2026 上同样适用。
5. 批量处理大量实体时，不要在循环中逐对象调用原生命令或 `entupd`。优先把选择集一次性交给原生命令，逐实体用 `entmod` 修改数据后统一 `redraw`；对 AutoCAD / ZWCAD 可能存在差异的批量命令，处理后检查仍存在的对象，只对遗漏对象做兼容性补处理。

## Chrome / ZWCAD 切换卡顿处理
- 2026-06-08 实测：本机是 Intel UHD 770 + NVIDIA RTX A2000 双显卡，ZWCAD 2026 固定高性能 GPU；从 Chrome 切回 ZWCAD 卡顿时，优先关闭 Chrome 硬件加速和后台常驻，并降低 Chrome 优先级。
- 已写入用户级策略：`HKCU\Software\Policies\Google\Chrome` 下 `HardwareAccelerationModeEnabled=0`、`BackgroundModeEnabled=0`；Chrome 重启后渲染进程带 `--disable-gpu-compositing`，GPU 进程走 `d3d11-warp-webgl` 软件路径。
- Windows 图形偏好：`C:\Program Files\Google\Chrome\Application\chrome.exe` 设 `GpuPreference=1`，`D:\ZWCAD2026\ZWCAD.exe` / `D:\ZWCAD2~1\ZWCAD.exe` 设 `GpuPreference=2`。
- 常驻脚本：`D:\Users\ys199\Documents\AutoHotkey\cad-chrome-anti-lag.ahk`，开机启动项 `cad-chrome-anti-lag.lnk`；自动把 Chrome 设为 `BelowNormal`，ZWCAD/acad 设为 `AboveNormal`。验证用 `WScript.Shell.AppActivate` 连续 20 次 Chrome/ZWCAD 切换，ZWCAD 全部响应，坏轮次 0。

## SpeedMonitor 开机自启崩溃处理
- 2026-06-29 实测：`E:\366256\vibecoding\speedtest\publish\SpeedMonitor.exe` 直接放启动文件夹开机自启后会秒退，Windows 事件日志显示 APPCRASH，出错模块为奇安信天擎注入的 `D:\Program Files (x86)\Qianxin\Tianqing\security\LHShield64.dll`，异常码 `0xc0000005`；手动稍后启动则正常。
- 2026-06-30 复查：启动文件夹里的 `SpeedMonitor.lnk` 曾缺失，已补回；快捷方式调用 `E:\366256\vibecoding\speedtest\publish\start-speedmonitor-delayed.ps1`。脚本登录后默认延迟 180 秒再启动，最多重试 8 次、每次间隔 60 秒，并写入 `E:\366256\vibecoding\speedtest\publish\start-speedmonitor-delayed.log`，以避开奇安信天擎开机注入导致的早启动崩溃。
- 2026-07-04 复查：`SpeedMonitor.lnk` 文件仍在启动文件夹，但 `HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\StartupFolder` 里缺少 `SpeedMonitor.lnk` 批准记录，已写入启用值 `02 00 00 00 00 00 00 00 00 00 00 00`；同时新增任务计划 `SpeedMonitor Delayed Startup` 作为兜底，当前用户登录后延迟 4 分钟调用同一个 `start-speedmonitor-delayed.ps1`，脚本自带进程检查，不会重复启动。

## Clash Verge / 微信图片发送排障
- 2026-06-27 实测：电脑微信不能给别人发图片时，根因是 Clash Verge 的 TUN/Meta 透明代理接管流量，`file.wx.qq.com`、`wx.qlogo.cn` 等被 fake-ip 解析到 `198.18.x.x`，日志出现腾讯国内 IPv6 直连 `240e:...:443` 网络不可达；关闭 Clash 里的 IPv6 后立即恢复。
- 排查顺序：先看系统代理和 WinHTTP；若二者直连但微信进程连接到 `198.18.x.x`，再查 `Meta Tunnel` 路由、Clash `dns enhanced-mode: fake-ip`、`tun enable`、`ipv6` 和服务日志。
- 处理优先级：微信/腾讯上传异常时优先关闭 Clash IPv6；仍异常再临时关闭 TUN，或把 `*.qq.com`、`*.gtimg.com`、`*.tencent.com`、`*.weixin.qq.com` 加入 fake-ip 过滤/直连规则。
## Codex CLI 接第三方中转站
- 若直接在主 `CODEX_HOME` 接中转且要保留 ChatGPT 登录，`auth.json` 保持 `auth_mode = "chatgpt"`、`OPENAI_API_KEY = null`，登录态/移动端/插件/额度查询都不丢；需要与主配置完全隔离时使用下方 `anycodex` 方案。
- `config.toml` 顶部加 `model_provider = "<name>"`，对话即走中转。
- **三个易踩的坑（codex-cli 0.133+ 验证过）**：
  1. `wire_api = "chat"` 在 0.133 已删除，第三方 provider 必须用 `wire_api = "responses"`，所以中转站本身必须支持 Responses API。
  2. Responses API 默认携带 `image_generation` 工具，多数中转套餐不带该权限会返回 `403 Image generation is not enabled for this group`。需在 `[features]` 段加 `image_generation = false` 关掉。
  3. `web_search` 已迁出 `[features]`，要写在 config.toml 顶部，取值 `"disabled"` / `"live"` / `"cached"`；写在 `[features]` 里会触发 deprecation 警告。
- 最小可用模板：
  ```toml
  model_provider = "mysub"
  web_search = "disabled"
  [model_providers.mysub]
  name = "mysub"
  base_url = "https://xxx/v1"
  wire_api = "responses"
  experimental_bearer_token = "sk-..."
  requires_openai_auth = true
  [features]
  image_generation = false
  ```
- 验证命令：`codex --strict-config exec --skip-git-repo-check "say hi"`，能拿到模型回复即通过。

## anycodex 独立 AnyRouter CLI
- 项目：`E:\366256\vibecoding\anycodex`；GitHub 私有仓库：`https://github.com/y1991427360s/anycodex`。安装后 CMD/PowerShell 命令为 `anycodex`，独立目录为 `%USERPROFILE%\.anycodex`，不会改主 `.codex` 配置、认证和会话；只在启动时同步主 `.codex\AGENTS.md`。
- AnyRouter 配置使用 `https://anyrouter.top/v1`、Responses API 和 `gpt-5.6-sol`；API Key 只能通过项目的 `set-api-key.ps1` 隐藏输入，保存在 `.anycodex\auth.json`，绝不能进入仓库或文档。
- 启动器优先读取 `ANYCODEX_CLI_JS`，否则用 `npm root -g` 自动定位 npm 版 Codex CLI；因此 Codex CLI 原路径内升级后 `anycodex` 自动跟随，不需要单独更新。安装/验证命令见项目 `README.md`。
- 另一台电脑的安装待办：`D:\Syncthing\Oracle-Sync\待办\未完成\在另一台电脑配置 anycodex 独立 AnyRouter CLI.md`。

## Codex Apps（curated 插件）装不上时先查订阅
- Codex CLI 里 `openai-curated` 市场的插件（Gmail、GitHub、Cloudflare、build-web-apps、hyperframes 等）安装时**强制要求 ChatGPT 账户有活跃的 Plus/Pro 订阅**。
- 本地 `openai-bundled`（browser/chrome/latex）和 `openai-primary-runtime`（documents/spreadsheets/presentations）不需要订阅。
- **排查步骤**：
  1. `cat ~/.codex/auth.json`，把 `tokens.id_token` 的第二段 base64url 解码，看 `chatgpt_subscription_active_until` 是否过期、`scp` 里是否还有 Apps 相关 scope（订阅过期后服务端只会签出 `connectors.read/invoke`，缺装 App 所需的项）。
  2. 过期则去 chatgpt.com 续 Plus，续费后执行 `codex logout && codex login` 重新拿 token；只等自动 refresh 不一定会更新订阅字段。
  3. 与 `model_provider`（中转站）无关——curated 插件的发现/安装走 ChatGPT 后端、看 token 里的订阅状态，不走 mysub。不要先怀疑 provider / 网络 / marketplace 配置。

## ChatGPT App 启动报 "Codex app-server initialize handshake timed out" 处理
- 2026-07-15 实测：ChatGPT 桌面应用（OpenAI.Codex 26.707.x）启动时会把 Codex app-server 通过 `wsl.exe` 跑在 Ubuntu-24.04 里，需要先把 `/mnt/c/Users/ys199/.codex` 的会话状态回填到 WSL 内 `/root/.codex/sqlite` 的 SQLite；`~/.codex/sessions` 有 458MB/近 500 个文件，跨 `/mnt/c` 的 9p 访问极慢，30 秒握手超时被掐死，日志报 `timed out waiting for state db backfill at /mnt/c/Users/ys199/.codex (status: running)`。
- 有效修法：`wsl --shutdown` 重启 WSL（清掉卡死的 backfill 进程/stale 状态）后再启动 ChatGPT 应用，应用会改走 Windows 原生 `codex.exe`（app 包内 `resources\codex.exe`），握手 1 秒多即成功。
- 排查入口：应用日志在 `%LOCALAPPDATA%\Packages\OpenAI.Codex_2p2nqsd0c76g0\LocalCache\Local\Codex\Logs\<年>\<月>\<日>\`，搜 `initialize_handshake_result` 和 `stdio_transport_spawned` 可看到用的是 WSL 还是 Windows codex，以及失败原因原文。
- 注意：不要手动 `CODEX_HOME=/mnt/c/... codex app-server` 补跑回填——sqlite 建在 /mnt/c 上会直接失败，而且多个 app-server 扫 /mnt/c 会把整个 WSL 压到无法新建会话（报 0x8007274c），只能 `wsl --shutdown` 恢复。若复发可考虑归档瘦身 `~/.codex/sessions`（2026-07 单月就 254MB）。
## ChatGPT App 微软商店更新失败处理
- Microsoft Store 官方商品 ID 为 `9PLM9XGG6VKS`，系统包名仍是 `OpenAI.Codex`，包族为 `OpenAI.Codex_2p2nqsd0c76g0`；商店只显示“打开”不代表一定是最新版。
- 2026-07-10 实测：商店把 `26.623.19656.0` 误判为最新版，`winget msstore` 报 `WinHttpSendRequest 12030 / 0x80072efe`，直连 `fe3.delivery.mp.microsoft.com` 又在 TLS 握手阶段被重置，而官方目录已有 `26.707.3563.0`。
- 先从 `displaycatalog.mp.microsoft.com/v7.0/products/9PLM9XGG6VKS` 比较官方 x64 `PackageFullName` 与本机 `Get-AppxPackage OpenAI.Codex` 版本，不要只看商店按钮。
- 更新链路不通时，打开 `D:\wandacloud\wandacloud.exe`，临时切“全局代理”并连接；`curl -I https://fe3.delivery.mp.microsoft.com/ClientWebService/client.asmx` 返回 HTTP 400 即表示 TLS 已打通（空 HEAD 请求返回 400 属正常）。
- 用 `StoreDev/StoreLib` 查询微软 DCAT/FE3 的 x64 MSIX 地址，下载必须支持 `curl -C -` 断点续传；安装前必须同时核对官方 Base64 SHA-256、完整文件大小和 `Get-AuthenticodeSignature` 的 `Valid` 状态。
- 就地升级用 `Add-AppxPackage -Path <msix> -DeferRegistrationWhenPackagesAreInUse`，再核验版本和 `Status=Ok`；完成后恢复万达云原模式并清理临时包。详细手册在 `E:\366256\vibecoding\知识库\工具\ChatGPT应用微软商店更新失败处理.md`。

## Codex node_repl MCP 启动警告
- 2026-06-05 实测：Codex 升级后 `~/.codex/config.toml` 里的 `[mcp_servers.node_repl]` 如果仍指向 `C:\Users\ys199\AppData\Local\OpenAI\Codex\bin\<hash>\node_repl.exe`，启动会报 `MCP client for node_repl failed to start: 系统找不到指定的路径。 (os error 3)`。
- 修法：把 `command` 改成稳定入口 `C:\Users\ys199\AppData\Local\OpenAI\Codex\bin\node_repl.exe`，同时把 `CODEX_CLI_PATH` 改成 `...\Codex\bin\codex.exe`，`NODE_REPL_NODE_PATH` 改成 `...\Codex\bin\node.exe`，不要继续固定旧哈希目录。
- 2026-06-11 复发根因：除了 `config.toml`，`C:\Users\ys199\.codex\chrome-native-hosts.json` 和 `C:\Users\ys199\AppData\Local\OpenAI\Codex\chrome-native-hosts.json` 也可能保留旧哈希路径；`C:\Users\ys199\.codex\repair-node-repl-paths.ps1` 会自动把 `config.toml`、两份 `chrome-native-hosts.json` 里的 `codex.exe`、`node.exe`、`node_repl.exe` 拉回稳定入口。
- 2026-06-16 二次复发根因：npm 升级到 Codex CLI 0.140.0 后覆盖了 `D:\Users\ys199\NodeGlobal\codex.ps1` / `codex.cmd` / `codex`，导致启动前自修复失效。已新增不受 npm 覆盖的稳定包装入口 `C:\Users\ys199\bin\codex.ps1`、`C:\Users\ys199\bin\codex.cmd`、`C:\Users\ys199\bin\codex`，用户级 PATH 已把 `C:\Users\ys199\bin` 放在 `D:\Users\ys199\NodeGlobal` 前面；三种入口都会先运行 `repair-node-repl-paths.ps1` 再转发到 NodeGlobal 的 Codex。
- 兜底：启动文件夹里有 `codex-node-repl-path-repair.lnk`，登录时静默执行同一个修复脚本。验证：`codex mcp list` / `codex mcp get node_repl` 应显示 `Command = C:\Users\ys199\AppData\Local\OpenAI\Codex\bin\node_repl.exe` 且状态为 enabled；`codex --version` 应能正常返回当前版本。

## Claude Code Windows Bun 段错误处理
- 2026-06-06 实测：`claude --permission-mode bypassPermissions` 在 Claude Code `2.1.160` 上进入交互模式时可能触发 Bun `Segmentation fault`，崩溃栈里出现 `LHShield64.dll`；该 DLL 来自奇安信天擎 `D:\Program Files (x86)\Qianxin\Tianqing\security\LHShield64.dll`，会注入多个进程。
- 低风险修法优先：执行 `claude update` 升级原生安装到最新版，再用 `npm uninstall -g @anthropic-ai/claude-code` 清理重复的 npm 全局安装，避免 PATH 命中不同入口。2026-06-06 已从 `2.1.160` 升到 `2.1.167`，`where claude` 只剩 `C:\Users\ys199\.local\bin\claude.exe`。
- 验证：`claude --version` 应显示最新版；`claude --permission-mode bypassPermissions --print "只回答 OK"` 应正常返回 `OK`。若最新版交互模式仍崩，再重点排查/临时关闭奇安信天擎对 `claude.exe` 的注入或白名单。
- 2026-07-26 再次复现：Claude Code `2.1.220` / Bun `1.4.0` 运行约 15 秒即段错误，崩溃链接反复出现 `MozartBreathCore.dll` 和 `MozartBreathBolo2.dll`。两者来自联软科技 `UniAccessAgent`，路径为 `C:\Windows\LVUAAgentInstBaseRoot\system32\`；`UniKInject` 驱动会向 `claude.exe` 注入 6 个 `MozartBreath*` DLL。该问题与模型、项目代码和内存不足无关。
- 有效修法：以管理员 PowerShell 执行 `Set-ProcessMitigation -Name claude.exe -Enable MicrosoftSignedOnly`，只阻止非微软签名 DLL 动态加载到 `claude.exe`，无需停用公司终端管控。修复后实测注入模块从 6 个降为 0，1 次单任务及 3 次并发 20 秒任务均正常退出，退出码 0、无标准错误。
- 核验：`(Get-ProcessMitigation -Name claude.exe).BinarySignature.MicrosoftSignedOnly` 应为 `ON`。如该策略导致后续 Claude 版本兼容问题，以管理员 PowerShell 执行 `Set-ProcessMitigation -Name claude.exe -Disable MicrosoftSignedOnly` 撤销。
- 2026-07-27 补充：`MicrosoftSignedOnly` 会阻止联软的 `Vozokopot.dll`，但 `UniKInject` 仍会强制尝试注入，Code Integrity 事件 3033 会记录拦截，桌面偶尔弹出 `claude.exe - 损坏的映像`，错误码 `0xc0000428`；DLL 的 Authenticode 签名本身为 `Valid`，并非文件损坏。额外启用 `DisableExtensionPoints` 不能阻止该内核驱动注入。
- 弹窗处理：已部署 `D:\Users\ys199\Documents\AutoHotkey\claude-injection-dialog-guard.ahk`，只自动关闭 `claude.exe` 中正文含 `LVUAAgentInstBaseRoot` 或 `SangforNspX64.dll` 的“损坏的映像 / Bad Image”对话框，不会吞掉其他真实损坏提示；开机启动项为 `claude-injection-dialog-guard.lnk`，命中日志为 `%APPDATA%\ClaudeInjectionDialogGuard\guard.log`。签名保护继续保持 `ON`，不要为消除弹窗而撤销，否则 Bun 可能重新被注入并段错误。


## Claude Code Transcript 保存被关闭处理
- 2026-07-31 实测：启动 Claude Code 时提示 Transcript saving is off — inherited CLAUDE_CODE_CHILD_SESSION marker，原因是进程环境里存在 CLAUDE_CODE_CHILD_SESSION=1（Claude Code 认定自己是"子会话"而自动关闭记录保存）；该变量不在用户级/机器级环境变量中，来自启动 claude 的终端会话环境（本机为 WezTerm 下的 cmd）。
- 永久修复：已写入用户级环境变量 CLAUDE_CODE_FORCE_SESSION_PERSISTENCE=1，之后新启动的终端/进程自动生效，无需再手动设置。
- 已打开的旧终端窗口不继承新用户级变量，需先手动执行 $env:CLAUDE_CODE_FORCE_SESSION_PERSISTENCE="1"（PowerShell）或 set CLAUDE_CODE_FORCE_SESSION_PERSISTENCE=1（cmd）再启动 claude，或完全重启 WezTerm。
- 验证：CLAUDE_CODE_CHILD_SESSION=1 与 CLAUDE_CODE_FORCE_SESSION_PERSISTENCE=1 同时存在时，claude -p 仍正常生成 ~/.claude/projects/<目录>/*.jsonl 新记录，FORCE 变量优先于 CHILD_SESSION 标记。
## Antigravity CLI（agy）Windows 启动崩溃处理
- 2026-05-27 实测：`C:\Users\ys199\AppData\Local\agy\bin\agy.exe` 直接在 PowerShell 中运行会在 Go runtime 初始化阶段崩溃，典型报错是 `fatal error: unknown caller pc`，栈里有 `google3/third_party/golang/enry/data.init()`。
- 安装目录里的 `agy.cmd` 已设置 `GOGC=off`，用 wrapper 调用可正常运行；`--dangerously-skip-permissions` 参数仍存在，不是参数被删除。
- 为避免 PowerShell/cmd 优先命中 `.exe`，已把原二进制改名为 `agy-bin.exe`，并把 `agy.cmd` 改为调用 `agy-bin.exe`。验证 `agy --version` 返回 `1.0.1`，`agy --dangerously-skip-permissions --help` 正常。
- 如果以后 `agy update` 或重装又生成了 `agy.exe`，先检查 `Get-Command agy` 是否再次指向 `.exe`；若是，按同样方式让裸 `agy` 命中带 `GOGC=off` 的 wrapper。
- 2026-05-27 17:12 Windows `Microsoft-Windows-Resource-Exhaustion-Detector` 事件 2004 记录过 `agy-bin.exe` 虚拟内存暴涨：PID 28196 用 46847565824 字节、PID 46400 用 25197154304 字节，合计约 72GB；17:06 另有 `RADAR_PRE_LEAK_64` 指向 `agy-bin.exe.1779872506257155100.old`。若再次出现高内存，先查 `Get-WinEvent` 的 Resource-Exhaustion-Detector/RADAR 记录和是否有更新残留的旧 `agy-bin.exe.*.old` 进程。

## 本地知识库

知识库位于 `E:\366256\vibecoding\知识库\`，通过 Syncthing 跨设备同步。**不管当前工作目录在哪里**，遇到以下指令时都要操作该目录：

- **存入知识**：用户说"记一下"、"存一下"、"记录"、"保存到知识库"等时，将内容存为 markdown 文件到知识库对应分类子目录（技术/工作/工具/生活/其他），并更新 `INDEX.md`。文件带 frontmatter（title、tags、created、updated）。
- **查询知识**：用户说"查知识库"、"知识库里有没有"、或提问时明确提到知识库，先用 Grep/Glob 搜索 `E:\366256\vibecoding\知识库\` 下的文件，基于搜索结果回答并注明来源文件。知识库中未找到则明确告知。
- **管理知识**：用户说"删除/更新/修改"某条知识时，找到对应文件操作；说"列出/有哪些"时展示索引或文件列表。

详细规则见 `E:\366256\vibecoding\知识库\CLAUDE.md`。

## 中文 CSV 乱码预防（强制规则，2026-06-10）
- 凡是给 Excel 双击打开的中文 CSV/文本文件，必须写成 **带 BOM 的 UTF-8（utf-8-sig）**，绝不能写裸 UTF-8——中文 Windows 的 Excel 双击打开 CSV 默认按 GBK 解析，裸 UTF-8 必乱码。
- Claude/Codex/Antigravity 的 Write/编辑工具默认写**不带 BOM** 的 UTF-8，所以**不要用 Write 工具直接创建中文 CSV**；改用 python：`Path(...).write_text(text, encoding='utf-8-sig')` 或 `open(..., 'w', encoding='utf-8-sig', newline='')`。
- 程序读 CSV 用 `utf-8-sig` 优先（自动剥 BOM），需兼容历史文件时按 `utf-8-sig → gbk → utf-16` 顺序尝试。
- 已踩坑案例：多氟多电缆工具 `data\参数.csv`、`柜名别名.csv`、`强制规则.csv` 曾以裸 UTF-8 创建，Excel 打开全乱码，已统一转 utf-8-sig 并验证 Excel/脚本两边正常。

## Windows 右键菜单极速优化
- 2026-06-11 为解决资源管理器右键菜单反应很慢，已启用经典右键菜单：`HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32` 默认值为空，并重启 Explorer 生效。
- 已通过 `HKCU\Software\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked` 屏蔽 21 个第三方/非核心右键 Shell 扩展，目标是极限加快右键弹出速度。涉及 WPS/轻文档、坚果云、AutoCAD Shell Extension、WinRAR、NVIDIA 桌面菜单、PowerToys File Locksmith、网盘/同步/加密/共享/离线文件等右键扩展；不卸载软件本体，只禁止资源管理器加载这些菜单扩展。
- 备份位置：注册表导出在 `D:\Users\ys199\Desktop\right-click-reg-backup-20260611-180721\`，禁用清单在 `D:\Users\ys199\Desktop\right-click-disabled-extensions-20260611-180947.csv`。如需恢复，可删除 Blocked 中对应 CLSID，或导入备份；如需恢复 Windows 11 新式右键菜单，删除 `{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}` 这个 HKCU CLSID 键后重启 Explorer。

## Tailscale 内网使用要点
- 2026-06-26 已把 3 号服务器 `sen3` 加入 `sen0701001@gmail.com` 的 Tailscale tailnet。Tailscale IPv4 为 `100.90.234.37`，MagicDNS 后缀为 `tail8e1361.ts.net`，完整域名为 `sen3.tail8e1361.ts.net`；本机 Windows 设备为 `sjy-14000048`，Tailscale IPv4 为 `100.80.29.122`，完整域名为 `sjy-14000048.tail8e1361.ts.net`。
- MagicDNS 已开启，可优先尝试 `ssh -i .\ssh-key-2026-04-21.key ubuntu@sen3.tail8e1361.ts.net`；若本机 DNS 客户端状态正常，也可尝试短名 `ssh -i .\ssh-key-2026-04-21.key ubuntu@sen3`。裸 IP 方式为 `ssh -i .\ssh-key-2026-04-21.key ubuntu@100.90.234.37`。
- Tailscale 默认每台设备获得 `100.x.y.z` 私网地址；已加入同一 tailnet 的设备通常不需要额外开放公网端口即可互通。若想提高直连概率，可在云安全组/系统防火墙放行 UDP `41641`，但不放也可经 DERP 中继。
- Tailscale 适合给自用管理面板、VNC/noVNC、临时调试端口、代理服务提供“只给自己访问”的入口，减少公网暴露。要分享给别人时优先用 Tailscale 的 Share node，而不是开放公网端口；多人/多设备加入后再用 ACL 限制哪些设备能访问哪些服务。
- 2026-06-26 排查：`sen3` 的 `fail2ban` 曾把 Windows Tailscale IP `100.80.29.122` 加进 `sshd` 封禁集合，导致 `100.90.234.37:22` 超时；已在 `sen3:/etc/fail2ban/jail.d/sshd-local-ignore.conf` 给 `sshd` jail 添加 `ignoreip = 127.0.0.0/8 ::1 10.241.0.0/16 100.64.0.0/10` 并解除封禁。以后若 Tailscale ping 通但 SSH 超时，优先查 `fail2ban-client status sshd` 和 nftables 里的 `f2b-table`。

## 本地项目总览工具
- 2026-07-10 已在 `E:\366256\vibecoding\visio-project` 创建 Windows 桌面工具“项目总览”，便携版为 `release\项目总览.exe`。程序默认只读扫描 `E:\366256` 下的 `20xx年`、月份和项目文件夹，支持树状展开、搜索、年度/月度统计、收藏、最近打开、排除非项目目录和双击打开资源管理器；未来新增年份、月份和项目会自动刷新。2026-07-12 新增“项目画布”：以大括号展示“总览 → 年份 → 月份 → 项目”，年份和月份可分别展开或收起并保存状态，画布空白区域可自由拖动，工具栏可全部展开、全部收起或回到起点。
- 用户设置保存在 `%APPDATA%\项目总览\config.json`，包含扫描根目录、排除、收藏、最近打开和展开状态；不会修改、移动或删除项目文件。源码重新打包命令为 `npm run dist`。
- GitHub 公开仓库为 `https://github.com/y1991427360s/project-atlas`；公开版下载位于 Releases，附件名 `Project-Atlas-Windows-x64.exe`。公开源码和公开版已替换真实项目演示数据，首次启动由使用者选择自己的项目根目录。

## WSL Ubuntu 24.04 开发环境
- 2026-07-15 实测：唯一发行版为 WSL 2 的 `Ubuntu-24.04`，实际文件位于 `D:\WSL\Ubuntu-24.04\ext4.vhdx`；Linux 内核 `6.6.87.2-microsoft-standard-WSL2`，默认用户仍为 `root`。
- `/etc/wsl.conf` 已启用 `[boot] systemd=true`。冷启动后 `systemd` 状态为 running，无失败单元；Docker `29.1.3`、Docker Compose `2.40.3`、Buildx `0.30.1` 已安装并启用，普通用户 `ys199` 已加入 `docker` 组。
- Docker 守护进程通过 `/usr/local/sbin/generate-wsl-proxy-env`、`wsl-proxy-env.service` 和 `docker.service.d/proxy.conf` 在每次启动时读取 WSL 默认网关，动态生成 `/run/wsl-proxy.env`，使用 Windows 的 `7892` 代理端口；已从 Docker Hub 拉取并运行 `hello-world` 验证成功。
- root 交互终端的 `/root/.bashrc` 仍使用 Windows 以太网地址 `10.3.5.8:7892`，Google、GitHub、OpenAI 和 Git 操作实测可达；普通用户 `ys199` 尚未配置交互式代理。WSL NAT 下 `127.0.0.1:7892` 不可用，WSL 默认网关代理可用。
- Ubuntu 软件包已于 2026-07-15 完整更新，待升级数量为 0；WSL 内 Codex 为 `0.144.4`，Claude Code 为 `2.1.210`，Node.js 为 `22.23.1`。
- SSH 密钥 `/root/ssh-key-2026-04-12.key` 已移动到 `/root/.ssh/ssh-key-2026-04-12.key`，权限为 `600`；`/root/.ssh` 权限为 `700`。
- Linux 项目统一放在 `/home/ys199/projects` 并归 `ys199:ys199` 所有。`work-sen666-cn`、`work-export-fix`、`sen666-db-migration` 和原 `/root/desktop` 已迁入；原 `/root/...` 路径保留符号链接，旧命令仍可使用。

## Codex / Claude Code 任务完成 Bark 通知
- 2026-07-16 已在 `E:\366256\vibecoding\watch` 部署统一 Bark 通知器：Codex CLI 或 Claude Code CLI 主智能体完成一轮工作后向 iPhone 推送，iPhone 上的 Bark 通知可继续由小米运动健康同步到小米手环。
- Codex CLI `0.144.4` 使用全局 `notify` 指向 `codex-notify-router.ps1`；转发器会同时调用原有 ChatGPT 桌面端 `codex-computer-use.exe turn-ended`，不会破坏电脑控制通知。Codex 全局 `Stop` hook 需要额外的 hook trust，不作为本工具入口。
- Claude Code `2.1.209` 使用 `~/.claude/settings.json` 的全局 `Stop` hook。Windows 上必须使用 `command = powershell.exe` 加独立 `args` 的 exec 形式，不能使用 shell 字符串形式，也不要设 `async = true`；后两种在本机 Bun `1.4.0` 上实测会导致 Claude Code 退出阶段段错误。
- Bark 地址使用 Windows 当前账户 DPAPI 加密后保存在 `%APPDATA%\AI-Task-Notifier\config.json`，日志为同目录 `notifier.log`；默认只发 CLI 名称、电脑名、项目名和时间，不发送回答摘要。重新配置运行 `setup-bark.ps1`，卸载运行 `uninstall-hooks.ps1`。
- 2026-07-24 实测：Claude Code 不推 Bark 时，优先检查 `~/.claude/settings.json` 的 `hooks.Stop` 是否仍含 `E:\366256\vibecoding\watch\task-notifier.ps1`。本机曾被改成只调用桌宠 `D:\Syncthing\Oracle-Sync\tools\pets\notify-pet.ps1`，桌宠有气泡但手机无通知；`notifier.log` 连续只有 Codex 条目可佐证。
- 修复：重跑 `E:\366256\vibecoding\watch\install-hooks.ps1`。安装器会保留其他 Stop hook（含桌宠），并追加 Bark 的 `powershell.exe` + `args` 形式；两者可并存。收尾复查时还出现过 settings 被再次覆盖只剩桌宠的情况，若 Claude 再次不通知，按同样步骤重装 hook。
- 手动验证：`powershell.exe -NoProfile -ExecutionPolicy Bypass -File E:\366256\vibecoding\watch\task-notifier.ps1 -Source "Claude Code" -TestMode`，成功后 `notifier.log` 应出现 `推送成功：Claude Code / ...`。

## 物理互动实验室发布与验收规则
- 项目本地源码：`D:\Syncthing\Oracle-Sync\baobao\teach`；公网地址：`https://sen666.cn/teach/`；部署到 3 号服务器 `/var/www/sen666-cn/teach`。
- 每次修改该项目后必须立即部署 `index.html`、`assets/`、`experiments/`，发布前保留带时间戳的远端备份；不能只完成本地版本就结束。
- 用户只以公网版本验收。发布后必须用真实浏览器在 `https://sen666.cn/teach/` 检查受影响页面的桌面端与手机端、交互、控制台错误、404 和横向溢出，最终回复给出可直接点击的公网链接。

## 发布后必须输出公网下载链接（强制规则，2026-07-19）
- 凡是 `baobao/APP`（SEN 入口 App）或任何把产物推到 `sen666.cn/app/<product>/` 的项目，发布脚本 `PUBLISH_OK` 之后必须立刻给用户下面 5 项内容，少一项视为没发完：
  1. **公网 APK 下载链接**：`https://sen666.cn/app/<product>/releases/<filename>`
  2. **公网 manifest 链接**（如有）：`https://sen666.cn/app/<product>/latest.json`
  3. **本机 APK 路径**：`release/<文件名>`
  4. **SHA-256**（本机和远端都要给，并确认一致；用 SSH 上 sen3 取 `sha256sum`）
  5. **versionCode / versionName** + **git commit hash**
- 不允许只说"已发布"或"发布成功"就停；用户需要在手机浏览器里直接点链接下载，链不出来等于没发。
- 失败时也要把失败原因（哪一步、SSH 报错、PowerShell 异常原文）原样贴出来，不要只写"发布失败"。
