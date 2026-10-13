---
name: sld-pdf-translate-overlay
description: 把英文 CAD 单线图(SLD) PDF 原位转中文的方法——文字是矢量轮廓不可直接换字体，需 OCR 定位+盖白底叠加中文
metadata: 
  node_type: memory
  type: project
  originSessionId: 40bd08b2-f5e8-4d77-bba5-68ed0647481f
---

PTS计算实操目录下 `Prefabricated SS CT-VT SLD.pdf` 是 CAD 导出的单线图：**全部文字是矢量轮廓(curves/lines)，PyMuPDF `get_text()` 返回空**，无法换字体。要"原位转中文、不改结构/位置"，唯一可行法是叠加覆盖。

已落地工具链（同目录可复现）：
- `_ocr_dump.py`：fitz 渲染→Tesseract(`C:/Program Files/Tesseract-OCR/`) OCR 取**词级框+PDF坐标**。多遍 OCR：整页 `--psm 11`(稀疏) + 标题栏/图例/底部数据表带分块 `--psm 6`/`--psm 11` 高倍率补小字。输出 `_ocr_words.json`。
- `_trans_map.py`：手写"规范英文→中文"词典(~150条，图例/数据表标题/设备名/标题栏/表头)。**纯代码/电压/变比/图号(如 13.8kV、2000/1A、PTS-25KM001)不译，留原文**。
- `gen_sld_cn.py`：词级聚类成行→对每行用 `difflib` 做**子跨度(best_span)倒排匹配**(junk 前缀不影响命中、只覆盖匹配到的词，不误伤数据表数字格)→`draw_rect` 盖白底+`insert_text(fontfile=msyh.ttc)` 叠加中文→`doc.subset_fonts()` 再 save。输出 `Prefabricated SS CT-VT SLD_中文.pdf`。

关键坑：
1. 不 `subset_fonts()` 会把整套雅黑嵌进去→文件 13MB；subset 后 ~0.9MB。
2. 阈值/长度比守卫防止短 OCR 串误命中长句(如裸 "132/13.8KV" 误配长表头)。
3. **残留**：部分重复的数据表列头(LOCATION/RATIO/CLASS/FUNCTION 等细小轮廓字)某些表块 OCR 读不到→仍英文；旋转90°的右侧版权竖排文字未处理。要全覆盖需模板法按表格网格定位贴标，OCR 法到此为瓶颈。

方法论参见 [[ctpt-calc-toolchain]]。
