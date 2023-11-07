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
#MaxHotkeysPerInterval 2000

#include TrayIcon.ahk

GroupAdd, Group_CtrlRToF5, ahk_class CabinetWClass
GroupAdd, Group_CtrlRToF5, ahk_exe GitExtensions.exe
GroupAdd, Group_CtrlRToF5, ahk_exe WinMergeU.exe

GroupAdd, Group_ZoomableByWheel, ahk_exe WINWORD.EXE
GroupAdd, Group_ZoomableByWheel, ahk_exe EXCEL.EXE
GroupAdd, Group_ZoomableByWheel, ahk_exe soffice.bin

GroupAdd, Group_HScroll_SupportsShiftWheel, ahk_exe notepad++.exe
GroupAdd, Group_HScroll_SupportsShiftWheel, ahk_exe devenv.exe

GroupAdd, Group_HScroll_SupportsNativeHWheel, ahk_class MMCMainFrame
GroupAdd, Group_HScroll_SupportsNativeHWheel, ahk_exe GitExtensions.exe
GroupAdd, Group_HScroll_SupportsNativeHWheel, ahk_exe msedge.exe
GroupAdd, Group_HScroll_SupportsNativeHWheel, ahk_exe chrome.exe
GroupAdd, Group_HScroll_SupportsNativeHWheel, ahk_exe catsxp.exe
GroupAdd, Group_HScroll_SupportsNativeHWheel, ahk_exe WINWORD.EXE
GroupAdd, Group_HScroll_SupportsNativeHWheel, ahk_exe idea64.exe
GroupAdd, Group_HScroll_SupportsNativeHWheel, ahk_class MozillaWindowClass
GroupAdd, Group_HScroll_SupportsNativeHWheel, ahk_exe paintdotnet.exe
GroupAdd, Group_HScroll_SupportsNativeHWheel, ahk_exe soffice.bin

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

MovementMethod := { unknown: 0, horizontal: 1, vertical: 2 }

_L1 := Floor(A_ScreenWidth  / 2 - A_ScreenWidth  / ScreenGridSizePrimary)
_L2 := Floor(A_ScreenWidth  / 2 - A_ScreenWidth  / ScreenGridSizeAlternate)
_T1 := Floor(A_ScreenHeight / 2 - A_ScreenHeight / ScreenGridSizePrimary)
_T2 := Floor(A_ScreenHeight / 2 - A_ScreenHeight / ScreenGridSizeAlternate)
_CX := Floor(A_ScreenWidth  / 2)
_CY := Floor(A_ScreenHeight / 2)
_R1 := Floor(A_ScreenWidth  / 2 + A_ScreenWidth  / ScreenGridSizePrimary)
_R2 := Floor(A_ScreenWidth  / 2 + A_ScreenWidth  / ScreenGridSizeAlternate)
_B1 := Floor(A_ScreenHeight / 2 + A_ScreenHeight / ScreenGridSizePrimary)
_B2 := Floor(A_ScreenHeight / 2 + A_ScreenHeight / ScreenGridSizeAlternate)
_RelativeHorizontalJump := Floor(A_ScreenWidth  / ScreenGridSizeAlternate / 4) ; _CX - _L2
_RelativeVerticalJump   := Floor(A_ScreenHeight / ScreenGridSizeAlternate / 4) ;_CY - _T2
_DateTimeX := A_ScreenWidth - 71
_DateTimeY := A_ScreenHeight - 15

LastMovement := MovementMethod.unknown

CoordMode, Mouse, Screen

LWin & Enter::Send, {RWin Down}{Enter}{RWin Up}                                   ; lwin + Enter                 | Send rwin + Enter
#w::Send, !{f15}                                                                  ; win + w                      | Send alt + f15
#^a::Winset, Alwaysontop, , A                                                     ; win + ctrl + a               | Make the active window stay always on top
<#<^<+Up::Volume_Up                                                               ; lwin + lctrl + lshift + up   | Increase volume
<#<^<+Down::Volume_Down                                                           ; lwin + lctrl + lshift + down | Decrease volume
CapsLock & Del::Send, !{f4}                                                       ; CapsLock + del               | Send alt + f4
^!+l::Run, ClipToQuotedLines.exe                                                  ; ctrl + alt + shift + l       | ClipToQuotedLines.exe
^!+h::clipboard := StrReplace(clipboard, "`\", "`/")                              ; ctrl + alt + shift + h       | Replace all the \ characters within the text in clipboard with /
^!+Left::Media_Prev                                                               ; ctrl + alt + shift + left    | Media_Prev
^!+Right::Media_Next                                                              ; ctrl + alt + shift + right   | Media_Next
^!+Down::Media_Play_Pause                                                         ; ctrl + alt + shift + down    | Media_Play_Pause
^!+Up::Media_Stop                                                                 ; ctrl + alt + shift + up      | Media_Stop
^!+b::
    clipboard := ""
    Send, ^c
    ClipWait
    clipboard := SubStr(clipboard, 2, StrLen(clipboard) - 2)
Return

CapsLock & Left::                                                                 ; CapsLock + left arrow        | Move mouse pointer leftward
    if GetKeyState("LAlt") {
        ToggleMousePos(-_RelativeHorizontalJump, 0, 1)
    }
    else {
        SavePosAndMouseMoveR(-14, 0)
    }
Return
CapsLock & Right::                                                                ; CapsLock + right arrow       | Move mouse pointer rightward
    if GetKeyState("LAlt") {
        ToggleMousePos(_RelativeHorizontalJump, 0, 1)
    }
    else {
        SavePosAndMouseMoveR(14, 0)
    }
Return
Return
CapsLock & Down::                                                                 ; CapsLock + down arrow        | Move mouse pointer downward
    if GetKeyState("LAlt") {
        ToggleMousePos(0, _RelativeVerticalJump, 1)
    }
    else {
        SavePosAndMouseMoveR(0, 14)
    }
Return
Return
CapsLock & Up::                                                                   ; CapsLock + up arrow          | Move mouse pointer upward
    if GetKeyState("LAlt") {
        ToggleMousePos(0, -_RelativeVerticalJump, 1)
    }
    else {
        SavePosAndMouseMoveR(0, -14)
    }
Return
Return

+NumpadHome::Send {Numpad7}
+NumpadUp::Send {Numpad8}
+NumpadPgup::Send {Numpad9}
+NumpadLeft::Send {Numpad4}
+NumpadClear::Send {Numpad5}
+NumpadRight::Send {Numpad6}
+NumpadEnd::Send {Numpad1}
+NumpadDown::Send {Numpad2}
+NumpadPgdn::Send {Numpad3}
+NumpadIns::Send {Numpad0}
+NumpadDel::Send .

#If !GetKeyState("NumLock", "T")
    NumpadHome::Send, {Click 1}
    ^NumpadHome::Send, {MButton 1}
    NumpadPgup::Click, Right
#If

#Ins::
CapsLock & Ins::                                                                  ; CapsLock + Insert            | Save current Mouse Coord
    MouseGetPos, SavedMouseCoordX, SavedMouseCoordY
    SavedMouseCoordX := Floor(SavedMouseCoordX)
    SavedMouseCoordY := Floor(SavedMouseCoordY)
Return

#Home::                                                                           ; Win + Home
CapsLock & Home::                                                                 ; CapsLock + Home              | Go to saved Mouse Coord
    if (LastMovement = MovementMethod.unknown) {
        ToggleMousePos(_R1, _T1 + 14 * 9)
    }
    else {
        ToggleMousePos(SavedMouseCoordX, SavedMouseCoordY)
    }
Return

CapsLock & Space::SetCapsLockState % !GetKeyState("CapsLock", "T")                ; CapsLock + Space             | Toggle CapsLock state

#If !GetKeyState("LAlt")
    CapsLock & Enter::Send, {Click 1}
#If

#If GetKeyState("LAlt")
    CapsLock & Enter::Click, Right
#If

<#End::ToggleMousePos(-1, _B2)

<#Numpad7::
<#NumpadHome::
CapsLock & NumpadHome::
CapsLock & Numpad7::
    if GetKeyState("LAlt") {
        ToggleMousePos(_L1, _T1)
    }
    else {
        ToggleMousePos(_L2, _T2)
    }
return

<#Numpad8::
<#NumpadUp::
CapsLock & NumpadUp::
CapsLock & Numpad8::
    if GetKeyState("LAlt") {
        ToggleMousePos(_CX, _T1)
    }
    else {
        ToggleMousePos(-1,  _T2)
    }
return

<#Numpad9::
<#NumpadPgup::
CapsLock & NumpadPgup::
CapsLock & Numpad9::
    if GetKeyState("LAlt") {
        ToggleMousePos(_R1, _T1)
    }
    else {
        ToggleMousePos(_R2, _T2)
    }
return

<#Numpad4::
<#NumpadLeft::
CapsLock & NumpadLeft::
CapsLock & Numpad4::
    if GetKeyState("LAlt") {
        ToggleMousePos(_L1, _CY)
    }
    else {
        ToggleMousePos(_L2,  -1)
    }
return

<#Numpad5::
<#NumpadClear::
CapsLock & NumpadClear::
CapsLock & Numpad5::
    if GetKeyState("LAlt") {
        ToggleMousePos(_CX, _CY)
        Return
    }

    targetx := _CX
    targety := _CY

    if (LastMovement = MovementMethod.horizontal) {
        targety := -1
    }
    else if (LastMovement = MovementMethod.vertical) {
        targetx := -1
    }

    ToggleMousePos(targetx, targety)
return

<#Numpad6::
<#NumpadRight::
CapsLock & NumpadRight::
CapsLock & Numpad6::
    if GetKeyState("LAlt") {
        ToggleMousePos(_R1, _CY)
    }
    else {
        ToggleMousePos(_R2,  -1)
    }
return

<#Numpad1::
<#NumpadEnd::
CapsLock & NumpadEnd::
CapsLock & Numpad1::
    if GetKeyState("LAlt") {
        ToggleMousePos(_L1, _B1)
    }
    else {
        ToggleMousePos(_L2, _B2)
    }
return

<#Numpad2::
<#NumpadDown::
CapsLock & NumpadDown::
CapsLock & Numpad2::
    if GetKeyState("LAlt") {
        ToggleMousePos(_CX, _B1)
    }
    else {
        ToggleMousePos(-1,  _B2)
    }
return

<#Numpad3::
<#NumpadPgdn::
CapsLock & NumpadPgdn::
CapsLock & Numpad3::
    if GetKeyState("LAlt") {
        ToggleMousePos(_R1, _B1)
    }
    else {
        ToggleMousePos(_R2, _B2)
    }
return

ClickOnCenter:
CapsLock & End::                                                                  ; CapsLock + end
<!End::                                                                           ; lalt + end
    MouseGetPos, xpos, ypos
    MouseMove, _CX, _CY
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
        MouseMove, _CX, 150
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
        MouseMove, _CX, 150
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
    ~NumpadIns::
        SetTitleMatchMode, 2

        if WinActive("Fotoğraflar") {
            Send, ^0
        }
    return

    ~Numpad1::
    ~NumpadEnd::
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

#IfWinActive ahk_exe devenv.exe
    !NumpadUp::Send {Blind}{WheelUp}
    !NumpadClear::Send {Blind}{WheelDown}
    <!Backspace::
        Send ^+ü
        Sleep, 15
        Send {Backspace}
        Sleep, 15
        SendInput ""
        Sleep, 15
        Send {Left}
    Return
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
            TrayIcon_Button("thunderbird.exe")
        }
    }
return

>#>+g::
    TrayIcon_Button("GoogleDriveFS.exe")
Return

>#>+d::
    MouseGetPos, xpos, ypos
    Click, %_DateTimeX%, %_DateTimeY%
    MouseMove, %xpos%, %ypos%
Return

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
    Send, !{f17} ; disable copyq
    clipboard := ""
    Send, ^c
    ClipWait
    clipboard := RegexReplace(clipboard, " *\r?\n *", " ")
    Send, ^v
    Sleep 250
    Send, !{f16} ; Enable copyq and activate first item
return

#IfWinNotActive ahk_exe soffice.bin
    ^!+j::                                                                            ; ctrl + alt + shift + j
        clipboard := RegexReplace(clipboard, "(\r?\n)", ",$1")
        Send, ^v
    return
#IfWinNotActive

<#ü::
    clipboard := ""
    Send, ^c
    ClipWait, 0.25
    Send, #+ü ; execute copyq action
return

^'::
Ctrl & ":: ;"
    if GetKeyState("RShift") {
        if GetKeyState("RAlt") {
            WrapTextWith("“", "”")
        }
        else {
            WrapTextWith("'", "'")
        }
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
    Sleep 50
    clipboard := ""
    Send, ^c
    ClipWait, 0.25
    clipboard := clipboard

    if not StrLen(clipboard) {
        Send ^+{Left}
        Send, ^c
        ClipWait, 0.25
    }

    clipboard := left . RegexReplace(clipboard, "[\r\n]+$", "") . right
    Send, ^v
    Sleep 250
    Send, !{f16} ; Enable copyq and activate first item
    Sleep 50
}

>#v::Send !{f20}
<#Left::Send +{f13}
<#Right::Send ^{f13}
>#g::Send ^{f14}
>#b::Send ^{f15}
>#n::Send ^{f16}
!8::SendInput [
!9::SendInput ]
!7::SendInput {{}
!0::SendInput {}}

; Credits for the debouncer code: https://www.autohotkey.com/boards/viewtopic.php?p=117262#p117262

#UseHook
#If !GetKeyState("NumLock", "T") or (!GetKeyState("LControl") and !GetKeyState("LShift") and !GetKeyState("LAlt"))
    <#Up::
    NumpadUp::
        Send % ((A_PriorHotkey=A_ThisHotkey)&&(A_TimeSincePriorHotkey<17))?"":"{Blind}{Up up}{WheelUp}"
    Return

    <#Down::
    NumpadClear::
        Send % ((A_PriorHotkey=A_ThisHotkey)&&(A_TimeSincePriorHotkey<17))?"":"{Blind}{Down up}{WheelDown}"
    Return
#If
#UseHook Off

#If (!GetKeyState("NumLock", "T") or (!GetKeyState("LControl") and !GetKeyState("LShift") and !GetKeyState("LAlt"))) and WinActive("ahk_group Group_HScroll_SupportsShiftWheel")
    NumpadLeft::
        Send, +{WheelUp}
    Return

    NumpadRight::
        Send, +{WheelDown}
    Return
#If

#If (!GetKeyState("NumLock", "T") or (!GetKeyState("LControl") and !GetKeyState("LShift") and !GetKeyState("LAlt"))) and WinActive("ahk_group Group_HScroll_SupportsNativeHWheel")
    NumpadLeft::
        Send {Blind}{WheelLeft}
    Return

    NumpadRight::
        Send {Blind}{WheelRight}
    Return
#If

#If !GetKeyState("LControl") and !GetKeyState("LShift") and !GetKeyState("LAlt") and WinActive("ahk_group Group_HScroll_HonorsScrollLockState")
    NumpadLeft::
        SetScrollLockState, On
        Send, {Left}
        SetScrollLockState, Off
    return

    NumpadRight::
        SetScrollLockState, On
        Send, {Right}
        SetScrollLockState, Off
    return
#If

; Sending WM_HSCROLL messages is the fallback scrolling mode

#If (!GetKeyState("NumLock", "T") or (!GetKeyState("LControl") and !GetKeyState("LAlt"))) and !WinActive("ahk_group Group_HScroll_All")
    NumpadLeft::
        ControlGetFocus, fcontrol, A
        Loop 8
            PostMessage, 0x114, 0, 0, %fcontrol%, A  ; 0x114=WM_HSCROLL; 0=SB_LINELEFT
    return

    NumpadRight::
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
        clipboard := RegexReplace(clipboard, "^(\[[^\]]+\]\.)?\[([^\]]+)\]$", "$2")
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

    <#+Ş::
        Send, !{f17} ; disable copyq
        Send ^+ü
        Sleep 15
        Send {Del}
        Sleep 15
        SendInput []
        Send {Left}{Enter}{Up}{End}{Enter}{BackSpace 2}
        Sleep 15
        Run, ClipToQuotedLines.exe
        Sleep 200
        ClipBoard := RegExReplace(ClipBoard, "(\r?\n|^)([^\r\n]+)", "$1    $2")
        Send ^v
        Sleep 250
        Send, !{f16} ; Enable copyq and activate first item
    Return

    >#b::Send {F7}
    >#g::Send {Esc}
    >#w::Send {F6}
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

#IfWinActive ahk_exe WinMergeU.exe
    ~n::
        SetTitleMatchMode, 3

        if WinActive("Save modified files?") {
            Send !{r}
        }
    return
#IfWinActive

#IfWinActive ahk_exe EXCEL.EXE
    F1::=
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
        SetScrollLockState, Off
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
        SetScrollLockState, Off
    return
#If

#If WinActive("ahk_exe idea64.exe") && WinExist("ahk_class SunAwtWindow")
    ; Up::Send {Esc}{Up}
    ; Right::Send {Esc}{Right}
    ; Down::Send {Esc}{Down}
    ; Left::Send {Esc}{Left}
    Home::Send {Esc}{Home}
    End::Send {Esc}{End}
    Ctrl::Send {Esc}
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

:*:;;vnow::                                                    ; Replace ";;vnow" with current date and time without separators
    FormatTime, CurrentDateTime,, yyyMMddHHmm                  ; 200910131057
    SendInput %CurrentDateTime%
return

:*:;;dfc::{Raw}[DefaultValueFactory(UseDefaultPropertyValue = true)]`n[ValidateReferenceType]
:*:;;dfl::{Raw}[DefaultValueFactory(UseDefaultPropertyValue = true)]`n[ValidateReferenceTypeCollection]`n[LoyalReferenceTypeCollectionRange(Min = 1, ErrorMessage = "En az bir satır eklemeniz gereklidir.")]

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

>#>+2::SendInput ’
>#>+1::
    SendInput “”
    Send {Left}
Return

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

ToggleMousePos(targetx, targety, isRelative := 0) {
    Global LastMouseCoordX
    Global LastMouseCoordY
    Global LastMovement
    Global MovementMethod

    MouseGetPos, xpos, ypos
    xpos := Floor(xpos)
    ypos := Floor(ypos)

    LastMovement := MovementMethod.unknown

    if (isRelative = 1) {
        targetx := xpos + targetx
        targety := ypos + targety
    }
    else {
        if (targetx = -1) {
            targetx := xpos
        }

        if (targety = -1) {
            targety := ypos
        }
    }

    ; MsgBox, last: %LastMouseCoordX%,%LastMouseCoordY%`ncurrent: %xpos%,%ypos%`ntarget: %targetx%,%targety%

    if (targetx = xpos) and (targety = ypos) {
        if (LastMouseCoordX = xpos) {
            LastMovement := MovementMethod.vertical
        }
        else if (LastMouseCoordY = ypos) {
            LastMovement := MovementMethod.horizontal
        }

        MouseMove, %LastMouseCoordX%, %LastMouseCoordY%
    }
    else {
        if (targetx = xpos) {
            LastMovement := MovementMethod.vertical
        }
        else if (targety = ypos) {
            LastMovement := MovementMethod.horizontal
        }

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
