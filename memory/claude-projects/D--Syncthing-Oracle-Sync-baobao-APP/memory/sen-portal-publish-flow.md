---
name: sen-portal-publish-flow
description: SEN 入口 Android App（baobao/APP）更新发布的实际参数、SSH 凭据位置、PowerShell 调用要点与 Windows 编码坑
metadata:
  node_type: memory
  type: project
  originSessionId: 34796a1d-a61a-4be5-a17f-b669a6f24c97
  modified: 2026-07-19T05:20:18.735Z
---

SEN 入口 App（`D:\Syncthing\Oracle-Sync\baobao\APP`，包名 `cn.sen666.portal`）发布自动更新的实操要点：

## 发布命令

```
powershell -NoProfile -ExecutionPolicy Bypass -Command "
  $env:PATH = 'C:\Windows\System32\OpenSSH;' + $env:PATH
  & '.\scripts\publish-update.ps1' -Notes '...' -Remote 'ubuntu@sen3' -RemoteRoot '/var/www/sen666-cn/app/sen-portal' -SshKey 'D:\Syncthing\Oracle-Sync\服务器\ssh-key-2026-04-21.key'
"
```

参数说明（这些不进仓库、不进文档）：

- `-Remote` 必须写成 `ubuntu@sen3`（带 `user@host` 前缀），不能只写 `sen3`——脚本直接把 `Remote` 拼进 `scp user@host:/path`，省略 user 时 PowerShell 会用本地用户名 `ys199` 凑上去，远端拒绝。
- `-SshKey` 是 sen3 真正的私钥。文件名带 `.key` 后缀，位置在 `D:\Syncthing\Oracle-Sync\服务器\ssh-key-2026-04-21.key`，SHA-256 `94704d90e65c12fad34b5840a42f7a5ab5c7c36219e45745b448b55899f08b53`，大小 1675 B。
- **`D:\Syncthing\Oracle-Sync\baobao\APP\ssh-key-2026-04-21.key` 不存在**，`~/.ssh/ssh-key-2026-04-21.key` 也不存在；MEMORY 之前写的位置是错的。
- `C:\Users\ys199\Downloads\ssh-key-2026-04-21`（1700 B，SHA `24b102b1…d6b5af`）和 `Desktop.backup-20260520-155030\新建文件夹\ssh-key-2026-04-21` 是同一份的过期副本，**不要用**，登录会失败；可清理。
- 线上清单：`https://sen666.cn/app/sen-portal/latest.json`；App 登录后约 1.6 秒自动检查，versionCode 大于本机即弹更新。

## Windows 原生 OpenSSH 与 known_hosts

- 从 Git Bash / Claude 子 shell 调 PowerShell 时，PATH 默认命中 `D:\Git\usr\bin\ssh.exe`（MSYS 版），它会重解析参数吞掉远程命令的单引号，远端报 `$1: unbound variable`。修法：发布前必须 `$env:PATH = 'C:\Windows\System32\OpenSSH;' + $env:PATH`。
- sen3 的 host key **不在本机 `~/.ssh/known_hosts`**。首次需要 `ssh -o StrictHostKeyChecking=accept-new -i <key> ubuntu@sen3 hostname` 接受一次，之后才能非交互登录。
- ssh 别名 `sen3-via-sen5`（`~/.ssh/config` 里 ubuntu@10.241.7.125 经 sen5 跳板）也可走；但直接 `ubuntu@sen3` / `ubuntu@10.241.7.125` 直连通常更短，不依赖跳板。

## 脚本与编码坑

- `scripts/publish-update.ps1` 必须保持纯 ASCII。无 BOM 的 `.ps1` 被 Windows PowerShell 5 按 ANSI/GBK 解析，中文注释的字节序列会吞掉行尾换行、把下一行代码静默并入注释（2026-07-15 实测：中文注释导致 `$manifest` 赋值行被吞、发布哈希校验神秘失败）。清单 JSON 读取已显式用 UTF-8。
- publish 脚本对 RemoteRoot 严格校验：`^/[0-9A-Za-z._/-]+$`，不接受中文、空格、点号目录穿越。

## 发布前核对

- 新旧 APK debug 签名 SHA-256 必须一致（`apksigner verify --print-certs`），否则手机拒绝覆盖安装；aapt 核对包名与 versionCode。
- 升级 versionName 时同步改 `package.json` + `android/app/build.gradle` 里的 `versionCode`（+1）+ `versionName`。脚本从 gradle 读 versionCode。

## 发布流程（必须执行到底）

1. 升 `package.json` 的 `version`（如 1.2.0 → 1.3.0）和 `android/app/build.gradle` 里的 `versionCode`（+1）+ `versionName`。
2. `npm run android:sync`（web build + `cap sync android`）。
3. `cd android && ./gradlew.bat assembleDebug`（JDK 21 需 `export JAVA_HOME=...`）。
4. 拷贝 `android/app/build/outputs/apk/debug/app-debug.apk` → `release/SEN-Portal-v<新版本>-debug.apk`。
5. `node scripts/create-update-manifest.mjs "中文更新说明"` → 生成 `artifacts/update/latest.json`。
6. 用 `publish-update.ps1` 上传（参数见上文）。**前置 Windows 原生 OpenSSH + 带 `user@host` 前缀**。
7. **远程核验并输出公网下载链接**（必做）：
   ```bash
   ssh -i 'D:\Syncthing\Oracle-Sync\服务器\ssh-key-2026-04-21.key' ubuntu@sen3 \
     'cat /var/www/sen666-cn/app/sen-portal/latest.json && \
      sha256sum /var/www/sen666-cn/app/sen-portal/releases/SEN-Portal-v<新版本>-debug.apk'
   ```
   - 校验清单 `versionCode` / `versionName` 与本机一致
   - 校验 APK 远端 SHA-256 与本机 `release/SEN-Portal-v<新版本>-debug.apk` 完全一致
   - 公网 `curl -sI https://sen666.cn/app/sen-portal/latest.json` 必须返回 `HTTP/2 200`
   - 公网 `curl -sI https://sen666.cn/app/sen-portal/releases/SEN-Portal-v<新版本>-debug.apk` 必须返回 `HTTP/2 200`
8. **回复用户时必须包含**：
   - 公网 APK 下载链接：`https://sen666.cn/app/sen-portal/releases/SEN-Portal-v<新版本>-debug.apk`
   - 公网 manifest 链接：`https://sen666.cn/app/sen-portal/latest.json`
   - 本机 APK 路径（`release/...`）
   - 本机 / 远端 SHA-256（确认一致）
   - versionCode / versionName
   - git commit hash

这样用户可以直接点链接在手机浏览器里下载 APK，不再需要先 SSH 拿。

## 已知发布历史

- 2026-07-15 v1.2.0（versionCode 7）—— 收藏拖动排序 + 统一登录凭据 Android Keystore 持久化 + 退出登录清理 WebView 会话，commit `1eb4d94`。
- 2026-07-19 v1.3.0（versionCode 8）—— Apple 风格动效与字体改造（motion / design token / sheet enter-exit / drag velocity handoff / 玻璃分级 / reduced-motion 等降级），commit `f535b46`。发布后用户报告 App 端未自动触发更新。
- 2026-07-19 v1.3.1（versionCode 9）—— 修复自动更新只触发一次的 bug：`scheduleUpdateCheck` 不再预置 latch flag，改由 `checkForUpdates` 入口置位并在离线 / catch / `clearPortalSession` 时清掉；auto 路径加 logcat warn。commit `8be1733`。