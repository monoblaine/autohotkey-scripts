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
#Include .\VD.ahk\VD.ahk

desktops := {}

!Tab::Send, ^+q ; ctrl + shift + q

#Tab::
    currentDesktopNum := VD.getCurrentDesktopNum()

    if (!desktops.hasKey(currentDesktopNum)) {
        desktops[currentDesktopNum] := { lastActivatedWin: 0, lastBuriedWin: 0 }
    }

    currentDesktop := desktops[currentDesktopNum]
    visibleWindows := GetVisibleWindows()
    windowCount := visibleWindows.MaxIndex()

    if (windowCount < 2) {
        currentDesktop.lastActivatedWin := 0
        currentDesktop.lastBuriedWin := 0
        Send, !{Esc}
        return
    }

    ; firstWin := visibleWindows[1]
    ; secondWin := visibleWindows[2]
    ; lastWin := visibleWindows[windowCount]
    ; lastActivatedWin := currentDesktop.lastActivatedWin
    ; lastBuriedWin := currentDesktop.lastBuriedWin
    ; MsgBox, windowCount is %windowCount%`n1st win in list: %firstWin%`n2nd win in list: %secondWin%`nLast win in list: %lastWin%`nlastActivatedWin: %lastActivatedWin%`nlastBuriedWin: %lastBuriedWin%

    if (currentDesktop.lastActivatedWin = visibleWindows[1]) and (currentDesktop.lastBuriedWin = visibleWindows[windowCount]) {
        currentDesktop.lastActivatedWin := 0
        currentDesktop.lastBuriedWin := 0
        Send, !+{Esc}
    }
    else {
        currentDesktop.lastActivatedWin := visibleWindows[2]
        currentDesktop.lastBuriedWin := visibleWindows[1]
        Send, !{Esc}
    }
return

!Home::
#Home::
    visibleWindows := GetVisibleWindows()

    if (visibleWindows.MaxIndex()) {
        WinActivate, ahk_id %visibleWindows1%
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
