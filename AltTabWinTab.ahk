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
#SingleInstance force
#WinActivateForce
Process, Priority,, R

#include WinUtil.ahk

!Tab::
>#Tab::Send, ^+{F24} ; ctrl + shift + F24

<#Tab::
    visibleWindows := GetVisibleWindows()
    windowCount := visibleWindows.MaxIndex()

    if (windowCount = 0) {
        return
    }

    winToActivate := windowCount > 1 ? visibleWindows[2] : visibleWindows[1]
    WinActivate, ahk_id %winToActivate%
    winToActivate := ""
return

; Go to MRU - 1
#>+Tab::
    visibleWindows := GetVisibleWindows()
    windowCount := visibleWindows.MaxIndex()

    if (windowCount < 3) {
        return
    }

    winToActivate := visibleWindows[3]
    WinActivate, ahk_id %winToActivate%
    winToActivate := ""
return

!Del::
    if (WinExist("A")) {
        WinClose
        WinWaitClose
        Sleep 100
        visibleWindows := GetVisibleWindows()
        windowCount := visibleWindows.MaxIndex()
        if (windowCount > 0) {
            nextWin := visibleWindows[1]
            WinActivate, ahk_id %nextWin%
            nextWin := ""
        }
    }
return

~!Home::
    visibleWindows := GetVisibleWindows()

    if (visibleWindows.MaxIndex()) {
        firstWin := visibleWindows[1]
        WinActivate, ahk_id %firstWin%
        firstWin := ""
    }
return
