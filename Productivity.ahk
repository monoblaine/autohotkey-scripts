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

GroupAdd, Group_ZoomableByWheel, ahk_exe WINWORD.EXE
GroupAdd, Group_ZoomableByWheel, ahk_exe EXCEL.EXE
GroupAdd, Group_ZoomableByWheel, ahk_exe soffice.bin

GroupAdd, Group_HScroll_SupportsShiftWheel, ahk_exe notepad++.exe
GroupAdd, Group_HScroll_SupportsShiftWheel, ahk_exe devenv.exe
GroupAdd, Group_HScroll_SupportsShiftWheel, ahk_exe WinMergeU.exe

GroupAdd, Group_HScroll_SupportsNativeHWheel, ahk_class MMCMainFrame
GroupAdd, Group_HScroll_SupportsNativeHWheel, ahk_exe GitExtensions.exe
GroupAdd, Group_HScroll_SupportsNativeHWheel, ahk_exe msedge.exe
GroupAdd, Group_HScroll_SupportsNativeHWheel, ahk_exe chrome.exe
GroupAdd, Group_HScroll_SupportsNativeHWheel, ahk_exe catsxp.exe
GroupAdd, Group_HScroll_SupportsNativeHWheel, ahk_exe WINWORD.EXE
GroupAdd, Group_HScroll_SupportsNativeHWheel, ahk_exe idea64.exe
GroupAdd, Group_HScroll_SupportsNativeHWheel, ahk_class MozillaWindowClass
GroupAdd, Group_HScroll_SupportsNativeHWheel, ahk_exe paintdotnet.exe

GroupAdd, Group_HScroll_HonorsScrollLockState, ahk_exe EXCEL.EXE

GroupAdd, Group_HScroll_All, ahk_group Group_HScroll_SupportsShiftWheel
GroupAdd, Group_HScroll_All, ahk_group Group_HScroll_SupportsNativeHWheel
GroupAdd, Group_HScroll_All, ahk_group Group_HScroll_HonorsScrollLockState

GroupAdd, Group_ChromiumBasedApp, ahk_exe chrome.exe
GroupAdd, Group_ChromiumBasedApp, ahk_exe msedge.exe
GroupAdd, Group_ChromiumBasedApp, ahk_exe catsxp.exe

GroupAdd, Group_SendInputCheckBoxVariants, ahk_group Group_ChromiumBasedApp
GroupAdd, Group_SendInputCheckBoxVariants, ahk_exe soffice.bin
GroupAdd, Group_SendInputCheckBoxVariants, ahk_exe firefox.exe

Shell := ComObjCreate("WScript.Shell")
AutoHideMouseCursorRunning := ProcessExist("AutoHideMouseCursor_x64_p.exe")

SavedMouseCoordX := -1
SavedMouseCoordY := -1

LastMouseCoordX := 0
LastMouseCoordY := 0

ScreenGridSizePrimary := 2.5
ScreenGridSizeAlternate := 4

CoordMode, Mouse, Screen

LWin & Enter::Send, {RWin Down}{Enter}{RWin Up}                                   ; lwin + Enter                 | Send rwin + Enter
#w::Send, !{f15}                                                                  ; win + w                      | Send alt + f15
#^a::Winset, Alwaysontop, , A                                                     ; win + ctrl + a               | Make the active window stay always on top
<#<^<+Up::Volume_Up                                                               ; lwin + lctrl + lshift + up   | Increase volume
<#<^<+Down::Volume_Down                                                           ; lwin + lctrl + lshift + down | Decrease volume
CapsLock & Del::Send, !{f4}                                                       ; CapsLock + del               | Send alt + f4
^!+l::Run, ClipToQuotedLines.exe                                                  ; ctrl + alt + shift + l       | ClipToQuotedLines.exe
^!+h::clipboard := StrReplace(clipboard, "`\", "`/")                              ; ctrl + alt + shift + h       | Replace all the \ characters within the text in clipboard with /
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
#Ins::
CapsLock & Ins::MouseGetPos, SavedMouseCoordX, SavedMouseCoordY                   ; CapsLock + Insert            | Save current Mouse Coord
#Home::                                                                           ; Win + Home
CapsLock & Home::ToggleMousePos(SavedMouseCoordX, SavedMouseCoordY)               ; CapsLock + Home              | Go to saved Mouse Coord
CapsLock & Space::SetCapsLockState % !GetKeyState("CapsLock", "T")                ; CapsLock + Space             | Toggle CapsLock state

#If !GetKeyState("LAlt")
    CapsLock & Enter::Send, {Click 1}
#If

#If GetKeyState("LAlt")
    CapsLock & Enter::Click, Right
#If

<#NumpadDiv::
CapsLock & NumpadDiv::
    ToggleMousePos(A_ScreenWidth  / 2 - A_ScreenWidth  / ScreenGridSizeAlternate, -1)
return

<#NumpadMult::
CapsLock & NumpadMult::
    ToggleMousePos(A_ScreenWidth  / 2 + A_ScreenWidth  / ScreenGridSizeAlternate, -1)
return

<#NumpadSub::
CapsLock & NumpadSub::
    ToggleMousePos(-1
                 , A_ScreenHeight / 2 - A_ScreenHeight / ScreenGridSizeAlternate)
return

<#End::
<#NumpadAdd::
CapsLock & NumpadAdd::
    ToggleMousePos(-1
                 , A_ScreenHeight / 2 + A_ScreenHeight / ScreenGridSizeAlternate)
return

GetGridSize() {
    global ScreenGridSizeAlternate
    global ScreenGridSizePrimary

    return GetKeyState("LAlt") ? ScreenGridSizeAlternate : ScreenGridSizePrimary
}

<#Numpad7::
CapsLock & NumpadHome::
CapsLock & Numpad7::
    gridSize := GetGridSize()
    ToggleMousePos(A_ScreenWidth  / 2 - A_ScreenWidth  / gridSize
                 , A_ScreenHeight / 2 - A_ScreenHeight / gridSize)
return

<#Numpad8::
CapsLock & NumpadUp::
CapsLock & Numpad8::
    ToggleMousePos(A_ScreenWidth  / 2
                 , A_ScreenHeight / 2 - A_ScreenHeight / GetGridSize())
return

<#Numpad9::
CapsLock & NumpadPgup::
CapsLock & Numpad9::
    gridSize := GetGridSize()
    ToggleMousePos(A_ScreenWidth  / 2 + A_ScreenWidth  / gridSize
                 , A_ScreenHeight / 2 - A_ScreenHeight / gridSize)
return

<#Numpad4::
CapsLock & NumpadLeft::
CapsLock & Numpad4::
    ToggleMousePos(A_ScreenWidth  / 2 - A_ScreenWidth / GetGridSize()
                 , A_ScreenHeight / 2)
return

<#Numpad5::
CapsLock & NumpadClear::
CapsLock & Numpad5::
    ToggleMousePos(A_ScreenWidth  / 2
                 , A_ScreenHeight / 2)
return

<#Numpad6::
CapsLock & NumpadRight::
CapsLock & Numpad6::
    ToggleMousePos(A_ScreenWidth  / 2 + A_ScreenWidth / GetGridSize()
                 , A_ScreenHeight / 2)
return

<#Numpad1::
CapsLock & NumpadEnd::
CapsLock & Numpad1::
    gridSize := GetGridSize()
    ToggleMousePos(A_ScreenWidth  / 2 - A_ScreenWidth  / gridSize
                 , A_ScreenHeight / 2 + A_ScreenHeight / gridSize)
return

<#Numpad2::
CapsLock & NumpadDown::
CapsLock & Numpad2::
    ToggleMousePos(A_ScreenWidth  / 2
                 , A_ScreenHeight / 2 + A_ScreenHeight / GetGridSize())
return

<#Numpad3::
CapsLock & NumpadPgdn::
CapsLock & Numpad3::
    gridSize := GetGridSize()
    ToggleMousePos(A_ScreenWidth  / 2 + A_ScreenWidth  / gridSize
                 , A_ScreenHeight / 2 + A_ScreenHeight / gridSize)
return

ClickOnCenter:
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
        activeWindow := WinExist("A")
        Shell.Run("C:\Users\Serhan\Documents\.tools\AutoHideMouseCursor\AutoHideMouseCursor_x64_p.exe", 0)
        AutoHideMouseCursorRunning := 1

        if (activeWindow) {
            Sleep 150
            WinActivate
            activeWindow := ""
        }
    }
return

#IfWinActive ahk_group Group_SendInputCheckBoxVariants
    ^!+x::SendInput [_]{Space}
    ^!+c::SendInput [x]{Space}
    ^!+z::SendInput [-]{Space}
#IfWinActive

#IfWinActive ahk_group Group_ChromiumBasedApp
    ~^b::
        SetTitleMatchMode, 2

        if !WinActive("Google D") {
            Send, ^t
            Sleep, 200
            SendRaw, chrome://bookmarks/
            Send, {Enter}
        }
    return

    ^h::
        Send, ^t
        Sleep, 200
        SendRaw, chrome://history/all
        Send, {Enter}
    return

    ; Click "close this message" on StackOverflow
    CapsLock & x::
        MouseGetPos, xpos, ypos
        MouseMove, A_ScreenWidth / 2, 140
        Click
        MouseMove, %xpos%, %ypos%
    return

    <#<+Up::WheelLeft
    <#<+Down::WheelRight
#IfWinActive

#IfWinActive ahk_exe firefox.exe
    ; Click "close this message" on StackOverflow
    CapsLock & x::
        MouseGetPos, xpos, ypos
        MouseMove, A_ScreenWidth / 2, 140
        Click
        MouseMove, %xpos%, %ypos%
    return

    !f::!+f
    !e::!+e
    !v::!+v
    !ı::!+ı
    !o::!+o
    !t::!+t
    !n::!+n
    !h::!+h
#IfWinActive

#IfWinActive ahk_exe ApplicationFrameHost.exe
    ~Numpad0::
        SetTitleMatchMode, 2

        if WinActive("Fotoğraflar") {
            Send, ^0
        }
    return

    ~Numpad1::
        SetTitleMatchMode, 2

        if WinActive("Fotoğraflar") {
            Send, ^1
        }
    return

    ~NumpadAdd::
        SetTitleMatchMode, 2

        if WinActive("Fotoğraflar") {
            Send, ^{NumpadAdd}
        }
    return

    ~NumpadSub::
        SetTitleMatchMode, 2

        if WinActive("Fotoğraflar") {
            Send, ^{NumpadSub}
        }
    return
#IfWinActive

*CapsLock:: return ; This forces CapsLock into a modifying key.
RButton::RButton   ; restore the original RButton function

>#>+e::                                                                           ; rwin + rshift + e            | open file path in clipboard with notepad++
    Sleep 150
    Run, C:\Program Files (x86)\Notepad++\notepad++.exe "%clipboard%"
return

>#>+f::                                                                           ; rwin + rshift + f            | open file path in clipboard with explorer
    clipboard := StrReplace(clipboard, "`/", "`\")
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

; Text–only paste from clipboard (Trims leading and trailing whitespaces)
^+v:: ; ctrl + shift + v
    originalClipboard := ClipBoardAll
    clipboard := clipboard               ; Convert to text
    clipboard := RegexReplace(clipboard, "^\s+|\s+$")
    Send, ^v                             ; For best compatibility: SendPlay
    Sleep 50                             ; Don't change clipboard while it is pasted! (Sleep > 0)
    clipboard := originalClipboard       ; Restore original ClipBoard
    VarSetCapacity(originalClipboard, 0) ; Free memory
return

^!+n::                                                                            ; ctrl + alt + shift + n
    clipboard := ""
    Send, ^c
    ClipWait
    clipboard := StrReplace(RegexReplace(clipboard, "\r?\n", " "), """", """""")
return

<#ü::
    clipboard := ""
    Send, ^c
    ClipWait, 0.25
    Send, #+ü ; execute copyq action
return

^'::
Ctrl & ":: ;"
    if GetKeyState("RShift") {
        WrapTextWith("'", "'")
    }
    else {
        WrapTextWith("""", """")
    }
return

^SC056::WrapTextWith("<", ">")
^+1::WrapTextWith("(", ")")
^+2::WrapTextWith("[", "]")
^+3::WrapTextWith("{", "}")
^+4::WrapTextWith("``", "``")
^+5::WrapTextWith("```````r`n", "`r`n``````")

^+6::
    Send, !{f17} ; disable copyq
    clipboard := ""
    Send, ^c
    ClipWait
    clipboard := RegexReplace(clipboard, "[\r\n]+$", "")
    firstChar := SubStr(clipboard, 1, 1)

    if (firstChar != "``") {
        clipboard := "``" . clipboard . "``"
    }

    RunWait %ComSpec% /c clipemdown | MarkdownForClipboard.exe,, Hide
    Send, ^v
    Sleep 250
    Send, !{f16} ; Enable copyq and activate first item
return

WrapTextWith(left, right) {
    Send, !{f17} ; disable copyq
    clipboard := ""
    Send, ^c
    ClipWait
    clipboard := left . RegexReplace(clipboard, "[\r\n]+$", "") . right
    Send, ^v
    Sleep 250
    Send, !{f16} ; Enable copyq and activate first item
}

; Credits for the debouncer code: https://www.autohotkey.com/boards/viewtopic.php?p=117262#p117262

#If !GetKeyState("LControl") and !GetKeyState("LShift") and !GetKeyState("LAlt")
    <#Up::Send % ((A_PriorHotkey=A_ThisHotkey)&&(A_TimeSincePriorHotkey<5))?"":"{Blind}{Up up}{WheelUp}"
    <#Down::Send % ((A_PriorHotkey=A_ThisHotkey)&&(A_TimeSincePriorHotkey<5))?"":"{Blind}{Down up}{WheelDown}"
#If

#If !GetKeyState("LControl") and !GetKeyState("LShift") and !GetKeyState("LAlt") and WinActive("ahk_group Group_HScroll_SupportsShiftWheel")
    <#Left::Send, +{WheelUp}
    <#Right::Send, +{WheelDown}
#If

#If !GetKeyState("LControl") and !GetKeyState("LShift") and !GetKeyState("LAlt") and WinActive("ahk_group Group_HScroll_SupportsNativeHWheel")
    <#Left::WheelLeft
    <#Right::WheelRight
#If

#If !GetKeyState("LControl") and !GetKeyState("LShift") and !GetKeyState("LAlt") and WinActive("ahk_group Group_HScroll_HonorsScrollLockState")
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

; Sending WM_HSCROLL messages is the fallback scrolling mode

#If !GetKeyState("LControl") and !GetKeyState("LAlt") and !WinActive("ahk_group Group_HScroll_All")
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
#If

#IfWinActive ahk_group Group_CtrlRToF5
    ^r::Send, {f5}
#IfWinActive

#IfWinActive ahk_group Group_ZoomableByWheel
    ^NumpadSub::Send % ((A_PriorHotkey=A_ThisHotkey)&&(A_TimeSincePriorHotkey<5))?"":"{Blind}{NumpadSub up}{WheelDown}"
    ^NumpadAdd::Send % ((A_PriorHotkey=A_ThisHotkey)&&(A_TimeSincePriorHotkey<5))?"":"{Blind}{NumpadAdd up}{WheelUp}"
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

VS_Handle_CtrlF := 1

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

    f3::
        VS_Handle_CtrlF := 0
        Send ^{f19}
        Send {Enter}
        Send {Esc}
        VS_Handle_CtrlF := 1
    return

    +f3::
        VS_Handle_CtrlF := 0
        Send ^{f19}
        Send +{Enter}
        Send {Esc}
        VS_Handle_CtrlF := 1
    return

    *^f::
        if (VS_Handle_CtrlF = 0) {
            return
        }

        VS_Handle_CtrlF := 0
        VS_ShiftPressed := GetKeyState("Shift")
        Send, !{f17} ; disable copyq
        clipboard := ""
        Send ^c
        ClipWait, 0.25

        if (VS_ShiftPressed) {
            Send ^+{f19}
        }
        else {
            Send ^{f19}
        }

        if StrLen(clipboard) {
            Send ^v
            Sleep 250
        }

        Send, !{f16} ; Enable copyq and activate first item
        VS_Handle_CtrlF := 1
    return
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

    f3::
        Send {Right}{Left}
        Send {f19}
    return

    +f3::
        ; Send {End}{Home 2}
        Send {Right}{Left}
        Send +{f19}
    return
#IfWinActive

#IfWinActive ahk_exe 7zFM.exe                                                     ; if it is 7-Zip
    Esc::Send, !{f4}                                                              ; esc                          | Send alt + f4
    !Up::Send, {Backspace}                                                        ; alt + up                     | Send backspace
#IfWinActive

#IfWinActive ahk_exe notepad++.exe
    ^+Tab::
        Send, !w
        Send, w
    return

    !PgUp::
        GoSub ClickOnCenter
        Sleep 15
        Send ^!+{PgUp} ; SCI_STUTTEREDPAGEUP
    return

    !PgDn::
        GoSub ClickOnCenter
        Sleep 15
        Send ^!+{PgDn} ; SCI_STUTTEREDPAGEDOWN
    return

    <^>!+İ::Send ^!+{I}
#IfWinActive

#IfWinActive ahk_exe soffice.bin
    ^'::
    Ctrl & ":: ;"
        if GetKeyState("RShift") {
            WrapTextWith("‘", "’")
        }
        else {
            WrapTextWith("“", "”")
        }
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

; if scroll lock is on
#If GetKeyState("ScrollLock", "T")
    ; Convert a bower.json url to npm-friendly url
    ^!+b::                                                                        ; ctrl + alt + shift + b
        originalClipboard := ClipBoardAll
        clipboard := clipboard               ; Convert to text
        clipboard := RegexReplace(clipboard, "^(git@[^.]+\.com):([^#]+)#v?(.+)$", "git+ssh://$1/$2#v$3")
        Send, ^v                             ; For best compatibility: SendPlay
        Sleep 50                             ; Don't change clipboard while it is pasted! (Sleep > 0)
        clipboard := originalClipboard       ; Restore original clipboard
        VarSetCapacity(originalClipboard, 0) ; Free memory
    return

    ; Excess indent removal
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

:*:;;tm::                                                      ; Replace ";;tm" with current time surrounded by brackets
    FormatTime, CurrentDateTime, L1055, HH.mm                  ; [13.17]
    SendInput [%CurrentDateTime%]{Space}
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
