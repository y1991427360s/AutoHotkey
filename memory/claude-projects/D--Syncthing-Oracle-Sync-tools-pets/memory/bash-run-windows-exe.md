---
name: bash-run-windows-exe
description: "How to run powershell/Windows .exe from this project's git-bash (direct exec is Permission denied)"
metadata: 
  node_type: memory
  type: reference
  originSessionId: 57b5b17e-a81a-4d85-bb3d-decf73ab0f82
---

In this project's Claude Code Bash tool (git-bash on Windows), calling `powershell.exe` / `powershell` directly returns `Permission denied` (exit 126), even with `dangerouslyDisableSandbox: true`. `cmd.exe` *is* executable, but a bare `cmd.exe /c "..."` opens **interactively** (prints the banner, ignores `/c`) because MSYS rewrites the `/c` arg into a `C:\` path.

**Working invocation:** `MSYS_NO_PATHCONV=1 cmd.exe /c "powershell -NoProfile -ExecutionPolicy Bypass -File foo.ps1"` — the `MSYS_NO_PATHCONV=1` stops the path mangling so `/c` survives. Pipe through `tr -d '\r'` to clean CRLFs.

**Path quoting trap (cost me 2 retries):** do NOT wrap the `-File` path in escaped inner quotes like `-File \"D:\Syncthing\...\foo.ps1\"` — through the bash→cmd→powershell layers the `\"` corrupts into an invalid path ("路径中具有非法字符 / 为 -File 参数指定一个有效路径"). Instead pass the path **with forward slashes and unquoted**: `-File D:/Syncthing/Oracle-Sync/tools/pets/foo.ps1` (Windows PowerShell accepts `/`; works as long as the path has no spaces). For inline `-Command` with quotes, write a tiny `.ps1` helper and `-File` it rather than fighting nested quoting.

Gotchas:
- Heredoc-written `.ps1` test files have **no BOM**, so PS 5.1 reads them as ANSI and any Chinese/Unicode string triggers "字符串缺少终止符" parse errors. Keep throwaway PS test scripts ASCII-only, or add a BOM. (The real [[pet-startup-optimized]] scripts are fine — they ship with BOM.)
- Syntax-check a script without launching it: `[System.Management.Automation.PSParser]::Tokenize((Get-Content -Raw -Encoding UTF8 'path'),[ref]$e)`.
- `pwsh` (PowerShell 7) also exists at `C:\Users\ys199\AppData\Local\Programs\Programs\PowerShell\7\pwsh`, but the pet runs under 5.1 (`powershell.exe`), so validate under 5.1.
