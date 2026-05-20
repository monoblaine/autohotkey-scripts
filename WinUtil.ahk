GetVisibleWindows() {
    visibleWindows := []
    WinGet windowList, List
    loop %windowList% {
        winAhkId := windowList%A_Index%
        WinGetTitle winTitle, ahk_id %winAhkId%
        if (winTitle = "") {
            continue
        }
        WinGet, winExStyle, ExStyle, ahk_id %winAhkId%
        ; WS_EX_TOPMOST:    0x00000008
        ; WS_EX_TOOLWINDOW: 0x00000080
        if (winExStyle & 0x00000088) {
            continue
        }
        WinGetClass winClass, ahk_id %winAhkId%
        WinGet, winStyle, Style, ahk_id %winAhkId%
        isUWP := winClass = "ApplicationFrameWindow"
        if (isUWP) {
            WinGetText, winText, ahk_id %winAhkId%
            if (winText = "" && !(winStyle = "0xB4CF0000")) {
                continue
            }
        }
        if !(winStyle & 0xC00000) { ; if the window doesn't have a title bar
            ; If title not contains ...  ; add exceptions
            continue
        }
        visibleWindows.Push(winAhkId)
    }
    return visibleWindows
}
