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

EnvGet, A_LocalAppData, LocalAppData

RunWait, % A_LocalAppData "\Android\Sdk\emulator\emulator-original.exe -writable-system -dns-server 8.8.8.8 " RTrim(Format(StrReplace(Format("{:0" A_Args.length() "}", ""), 0, """{}"" "), A_Args*)), , Hide
