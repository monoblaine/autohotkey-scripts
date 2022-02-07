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

GroupAdd, AppsThatHaveDefaultRawPasteDisabled, ahk_exe WinMergeU.exe ; WinMerge
GroupAdd, AppsThatHaveDefaultRawPasteDisabled, ahk_class Notepad++
GroupAdd, AppsThatHaveDefaultRawPasteDisabled, ahk_exe devenv.exe
GroupAdd, AppsThatHaveDefaultRawPasteDisabled, ahk_exe GitExtensions.exe

GroupAdd, AppsThatHaveExcessIndentRemovalEnabled, ahk_class Notepad++
GroupAdd, AppsThatHaveExcessIndentRemovalEnabled, ahk_exe WinMergeU.exe
GroupAdd, AppsThatHaveExcessIndentRemovalEnabled, ahk_exe devenv.exe

;GroupAdd, Group_HScroll_ShiftWheel, ahk_class CabinetWClass

GroupAdd, Group_HScroll_WheelLeftRight, ahk_class MMCMainFrame
GroupAdd, Group_HScroll_WheelLeftRight, ahk_exe GitExtensions.exe
GroupAdd, Group_HScroll_WheelLeftRight, ahk_exe msedge.exe
GroupAdd, Group_HScroll_WheelLeftRight, ahk_exe WINWORD.EXE
GroupAdd, Group_HScroll_WheelLeftRight, ahk_exe idea64.exe
GroupAdd, Group_HScroll_WheelLeftRight, ahk_class MozillaWindowClass

GroupAdd, Group_HScroll_ScrollLock, ahk_exe EXCEL.EXE

GroupAdd, Group_CtrlRToF5, ahk_class CabinetWClass
GroupAdd, Group_CtrlRToF5, ahk_exe GitExtensions.exe

Shell := ComObjCreate("WScript.Shell")
AutoHideMouseCursorRunning := ProcessExist("AutoHideMouseCursor_x64_p.exe")
LastMouseCoordX := 0
LastMouseCoordY := 0

CoordMode, Mouse, Screen

LWin & Enter::Send, {RWin Down}{Enter}{RWin Up}

#^a:: ; Win + ctrl + A
    ; Make the active window stay always on top
    Winset, Alwaysontop, , A
return

#IfWinNotActive ahk_group AppsThatHaveDefaultRawPasteDisabled
    ^+v:: ; ctrl + shift + v
        ; Text–only paste from ClipBoard (Trims leading and trailing whitespaces)
        Clip0 = %ClipBoardAll%
        ClipBoard = %ClipBoard%       ; Convert to text
        ClipBoard := RegexReplace(ClipBoard, "^\s+|\s+$")
        Send, ^v                      ; For best compatibility: SendPlay
        Sleep 50                      ; Don't change clipboard while it is pasted! (Sleep > 0)
        ClipBoard = %Clip0%           ; Restore original ClipBoard
        VarSetCapacity(Clip0, 0)      ; Free memory
    return
#IfWinNotActive

<#<^<+Up::Volume_Up ; lwin + lctrl + lshift + up arrow
<#<^<+Down::Volume_Down ; lwin + lctrl + lshift + down arrow

:*:;;today::
    ; Replace ";;today" with current date
    FormatTime, CurrentDateTime,, yyy-MM-dd ; 2009-10-13
    SendInput %CurrentDateTime%
return

:*:;;now::
    ; Replace ";;now" with current date and time
    FormatTime, CurrentDateTime,, yyy-MM-dd HH.mm ; 2009-10-13 10.57
    SendInput %CurrentDateTime%
return

:*:;;snow::
    ; Replace ";;snow" with current date and time (with seconds)
    FormatTime, CurrentDateTime,, yyy-MM-dd HH:mm:ss ; 2009-10-13 10:57:23
    SendInput %CurrentDateTime%
return

:*:;;vnow::
    ; Replace ";;vnow" with current date and time without separators
    FormatTime, CurrentDateTime,, yyyMMddHHmm ; 200910131057
    SendInput %CurrentDateTime%
return

:*:;;time::
    ; Replace ";;time" with current date, time and day of week
    FormatTime, CurrentDateTime, L1055, d MMMM yyy dddd, HH.mm ; 13 August 2013 Tuesday, 13.17
    SendInput %CurrentDateTime%
return

:*:;;date::
    ; Replace ";;date" with current date and day of week
    FormatTime, CurrentDateTime, L1055, d MMMM yyy dddd ; 26 April 2010 Monday
    SendInput %CurrentDateTime%
return

:*:;;tm::
    ; Replace ";;tm" with current time surrounded by parentheses
    FormatTime, CurrentDateTime, L1055, HH.mm ; (13.17)
    SendInput (%CurrentDateTime%){Space}
return

:*:;;pipe::
    SendInput {Raw}==============================================================================
return

:*:;;dash::
    SendInput {Raw}------------------------------------------------------------------------------
return

:*:;;mail::
    SendInput {Raw}zerhan@gmail.com
return

^!+l:: ; ctrl + alt + shift + l
    Run, ClipToQuotedLines.exe
return

ToggleMousePos(targetx, targety) {
    global LastMouseCoordX
    global LastMouseCoordY

    targetx := Floor(targetx)
    targety := Floor(targety)

    if (targetx = -1) {
        targetx := LastMouseCoordX
    }

    if (targety = -1) {
        targety := LastMouseCoordY
    }

    MouseGetPos, xpos, ypos

    xpos := Floor(xpos)
    ypos := Floor(ypos)

    ;MsgBox, last: %LastMouseCoordX%,%LastMouseCoordY%`ncurrent: %xpos%,%ypos%`ntarget: %targetx%,%targety%

    if (targetx = xpos) and (targety = ypos) {
        MouseMove, %LastMouseCoordX%, %LastMouseCoordY%
    }
    else {
        LastMouseCoordX := xpos
        LastMouseCoordY := ypos
        MouseMove, %targetx%, %targety%
    }
}

; ctrl + alt + shift + w
^!+w::ToggleMousePos(A_ScreenWidth - 172, 0) ; Move mouse pointer to somewhere safe

; ctrl + alt + shift + e
^!+e::ToggleMousePos(A_ScreenWidth - 90, 50) ; Move mouse pointer to somewhere safe (alternate)

; CapsLock + left arrow
CapsLock & Left::MouseMove, -14, 0, 0, R ; Move mouse pointer leftward

; CapsLock + right arrow
CapsLock & Right::MouseMove, 14, 0, 0, R ; Move mouse pointer rightward

; CapsLock + down arrow
CapsLock & Down::MouseMove, 0, 14, 0, R ; Move mouse pointer downward

; CapsLock + up arrow
CapsLock & Up::MouseMove, 0, -14, 0, R ; Move mouse pointer upward

<#NumpadDiv::
CapsLock & NumpadDiv::ToggleMousePos(A_ScreenWidth / 6, -1)

<#NumpadMult::
CapsLock & NumpadMult::ToggleMousePos(A_ScreenWidth * 5 / 6, -1)

<#NumpadSub::
CapsLock & NumpadSub::ToggleMousePos(-1, A_ScreenHeight / 6)

<#NumpadAdd::
CapsLock & NumpadAdd::ToggleMousePos(-1, A_ScreenHeight * 5 / 6)

<#Numpad7::
CapsLock & Numpad7::ToggleMousePos(A_ScreenWidth / 6, A_ScreenHeight / 6)

<#Numpad8::
CapsLock & Numpad8::ToggleMousePos(A_ScreenWidth / 2, A_ScreenHeight / 6)

<#Numpad9::
CapsLock & Numpad9::ToggleMousePos(A_ScreenWidth * 5 / 6, A_ScreenHeight / 6)

<#Numpad4::
CapsLock & Numpad4::ToggleMousePos(A_ScreenWidth / 6, A_ScreenHeight / 2)

<#Numpad5::
CapsLock & Numpad5::ToggleMousePos(A_ScreenWidth / 2, A_ScreenHeight / 2)

<#Numpad6::
CapsLock & Numpad6::ToggleMousePos(A_ScreenWidth * 5 / 6, A_ScreenHeight / 2)

<#Numpad1::
CapsLock & Numpad1::ToggleMousePos(A_ScreenWidth / 6, A_ScreenHeight * 5 / 6)

<#Numpad2::
CapsLock & Numpad2::ToggleMousePos(A_ScreenWidth / 2, A_ScreenHeight * 5 / 6)

<#Numpad3::
CapsLock & Numpad3::ToggleMousePos(A_ScreenWidth * 5 / 6, A_ScreenHeight * 5 / 6)

CapsLock & Space::SetCapsLockState % !GetKeyState("CapsLock", "T") ; %

CapsLock & End::Send, {Click 1}
CapsLock & PgDn::Click, Right

#IfWinActive ahk_class XLMAIN
    ^NumpadSub::Send, ^{WheelDown}
    ^NumpadAdd::Send, ^{WheelUp}
#IfWinActive

#IfWinActive ahk_exe WINWORD.EXE
    ^NumpadSub::Send, ^{WheelDown}
    ^NumpadAdd::Send, ^{WheelUp}
#IfWinActive

; Media stuff
^!+Left::Media_Prev
^!+Right::Media_Next
^!+Down::Media_Play_Pause
^!+Up::Media_Stop

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
    return
#IfWinActive

; Press Esc to close window (If it is 7-Zip)
#IfWinActive ahk_exe 7zFM.exe
    Esc::Send, {Alt Down}{f4}{Alt Up}
#IfWinActive

#IfWinNotActive ahk_exe firefox.exe
    ^!+x:: ; ctrl + alt + shift + x
        ; print [ ]
        SendInput [ ]{Space}
    return
#IfWinNotActive

#IfWinActive ahk_exe firefox.exe
    ^!+x:: ; ctrl + alt + shift + x
        ; print [TODO]
        SendInput [TODO]{Space}
    return
#IfWinNotActive

#IfWinNotActive ahk_exe devenv.exe
    ^!+c:: ;; ctrl + alt + shift + c
        ; print * (But not in Visual Studio)
        SendInput *{Space}
    return
#IfWinNotActive

#IfWinNotActive ahk_exe devenv.exe
    ^!+g:: ;; ctrl + alt + shift + g
        ; Get substring that comes after the last index of '/' (But not in Visual Studio)
        ; Useful for copying commit id's from a url
        clipboard := RegExReplace(clipboard, "([^/]+\/+)+", "")
    return
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
return

<#Space:: ; lwin + space
    ; Send 4 spaces
    SendInput {Space}{Space}{Space}{Space}
return

<#>+Space:: ; win + rshift + space
    ; Remove 4 spaces
    SendInput {Backspace}{Backspace}{Backspace}{Backspace}
return

;=============================================================================================
; Show a ToolTip that shows the current state of the lock keys (e.g. NumLock) when one is pressed
;=============================================================================================
~*NumLock::
    Sleep, 10	; drastically improves reliability on slower systems (took a loooong time to figure this out)
    msg := "Num Lock: " (GetKeyState("NumLock", "T") ? "ON" : "OFF")
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

#If !GetKeyState("LControl") && !GetKeyState("LShift") && !GetKeyState("LAlt")
    <#Up::WheelUp
    <#Down::WheelDown

#If !GetKeyState("LControl") && !GetKeyState("LShift") && !GetKeyState("LAlt") && WinActive("ahk_group Group_HScroll_ScrollLock")
    <#Left::
        SetScrollLockState, On
        Send, {Left}
        SetScrollLockState, Off
    return

    <#Right::
        SetScrollLockState, On
        Send, {Right}
        SetScrollLockState, Off
    return

#If !GetKeyState("LControl") && !GetKeyState("LShift") && !GetKeyState("LAlt") && WinActive("ahk_group Group_HScroll_ShiftWheel")
    <#Left::Send, +{WheelUp}
    <#Right::Send, +{WheelDown}

#If !GetKeyState("LControl") && !GetKeyState("LShift") && !GetKeyState("LAlt") && WinActive("ahk_group Group_HScroll_WheelLeftRight")
    <#Left::WheelLeft
    <#Right::WheelRight

#If !GetKeyState("LControl") && !GetKeyState("LShift") && !GetKeyState("LAlt") && !WinActive("ahk_group Group_HScroll_ShiftWheel") && !WinActive("ahk_group Group_HScroll_WheelLeftRight") && !WinActive("ahk_group Group_HScroll_ScrollLock")
    <#Left::
        ControlGetFocus, fcontrol, A
        Loop 8  ; <-- Increase this value to scroll faster.
            PostMessage, 0x114, 0, 0, %fcontrol%, A  ; 0x114=WM_HSCROLL; 0=SB_LINELEFT
    return

    <#Right::
        ControlGetFocus, fcontrol, A
        Loop 8  ; <-- Increase this value to scroll faster.
            PostMessage, 0x114, 1, 0, %fcontrol%, A  ; 0x114=WM_HSCROLL; 1=SB_LINERIGHT
    return
#If

>#>+e:: ; rwin + rshift + e
    ; open file path in clipboard with notepad++
    Sleep 150
    Run, C:\Program Files (x86)\Notepad++\notepad++.exe "%clipboard%"
return

>#>+f:: ; rwin + rshift + f
    ; open file path in clipboard with explorer
    ClipBoard := RegexReplace(ClipBoard, "\/", "\")
    Sleep 150
    Run explorer.exe /select`, "%clipboard%"
return

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
        MouseGetPos, xpos, ypos
        Click, 370, 121
        MouseMove, %xpos%, %ypos%
    return

    ^!+d:: ; ctrl + alt + shift + d
        MouseGetPos, xpos, ypos
        Click, 370, 202
        MouseMove, %xpos%, %ypos%
    return

    ^!+r:: ; ctrl + alt + shift + r
        MouseGetPos, xpos, ypos
        Click, 774, 62
        MouseMove, %xpos%, %ypos%
    return

    ^+c:: ; ctrl + shift + c
        clipboard =
        Send, ^c
        ClipWait
        clipboard := RegexReplace(clipboard, "^\[[^\]]+\]\.\[([^\]]+)\]$", "$1")
    return

    #w::Send, {Alt Down}w{Alt Up}1
#IfWinActive

#w::Send, {Alt Down}{f15}{Alt Up}

#IfWinActive ahk_group AppsThatHaveExcessIndentRemovalEnabled
    ^+v:: ; ctrl + shift + v
        Clip0 = %ClipBoardAll%
        RegExMatch(ClipBoard, "^([ \t]+)", Lw)
        ClipBoard := RegexReplace(ClipBoard, "(?:(\r?\n)" . Lw . ")|(^" . Lw . ")", "$1")
        ClipBoard := RegexReplace(ClipBoard, "\s+$") ; Remove the trailing spaces anyway
        Send, ^v                      ; For best compatibility: SendPlay
        Sleep 50                      ; Don't change clipboard while it is pasted! (Sleep > 0)
        ClipBoard = %Clip0%           ; Restore original ClipBoard
        VarSetCapacity(Clip0, 0)      ; Free memory
    return
#IfWinActive

#IfWinActive ahk_exe GitExtensions.exe
    ^+v:: ; ctrl + shift + v
        Clip0 = %ClipBoardAll%
        ClipBoard = %ClipBoard%       ; Convert to text
        ClipBoard := RegexReplace(ClipBoard, "\t", " -> ")
        Send, ^v                      ; For best compatibility: SendPlay
        Sleep 50                      ; Don't change clipboard while it is pasted! (Sleep > 0)
        ClipBoard = %Clip0%           ; Restore original ClipBoard
        VarSetCapacity(Clip0, 0)      ; Free memory
    return
#IfWinActive

; Convert a bower.json url to npm-friendly url (if scroll lock is on)
#If GetKeyState("ScrollLock", "T")
    ^!+b:: ; ctrl + alt + shift + b
        Clip0 = %ClipBoardAll%
        ClipBoard = %ClipBoard%       ; Convert to text
        ClipBoard := RegexReplace(clipboard, "^(git@[^.]+\.com):([^#]+)#v?(.+)$", "git+ssh://$1/$2#v$3")
        Send, ^v                      ; For best compatibility: SendPlay
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

^!+m:: ;; ctrl + alt + shift + m
    SetTitleMatchMode, 2
    DetectHiddenWindows, On

    if WinExist(" - Mozilla Thunderbird") {
        if (WinActive()) {
            WinMinimize
        }
        else {
            WinActivate
        }
    }
return

!End::Send, {Alt Down}{f4}{Alt Up} ; alt+end to alt+f4 anything

<#End:: ; lwin + end
    MouseGetPos, xpos, ypos
    MouseMove, A_ScreenWidth / 2, A_ScreenHeight / 2
    Click
    MouseMove, %xpos%, %ypos%
return

; Credits: https://www.autohotkey.com/board/topic/119505-minimize-restore-active-window/
!Del::
    lastWindow:= WinExist("A")
    WinMinimize, ahk_id %lastWindow%
return

!Ins::
    IfWinExist, ahk_id %lastWindow%
    {
        WinGet, WinState, MinMax, ahk_id %lastWindow%

        If WinState = -1
            WinActivate
        else
            WinMinimize

        lastWindow := ; remove this line if you want minimize/toggle only one window
    }
return

<#+Up:: ; lwin + shift + Up
<#+Down:: ; lwin + shift + Down
CapsLock & Enter::
RButton & LButton::
>#>+m:: ; rwin + rshift + m
    if AutoHideMouseCursorRunning {
        Process, Close, AutoHideMouseCursor_x64_p.exe
        AutoHideMouseCursorRunning := 0
        Sleep 15
        MouseMove, 0, 5, 0, R
        Sleep 15
        MouseMove, 0, -5, 0, R
    }
    else {
        Shell.Run("C:\Users\Serhan\Documents\.tools\AutoHideMouseCursor\AutoHideMouseCursor_x64_p.exe", 0)
        AutoHideMouseCursorRunning := 1
        Send, {Alt Down}{Home}{Alt Up}
    }
return

ProcessExist(Name) {
    Process, Exist, %Name%
    return Errorlevel
}

#IfWinActive ahk_group Group_CtrlRToF5
    ^r::Send, {f5}
#IfWinActive

*CapsLock:: return ; This forces capslock into a modifying key.
RButton::RButton ; restore the original RButton function

; #IfWinActive Google Keep
;     ^q::Send, ^[ ; ctrl + q
;     ^+q::Send, ^] ; ctrl + shift + q
; #IfWinActive
