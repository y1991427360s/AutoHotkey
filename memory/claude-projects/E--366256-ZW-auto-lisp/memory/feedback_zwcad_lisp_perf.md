---
name: ZWCAD 2026 LISP 性能调优要点
description: ZWCAD 2026 批处理优先使用 CAD 空间索引、选择集批量命令和统一重绘，避免大列表 lambda 排序及逐对象命令刷新
type: feedback
originSessionId: d6bf5a43-dcb4-43d8-af8e-f491dffe2f29
---
在 ZWCAD 2026 里做 AutoLISP 批量几何处理时，以下原则已经实测有效：

1. **不要对大列表用 `vl-sort` + lambda 比较器**。ZWCAD 2026 上对几万条记录调一次 `(vl-sort lst (function (lambda ...)))` 就能把命令拖到几乎卡死，行为和 AutoCAD 不一样。如果一定要排序，先想想能不能换成 ssget 空间过滤或桶式分组。

2. **"每个对象找附近邻居"的问题，优先用 per-entity `ssget "_C" pt1 pt2 filter`** 把空间过滤交给中望自己的 C++ 空间索引，而不是 `ssget "_X"` 把全图捞回来再在 LISP 里 foreach 扫。本项目 ZZ 命令做完这一步从"几乎卡死"变成"极快"。

3. **不要在循环中逐对象调用原生命令或 `entupd`**。优先把选择集一次性交给原生命令，逐实体用 `entmod` 修改数据，最后统一 `redraw`。若 AutoCAD / ZWCAD 的批量命令行为可能不同，批处理后检查仍存在的对象，只对遗漏对象补处理。2026-07-10，`T` 刷字体命令将逐个 `EXPLODE` 和逐文字 `entupd` 改成该模式后，用户实测速度明显改善且效果正常。

4. **必须核对实际加载副本和覆盖顺序**。ZWCAD 2026 的 `%APPDATA%\ZWSOFT\ZWCAD\2026\zh-CN\Support\YS-Tools` 模块可能在工作区主文件之后加载并覆盖同名命令；`YS-Tools\aa-bundle.path` 应指向 `E:\366256\ZW-auto_lisp\AA整合版本.lsp`，修改后要同步生成兼容包并部署支持目录。

**Why:** 2026-05-23 给 ZZ 命令做优化时实测：原版 `ssget "_X"` 拿全图线段 + LISP foreach 扫描慢；加 vl-sort 排序剪枝想再提速，反而卡死；改成 per-text `ssget "_C"` 后速度立刻飞起。

**How to apply:** 调优本项目或其他中望 LISP 项目时，先判断工作能否交给 `ssget` 空间过滤或一次选择集命令，再考虑 LISP 数据结构；避免大列表 lambda 排序、循环内原生命令和逐实体刷新。还要记得 ssget pt 默认按当前 UCS 解释，标准 2D 平面图下与 WCS 一致；非标准 UCS 需要 `trans`。
