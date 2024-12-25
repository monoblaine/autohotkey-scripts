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

        if (winExStyle & 0x8) {
            continue ; I don't want always-on-top windows in this list
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
