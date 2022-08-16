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

GroupAdd, ExcludedApps, ahk_exe notepad++.exe
GroupAdd, ExcludedApps, ahk_exe devenv.exe
GroupAdd, ExcludedApps, ahk_exe Ssms.exe
GroupAdd, ExcludedApps, ahk_exe soffice.bin
GroupAdd, ExcludedApps, ahk_exe WinMergeU.exe
GroupAdd, ExcludedApps, ahk_exe idea64.exe

#IfWinActive ahk_exe WinMergeU.exe
    ^PgUp::
        Send {Blind}{Ctrl Up}
        clickOn(1)
        Send {Blind}{Ctrl Down}
    return

    ^PgDn::
        Send {Blind}{Ctrl Up}
        clickOn(0)
        Send {Blind}{Ctrl Down}
    return
#IfWinActive

#IfWinNotActive ahk_group ExcludedApps
    !PgUp::clickOn(1)
    !PgDn::clickOn(0)
#IfWinNotActive

clickOn(isTop) {
    ControlGetFocus, FocusedControl, A

    if ErrorLevel {
        return
    }

    ControlGetPos, controlTopLeft_X, controlTopLeft_Y
                 , control_width, control_height
                 , %FocusedControl%, A

    if (controlTopLeft_X = "") {
        return
    }

    ; MsgBox controlTopLeft_X: %controlTopLeft_X%, controlTopLeft_Y: %controlTopLeft_Y%, control_width: %control_width%, control_height: %control_height%

    targetX := controlTopLeft_X + control_width / 2
    targetY := isTop ? (controlTopLeft_Y + 20) : (controlTopLeft_Y + control_height - 40)

    MouseGetPos, currentX, currentY
    MouseMove, %targetX%, %targetY%
    Click
    MouseMove, %currentX%, %currentY%
}
