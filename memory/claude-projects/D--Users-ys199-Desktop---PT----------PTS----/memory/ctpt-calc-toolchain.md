---
name: ctpt-calc-toolchain
description: 做互感器/CT/PT 参数校验计算时的本机工具链与算例资料位置
metadata: 
  node_type: memory
  type: project
  originSessionId: df70f763-1a36-462a-a0e2-b00397696a06
---

CT/PT 参数校验类任务（从 SLD 图提参数、对照保护装置要求逐间隔校核）的本机工具链与资料位置。

**资料**：`D:\Users\ys199\Desktop\简单PT计算学习\` 下有培训资料：各类算例 docx、`18KV CT-VT Sizing Calculation_Najran.xlsx`（成熟计算模板，多 section 分间隔）、SEL/西门子手册 PDF、课件公式截图 `2026.2.28-国际项目互感器参数计算培训\html_assets\ppt_slide_*.png`（可作公式出处附录）。

**工具链**（Windows + Git Bash）：
- SLD 多为矢量 CAD PDF，无可提取文本 → 用 `fitz`(PyMuPDF) 渲染表区（`get_pixmap(matrix=fitz.Matrix(z,z),clip=fitz.Rect(...))`，4~8x）再 OCR。
- OCR：`pytesseract`，二进制在 `C:\Program Files\Tesseract-OCR\tesseract.exe`（须显式设 `pytesseract.pytesseract.tesseract_cmd`）；`--psm 6` + `PIL.ImageOps.autocontrast`。注意 Read 工具读大尺寸 PNG 经常返回"Unsupported Image"，OCR 路线更可靠。
- 出稿：`openpyxl`（多表 Excel，判据 PASS/FAIL/WARN 自动标色）+ `python-docx`（Word，`add_picture` 嵌图，文件自包含）。均已安装。

**方法论**见知识库 `D:\Syncthing\Oracle-Sync\知识库\技术\全站CT-PT参数校验计算完整流程.md`（五步法 + 按用途路由公式 + 9 款保护装置 CT 要求速查 + 高频坑）。

2026-06-03 完成首个全站算例：132/13.8kV 预制舱站，输出 `CTPT计算实操_校验计算书.{xlsx,docx}` 到 `计算实例\PTS计算实操\`，生成脚本 `gen_final.py`/`gen_word.py` 保留可复用。
