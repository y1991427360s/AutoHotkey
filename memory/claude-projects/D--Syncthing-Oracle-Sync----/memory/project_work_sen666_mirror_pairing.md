---
name: project_work_sen666_mirror_pairing
description: "work.sen666.cn 电缆导入的\"原始/镜像\"配对逻辑在哪、为何不能再反向改回"
metadata: 
  node_type: memory
  type: project
  originSessionId: ef7b292e-7dbd-48f7-924a-cdfca49d1a93
---

sen3 `work.sen666.cn`（电缆编号管理工具，`/home/ubuntu/work-sen666-cn`，FastAPI `dianlan-work.service` :8004，本地 postgres `dianlan`）的「原始/镜像」配对要点：

- 导入(`import_cables_from_excel`)把每行都建成 `is_mirror=False`(原始)；真正的配对发生在 `repair_imported_mirror_flags()`，它在**每次 `list_cables` 都会跑**。
- 配对判据用 `can_form_mirror_pair`：同电缆号 + 起终点互换 + 芯数一致 + **原理号(core 的 from/to_terminal)一致**。满足才把后出现的一条标 `is_mirror=True, mirror_of=原始id`；原理号/柜名/芯数不一致的同号电缆**不配对**，留作「电缆号重复」冲突供人工核对——这是正确行为，别强行配对。
- **历史坑**：该逻辑被反复来回改过（见 `cable_service.py.bak-20260423-*`）。2026-06-07 之前的版本里 `repair_imported_mirror_flags` 反而**强制把所有"Excel 导入"行 `is_mirror=False`**，导致用户(多氟多项目 id=13)导入后 609 条全是"原始"。已于 2026-06-07 改为调用新增的 `pair_imported_mirror_cables()` 做配对，并修了 model 推断为 None 时每次都误写 `updated_ids` 的非幂等 bug。**不要再把它改回"强制全原始"**。
- 改 backend 后必须 `sudo systemctl restart dianlan-work.service`（uvicorn 无 --reload）。配对会在重启后首次 list 自动自愈历史数据，幂等(重复跑 0 改动)。当时一并修复的项目：13(235对)、1(59对)、3(247对)。
