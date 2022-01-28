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

!Tab:: ; ctrl + shift + q
    Send ^+q
    Sleep 50
    MouseMove, -10, 0, 0, R
    Sleep 50
    MouseMove, 10, 0, 0, R
return

#Tab::Send ^+y ; ctrl + shift + y
