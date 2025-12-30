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
#include WinUtil.ahk

GroupAdd, Group_WinMerge, ahk_exe WinMergeU.exe
GroupAdd, Group_WinMerge, ahk_exe wm

GroupAdd, Group_CtrlRToF5, ahk_class CabinetWClass
GroupAdd, Group_CtrlRToF5, ahk_exe GitExtensions.exe
GroupAdd, Group_CtrlRToF5, ahk_group Group_WinMerge
GroupAdd, Group_CtrlRToF5, ahk_exe thunderbird.exe

GroupAdd, Group_ZoomableByWheel, ahk_exe WINWORD.EXE
GroupAdd, Group_ZoomableByWheel, ahk_exe EXCEL.EXE
GroupAdd, Group_ZoomableByWheel, ahk_exe soffice.bin

GroupAdd, Group_IntelliJLike, ahk_exe idea64.exe
GroupAdd, Group_IntelliJLike, ahk_exe studio64.exe

GroupAdd, Group_HScroll_SupportsNativeHWheel, ahk_class MMCMainFrame
GroupAdd, Group_HScroll_SupportsNativeHWheel, ahk_exe GitExtensions.exe
GroupAdd, Group_HScroll_SupportsNativeHWheel, ahk_exe msedge.exe
GroupAdd, Group_HScroll_SupportsNativeHWheel, ahk_exe chrome.exe
GroupAdd, Group_HScroll_SupportsNativeHWheel, ahk_exe catsxp.exe
GroupAdd, Group_HScroll_SupportsNativeHWheel, ahk_exe WINWORD.EXE
GroupAdd, Group_HScroll_SupportsNativeHWheel, ahk_group Group_IntelliJLike
GroupAdd, Group_HScroll_SupportsNativeHWheel, ahk_class MozillaWindowClass
GroupAdd, Group_HScroll_SupportsNativeHWheel, ahk_exe paintdotnet.exe
GroupAdd, Group_HScroll_SupportsNativeHWheel, ahk_exe soffice.bin
GroupAdd, Group_HScroll_SupportsNativeHWheel, ahk_exe devenv.exe
GroupAdd, Group_HScroll_SupportsNativeHWheel, ahk_exe Code.exe

GroupAdd, Group_HScroll_HonorsScrollLockState, ahk_exe EXCEL.EXE

GroupAdd, Group_HScroll_All, ahk_group Group_HScroll_SupportsNativeHWheel
GroupAdd, Group_HScroll_All, ahk_group Group_HScroll_HonorsScrollLockState

GroupAdd, Group_ChromiumBasedApp, ahk_exe chrome.exe
GroupAdd, Group_ChromiumBasedApp, ahk_exe msedge.exe
GroupAdd, Group_ChromiumBasedApp, ahk_exe catsxp.exe

GroupAdd, Group_SendInputCheckBoxVariants, ahk_group Group_ChromiumBasedApp
GroupAdd, Group_SendInputCheckBoxVariants, ahk_exe soffice.bin
GroupAdd, Group_SendInputCheckBoxVariants, ahk_exe firefox.exe

GroupAdd, Group_CtrlAltShiftGExcludedApps, ahk_exe devenv.exe
GroupAdd, Group_CtrlAltShiftGExcludedApps, ahk_exe Code.exe
GroupAdd, Group_CtrlAltShiftGExcludedApps, ahk_exe msedge.exe
GroupAdd, Group_CtrlAltShiftGExcludedApps, ahk_exe chrome.exe

GroupAdd, Group_CtrlShiftVExcludedApps, ahk_exe Be.HexEditor.exe

GroupAdd, AltPgxExcludedApps, ahk_exe notepad++.exe
GroupAdd, AltPgxExcludedApps, ahk_exe devenv.exe
GroupAdd, AltPgxExcludedApps, ahk_exe Ssms.exe
GroupAdd, AltPgxExcludedApps, ahk_exe soffice.bin
GroupAdd, AltPgxExcludedApps, ahk_group Group_WinMerge
GroupAdd, AltPgxExcludedApps, ahk_group Group_IntelliJLike
GroupAdd, AltPgxExcludedApps, ahk_exe tomb123.exe

GroupAdd, FileExplorerLike, ahk_class CabinetWClass
GroupAdd, FileExplorerLike, ahk_exe Everything.exe

Shell := ComObjCreate("WScript.Shell")

LastMouseCoordX := 0
LastMouseCoordY := 0

ScreenGridSize0 := 0.25
ScreenGridSize1 := 0.50

IsExternalMon := 1
WheelScrollLines := 1
RegRead, WheelScrollLines, HKCU\Control Panel\Desktop, WheelScrollLines

MovementMethod := { unknown: 0, horizontal: 1, vertical: 2 }

MouseMovableRegionMargin := 70
MouseMovableRegionWidth  := A_ScreenWidth  - (MouseMovableRegionMargin * 2)
MouseMovableRegionHeight := A_ScreenHeight - (MouseMovableRegionMargin * 2)
_CX := Floor(A_ScreenWidth  / 2)
_CY := Floor(A_ScreenHeight / 2)
_L0 := Floor(_CX - MouseMovableRegionWidth  * ScreenGridSize0)
_L1 := Floor(_CX - MouseMovableRegionWidth  * ScreenGridSize1)
_T0 := Floor(_CY - MouseMovableRegionHeight * ScreenGridSize0)
_T1 := Floor(_CY - MouseMovableRegionHeight * ScreenGridSize1)
_R0 := Floor(_CX + MouseMovableRegionWidth  * ScreenGridSize0)
_R1 := Floor(_CX + MouseMovableRegionWidth  * ScreenGridSize1)
_B0 := Floor(_CY + MouseMovableRegionHeight * ScreenGridSize0)
_B1 := Floor(_CY + MouseMovableRegionHeight * ScreenGridSize1)

_SafeX := Floor(A_ScreenWidth  / 2 + A_ScreenWidth  / 2.5)
_SafeY := Floor(A_ScreenHeight / 2 - A_ScreenHeight / 2.5) + (14 * 9)

_RelativeHorizontalJumpNormal := 6
_RelativeHorizontalJumpLarge := 42
_RelativeVerticalJump   := 42
_DateTimeX := A_ScreenWidth - 71
_DateTimeY := A_ScreenHeight - 15

LastMovement := MovementMethod.unknown

CoordMode, Mouse, Screen

NumpadEnd::Esc
#w::Send, !{f15}                                                                  ; win + w                      | Send alt + f15
CapsLock & SC02B::SendInput, ?
CapsLock & SC035::SendInput, -
^!+l::Run, ClipToQuotedLines.exe                                                  ; ctrl + alt + shift + l       | ClipToQuotedLines.exe
^!+h::clipboard := StrReplace(clipboard, "`\", "`/")                              ; ctrl + alt + shift + h       | Replace all the \ characters within the text in clipboard with /

!Del::
    if (WinExist("A")) {
        WinClose
        WinWaitClose,,, 3
        Sleep 100
        visibleWindows := GetVisibleWindows()
        windowCount := visibleWindows.MaxIndex()
        if (windowCount > 0) {
            nextWin := visibleWindows[1]
            WinActivate, ahk_id %nextWin%
            nextWin := ""
        }
    }
return

CapsLock & Del::
    if GetKeyState("LAlt") {
        Send, ^{BackSpace}
    }
    else {
        Send, {BackSpace}
    }
return

~!Home::
    visibleWindows := GetVisibleWindows()

    if (visibleWindows.MaxIndex()) {
        firstWin := visibleWindows[1]
        WinActivate, ahk_id %firstWin%
        firstWin := ""
    }
return

~^w::
    Sleep 100
    visibleWindows := GetVisibleWindows()

    if (visibleWindows.MaxIndex()) {
        firstWin := visibleWindows[1]
        WinActivate, ahk_id %firstWin%
        firstWin := ""
    }
return

<#Home::Volume_Up
<#End::Volume_Down

<#Left::
    if !GetKeyState("LCtrl") {
        Send, {Media_Prev}
    }
Return

<#Right::
    if !GetKeyState("LCtrl") {
        Send, {Media_Next}
    }
Return

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
        ToggleMousePos(-_RelativeHorizontalJumpLarge, 0, 1)
    }
    else {
        SavePosAndMouseMoveR(-_RelativeHorizontalJumpNormal, 0)
    }
Return
CapsLock & Right::                                                                ; CapsLock + right arrow       | Move mouse pointer rightward
    if GetKeyState("LAlt") {
        ToggleMousePos(_RelativeHorizontalJumpLarge, 0, 1)
    }
    else {
        SavePosAndMouseMoveR(_RelativeHorizontalJumpNormal, 0)
    }
Return
CapsLock & Down::                                                                 ; CapsLock + down arrow        | Move mouse pointer downward
    if GetKeyState("LAlt") {
        ToggleMousePos(0, _RelativeVerticalJump, 1)
    }
    else {
        SavePosAndMouseMoveR(0, _RelativeHorizontalJumpNormal)
    }
Return
CapsLock & Up::                                                                   ; CapsLock + up arrow          | Move mouse pointer upward
    if GetKeyState("LAlt") {
        ToggleMousePos(0, -_RelativeVerticalJump, 1)
    }
    else {
        SavePosAndMouseMoveR(0, -_RelativeHorizontalJumpNormal)
    }
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
NumpadDel::Send, ,

#If !GetKeyState("NumLock", "T")
    NumpadHome::Send, {Click 1}
    ^NumpadHome::Send, {MButton 1}
    NumpadPgup::Click, Right

    <#NumpadHome::
    <#NumpadPgup::
        targetx := _SafeX
        targety := _SafeY
        MouseGetPos, xpos, ypos
        xpos := Floor(xpos)
        ypos := Floor(ypos)
        if (targetx = xpos) {
            targetx := A_ScreenWidth - 1
        }
        MouseMove, %targetx%, %targety%
    Return
#If

<#Up::                                                                            ; LWin + Up
    ToggleMousePos(_SafeX, _SafeY)
Return

CapsLock & Home::
    ToggleMousePos(A_ScreenWidth - 1, _SafeY)
Return

CapsLock & Space::SetCapsLockState % !GetKeyState("CapsLock", "T")                ; CapsLock + Space             | Toggle CapsLock state

<#Down::ToggleMousePos(_SafeX, _B0)

<#Numpad7::
CapsLock & NumpadHome::
CapsLock & Numpad7::
    if GetKeyState("LAlt") {
        ToggleMousePos(_L1, _T1)
    }
    else {
        ToggleMousePos(_L0, _T0)
    }
return

<#Numpad8::
CapsLock & NumpadUp::
CapsLock & Numpad8::
    if GetKeyState("LAlt") {
        ToggleMousePos(_CX, _T1)
    }
    else {
        ToggleMousePos(_CX, _T0)
    }
return

<#Numpad9::
CapsLock & NumpadPgup::
CapsLock & Numpad9::
    if GetKeyState("LAlt") {
        ToggleMousePos(_R1, _T1)
    }
    else {
        ToggleMousePos(_R0, _T0)
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
        ToggleMousePos(_L0, _CY)
    }
return

<#Numpad5::
CapsLock & NumpadClear::
CapsLock & Numpad5::
    ToggleMousePos(_CX, _CY)
return

<#Numpad6::
<#NumpadRight::
CapsLock & NumpadRight::
CapsLock & Numpad6::
    if GetKeyState("LAlt") {
        ToggleMousePos(_R1, _CY)
    }
    else {
        ToggleMousePos(_R0, _CY)
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
        ToggleMousePos(_L0, _B0)
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
        ToggleMousePos(_CX, _B0)
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
        ToggleMousePos(_R0, _B0)
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

    NumpadEnd::
        SetTitleMatchMode, 2

        if WinActive("— Yandex: ") {
            Send, {NumpadDiv}
        }
        else {
            Send, {Esc}
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
        MouseMove, _CX, 166
        Click
        MouseMove, %xpos%, %ypos%
    return

    <#<+Up::WheelLeft
    <#<+Down::WheelRight
    ^q::Send, ^l

    NumpadPgdn::
        Send ^+q ; This writes the focused element's coords to page title using some Tampermonkey script
        Sleep 250
        WinGetActiveTitle, Title
        Coords := StrSplit(RegExReplace(Title, "screenX: (\d+), screenY: (\d+)", "$1 $2"), " ")
        X := Coords[1]
        Y := Coords[2]
        MouseGetPos, xpos, ypos
        if (X = xpos) and (Y = ypos) {
            MouseMove, %_SafeX%, %_SafeY%
        }
        else {
            MouseMove, %X%, %Y%
            Sleep 50
            Click, Right
        }
    Return

    NumpadIns::Send, +{Down}
#IfWinActive

#IfWinActive Google Çeviri ahk_group Group_ChromiumBasedApp
    ^u::Send ^+s
#IfWinActive

#IfWinActive ahk_exe firefox.exe
    ; Click "close this message" on StackOverflow
    CapsLock & x::
        MouseGetPos, xpos, ypos
        MouseMove, _CX, 166
        Click
        MouseMove, %xpos%, %ypos%
    return

    ^+n::^+p
    ^+b::^+o

    ; Alternative:
    ; ^+k::
    ;     Send, ^l
    ;     Sleep 75
    ;     Send, +{Tab}
    ;     Sleep 75
    ;     Send, +{Tab}
    ;     Sleep 75
    ;     Send, +{Tab}
    ;     Sleep 75
    ;     Send, +{Tab}
    ;     Sleep 75
    ;     Send, {AppsKey}
    ;     Sleep 100
    ;     Send, o
    ; Return

    >#+v::
        MouseGetPos, xpos, ypos
        MouseMove, 1644, 65
        Click
        Sleep 500
        MouseMove, 1471, 266
        Click
        Sleep 100
        MouseMove, %xpos%, %ypos%
    Return

    !f::
        MouseGetPos, xpos, ypos
        MouseMove, 1894, 56
        Click
        MouseMove, %xpos%, %ypos%
    Return

    ^q::Send, ^l
#IfWinActive

#IfWinActive ahk_group Group_ChromiumBasedApp
    >#+v::
        MouseGetPos, xpos, ypos
        MouseMove, 1575, 54
        Click
        Sleep 500
        MouseMove, 1407, 250
        Click
        Sleep 100
        MouseMove, %xpos%, %ypos%
    Return

    ^+r::Send, {f7}
#IfWinActive

#IfWinActive ahk_exe msedge.exe
    ^!+g::Send, {f6}

    ^Tab::
        Send, ^+a
        if WinActive("WhatsApp") {
            Sleep 15
            Send, {Tab}
        }
    Return

    ^+Tab::Send, ^+a
#IfWinActive

#IfWinActive ahk_exe chrome.exe
    ^!+g::Send, +{f6}
#IfWinActive

; gitk
#IfWinActive ahk_exe wish.exe
    +Space::Send, {BackSpace}
#IfWinActive

#IfWinActive ahk_exe Insomnia.exe
    ^+s::
        Send ^l
        Sleep, 15
        Send +{Tab}
        Sleep, 15
        Send +{Tab}
        Sleep, 15
        Send +{Tab}
        Sleep, 15
        Send +{Tab}
        Sleep, 15
        Send +{Tab}
        Sleep, 15
        Send +{Tab}
        Sleep, 15
        Send +{Tab}
        Sleep, 15
        Send +{Tab}
        Sleep, 15
        Send +{Tab}
        Sleep, 15
        Send +{Tab}
        Sleep, 15
        Send +{Tab}
    Return
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

RButton & LButton::
<#<+s::
<#NumpadUp::
<#NumpadClear::
<#NumpadDiv::
    if (WheelScrollLines = 1) {
        WheelScrollLines := 4
    }
    else {
        WheelScrollLines := 1
    }
    msg := "WheelScrollLines: " . WheelScrollLines
    ToolTip, %msg%
    DllCall("SystemParametersInfoA", uint, 0x69, uint, WheelScrollLines, uintP, 0, uint, 1|2)
    Sleep, 200	; SPECIFY DISPLAY TIME (ms)
    ToolTip		; remove
return

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
    >#b::Send, {Esc}
#IfWinActive

#IfWinActive ahk_exe Ssms.exe
    CapsLock & Enter::SendInput dbo.

    CapsLock & v::
        clipboard := clipboard               ; Convert to text
        object_name := RegexReplace(clipboard, "^""|""$", "")
        SendInput dbo.%object_name%
    Return
#IfWinActive

#IfWinActive ahk_exe PROFILER.EXE
    f4::^+Del

    f5::
        SetMouseDelay, -1
        SetDefaultMouseSpeed, 0
        MouseGetPos, xpos, ypos
        Click, 180, 59
        MouseMove, %xpos%, %ypos%
    Return

    +f5::
        SetMouseDelay, -1
        SetDefaultMouseSpeed, 0
        MouseGetPos, xpos, ypos
        Click, 226, 59
        MouseMove, %xpos%, %ypos%
    Return

    CapsLock & Enter::
        SetMouseDelay, -1
        SetDefaultMouseSpeed, 0
        MouseGetPos, xpos, ypos
        Click, 144 94 Left 2
        MouseMove, %xpos%, %ypos%
    Return
#IfWinActive

CapsLock & LButton::
    Click
    Sleep 15
    Winset, Alwaysontop, , A
Return

CapsLock & Backspace::Winset, Alwaysontop, , A

*CapsLock:: return ; This forces CapsLock into a modifying key.
RButton::RButton   ; restore the original RButton function

>#>+e::                                                                           ; rwin + rshift + e            | open file path in clipboard with notepad++
    Sleep 150
    Run, C:\Program Files (x86)\Notepad++\notepad++.exe "%clipboard%"
return

<#v::
    Run, C:\Program Files\CopyQ\copyq.exe toggle
    Sleep 250
    WinActivate, ahk_exe copyq.exe
return

#IfWinActive ahk_exe copyq.exe
    ^+r::Send, {f2}
#IfWinActive

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

^!+f::
    if WinActive("ahk_exe Spotify.exe") {
        WinClose
        Sleep 300
        visibleWindows := GetVisibleWindows()

        if (visibleWindows.MaxIndex()) {
            firstWin := visibleWindows[1]
            WinActivate, ahk_id %firstWin%
            firstWin := ""
        }
    }
    else {
        TrayIcon_Button("Spotify.exe", "L", True)
    }
Return

>#>+d::
    MouseGetPos, xpos, ypos
    Click, %_DateTimeX%, %_DateTimeY%
    MouseMove, %xpos%, %ypos%
Return

#IfWinNotActive ahk_group Group_CtrlShiftVExcludedApps
    ; Text–only paste from clipboard (Trims leading and trailing whitespaces)
    ^+v:: ; ctrl + shift + v
        originalClipboard := ClipBoardAll
        clipboard := clipboard               ; Convert to text
        clipboard := RegexReplace(clipboard, "^\s+|\s+$")
        Sleep 10
        Send, ^v                             ; For best compatibility: SendPlay
        Sleep 50                             ; Don't change clipboard while it is pasted! (Sleep > 0)
        clipboard := originalClipboard       ; Restore original ClipBoard
        VarSetCapacity(originalClipboard, 0) ; Free memory
    return
#IfWinNotActive

^!+n::                                                                            ; ctrl + alt + shift + n
    Send, !{f17} ; disable copyq
    Sleep 100
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

<#SC01B::
    clipboard := ""
    Send, ^c
    ClipWait, 0.25
    Send, #+ü ; execute copyq action
return

; Excess indent removal
>#+v::                                                                            ; rwin + shift + v
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

#IfWinActive ahk_exe Be.HexEditor.exe
    ^+v::SendInput "%clipboard%"
#IfWinActive

AppsKey::RWin
>#Tab::Send, {AppsKey}
>#+Tab::Send, +{AppsKey}

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
    Sleep 100
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
    Sleep 100
    clipboard := ""
    Send, ^c
    ClipWait, 0.25
    clipboard := clipboard

    if not StrLen(clipboard) {
        Send ^+{Left}
        Send, ^c
        ClipWait
    }

    clipboard := left . RegexReplace(clipboard, "[\r\n]+$", "") . right
    Send, ^v
    Sleep 250
    Send, !{f16} ; Enable copyq and activate first item
}

>#v::Send !{f20}
>#g::Send ^{f14}
>#b::Send ^{f15}
>#n::Send ^{f16}

!8::SendInput [
!9::SendInput ]
!*::SendInput {\}

; SC01A: ğ
; SC01B: ü
; SC027: ş
; SC028: i
; SC02B: ,
; SC033: ö
; SC034: ç
; SC035: .

<!SC01A::SendInput [     ; LAlt + ğ
<!SC01B::SendInput ]     ; LAlt + ü
<!<+SC01A::SendInput {{} ; LAlt + LShift + ğ
<!<+SC01B::SendInput {}} ; LAlt + LShift + ü
<!SC027::SendInput (     ; LAlt + ş
<!SC028::SendInput )     ; LAlt + i
<!SC02B::SendInput {=}   ; LAlt + ,
<!SC033::SendInput [     ; LAlt + ö
<!SC034::SendInput ]     ; LAlt + ç
<!SC035::SendInput {/}   ; LAlt + .
<!<+SC035::SendInput {\} ; LAlt + LShift + .

; Credits for the debouncer code: https://www.autohotkey.com/boards/viewtopic.php?p=117262#p117262

#UseHook
#If !GetKeyState("NumLock", "T") or (!GetKeyState("LControl") and !GetKeyState("LShift") and !GetKeyState("LAlt"))
    NumpadUp::
        Send % ((A_PriorHotkey=A_ThisHotkey)&&(A_TimeSincePriorHotkey<17))?"":"{Blind}{WheelUp}"
    Return

    NumpadClear::
        Send % ((A_PriorHotkey=A_ThisHotkey)&&(A_TimeSincePriorHotkey<17))?"":"{Blind}{WheelDown}"
    Return
#If
#UseHook Off

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
        Loop 4
            PostMessage, 0x114, 0, 0, %fcontrol%, A  ; 0x114=WM_HSCROLL; 0=SB_LINELEFT
    return

    NumpadRight::
        ControlGetFocus, fcontrol, A
        Loop 4
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

    ^+r::Send, {f2}
#IfWinActive

#IfWinActive ahk_group FileExplorerLike
    +Enter::
        clipboard := ""
        Send, ^c
        ClipWait
        clipboard := StrReplace(clipboard, "`\", "`/")
    Return

    ^e::
        Send, {AppsKey}
        Sleep, 50
        Send n
    Return
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
    >#w::Send, {F6}
    >#+w::Send, {Blind}{F6}

    ^!+s::                                                                        ; ctrl + alt + shift + s
        MouseGetPos, xpos, ypos
        if (IsExternalMon = 1) {
            Click, 370, 121
        }
        else {
            Click, 450, 150
        }
        MouseMove, %xpos%, %ypos%
    return

    ^!+d::                                                                        ; ctrl + alt + shift + d
        MouseGetPos, xpos, ypos
        if (IsExternalMon = 1) {
            Click, 370, 202
        }
        else {
            Click, 450, 255
        }
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

    #+r::
        Send, !{f17} ; disable copyq
        Sleep 100
        clipboard := ""
        Send, ^c
        ClipWait
        clipboard := RegexReplace(clipboard, """(varchar|nvarchar|char|int|tinyint|bit|date|datetimeoffset|datetime|time|decimal|varbinary|binary)""", "$1")
        Send, ^v
        Sleep 250
        Send, !{f16} ; Enable copyq and activate first item
    Return
#IfWinActive

#IfWinActive ahk_exe 7zFM.exe                                                     ; if it is 7-Zip
    Esc::
    NumpadEnd::
        Send, !{f4}
    Return

    !Up::Send, {Backspace}                                                        ; alt + up                     | Send backspace
    ^Enter::Send {f3}
#IfWinActive

#IfWinActive ahk_exe notepad++.exe
    ^q::
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
        Sleep 100
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

    :*:;;bkz::
        SendInput (bkz.{Space})
        Send {Left}
    Return
#IfWinActive

#IfWinActive ahk_group Group_WinMerge
    ~n::
        SetTitleMatchMode, 3

        if WinActive("Save modified files?") {
            Send !{r}
        }
    return

    ^+s::Send ^u

    ^PgUp::
        Send {Blind}{Ctrl Up}
        MoveCaretToPageTopBottom(1)
        Send {Blind}{Ctrl Down}
    return

    ^PgDn::
        Send {Blind}{Ctrl Up}
        MoveCaretToPageTopBottom(0)
        Send {Blind}{Ctrl Down}
    return
#IfWinActive

#IfWinActive ahk_exe EXCEL.EXE
    F1::=
    ^r::Send, {F2}
#IfWinActive

#IfWinActive ahk_exe thunderbird.exe
    ^+c::
        Send ^t
        Sleep 150
        Send ^u
        Sleep 150
        Send ^b
        Sleep 150
    Return
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
#If

#IfWinActive ahk_group Group_IntelliJLike
    #w::Send, ^!{BackSpace}

    ~^NumpadAdd::
        SetTitleMatchMode, RegEx

        if WinActive(".+\.jpe?g|png$") {
            Send, ^*
        }
    return

    ~^NumpadSub::
        SetTitleMatchMode, RegEx

        if WinActive(".+\.jpe?g|png$") {
            Send, ^-
        }
    return
#IfWinActive

#IfWinActive ahk_exe DB Browser for SQLite.exe
    ^o::Send, ^+t
    ^n::Send, ^t
    ^+b::Send, {F5}
    ^Pgdn::Send, ^{Tab}
    ^Pgup::Send, ^+{Tab}
#IfWinActive

#IfWinActive ahk_exe Code.exe
    !Pgdn::Send, ^!+{Pgdn}
    !Pgup::Send, ^!+{Pgup}
    <^>!+g::Send, ^!+g

    ~^+d::
        ; There's no option to make the new editor open maximized, so make sure the
        ; window created on "workbench.action.copyEditorToNewWindow" gets maximized.
        ; Idiots...
        Sleep 150
        WinMaximize, A
    Return
#IfWinActive

<#+F7::
<#F7::
    isVertical := GetKeyState("Shift")
    MouseGetPos, curX, curY
    targetX := isVertical ? curX : (curX - 42)
    targetY := isVertical ? (curY - 42) : curY
    SetMouseDelay, 3
    SetDefaultMouseSpeed, 3
    SendEvent {Click %curX% %curY% Down}{Click %targetX% %targetY% Up}
Return

<#+F8::
<#F8::
    isVertical := GetKeyState("Shift")
    MouseGetPos, curX, curY
    targetX := isVertical ? curX : (curX + 42)
    targetY := isVertical ? (curY + 42) : curY
    SetMouseDelay, 3
    SetDefaultMouseSpeed, 3
    SendEvent {Click %curX% %curY% Down}{Click %targetX% %targetY% Up}
Return

#IfWinActive ahk_exe WindowsTerminal.exe
    ^!Pgup::
        Send, ^+q
        Sleep 50
        SendInput move{Space}tab{Space}ward
        Sleep 300
        Send {Enter}
    Return
    ^!Pgdn::
        Send, ^+q
        Sleep 50
        SendInput move{Space}tab{Space}ward
        Sleep 300
        Send {Down}
        Sleep 100
        Send {Enter}
    Return
#IfWinActive

#IfWinNotActive ahk_group AltPgxExcludedApps
    !PgUp::MoveCaretToPageTopBottom(1)
    !PgDn::MoveCaretToPageTopBottom(0)
#IfWinNotActive

; Cascade file explorer windows
<#<+Enter::
    WinGet windowList, List, ahk_class CabinetWClass
    distance := 26
    x        := 34 - distance
    y        := 34 - distance
    loop %windowList% {
        x := x + distance
        y := y + distance
        winAhkId := windowList%A_Index%
        WinMove, ahk_id %winAhkId%,, %x%, %y%
    }
Return

;==============================================================================
; Various SendInput commands
;==============================================================================

:*:;;today::                                                   ; Replace ";;today" with current date
    FormatTime, CurrentDateTime,, yyy-MM-dd                    ; 2009-10-13
    SendInput %CurrentDateTime%
return

:*:::today::                                                   ; Replace "::today" with [current date]
    FormatTime, CurrentDateTime,, yyy-MM-dd                    ; [2009-10-13]
    SendInput [%CurrentDateTime%]{Space}
return

:*:;;now::                                                     ; Replace ";;now" with current date and time
    FormatTime, CurrentDateTime,, yyy-MM-dd HH.mm              ; 2009-10-13 10.57
    SendInput %CurrentDateTime%
return

:*:::now::                                                     ; Replace "::now" with [current date and time]
    FormatTime, CurrentDateTime,, yyy-MM-dd HH.mm              ; [2009-10-13 10.57]
    SendInput [%CurrentDateTime%]{Space}
return

:*:;;snow::                                                    ; Replace ";;snow" with current date and time (with seconds)
    FormatTime, CurrentDateTime,, yyy-MM-dd HH:mm:ss           ; 2009-10-13 10:57:23
    SendInput %CurrentDateTime%
return

:*:::snow::                                                    ; Replace "::snow" with [current date and time (with seconds)]
    FormatTime, CurrentDateTime,, yyy-MM-dd HH:mm:ss           ; [2009-10-13 10:57:23]
    SendInput [%CurrentDateTime%]{Space}
return

:*:;;vnow::                                                    ; Replace ";;vnow" with current date and time without separators
    FormatTime, CurrentDateTime,, yyyMMddHHmm                  ; 200910131057
    SendInput %CurrentDateTime%
return

:*:::vnow::                                                    ; Replace "::vnow" with [current date and time without separators]
    FormatTime, CurrentDateTime,, yyyMMddHHmm                  ; [200910131057]
    SendInput [%CurrentDateTime%]{Space}
return

:*:;;time::                                                    ; Replace ";;time" with current date, time and day of week
    FormatTime, CurrentDateTime, L1055, d MMMM yyy dddd, HH.mm ; 13 August 2013 Tuesday, 13.17
    SendInput %CurrentDateTime%
return

:*:::time::                                                    ; Replace "::time" with [current date, time and day of week]
    FormatTime, CurrentDateTime, L1055, d MMMM yyy dddd, HH.mm ; [13 August 2013 Tuesday, 13.17]
    SendInput [%CurrentDateTime%]{Space}
return

:*:;;date::                                                    ; Replace ";;date" with current date and day of week
    FormatTime, CurrentDateTime, L1055, d MMMM yyy dddd        ; 26 April 2010 Monday
    SendInput %CurrentDateTime%
return

:*:::date::                                                    ; Replace "::date" with [current date and day of week]
    FormatTime, CurrentDateTime, L1055, d MMMM yyy dddd        ; [26 April 2010 Monday]
    SendInput [%CurrentDateTime%]{Space}
return

:*:;;tm::                                                      ; Replace ";;tm" with current time surrounded by brackets
    FormatTime, CurrentDateTime, L1055, HH.mm                  ; [13.17]
    SendInput [%CurrentDateTime%]{Space}
return

:*:;;dfc::{Raw}[DefaultValueFactory(UseDefaultPropertyValue = true)]`n[ValidateReferenceType]
:*:;;dfl::{Raw}[DefaultValueFactory(UseDefaultPropertyValue = true)]`n[ValidateReferenceTypeCollection]`n[LoyalReferenceTypeCollectionRange(Min = 1, ErrorMessage = "En az bir satır eklemeniz gereklidir.")]

:*:;;pipe::{Raw}==============================================================================
:*:;;dash::{Raw}------------------------------------------------------------------------------
:*:;;mail::{Raw}zerhan@gmail.com
^!+x::SendInput [ ]{Space}                                           ; ctrl + alt + shift + x     | print [ ]
<#Space::SendInput {Space}{Space}{Space}{Space}                      ; lwin + space               | Send 4 spaces
<#>+Space::SendInput {Backspace}{Backspace}{Backspace}{Backspace}    ; win + rshift + space       | Remove 4 spaces

#IfWinNotActive ahk_group Group_CtrlAltShiftGExcludedApps
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

MoveCaretToPageTopBottom(isTop) {
    ControlGetFocus, FocusedControl, A

    if ErrorLevel {
        return
    }

    ControlGetPos, controlTopLeft_X, controlTopLeft_Y
        , control_width, control_height
        , %FocusedControl%, A

    if (controlTopLeft_X = "") {
        return
    }

    ; MsgBox controlTopLeft_X: %controlTopLeft_X%, controlTopLeft_Y: %controlTopLeft_Y%, control_width: %control_width%, control_height: %control_height%

    targetX := controlTopLeft_X + control_width / 2
    targetY := isTop ? (controlTopLeft_Y + 20) : (controlTopLeft_Y + control_height - 40)

    MouseGetPos, currentX, currentY
    MouseMove, %targetX%, %targetY%
    Click
    MouseMove, %currentX%, %currentY%
}
