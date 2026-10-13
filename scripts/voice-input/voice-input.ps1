param(
  [int]$Seconds = 6,
  [string]$Server = "http://10.241.7.125:8778/inference"
)

Add-Type -AssemblyName System.Windows.Forms

$work = Join-Path $env:TEMP "voice-input"
New-Item -ItemType Directory -Force -Path $work | Out-Null
$wav = Join-Path $work ("rec-{0}.wav" -f ([DateTime]::Now.ToString("yyyyMMdd-HHmmss-fff")))

Add-Type -TypeDefinition @"
using System;
using System.IO;
using System.Runtime.InteropServices;
using System.Threading;

public class WasapiRecorder {
  [ComImport, Guid("BCDE0395-E52F-467C-8E3D-C4579291692E")] class MMDeviceEnumerator {}
  enum EDataFlow { eRender, eCapture, eAll }
  enum ERole { eConsole, eMultimedia, eCommunications }
  [Flags] enum CLSCTX : uint { INPROC_SERVER = 0x1, ALL = 0x17 }
  [Guid("A95664D2-9614-4F35-A746-DE8DB63617E6"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
  interface IMMDeviceEnumerator { int NotImpl1(); int GetDefaultAudioEndpoint(EDataFlow dataFlow, ERole role, out IMMDevice ppDevice); }
  [Guid("D666063F-1587-4E43-81F1-B948E807363F"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
  interface IMMDevice { int Activate(ref Guid iid, CLSCTX clsCtx, IntPtr pActivationParams, out IAudioClient ppInterface); }
  [Guid("1CB9AD4C-DBFA-4c32-B178-C2F568A703B2"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
  interface IAudioClient {
    int Initialize(int shareMode, int streamFlags, long hnsBufferDuration, long hnsPeriodicity, IntPtr pFormat, ref Guid audioSessionGuid);
    int GetBufferSize(out uint pNumBufferFrames);
    int GetStreamLatency(out long phnsLatency);
    int GetCurrentPadding(out uint pNumPaddingFrames);
    int IsFormatSupported(int shareMode, IntPtr pFormat, IntPtr ppClosestMatch);
    int GetMixFormat(out IntPtr ppDeviceFormat);
    int GetDevicePeriod(out long phnsDefaultDevicePeriod, out long phnsMinimumDevicePeriod);
    int Start();
    int Stop();
    int Reset();
    int SetEventHandle(IntPtr eventHandle);
    int GetService(ref Guid riid, out IAudioCaptureClient ppv);
  }
  [Guid("C8ADBD64-E71E-48a0-A4DE-185C395CD317"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
  interface IAudioCaptureClient {
    int GetBuffer(out IntPtr ppData, out uint pNumFramesToRead, out uint pdwFlags, out long pu64DevicePosition, out long pu64QPCPosition);
    int ReleaseBuffer(uint NumFramesRead);
    int GetNextPacketSize(out uint pNumFramesInNextPacket);
  }
  [StructLayout(LayoutKind.Sequential)] struct WAVEFORMATEX { public ushort wFormatTag, nChannels; public uint nSamplesPerSec, nAvgBytesPerSec; public ushort nBlockAlign, wBitsPerSample, cbSize; }

  public static void Record(string path, int seconds) {
    var enumerator = (IMMDeviceEnumerator)(new MMDeviceEnumerator());
    IMMDevice device; Marshal.ThrowExceptionForHR(enumerator.GetDefaultAudioEndpoint(EDataFlow.eCapture, ERole.eCommunications, out device));
    Guid iid = typeof(IAudioClient).GUID; IAudioClient client; Marshal.ThrowExceptionForHR(device.Activate(ref iid, CLSCTX.ALL, IntPtr.Zero, out client));
    IntPtr fmtPtr; Marshal.ThrowExceptionForHR(client.GetMixFormat(out fmtPtr));
    WAVEFORMATEX fmt = Marshal.PtrToStructure<WAVEFORMATEX>(fmtPtr);
    Guid session = Guid.Empty;
    Marshal.ThrowExceptionForHR(client.Initialize(0, 0, seconds * 10000000L, 0, fmtPtr, ref session));
    Guid capid = typeof(IAudioCaptureClient).GUID; IAudioCaptureClient cap; Marshal.ThrowExceptionForHR(client.GetService(ref capid, out cap));
    using (var fs = new FileStream(path, FileMode.Create, FileAccess.Write)) {
      byte[] fmtBytes = GetFormatBytes(fmtPtr, fmt);
      WriteHeader(fs, fmtBytes, 0);
      long dataBytes = 0;
      Marshal.ThrowExceptionForHR(client.Start());
      var end = DateTime.UtcNow.AddSeconds(seconds);
      while (DateTime.UtcNow < end) {
        uint packet; cap.GetNextPacketSize(out packet);
        if (packet == 0) { Thread.Sleep(10); continue; }
        IntPtr data; uint frames; uint flags; long pos, qpc;
        Marshal.ThrowExceptionForHR(cap.GetBuffer(out data, out frames, out flags, out pos, out qpc));
        int bytes = checked((int)(frames * fmt.nBlockAlign));
        byte[] buf = new byte[bytes];
        if ((flags & 0x2) == 0) Marshal.Copy(data, buf, 0, bytes);
        fs.Write(buf, 0, bytes); dataBytes += bytes;
        Marshal.ThrowExceptionForHR(cap.ReleaseBuffer(frames));
      }
      client.Stop();
      fs.Seek(0, SeekOrigin.Begin); WriteHeader(fs, fmtBytes, dataBytes);
    }
    Marshal.FreeCoTaskMem(fmtPtr);
  }
  public static double Rms16(string path) {
    byte[] data = File.ReadAllBytes(path);
    int pos = 12;
    while (pos + 8 <= data.Length) {
      string id = System.Text.Encoding.ASCII.GetString(data, pos, 4);
      int len = BitConverter.ToInt32(data, pos + 4);
      pos += 8;
      if (id == "data") break;
      pos += len + (len & 1);
    }
    if (pos >= data.Length) return 0;
    long sum = 0;
    long n = 0;
    for (int i = pos; i + 1 < data.Length; i += 2) {
      short v = BitConverter.ToInt16(data, i);
      sum += (long)v * v;
      n++;
    }
    return n == 0 ? 0 : Math.Sqrt((double)sum / n) / 32768.0;
  }
  static byte[] GetFormatBytes(IntPtr fmtPtr, WAVEFORMATEX f) {
    int size = f.cbSize > 0 ? 18 + f.cbSize : 16;
    byte[] bytes = new byte[size];
    Marshal.Copy(fmtPtr, bytes, 0, size);
    return bytes;
  }
  static void WriteHeader(Stream s, byte[] fmtBytes, long dataBytes) {
    var bw = new BinaryWriter(s);
    bw.Write(System.Text.Encoding.ASCII.GetBytes("RIFF")); bw.Write((uint)(36 + dataBytes)); bw.Write(System.Text.Encoding.ASCII.GetBytes("WAVE"));
    bw.Write(System.Text.Encoding.ASCII.GetBytes("fmt ")); bw.Write((uint)fmtBytes.Length); bw.Write(fmtBytes);
    bw.Write(System.Text.Encoding.ASCII.GetBytes("data")); bw.Write((uint)dataBytes);
  }
}
"@

try {
  [WasapiRecorder]::Record($wav, $Seconds)
  if ([WasapiRecorder]::Rms16($wav) -lt 0.003) { exit 0 }
  $curl = Get-Command curl.exe -ErrorAction Stop
  $json = & $curl.Source -s -X POST $Server -H "Expect:" -F "file=@$wav" -F "temperature=0" -F "response_format=json"
  if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($json)) { throw "transcription request failed" }
  $obj = $json | ConvertFrom-Json
  if ($obj.error) { throw ([string]$obj.error) }
  $text = ""
  if ($null -ne $obj.text) { $text = [string]$obj.text }
  elseif ($null -ne $obj.transcription) { $text = [string]$obj.transcription }
  else { $text = [string]$json }
  $text = $text.Trim()
  if ($text -match '^(字幕|字幕制作|谢谢观看|请不吝点赞|[（(]?字幕[:：].*[）)]?)$') { exit 0 }
  if (-not $text) { exit 0 }
  [Windows.Forms.Clipboard]::SetText($text)
  [Windows.Forms.SendKeys]::SendWait("^v")
} catch {
  [Windows.Forms.MessageBox]::Show($_.Exception.Message, "Voice Input", [Windows.Forms.MessageBoxButtons]::OK, [Windows.Forms.MessageBoxIcon]::Error) | Out-Null
  exit 1
}
