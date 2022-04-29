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
    ^Right::
        Send {Right} ; does not work if there are multiple spaces, but that's OK.
        Send ^+m ; Select word
        Send {Right}{Left}
    return
#IfWinActive
