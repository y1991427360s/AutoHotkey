#Requires AutoHotkey v2.0
#SingleInstance Force

; Ctrl+Shift+Space: record 6 seconds, transcribe on sen3, paste result.
^+Space:: {
    script := "D:\Users\ys199\Documents\AutoHotkey\voice-input\voice-input.ps1"
    Run 'pwsh.exe -NoProfile -ExecutionPolicy Bypass -File "' script '" -Seconds 6', , 'Hide'
}
