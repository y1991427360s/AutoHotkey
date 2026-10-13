# AutoHotkey 配置归档

本目录集中归档本机 AutoHotkey 脚本、现役 Excel/WPS 命令面板、启动项副本，以及 AI 工具的全局规则和 Claude 项目记忆。

GitHub 公开归档仓库：`https://github.com/y1991427360s/AutoHotkey`。Excel/WPS 面板保留独立仓库，通过子模块关联。下载完整归档请使用 `git clone --recurse-submodules https://github.com/y1991427360s/AutoHotkey.git`；已有克隆可执行 `git submodule update --init --recursive`。

## 目录

- `scripts/`：原 `D:\Users\ys199\Documents\AutoHotkey\` 下的通用脚本和历史备份。
- `projects/excel-ahk-command-panel/`：现役 Excel/WPS 自动化面板完整项目副本。
- `config/startup-links/`：与 AutoHotkey 有关的开机启动快捷方式副本。
- `docs/global/`：Claude Code、Codex、Antigravity 三份全局规则文件副本。
- `memory/claude-projects/`：Claude Code 各项目的记忆目录副本，保留原项目目录层级。
- `INVENTORY.md`：本机实际安装、现役入口和迁移说明。

## 兼容策略

原路径目前保留不动。全局规则、Claude 记忆和开机启动快捷方式都依赖固定路径，直接移除原文件会导致工具失去规则、记忆或自启能力。本目录作为集中归档源；确认后可另行把运行入口切换到这里。
