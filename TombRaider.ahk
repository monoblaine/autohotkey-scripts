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
#MaxHotkeysPerInterval 200

#IfWinActive ahk_exe tomb123.exe
    RShift::.
    RAlt::LAlt
#IfWinActive
