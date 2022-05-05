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

#IfWinActive ahk_exe soffice.bin
    ^+Space::
        Send, ^{Space}
        Send, ^0
    return

    ^!+2::
        Send ^!+{f15} ; Convert to numbered list
        Send ^!+{f14} ; Restart numbering
    return

    !PgUp::
        MouseGetPos, xpos, ypos
        MouseMove, A_ScreenWidth / 2, 120
        Click
        MouseMove, %xpos%, %ypos%
    return

    !PgDn::
        MouseGetPos, xpos, ypos
        MouseMove, A_ScreenWidth / 2, A_ScreenHeight - 120
        Click
        MouseMove, %xpos%, %ypos%
    return
#IfWinActive
