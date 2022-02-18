#NoTrayIcon
#NoEnv
#KeyHistory 0
ListLines Off
SetBatchLines, -1
SetKeyDelay, -1, -1
SetMouseDelay, -1
SetDefaultMouseSpeed, 0
SetWinDelay, -1
SetControlDelay, -1
SendMode Input
Process, Priority,, R
#SingleInstance force
#WinActivateForce

!Tab::Send, ^+q ; ctrl + shift + q

#Tab::
    visibleWindows := GetVisibleWindows()
    windowCount := visibleWindows.MaxIndex()

    if (windowCount = 0) {
        return
    }

    winToActivate := windowCount > 1 ? visibleWindows[2] : visibleWindows[1]
    WinActivate, ahk_id %winToActivate%
    winToActivate := ""
return

!Home::
    WinGetClass, activeWindowClass, A

    if (activeWindowClass = "Shell_TrayWnd") or (activeWindowClass = "WorkerW") {
        visibleWindows := GetVisibleWindows()

        if (visibleWindows.MaxIndex()) {
            firstWin := visibleWindows[1]
            WinActivate, ahk_id %firstWin%
            firstWin := ""
        }
    }
return

GetVisibleWindows() {
    visibleWindows := []
    WinGet windowList, List

    loop %windowList% {
        winAhkId := windowList%A_Index%

        WinGetTitle winTitle, ahk_id %winAhkId%

        if (winTitle = "") {
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
