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
    CtrlRight:
        Send {Right} ; does not work if there are multiple spaces, but that's OK.
        Send ^+m ; Select word
        Send {Right}{Left}
    return

    ~^+Right::
    ~^+Left::
        if ((A_PriorHotkey = A_ThisHotkey) && (A_TimeSincePriorHotkey < 250)) {
            SetTimer, Selection_TrimRight, Off
        }

        SetTimer, Selection_TrimRight, -250
    return
#IfWinActive

Selection_TrimRight:
    Send {Alt Down}{f17}{Alt Up} ; disable copyq
    clipboard := ""
    Send ^c
    ClipWait 0.25 ; There may be no selection yet.
    clipboard := clipboard
    selection := clipboard
    Send {Alt Down}{f16}{Alt Up} ; Enable copyq and activate first item
    foundPos := RegExMatch(selection, "s)^(.*?)\s+$", match)

    if (foundPos = 0) {
        return
    }

    numOfWhitespaceChars := StrLen(selection) - StrLen(match1)
    Send +{Left %numOfWhitespaceChars%}
return
