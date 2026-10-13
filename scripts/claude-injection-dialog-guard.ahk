#Requires AutoHotkey v2.0
#SingleInstance Force
#NoTrayIcon

global LogDir := A_AppData "\ClaudeInjectionDialogGuard"
global LogFile := LogDir "\guard.log"
DirCreate(LogDir)

SetTimer(DismissKnownInjectionDialogs, 100)

DismissKnownInjectionDialogs() {
    for hwnd in WinGetList("ahk_class #32770") {
        try {
            title := WinGetTitle(hwnd)
            body := WinGetText(hwnd)
            isClaude := InStr(title, "claude.exe -") = 1
            isBadImage := InStr(title, "损坏的映像") || InStr(title, "Bad Image")
            isKnownInjector := InStr(body, "LVUAAgentInstBaseRoot") || InStr(body, "SangforNspX64.dll")

            if isClaude && isBadImage && isKnownInjector {
                FileAppend(FormatTime(, "yyyy-MM-dd HH:mm:ss") " | " title " | " StrReplace(body, "`r`n", " ") "`n", LogFile, "UTF-8")
                WinClose(hwnd)
            }
        }
    }
}
