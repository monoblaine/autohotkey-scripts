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

!Tab::Send ^+q ; ctrl + shift + q
#Tab::Send ^+y ; ctrl + shift + y
