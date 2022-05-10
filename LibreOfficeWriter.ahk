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
        MouseMove, A_ScreenWidth / 2, 159 ; 1 adet toolbar için 39 çıkar
        Click
        MouseMove, %xpos%, %ypos%
    return

    !PgDn::
        MouseGetPos, xpos, ypos
        MouseMove, A_ScreenWidth / 2, A_ScreenHeight - 120
        Click
        MouseMove, %xpos%, %ypos%
    return

    !Right::Send ^+{f15} ; StatefulJumpModule / JumpToLink
    !Left::Send ^+{f16}  ; StatefulJumpModule / ReturnFromJump

    F3::
        Send ^f
        Send {Enter}
        Send {Esc}
    Return

    +F3::
        Send ^f
        Send +{Enter}
        Send {Esc}
    Return
#IfWinActive

#IfWinActive Fields ahk_class SALSUBFRAME ahk_exe soffice.bin
    ~Enter::
        Sleep 15
        Send !c   ; Close window
        Sleep 15
        Send {f5} ; Run the "RefineTextButton" macro
    Return
#IfWinActive
