#NoTrayIcon
#SingleInstance force

GroupAdd, AppsThatHaveDefaultRawPasteDisabled, ahk_exe WinMergeU.exe ; WinMerge
GroupAdd, AppsThatHaveDefaultRawPasteDisabled, ahk_class Notepad++
GroupAdd, AppsThatHaveDefaultRawPasteDisabled, ahk_exe devenv.exe
GroupAdd, AppsThatHaveDefaultRawPasteDisabled, ahk_exe GitExtensions.exe

GroupAdd, AppsThatHaveExcessIndentRemovalEnabled, ahk_class Notepad++
GroupAdd, AppsThatHaveExcessIndentRemovalEnabled, ahk_exe WinMergeU.exe
GroupAdd, AppsThatHaveExcessIndentRemovalEnabled, ahk_exe devenv.exe
Return

#^a:: ; Win + ctrl + A
    ; Make the active window stay always on top
    Winset, Alwaysontop, , A
Return

#IfWinNotActive ahk_group AppsThatHaveDefaultRawPasteDisabled
    ^+v:: ; ctrl + shift + v
        ; Text–only paste from ClipBoard (Trims leading and trailing whitespaces)
        Clip0 = %ClipBoardAll%
        ClipBoard = %ClipBoard%       ; Convert to text
        ClipBoard := RegexReplace(ClipBoard, "^\s+|\s+$")
        Send ^v                       ; For best compatibility: SendPlay
        Sleep 50                      ; Don't change clipboard while it is pasted! (Sleep > 0)
        ClipBoard = %Clip0%           ; Restore original ClipBoard
        VarSetCapacity(Clip0, 0)      ; Free memory
    Return
#IfWinNotActive

#^+Up:: ; win + ctrl + shift + up arrow
    Send {Volume_Up}
Return

#^+Down:: ; win + ctrl + shift + down arrow
    Send {Volume_Down}
Return

:*:;;today::
    ; Replace ";;today" with current date
    FormatTime, CurrentDateTime,, yyy-MM-dd ; 2009-10-13
    SendInput %CurrentDateTime%
Return

:*:;;now::
    ; Replace ";;now" with current date and time
    FormatTime, CurrentDateTime,, yyy-MM-dd HH.mm ; 2009-10-13 10.57
    SendInput %CurrentDateTime%
Return

:*:;;snow::
    ; Replace ";;snow" with current date and time (with seconds)
    FormatTime, CurrentDateTime,, yyy-MM-dd HH:mm:ss ; 2009-10-13 10:57:23
    SendInput %CurrentDateTime%
Return

:*:;;vnow::
    ; Replace ";;vnow" with current date and time without separators
    FormatTime, CurrentDateTime,, yyyMMddHHmm ; 200910131057
    SendInput %CurrentDateTime%
Return

:*:;;time::
    ; Replace ";;time" with current date, time and day of week
    FormatTime, CurrentDateTime, L1055, d MMMM yyy dddd, HH.mm ; 13 August 2013 Tuesday, 13.17
    SendInput %CurrentDateTime%
Return

:*:;;date::
    ; Replace ";;date" with current date and day of week
    FormatTime, CurrentDateTime, L1055, d MMMM yyy dddd ; 26 April 2010 Monday
    SendInput %CurrentDateTime%
Return

:*:;;tm::
    ; Replace ";;tm" with current time surrounded by parentheses
    FormatTime, CurrentDateTime, L1055, HH.mm ; (13.17)
    SendInput (%CurrentDateTime%){Space}
Return

:*:;;pipe::
    SendInput {Raw}==============================================================================
Return

:*:;;dash::
    SendInput {Raw}------------------------------------------------------------------------------
Return

:*:;;mail::
    SendInput {Raw}zerhan@gmail.com
Return

^!+o:: ;; ctrl + alt + shift + o
    ; double click
    Send {Click 2}
Return

^!+1:: ; ctrl + alt + shift + 1
    ; Left click
    Send {Click 1}
Return

^!+2:: ; ctrl + alt + shift + 2
    ; Right click
    Click, Right
Return

^!+l:: ; ctrl + alt + shift + l
    Run, ClipToQuotedLines.exe
Return

^!+":: ; ctrl + alt + shift + "
    CoordMode, Mouse, Screen
    ; Move mouse pointer to "List all tabs" button (Firefox)
    MouseMove, A_ScreenWidth - 195, 15
Return

^!+w:: ; ctrl + alt + shift + w
    CoordMode, Mouse, Screen
    ; Move mouse pointer to somewhere safe
    MouseMove, A_ScreenWidth - 172, 0
Return

^!+e:: ; ctrl + alt + shift + e
    CoordMode, Mouse, Screen
    ; Move mouse pointer to somewhere safe (alternate)
    MouseMove, A_ScreenWidth - 90, 50
Return

^!+j:: ; ctrl + alt + shift + j
    CoordMode, Mouse, Screen
    ; Move mouse pointer to the center of the screen
    MouseMove, A_ScreenWidth / 2, A_ScreenHeight / 2
Return

#<+Left:: ; win + lshift + left arrow
    CoordMode, Mouse, Screen
    ; Move mouse pointer leftward
    MouseMove, -32, 0, 0, R
Return

#<+Right:: ; win + lshift + right arrow
    CoordMode, Mouse, Screen
    ; Move mouse pointer rightward
    MouseMove, 32, 0, 0, R
Return

#<+Down:: ; win + lshift + down arrow
    CoordMode, Mouse, Screen
    ; Move mouse pointer downward
    MouseMove, 0, 32, 0, R
Return

#<+Up:: ; win + lshift + up arrow
    CoordMode, Mouse, Screen
    ; Move mouse pointer upward
    MouseMove, 0, -32, 0, R
Return

^!+v:: ; ctrl + alt + shift + v
    CoordMode, Mouse, Screen
    ; Move mouse pointer to somewhere safe (alternate-bottom-left)
    MouseMove, 23, A_ScreenHeight - 18
Return

^!+n:: ; ctrl + alt + shift + n
    CoordMode, Mouse, Screen
    ; Move mouse pointer to somewhere safe (alternate-bottom-right)
    MouseMove, A_ScreenWidth - 23, A_ScreenHeight - 18
Return

; Media stuff
^!+Left::Send   {Media_Prev}
^!+Right::Send  {Media_Next}
^!+Down::Send   {Media_Play_Pause}
^!+Up::Send     {Media_Stop}

; Launch "Everything" when Ctrl + F is pressed within File Explorer
#IfWinActive ahk_class CabinetWClass
    ^F:: ;; ctrl + f
        ControlGetText, RunPath, ToolbarWindow323, A
        RunPath := SubStr(RunPath, 10)
        isnotauserfolder := ":\"
        IfNotInString, RunPath, %isnotauserfolder%
        {
           RunPath := "%UserProfile%" . "\" . RunPath . "\"
        }
        Run, C:\Program Files\Everything\Everything.exe -p "%RunPath%"
    Return
#IfWinActive

; Press Esc to close window (If it is 7-Zip)
#IfWinActive ahk_exe 7zFM.exe
    Esc::Send !{f4}
#IfWinActive

#IfWinNotActive ahk_exe firefox.exe
    ^!+x:: ; ctrl + alt + shift + x
        ; print [ ]
        SendInput [ ]{Space}
    Return
#IfWinNotActive

#IfWinActive ahk_exe firefox.exe
    ^!+x:: ; ctrl + alt + shift + x
        ; print [TODO]
        SendInput [TODO]{Space}
    Return
#IfWinNotActive

#IfWinNotActive ahk_exe devenv.exe
    ^!+c:: ;; ctrl + alt + shift + c
        ; print * (But not in Visual Studio)
        SendInput *{Space}
    Return
#IfWinNotActive

#IfWinNotActive ahk_exe devenv.exe
    ^!+g:: ;; ctrl + alt + shift + g
        ; Get substring that comes after the last index of '/' (But not in Visual Studio)
        ; Useful for copying commit id's from a url
        clipboard := RegExReplace(clipboard, "([^/]+\/+)+", "")
    Return
#IfWinNotActive

; Because Visual Studio 2019 broke my AltGr shortcuts!
#IfWinActive ahk_exe devenv.exe
    <^>!+g::Send, ^!+g
    <^>!+c::Send, ^!+c
    <^>!+d::Send, ^!+d
    <^>!f3::Send, ^!{f3}
    <^>!+f3::Send, ^!+{f3}
    <^>!+s::Send, ^!+s
    <^>!+t::Send, ^!+t
    <^>!+u::Send, ^!+u
#IfWinActive

^!+h:: ; ctrl + alt + shift + h
    ; replace all the \ characters within the text in clipboard with /
    StringReplace, clipboard, clipboard, `\ , `/ , All
Return

#Space:: ; win + space
    ; Send 4 spaces
    SendInput {Space}{Space}{Space}{Space}
Return

#+Space:: ; win + shift + space
    ; Remove 4 spaces
    SendInput {Backspace}{Backspace}{Backspace}{Backspace}
Return

;=============================================================================================
; Show a ToolTip that shows the current state of the lock keys (e.g. CapsLock) when one is pressed
;=============================================================================================
~*NumLock::
Sleep, 10	; drastically improves reliability on slower systems (took a loooong time to figure this out)
msg := "Num Lock: " (GetKeyState("NumLock", "T") ? "ON" : "OFF")
ToolTip, %msg%
Sleep, 400	; SPECIFY DISPLAY TIME (ms)
ToolTip		; remove
return

~*CapsLock::
Sleep, 10	; drastically improves reliability on slower systems (took a loooong time to figure this out)
msg := "Caps Lock: " (GetKeyState("CapsLock", "T") ? "ON" : "OFF")
ToolTip, %msg%
Sleep, 400	; SPECIFY DISPLAY TIME (ms)
ToolTip		; remove
return

~*ScrollLock::
Sleep, 10	; drastically improves reliability on slower systems (took a loooong time to figure this out)
msg := "Scroll Lock: " (GetKeyState("ScrollLock", "T") ? "ON" : "OFF")
ToolTip, %msg%
Sleep, 400	; SPECIFY DISPLAY TIME (ms)
ToolTip		; remove
return

#IfWinActive ahk_class XLMAIN
    ^NumpadSub::Send ^{WheelDown}
    ^NumpadAdd::Send ^{WheelUp}
    return
#IfWinActive

#IfWinActive ahk_exe WINWORD.EXE
    ^NumpadSub::Send ^{WheelDown}
    ^NumpadAdd::Send ^{WheelUp}
    return
#IfWinActive

#+e:: ; win + shift + e
    ; open file path in clipboard with notepad++
    Sleep 150
    Run, C:\Program Files (x86)\Notepad++\notepad++.exe "%clipboard%"
Return

#+f:: ; win + shift + f
    ; open file path in clipboard with explorer
    ClipBoard := RegexReplace(ClipBoard, "\/", "\")
    Sleep 150
    Run explorer.exe /select`, "%clipboard%"
Return

#IfWinActive ahk_class Notepad++
    ~Shift & WheelUp::  ; Scroll left
      ControlGetFocus, fcontrol, A
      Loop 3  ; <-- Increase this value to scroll faster.
        SendMessage, 0x114, 0, 0, %fcontrol%, A  ; 0x114=WM_HSCROLL; 0=SB_LINELEFT
    return

    ~Shift & WheelDown::  ; Scroll right
      ControlGetFocus, fcontrol, A
      Loop 3  ; <-- Increase this value to scroll faster.
        SendMessage, 0x114, 1, 0, %fcontrol%, A  ; 0x114=WM_HSCROLL; 1=SB_LINERIGHT
    return
#IfWinActive

#IfWinActive ahk_exe Ssms.exe ; SQL Server Management Studio
    ^!+s:: ; ctrl + alt + shift + s
        Click, 370, 121
        MouseMove, A_ScreenWidth - 172, 0
    Return

    ^!+d:: ; ctrl + alt + shift + d
        Click, 370, 202
        MouseMove, A_ScreenWidth - 172, 0
    Return

    ^!+r:: ; ctrl + alt + shift + r
        Click, 774, 62
        MouseMove, A_ScreenWidth - 172, 0
    Return

    ^+c:: ; ctrl + shift + c
        clipboard =
        Send ^c
        ClipWait
        clipboard := RegexReplace(clipboard, "^\[[^\]]+\]\.\[([^\]]+)\]$", "$1")
    return
#IfWinActive

#IfWinActive ahk_group AppsThatHaveExcessIndentRemovalEnabled
    ^+v:: ; ctrl + shift + v
        Clip0 = %ClipBoardAll%
        RegExMatch(ClipBoard, "^([ \t]+)", Lw)
        ClipBoard := RegexReplace(ClipBoard, "(?:(\r?\n)" . Lw . ")|(^" . Lw . ")", "$1")
        ClipBoard := RegexReplace(ClipBoard, "\s+$") ; Remove the trailing spaces anyway
        Send ^v                       ; For best compatibility: SendPlay
        Sleep 50                      ; Don't change clipboard while it is pasted! (Sleep > 0)
        ClipBoard = %Clip0%           ; Restore original ClipBoard
        VarSetCapacity(Clip0, 0)      ; Free memory
    Return
#IfWinActive

#IfWinActive ahk_exe GitExtensions.exe
    ^+v:: ; ctrl + shift + v
        Clip0 = %ClipBoardAll%
        ClipBoard = %ClipBoard%       ; Convert to text
        ClipBoard := RegexReplace(ClipBoard, "\t", " -> ")
        Send ^v                       ; For best compatibility: SendPlay
        Sleep 50                      ; Don't change clipboard while it is pasted! (Sleep > 0)
        ClipBoard = %Clip0%           ; Restore original ClipBoard
        VarSetCapacity(Clip0, 0)      ; Free memory
    Return
#IfWinActive

; Convert a bower.json url to npm-friendly url (if scroll lock is on)
#If GetKeyState("ScrollLock", "T")
    ^!+b:: ; ctrl + alt + shift + b
        Clip0 = %ClipBoardAll%
        ClipBoard = %ClipBoard%       ; Convert to text
        ClipBoard := RegexReplace(clipboard, "^(git@[^.]+\.com):([^#]+)#v?(.+)$", "git+ssh://$1/$2#v$3")
        Send ^v                       ; For best compatibility: SendPlay
        Sleep 50                      ; Don't change clipboard while it is pasted! (Sleep > 0)
        ClipBoard = %Clip0%           ; Restore original ClipBoard
        VarSetCapacity(Clip0, 0)      ; Free memory
    return
#If

; Honor scroll lock state! (This is my greatest achievement ever)
#If !WinActive("ahk_exe EXCEL.EXE") && GetKeyState("ScrollLock", "T")
    ;;==============================================================================
    ;; SCROLL USING ARROW KEYS
    ;;==============================================================================
    Up::
        ControlGetFocus, fcontrol, A
        SendMessage, 0x115, 0, 0, %fcontrol%, A  ; 0x115=WM_VSCROLL; 0=SB_LINEUP
    return

    Down::
        ControlGetFocus, fcontrol, A
        SendMessage, 0x115, 1, 0, %fcontrol%, A  ; 0x115=WM_VSCROLL; 1=SB_LINEDOWN
    return

    Left::
        ControlGetFocus, fcontrol, A
        SendMessage, 0x114, 0, 0, %fcontrol%, A  ; 0x114=WM_HSCROLL; 0=SB_LINELEFT
    return

    Right::
        ControlGetFocus, fcontrol, A
        SendMessage, 0x114, 1, 0, %fcontrol%, A  ; 0x114=WM_HSCROLL; 1=SB_LINERIGHT
    return

    ;;==============================================================================
    ;; SCROLL USING PgUp & PgDown
    ;;==============================================================================
    PgUp::
        ControlGetFocus, fcontrol, A
        SendMessage, 0x115, 2, 0, %fcontrol%, A  ; 0x115=WM_VSCROLL; 2=SB_PAGEUP
    return

    PgDn::
        ControlGetFocus, fcontrol, A
        SendMessage, 0x115, 3, 0, %fcontrol%, A  ; 0x115=WM_VSCROLL; 3=SB_PAGEDOWN
    return
#If
