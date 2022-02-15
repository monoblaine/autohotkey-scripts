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

GroupAdd, Group_CtrlRToF5, ahk_class CabinetWClass
GroupAdd, Group_CtrlRToF5, ahk_exe GitExtensions.exe
GroupAdd, Group_CtrlRToF5, ahk_exe WinMergeU.exe

GroupAdd, Group_RawPasteDisabled, ahk_exe WinMergeU.exe ; WinMerge
GroupAdd, Group_RawPasteDisabled, ahk_class Notepad++
GroupAdd, Group_RawPasteDisabled, ahk_exe devenv.exe
GroupAdd, Group_RawPasteDisabled, ahk_exe GitExtensions.exe

GroupAdd, Group_ExcessIndentRemovalEnabled, ahk_class Notepad++
GroupAdd, Group_ExcessIndentRemovalEnabled, ahk_exe WinMergeU.exe

GroupAdd, Group_ZoomableByWheel, ahk_exe WINWORD.EXE
GroupAdd, Group_ZoomableByWheel, ahk_exe EXCEL.EXE

; GroupAdd, Group_HScroll_ShiftWheel, ahk_class CabinetWClass

GroupAdd, Group_HScroll_WheelLeftRight, ahk_class MMCMainFrame
GroupAdd, Group_HScroll_WheelLeftRight, ahk_exe GitExtensions.exe
GroupAdd, Group_HScroll_WheelLeftRight, ahk_exe msedge.exe
GroupAdd, Group_HScroll_WheelLeftRight, ahk_exe WINWORD.EXE
GroupAdd, Group_HScroll_WheelLeftRight, ahk_exe idea64.exe
GroupAdd, Group_HScroll_WheelLeftRight, ahk_class MozillaWindowClass

GroupAdd, Group_HScroll_ScrollLock, ahk_exe EXCEL.EXE

; GroupAdd, Group_HScroll_All, ahk_group Group_HScroll_ShiftWheel
GroupAdd, Group_HScroll_All, ahk_group Group_HScroll_WheelLeftRight
GroupAdd, Group_HScroll_All, ahk_group Group_HScroll_ScrollLock

Shell := ComObjCreate("WScript.Shell")
AutoHideMouseCursorRunning := ProcessExist("AutoHideMouseCursor_x64_p.exe")

SavedMouseCoordX := -1
SavedMouseCoordY := -1

LastMouseCoordX := 0
LastMouseCoordY := 0

CoordMode, Mouse, Screen

LWin & Enter::Send, {RWin Down}{Enter}{RWin Up}                                   ; lwin + Enter                 | Send rwin + Enter
#w::Send, {Alt Down}{f15}{Alt Up}                                                 ; win + w                      | Send alt + f15
#^a::Winset, Alwaysontop, , A                                                     ; win + ctrl + a               | Make the active window stay always on top
<#<^<+Up::Volume_Up                                                               ; lwin + lctrl + lshift + up   | Increase volume
<#<^<+Down::Volume_Down                                                           ; lwin + lctrl + lshift + down | Decrease volume
CapsLock & Del::                                                                  ; CapsLock + del
!Del::Send, {Alt Down}{f4}{Alt Up}                                                ; alt + del                    | Send alt + f4
^!+l::Run, ClipToQuotedLines.exe                                                  ; ctrl + alt + shift + l       | ClipToQuotedLines.exe
^!+h::StringReplace, clipboard, clipboard, `\, `/, All                            ; ctrl + alt + shift + h       | Replace all the \ characters within the text in clipboard with /
^!+w::ToggleMousePos(A_ScreenWidth - 172, 0)                                      ; ctrl + alt + shift + w       | Move mouse pointer to somewhere safe
^!+e::ToggleMousePos(A_ScreenWidth - 90, 50)                                      ; ctrl + alt + shift + e       | Move mouse pointer to somewhere safe (alternate)
^!+Left::Media_Prev                                                               ; ctrl + alt + shift + left    | Media_Prev
^!+Right::Media_Next                                                              ; ctrl + alt + shift + right   | Media_Next
^!+Down::Media_Play_Pause                                                         ; ctrl + alt + shift + down    | Media_Play_Pause
^!+Up::Media_Stop                                                                 ; ctrl + alt + shift + up      | Media_Stop
CapsLock & Left::SavePosAndMouseMoveR(-14, 0)                                     ; CapsLock + left arrow        | Move mouse pointer leftward
CapsLock & Right::SavePosAndMouseMoveR(14, 0)                                     ; CapsLock + right arrow       | Move mouse pointer rightward
CapsLock & Down::SavePosAndMouseMoveR(0, 14)                                      ; CapsLock + down arrow        | Move mouse pointer downward
CapsLock & Up::SavePosAndMouseMoveR(0, -14)                                       ; CapsLock + up arrow          | Move mouse pointer upward
CapsLock & Ins::MouseGetPos, SavedMouseCoordX, SavedMouseCoordY                   ; CapsLock + Insert            | Save current Mouse Coord
#Home::                                                                           ; Win + Home
CapsLock & Home::ToggleMousePos(SavedMouseCoordX, SavedMouseCoordY)               ; CapsLock + Home              | Go to saved Mouse Coord
CapsLock & Space::SetCapsLockState % !GetKeyState("CapsLock", "T")              ;%; CapsLock + Space             | Toggle CapsLock state

#If !GetKeyState("LAlt")
    CapsLock & Enter::Send, {Click 1}
#If

#If GetKeyState("LAlt")
    CapsLock & Enter::Click, Right
#If

<#NumpadDiv::                                                                     ; lwin + NumpadDiv
CapsLock & NumpadDiv::ToggleMousePos(A_ScreenWidth / 6, -1)                       ; CapsLock + NumpadDiv

<#NumpadMult::                                                                    ; lwin + NumpadMult
CapsLock & NumpadMult::ToggleMousePos(A_ScreenWidth * 5 / 6, -1)                  ; CapsLock + NumpadMult

<#NumpadSub::                                                                     ; lwin + NumpadSub
CapsLock & NumpadSub::ToggleMousePos(-1, A_ScreenHeight / 6)                      ; CapsLock + NumpadSub

<#End::                                                                           ; lwin + end
<#NumpadAdd::                                                                     ; lwin + NumpadAdd
CapsLock & NumpadAdd::ToggleMousePos(-1, A_ScreenHeight * 5 / 6)                  ; CapsLock + NumpadAdd

<#Numpad7::                                                                       ; lwin + Numpad7
CapsLock & Numpad7::ToggleMousePos(A_ScreenWidth / 6, A_ScreenHeight / 6)         ; CapsLock + Numpad7

<#Numpad8::                                                                       ; lwin + Numpad8
CapsLock & Numpad8::ToggleMousePos(A_ScreenWidth / 2, A_ScreenHeight / 6)         ; CapsLock + Numpad8

<#Numpad9::                                                                       ; lwin + Numpad9
CapsLock & Numpad9::ToggleMousePos(A_ScreenWidth * 5 / 6, A_ScreenHeight / 6)     ; CapsLock + Numpad9

<#Numpad4::                                                                       ; lwin + Numpad4
CapsLock & Numpad4::ToggleMousePos(A_ScreenWidth / 6, A_ScreenHeight / 2)         ; CapsLock + Numpad4

<#Numpad5::                                                                       ; lwin + Numpad5
CapsLock & Numpad5::ToggleMousePos(A_ScreenWidth / 2, A_ScreenHeight / 2)         ; CapsLock + Numpad5

<#Numpad6::                                                                       ; lwin + Numpad6
CapsLock & Numpad6::ToggleMousePos(A_ScreenWidth * 5 / 6, A_ScreenHeight / 2)     ; CapsLock + Numpad6

<#Numpad1::                                                                       ; lwin + Numpad1
CapsLock & Numpad1::ToggleMousePos(A_ScreenWidth / 6, A_ScreenHeight * 5 / 6)     ; CapsLock + Numpad1

<#Numpad2::                                                                       ; lwin + Numpad2
CapsLock & Numpad2::ToggleMousePos(A_ScreenWidth / 2, A_ScreenHeight * 5 / 6)     ; CapsLock + Numpad2

<#Numpad3::                                                                       ; lwin + Numpad3
CapsLock & Numpad3::ToggleMousePos(A_ScreenWidth * 5 / 6, A_ScreenHeight * 5 / 6) ; CapsLock + Numpad3

CapsLock & End::                                                                  ; CapsLock + end
<!End::                                                                           ; lalt + end
    MouseGetPos, xpos, ypos
    MouseMove, A_ScreenWidth / 2, A_ScreenHeight / 2
    Click
    MouseMove, %xpos%, %ypos%
return

; Credits: https://www.autohotkey.com/board/topic/119505-minimize-restore-active-window/
CapsLock & PgDn::                                                                 ; CapsLock + PgDn
    lastWindow := WinExist("A")
    WinMinimize, ahk_id %lastWindow%
return

CapsLock & PgUp::                                                                 ; CapsLock + PgUp
    IfWinExist, ahk_id %lastWindow%
    {
        WinGet, WinState, MinMax, ahk_id %lastWindow%

        If WinState = -1
            WinActivate
        else
            WinMinimize

        lastWindow := "" ; remove this line if you want minimize/toggle only one window
    }
return

CapsLock & Backspace::                                                            ; CapsLock + Backspace
RButton & LButton::                                                               ; RButton + LButton
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

*CapsLock:: return ; This forces CapsLock into a modifying key.
RButton::RButton   ; restore the original RButton function

>#>+e::                                                                           ; rwin + rshift + e            | open file path in clipboard with notepad++
    Sleep 150
    Run, C:\Program Files (x86)\Notepad++\notepad++.exe "%clipboard%"
return

>#>+f::                                                                           ; rwin + rshift + f            | open file path in clipboard with explorer
    clipboard := RegexReplace(clipboard, "\/", "\")
    Sleep 150
    Run explorer.exe /select`, "%clipboard%"
return

^!+m::                                                                            ; ctrl + alt + shift + m
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

#If !GetKeyState("LControl") and !GetKeyState("LShift") and !GetKeyState("LAlt")
    <#Up::WheelUp
    <#Down::WheelDown
#If

; #If !GetKeyState("LControl") and !GetKeyState("LShift") and !GetKeyState("LAlt") and WinActive("ahk_group Group_HScroll_ShiftWheel")
;     <#Left::Send, +{WheelUp}
;     <#Right::Send, +{WheelDown}
; #If

#If !GetKeyState("LControl") and !GetKeyState("LShift") and !GetKeyState("LAlt") and WinActive("ahk_group Group_HScroll_WheelLeftRight")
    <#Left::WheelLeft
    <#Right::WheelRight
#If

#If !GetKeyState("LControl") and !GetKeyState("LShift") and !GetKeyState("LAlt") and WinActive("ahk_group Group_HScroll_ScrollLock")
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
#If

#If !GetKeyState("LControl") and !GetKeyState("LShift") and !GetKeyState("LAlt") and !WinActive("ahk_group Group_HScroll_All")
    <#Left::
        ControlGetFocus, fcontrol, A
        Loop 8
            PostMessage, 0x114, 0, 0, %fcontrol%, A  ; 0x114=WM_HSCROLL; 0=SB_LINELEFT
    return

    <#Right::
        ControlGetFocus, fcontrol, A
        Loop 8
            PostMessage, 0x114, 1, 0, %fcontrol%, A  ; 0x114=WM_HSCROLL; 1=SB_LINERIGHT
    return
#If

#IfWinActive ahk_group Group_CtrlRToF5
    ^r::Send, {f5}
#IfWinActive

#IfWinNotActive ahk_group Group_RawPasteDisabled
    ^+v:: ; ctrl + shift + v
        ; Text–only paste from clipboard (Trims leading and trailing whitespaces)
        originalClipboard := ClipBoardAll
        clipboard := clipboard               ; Convert to text
        clipboard := RegexReplace(clipboard, "^\s+|\s+$")
        Send, ^v                             ; For best compatibility: SendPlay
        Sleep 50                             ; Don't change clipboard while it is pasted! (Sleep > 0)
        clipboard := originalClipboard       ; Restore original ClipBoard
        VarSetCapacity(originalClipboard, 0) ; Free memory
    return
#IfWinNotActive

#IfWinActive ahk_group Group_ZoomableByWheel
    ^NumpadSub::Send, ^{WheelDown}                                                ; ctrl + NumpadSub
    ^NumpadAdd::Send, ^{WheelUp}                                                  ; ctrl + NumpadAdd
#IfWinActive

#IfWinActive ahk_class CabinetWClass                                              ; if it is Windows File Explorer
    ^f::                                                                          ; ctrl + f
        ControlGetText, RunPath, ToolbarWindow323, A
        RunPath := SubStr(RunPath, 10)
        isnotauserfolder := ":\"
        IfNotInString, RunPath, %isnotauserfolder%
        {
           RunPath := "%UserProfile%" . "\" . RunPath . "\"
        }
        Run, C:\Program Files\Everything\Everything.exe -p "%RunPath%"            ; Launch "Everything"
    return
#IfWinActive

#IfWinActive ahk_class Notepad++
    ~Shift & WheelUp::                                                            ; Scroll left
        ControlGetFocus, fcontrol, A
        Loop 3
            SendMessage, 0x114, 0, 0, %fcontrol%, A                               ; 0x114=WM_HSCROLL; 0=SB_LINELEFT
    return

    ~Shift & WheelDown::                                                          ; Scroll right
        ControlGetFocus, fcontrol, A
        Loop 3
            SendMessage, 0x114, 1, 0, %fcontrol%, A                               ; 0x114=WM_HSCROLL; 1=SB_LINERIGHT
    return
#IfWinActive

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

#IfWinActive ahk_exe Ssms.exe                                                     ; SQL Server Management Studio
    #w::Send, {Alt Down}w{Alt Up}1                                                ; win + w                      | Send alt + w + 1

    ^!+s::                                                                        ; ctrl + alt + shift + s
        MouseGetPos, xpos, ypos
        Click, 370, 121
        MouseMove, %xpos%, %ypos%
    return

    ^!+d::                                                                        ; ctrl + alt + shift + d
        MouseGetPos, xpos, ypos
        Click, 370, 202
        MouseMove, %xpos%, %ypos%
    return

    ^!+r::                                                                        ; ctrl + alt + shift + r
        MouseGetPos, xpos, ypos
        Click, 774, 62
        MouseMove, %xpos%, %ypos%
    return

    ^+c::                                                                         ; ctrl + shift + c
        clipboard := ""
        Send, ^c
        ClipWait
        clipboard := RegexReplace(clipboard, "^\[[^\]]+\]\.\[([^\]]+)\]$", "$1")
    return
#IfWinActive

#IfWinActive ahk_exe 7zFM.exe                                                     ; if it is 7-Zip
    Esc::Send, {Alt Down}{f4}{Alt Up}                                             ; esc                          | Send alt + f4
#IfWinActive

#IfWinActive ahk_group Group_ExcessIndentRemovalEnabled
    ^+v::                                                                         ; ctrl + shift + v
        originalClipboard := ClipBoardAll
        RegExMatch(clipboard, "^([ \t]+)", Lw)
        clipboard := RegexReplace(clipboard, "(?:(\r?\n)" . Lw . ")|(^" . Lw . ")", "$1")
        clipboard := RegexReplace(clipboard, "\s+$") ; Remove the trailing spaces anyway
        Send, ^v                                     ; For best compatibility: SendPlay
        Sleep 50                                     ; Don't change clipboard while it is pasted! (Sleep > 0)
        clipboard := originalClipboard               ; Restore original clipboard
        VarSetCapacity(originalClipboard, 0)         ; Free memory
    return
#IfWinActive

#IfWinActive ahk_exe GitExtensions.exe
    ^+v::                                                                         ; ctrl + shift + v
        originalClipboard := ClipBoardAll
        clipboard := clipboard               ; Convert to text
        clipboard := RegexReplace(clipboard, "\t", " -> ")
        Send, ^v                             ; For best compatibility: SendPlay
        Sleep 50                             ; Don't change clipboard while it is pasted! (Sleep > 0)
        clipboard := originalClipboard       ; Restore original clipboard
        VarSetCapacity(originalClipboard, 0) ; Free memory
    return
#IfWinActive

#IfWinActive ahk_exe msedge.exe
    ^b::
        Send, ^t
        Sleep, 200
        SendRaw, edge://favorites/
        Send, {Enter}
    return

    ^h::
        Send, ^t
        Sleep, 200
        SendRaw, edge://history/all
        Send, {Enter}
    return
#IfWinActive

; Honor scroll lock state (may or may not work)
#If !WinActive("ahk_exe EXCEL.EXE") and GetKeyState("ScrollLock", "T")
    ;==============================================================================
    ; SCROLL USING ARROW KEYS
    ;==============================================================================
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

    ;==============================================================================
    ; SCROLL USING PgUp & PgDown
    ;==============================================================================
    PgUp::
        ControlGetFocus, fcontrol, A
        SendMessage, 0x115, 2, 0, %fcontrol%, A  ; 0x115=WM_VSCROLL; 2=SB_PAGEUP
    return

    PgDn::
        ControlGetFocus, fcontrol, A
        SendMessage, 0x115, 3, 0, %fcontrol%, A  ; 0x115=WM_VSCROLL; 3=SB_PAGEDOWN
    return
#If

; Convert a bower.json url to npm-friendly url (if scroll lock is on)
#If GetKeyState("ScrollLock", "T")
    ^!+b::                                                                        ; ctrl + alt + shift + b
        originalClipboard := ClipBoardAll
        clipboard := clipboard               ; Convert to text
        clipboard := RegexReplace(clipboard, "^(git@[^.]+\.com):([^#]+)#v?(.+)$", "git+ssh://$1/$2#v$3")
        Send, ^v                             ; For best compatibility: SendPlay
        Sleep 50                             ; Don't change clipboard while it is pasted! (Sleep > 0)
        clipboard := originalClipboard       ; Restore original clipboard
        VarSetCapacity(originalClipboard, 0) ; Free memory
    return
#If

;==============================================================================
; Various SendInput commands
;==============================================================================

:*:;;today::                                                   ; Replace ";;today" with current date
    FormatTime, CurrentDateTime,, yyy-MM-dd                    ; 2009-10-13
    SendInput %CurrentDateTime%
return

:*:;;now::                                                     ; Replace ";;now" with current date and time
    FormatTime, CurrentDateTime,, yyy-MM-dd HH.mm              ; 2009-10-13 10.57
    SendInput %CurrentDateTime%
return

:*:;;snow::                                                    ; Replace ";;snow" with current date and time (with seconds)
    FormatTime, CurrentDateTime,, yyy-MM-dd HH:mm:ss           ; 2009-10-13 10:57:23
    SendInput %CurrentDateTime%
return

:*:;;vnow::                                                    ; Replace ";;vnow" with current date and time without separators
    FormatTime, CurrentDateTime,, yyyMMddHHmm                  ; 200910131057
    SendInput %CurrentDateTime%
return

:*:;;time::                                                    ; Replace ";;time" with current date, time and day of week
    FormatTime, CurrentDateTime, L1055, d MMMM yyy dddd, HH.mm ; 13 August 2013 Tuesday, 13.17
    SendInput %CurrentDateTime%
return

:*:;;date::                                                    ; Replace ";;date" with current date and day of week
    FormatTime, CurrentDateTime, L1055, d MMMM yyy dddd        ; 26 April 2010 Monday
    SendInput %CurrentDateTime%
return

:*:;;tm::                                                      ; Replace ";;tm" with current time surrounded by parentheses
    FormatTime, CurrentDateTime, L1055, HH.mm                  ; (13.17)
    SendInput (%CurrentDateTime%){Space}
return

:*:;;pipe::{Raw}==============================================================================
:*:;;dash::{Raw}------------------------------------------------------------------------------
:*:;;mail::{Raw}zerhan@gmail.com
^!+x::SendInput [ ]{Space}                                           ; ctrl + alt + shift + x     | print [ ]
<#Space::SendInput {Space}{Space}{Space}{Space}                      ; lwin + space               | Send 4 spaces
<#>+Space::SendInput {Backspace}{Backspace}{Backspace}{Backspace}    ; win + rshift + space       | Remove 4 spaces

#IfWinNotActive ahk_exe devenv.exe                                   ;                            | Exclude Visual Studio
    ^!+c::SendInput *{Space}                                         ; ctrl + alt + shift + c     | print *
    ^!+g::clipboard := RegExReplace(clipboard, "([^/]+\/+)+", "")    ; ctrl + alt + shift + g     | Get substring that comes after the last index of '/'. Useful for copying commit id's from a url
#IfWinNotActive

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

;==============================================================================
; Functions
;==============================================================================

ProcessExist(Name) {
    Process, Exist, %Name%
    return Errorlevel
}

ToggleMousePos(targetx, targety) {
    global LastMouseCoordX
    global LastMouseCoordY

    targetx := Floor(targetx)
    targety := Floor(targety)

    MouseGetPos, xpos, ypos

    xpos := Floor(xpos)
    ypos := Floor(ypos)

    if (targetx = -1) {
        targetx := xpos
    }

    if (targety = -1) {
        targety := ypos
    }

    ; MsgBox, last: %LastMouseCoordX%,%LastMouseCoordY%`ncurrent: %xpos%,%ypos%`ntarget: %targetx%,%targety%

    if (targetx = xpos) and (targety = ypos) {
        MouseMove, %LastMouseCoordX%, %LastMouseCoordY%
    }
    else {
        LastMouseCoordX := xpos
        LastMouseCoordY := ypos
        MouseMove, %targetx%, %targety%
    }
}

SavePosAndMouseMoveR(xDiff, yDiff) {
    global LastMouseCoordX
    global LastMouseCoordY

    MouseGetPos, xpos, ypos

    xpos := Floor(xpos)
    ypos := Floor(ypos)

    LastMouseCoordX := xpos
    LastMouseCoordY := ypos

    MouseMove, %xDiff%, %yDiff%, 0, R
}

; #IfWinActive Google Keep
;     ^q::Send, ^[ ; ctrl + q
;     ^+q::Send, ^] ; ctrl + shift + q
; #IfWinActive
