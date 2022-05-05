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

GroupAdd, ExcludedApps, ahk_exe notepad++.exe
GroupAdd, ExcludedApps, ahk_exe devenv.exe
GroupAdd, ExcludedApps, ahk_exe Ssms.exe

#IfWinNotActive ahk_group ExcludedApps
    ~^+Right::
        if ((A_PriorHotkey = A_ThisHotkey) && (A_TimeSincePriorHotkey < 250)) {
            SetTimer, Selection_TrimRight, Off
        }

        SetTimer, Selection_TrimRight, -250
    return
#IfWinNotActive

Selection_TrimRight:
    Send !{f17} ; disable copyq
    clipboard := ""
    Send ^c
    ClipWait 0.25 ; There may be no selection yet.
    clipboard := clipboard
    selection := clipboard
    Send !{f16} ; Enable copyq and activate first item

    if (StrLen(selection) = 0) {
        return
    }

    foundPos := RegExMatch(selection, "s)^(.*?)\s+$", match)

    if (foundPos = 0) {
        return
    }

    numOfWhitespaceChars := StrLen(selection) - StrLen(match1)
    Send +{Left %numOfWhitespaceChars%}
return
