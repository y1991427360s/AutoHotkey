---
name: project_speedmonitor_gpu_nvml
description: "SpeedMonitor 网速小工具 GPU 读取改用 NVML；以及\"鼠标旁沙漏一直闪\"的排查套路"
metadata: 
  node_type: memory
  type: project
  originSessionId: 93597f0a-1291-40ac-8690-5335a1137e42
---

用户自写的桌面小工具 **SpeedMonitor**（C# WinForms，net8.0-windows，源码 `E:\366256\vibecoding\speedtest\`，发布到 `publish\`，注册表 HKCU Run 键自启）。

**2026-06-02 排查"鼠标右侧沙漏(App Starting 光标)一直闪烁"**：根因是该工具每秒 `new Process` 启动 `nvidia-smi.exe` 查 GPU，子进程间歇崩溃 → 每次触发 `WerFault.exe` + `conhost.exe`，形成"启动→崩溃→错误报告"循环，光标狂闪。（另有 `i4Service.exe`/爱思助手 i4Tools9 满核空转，是额外 CPU 占用、非闪烁主因，已把 `i4ToolsService` 服务禁用。）

**GPU 读取三条路实测结论（这台 NVIDIA 机器，GPU Engine 有 639 个实例）**：
1. ❌ 每秒 spawn `nvidia-smi.exe` → 闪烁+崩溃（进程启动本身的代价，不是 NVIDIA 的错）。
2. ❌ Windows "GPU Engine" 性能计数器（`PerformanceCounter.NextValue` 逐实例 / `ReadCategory` 全量 / `Get-Counter`）→ **单次 PDH 采集就要 1.6~3 CPU 秒**，实例越多越炸，CPU 54~91%。many-instance 机器上 perflib 读 GPU 不可行。
3. ✅ **NVML 进程内 P/Invoke**：`nvml.dll`(在 `C:\Windows\System32\`)，`nvmlInit_v2` / `nvmlDeviceGetHandleByIndex_v2(0,out IntPtr)` / `nvmlDeviceGetUtilizationRates(handle,out {uint Gpu;uint Memory})` / `nvmlShutdown`，默认 DllImport(x64 调用约定无歧义)即可。微秒级、零进程、零闪烁，数值与 nvidia-smi 完全一致。最终 SpeedMonitor 稳态 CPU 5.7%（WinForms 1Hz 重绘的固有开销）。

**复用要点**：代码里要 NVIDIA GPU 利用率，用 NVML P/Invoke，别 spawn nvidia-smi、别用 GPU Engine perf counter。验证 P/Invoke 签名可先用 PowerShell `Add-Type` 复刻同样的 extern 调一遍。

**排查套路（沙漏狂闪）**：连续快照 `Get-CimInstance Win32_Process` 看哪些进程名在反复"诞生"（churn）；WerFault 的 `-i <pid> -e <pid>` 参数指向正在崩溃的进程；按 ParentProcessId 反查是谁在反复拉起。

相关：[[reference_gitbash_utf8_fix]]（本机命令行环境）。注意本机有企业安全代理 UniAccessAgent，会**间歇性拦截 powershell.exe 长命令**（短命令正常），长任务改用后台 .ps1 + ASCII 输出路径绕过。
