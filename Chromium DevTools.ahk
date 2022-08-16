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
SetTitleMatchMode, 2

GroupAdd, Group_ChromiumBasedApp, ahk_exe chrome.exe
GroupAdd, Group_ChromiumBasedApp, ahk_exe msedge.exe
GroupAdd, Group_ChromiumBasedApp, ahk_exe catsxp.exe

#IfWinActive DevTools -  ahk_group Group_ChromiumBasedApp
    ^w::Send !w
#IfWinActive
