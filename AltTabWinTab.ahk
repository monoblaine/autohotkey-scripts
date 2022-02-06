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

shouldGoBack := 0

!Tab::
    shouldGoBack := 0
    Send ^+q ; ctrl + shift + q
return

#Tab::
    tmp := shouldGoBack
    shouldGoBack := !shouldGoBack

    if (tmp) {
        Send, !+{Esc}
    }
    else {
        Send, !{Esc}
    }
return
