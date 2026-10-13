---
name: pdf-doc-text-extraction-gitbash
description: 本机 Git Bash 缺 pdftoppm 导致 Read 工具读不了 PDF；抽 PDF/旧 .doc 文本的可用替代命令
metadata: 
  node_type: memory
  type: reference
  originSessionId: 9e1a808a-423a-4468-a325-6c7a57a5990f
---

本机（Windows + MSYS2/Git Bash）处理 PDF / 旧 `.doc` 的工具现状，2026-06-02 实测：

- **Read 工具读 PDF 会失败**：报 `pdftoppm failed: Command 'pdftoppm' not found`——本机 **没装 poppler 的 pdftoppm**（PDF 转图渲染缺失），所以 Read 工具无法把 PDF 当图片读。
- **但能抽 PDF 文本**：`pdftotext "x.pdf" -`（poppler 的 pdftotext 在 `/mingw64/bin`，已装）；Python 侧 `PyMuPDF (fitz)` 1.27、`pypdf` 6.x、`pdfminer` 也都可用。需要按页抽用 `pdftotext -f <起> -l <止>`。
- **旧 `.doc`（Word 97-2003 复合文档）**：用 `antiword "x.doc"`（`/mingw64/bin/antiword`，已装）抽文本；`file x.doc` 的元数据里常直接含 Title/Author，可快速判型。
- 与全局 CLAUDE.md 里"本机 Git Bash 没装 iconv"属同类环境事实——若以后常处理 PDF，可考虑把"pdftoppm 缺失、用 pdftotext/PyMuPDF/antiword 替代"补进全局 CLAUDE.md 的 Git Bash 工具段。

应用场景：下次要"读 PDF/旧 doc 内容"时，别指望 Read 工具直接读 PDF，先用上面的文本抽取命令。
