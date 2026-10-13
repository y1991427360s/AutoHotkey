---
name: Windows profile paths
description: 用户配置文件部分目录迁移到 D 盘，Documents 等不在默认 C:\Users\ys199 下
type: reference
originSessionId: 5b841f13-a31d-45ce-b2a1-b4c67f085d96
---
用户名为 `ys199`，但部分用户目录已重定向到 D 盘：
- `Documents` → `D:\Users\ys199\Documents\`
- 还存在 `D:\Users\ys199\AppDataMoved` 等迁移痕迹。

`C:\Users\ys199\` 下仍保留 AppData、Desktop（部分内容）、`.claude` 等。

How to apply: 引用用户文件路径时不要默认假设在 `C:\Users\ys199\Documents`，先用 `find` 或环境变量定位；放新文件时遵循已有的迁移规则（用户文档类放 D 盘）。
