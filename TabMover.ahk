;OPTIMIZATIONS START
#NoTrayIcon
#NoEnv
#KeyHistory 0
ListLines Off
SetBatchLines, -1
SetKeyDelay, -1, -1
SetWinDelay, -1
SetControlDelay, -1
SendMode Input
Process, Priority,, R
;OPTIMIZATIONS END

PauseKeyState := 0 ; As if it's a toggle key

MovementMethod := { mouseClickDrag: 1, sendEvent: 2, foobar2000: 3 }

hModule := DllCall("LoadLibrary", Str, "ActiveTabSpy.dll", Ptr)
procHandle_MsEdge2 := DllCall("GetProcAddress", Ptr, hModule, AStr, "MsEdge_getThreeDotBtnStatus", Ptr)
procHandle_Firefox := DllCall("GetProcAddress", Ptr, hModule, AStr, "Firefox_inspectActiveTab", Ptr)
procHandle_Vs2019 := DllCall("GetProcAddress", Ptr, hModule, AStr, "Vs2019_inspectActiveTab", Ptr)
procHandle_Vs2022_1 := DllCall("GetProcAddress", Ptr, hModule, AStr, "Vs2022_inspectActiveTab", Ptr)
procHandle_Vs2022_2 := DllCall("GetProcAddress", Ptr, hModule, AStr, "Vs2022_isTextEditorFocused", Ptr)
procHandle_Vs2022_3 := DllCall("GetProcAddress", Ptr, hModule, AStr, "Vs2022_selectedIntelliSenseItemIsAMethod", Ptr)
procHandle_Ssms18_1 := DllCall("GetProcAddress", Ptr, hModule, AStr, "Ssms18_inspectActiveTab", Ptr)
procHandle_Ssms18_2 := DllCall("GetProcAddress", Ptr, hModule, AStr, "Ssms18_getResultsGridActiveColumnCoords", Ptr)
procHandle_Ssms18_3 := DllCall("GetProcAddress", Ptr, hModule, AStr, "Ssms18_getActiveArea", Ptr)
procHandle_Ssms18_4 := DllCall("GetProcAddress", Ptr, hModule, AStr, "Ssms18_getCellContent", Ptr)
procHandle_Ssms18_5 := DllCall("GetProcAddress", Ptr, hModule, AStr, "Ssms18_getObjectExplorerNodeType", Ptr)
procHandle_Foobar2000 := DllCall("GetProcAddress", Ptr, hModule, AStr, "Foobar2000_inspectActiveTab", Ptr)
procHandle_CopyQ := DllCall("GetProcAddress", Ptr, hModule, AStr, "CopyQ_inspectActiveTab", Ptr)
procHandle_Cleanup := DllCall("GetProcAddress", Ptr, hModule, AStr, "cleanup", Ptr)

CoordMode, Mouse, Screen

OnExit, Exit
return

Exit:
   DllCall(procHandle_Cleanup)
   DllCall("CloseHandle", Ptr, procHandle_MsEdge2)
   DllCall("CloseHandle", Ptr, procHandle_Firefox)
   DllCall("CloseHandle", Ptr, procHandle_Vs2019)
   DllCall("CloseHandle", Ptr, procHandle_Vs2022_1)
   DllCall("CloseHandle", Ptr, procHandle_Vs2022_2)
   DllCall("CloseHandle", Ptr, procHandle_Vs2022_3)
   DllCall("CloseHandle", Ptr, procHandle_Ssms18_1)
   DllCall("CloseHandle", Ptr, procHandle_Ssms18_2)
   DllCall("CloseHandle", Ptr, procHandle_Ssms18_3)
   DllCall("CloseHandle", Ptr, procHandle_Ssms18_4)
   DllCall("CloseHandle", Ptr, procHandle_Ssms18_5)
   DllCall("CloseHandle", Ptr, procHandle_Foobar2000)
   DllCall("CloseHandle", Ptr, procHandle_CopyQ)
   DllCall("CloseHandle", Ptr, procHandle_Cleanup)
   DllCall("FreeLibrary", Ptr, hModule)
   ExitApp

*Pause::
    PauseKeyState := !PauseKeyState
    Sleep, 10	; drastically improves reliability on slower systems (took a loooong time to figure this out)
    msg := "Pause: " (PauseKeyState ? "ON" : "OFF")
    ToolTip, %msg%
    Sleep, 400	; SPECIFY DISPLAY TIME (ms)
    ToolTip		; remove
Return

#IfWinActive ahk_exe msedge.exe
    ^!PgUp::Send, ^+{PgUp}
    ^!PgDn::Send, ^+{PgDn}

    ~LAlt::
        if GetKeyState("Ctrl") {
            return
        }

        if DllCall(procHandle_MsEdge2, Int, WinExist("A")) {
            Send, {f6}
        }
    return
#IfWinActive

#IfWinActive ahk_exe thunderbird.exe
    ^!PgUp::MoveTab(1, -1, procHandle_Firefox, MovementMethod.sendEvent, 0, 1)
    ^!PgDn::MoveTab(1, 1, procHandle_Firefox, MovementMethod.sendEvent, 0, 1)
#IfWinActive

#IfWinActive ahk_class MozillaWindowClass
    ^!PgUp::MoveTab(1, -1, procHandle_Firefox, MovementMethod.sendEvent)
    ^!PgDn::MoveTab(1, 1, procHandle_Firefox, MovementMethod.sendEvent)
#IfWinActive

#If WinActive("ahk_exe devenv.exe") and !PauseKeyState
    $Tab::
        if (DllCall(procHandle_Vs2022_3, Int, WinExist("A"), Int, 0)) {
            Send ()
        }
        else {
            Send {Tab}
        }
    Return
    $+Enter::
        if (DllCall(procHandle_Vs2022_3, Int, WinExist("A"), Int, 1)) {
            Send (){Left}
        }
        else {
            Send +{Enter}
        }
    Return
    $^Enter::
        Switch DllCall(procHandle_Vs2022_3, Int, WinExist("A"), Int, 1) {
            Case 1:
                Send (){;}

            Case 2:
                Send {;}

            Default:
                Send ^{Enter}
        }
    Return
    $!Enter::
        if (DllCall(procHandle_Vs2022_3, Int, WinExist("A"), Int, 1)) {
            Send {{}{Left}{Space}
        }
        else {
            Send !{Enter}
        }
    Return
    $SC056::
        if (DllCall(procHandle_Vs2022_3, Int, WinExist("A"), Int, 1)) {
            Send <>{Left}
        }
        else {
            Send <
        }
    Return
#If

#IfWinActive ahk_exe devenv.exe
    ^!PgUp::MoveVisualStudioTab(-1)
    ^!PgDn::MoveVisualStudioTab(1)
#IfWinActive

#IfWinActive ahk_exe Ssms.exe
    ^!PgUp::MoveTab(1, -1, procHandle_Ssms18_1, MovementMethod.mouseClickDrag)
    ^!PgDn::MoveTab(1, 1, procHandle_Ssms18_1, MovementMethod.mouseClickDrag)

    ^NumpadAdd::
        ptr_left := 0
        ptr_right := 0
        ptr_top := 0
        ptr_bottom := 0
        success := DllCall(procHandle_Ssms18_2, Int, WinExist("A")
                         , Ptr, &ptr_left, Ptr, &ptr_right
                         , Ptr, &ptr_top, Ptr, &ptr_bottom)

        if (A_LastError) {
            MsgBox, Error: %A_LastError%
        }

        if (success) {
            left := NumGet(&ptr_left)
            right := NumGet(&ptr_right)
            top := NumGet(&ptr_top)
            bottom := NumGet(&ptr_bottom)

            curX := 0
            curY := 0
            targetY := top + (bottom - top) // 2

            MouseGetPos, curX, curY
            SetMouseDelay, -1
            SetDefaultMouseSpeed, 0
            MouseMove, %right%, %targetY%
            Send, {Click 2}
            MouseMove, %curX%, %curY%
        }

        ptr_left := ""
        ptr_right := ""
        ptr_top := ""
        ptr_bottom := ""
    return

    ~Esc::
        if (DllCall(procHandle_Ssms18_3, Int, WinExist("A")) = 2) {
            Send, +{f6}
        }
    Return

    SsmsOpenCellContentInNewTab := 0

    ~^t::
        SsmsOpenCellContentInNewTab := 1
    ~^c::
        ptr_result := 0
        cellContent := DllCall(procHandle_Ssms18_4, Ptr, &ptr_result, "WStr")
        result := NumGet(&ptr_result)
        ptr_result := ""

        if (result) {
            Send !{f17} ; disable copyq
            Sleep 100
            Clipboard := Trim(cellContent, " `t`r`n") . "`r`ngo`r`n"
            cellContent := ""

            if (SsmsOpenCellContentInNewTab) {
                Send ^n
                Sleep 50
                Send ^v
                Sleep 50
                Send {Ctrl Down}{e Down}{r Down}{e Up}{r Up}{Ctrl Up}
                Sleep 50
                Send ^{Home}
            }

            Sleep 250
            Send !{f16} ; Enable copyq and activate first item
            Sleep 50
        }

        SsmsOpenCellContentInNewTab := 0
    Return

    ~^x::
        result := DllCall(procHandle_Ssms18_5)

        if (result) {
            Send {Ctrl Up}{x Up}
        }

        Switch result {
            Case 1: ; Tables
                Send {AppsKey}
                Sleep 50
                Send s
                Sleep 50
                Send {Enter 3}
                Sleep 50

            Case 2, Case 4, Case 8: ; Views, Table-valued Functions, Triggers
                Send {AppsKey}
                Sleep 50
                Send s
                Sleep 50
                Send a
                Sleep 50
                Send {Enter}
                Sleep 50

            Case 3, Case 5: ; Stored Procedures, Scalar-valued Functions
                Send {AppsKey}
                Sleep 50
                Send {s 2}
                Sleep 50
                Send {Enter}
                Sleep 50
                Send a
                Sleep 50
                Send {Enter}
                Sleep 50

            Case 6, Case 7, Case 9: ; Keys, Constraints, Indexes
                Send {AppsKey}
                Sleep 50
                Send s
                Sleep 50
                Send r
                Sleep 50
                Send {Enter}
                Sleep 50

            Default:
                Return
        }

        SetTitleMatchMode, 1 ; A window's title must start with the specified WinTitle to be a match.
        WinWait,, Creating script for, 3

        if ErrorLevel {
            Send {Esc}
            Return
        }

        WinWaitClose
        Sleep 50

        Switch result {
            Case 1, Case 6, Case 7, Case 9: ; Tables, Keys, Constraints, Indexes
                Send ^+f
                Sleep 50
        }

        Send {Ctrl Down}{e Down}{r Down}{e Up}{r Up}{Ctrl Up}
        Sleep 50
        Send ^{Home}
        Sleep 50
        Switch result {
            Case 6, Case 7, Case 9: ; Keys, Constraints, Indexes
                Send ^a
                Send !{f17} ; disable copyq
                Clipboard := ""
                Send, ^c
                ClipWait
                Clipboard := StrReplace(Clipboard, " drop constraint", "`r`ndrop constraint")
                Clipboard := StrReplace(Clipboard, " foreign key(", "`r`nforeign key (")
                Clipboard := StrReplace(Clipboard, " on delete cascade", "`r`non delete cascade")
                Clipboard := StrReplace(Clipboard, " on update cascade", "`r`non update cascade")
                Clipboard := RegexReplace(Clipboard, " references ([^(]+)", "`r`nreferences $1 ")
                Send, ^v
                Sleep 250
                Send, !{f16} ; Enable copyq and activate first item
        }
    Return

    $^PgDn::
        if (DllCall(procHandle_Ssms18_3, Int, WinExist("A")) = 2) {
            Send ^+{F11}
        }
        else {
            Send ^{PgDn}
        }
    Return

    $^PgUp::
        if (DllCall(procHandle_Ssms18_3, Int, WinExist("A")) = 2) {
            Send ^+{F10}
        }
        else {
            Send ^{PgUp}
        }
    Return
#IfWinActive

#IfWinActive ahk_exe foobar2000.exe
    ^!PgUp::MoveTab(1, -1, procHandle_Foobar2000, MovementMethod.foobar2000)
    ^!PgDn::MoveTab(1, 1, procHandle_Foobar2000, MovementMethod.foobar2000)
#IfWinActive

#IfWinActive ahk_exe copyq.exe
    ^!PgUp::MoveTab(1, -1, procHandle_CopyQ, MovementMethod.mouseClickDrag, 0, 0.3)
    ^!PgDn::MoveTab(1, 1, procHandle_CopyQ, MovementMethod.mouseClickDrag, 0, 0.3)
#IfWinActive

MoveVisualStudioTab(direction) {
    global procHandle_Vs2019
    global procHandle_Vs2022_1
    global MovementMethod

    hWnd := WinExist("A")
    WinGet, pathToVsExe, ProcessPath
    procHandle := InStr(pathToVsExe, "2022") ? procHandle_Vs2022_1 : procHandle_Vs2019
    MoveTab(0, direction, procHandle, MovementMethod.mouseClickDrag, hWnd)
}

MoveTab(horizontal, direction, procHandle, movementMethodId, maybeHWnd := 0, widthHeightFactor := 0) {
    global MovementMethod

    curX := 0
    curY := 0
    pointX := 0
    pointY := 0
    left := 0
    right := 0
    top := 0
    bottom := 0
    width := 0
    height := 0
    prevPointX := 0
    prevPointY := 0
    nextPointX := 0
    nextPointY := 0

    CollectTabInfo(horizontal, procHandle, maybeHWnd
                 , curX, curY
                 , pointX, pointY
                 , left, right
                 , top, bottom
                 , width, height
                 , prevPointX, prevPointY
                 , nextPointX, nextPointY)

    ; MsgBox, curX: %curX%, curY: %curY%, pointX: %pointX%, pointY: %pointY%, left: %left%, right: %right%, top: %top%, bottom: %bottom%, width: %width%, height: %height%, prevPointX: %prevPointX%, prevPointY: %prevPointY%

    targetX := horizontal
        ? direction < 0
            ? (left - 1 - width * widthHeightFactor)
            : (right + 1 + width * widthHeightFactor)
        : pointX
    targetY := horizontal
        ? pointY
        : direction < 0
            ? (top - 1 - height * widthHeightFactor)
            : (bottom + 1 + height * widthHeightFactor)

    switch movementMethodId {
        case MovementMethod.mouseClickDrag:
            SetMouseDelay, 1
            SetDefaultMouseSpeed, 1
            MouseClickDrag, Left, %pointX%, %pointY%, %targetX%, %targetY%

        case MovementMethod.sendEvent:
            SetMouseDelay, 3
            SetDefaultMouseSpeed, 3
            SendEvent {Click %pointX% %pointY% Down}{Click %targetX% %targetY% Up}

        case MovementMethod.foobar2000:
            SetMouseDelay, -1
            SetDefaultMouseSpeed, 0
            MouseMove, %pointX%, %pointY%
            Click
            KeyWait, Alt
            Send {AppsKey}

            if (direction < 0)
                Send m
            else
                Send o
    }

    MouseMove, %curX%, %curY%
}

ClickOnSiblingTab(horizontal, direction, procHandle, maybeHWnd := 0) {
    curX := 0
    curY := 0
    pointX := 0
    pointY := 0
    left := 0
    right := 0
    top := 0
    bottom := 0
    width := 0
    height := 0
    prevPointX := 0
    prevPointY := 0
    nextPointX := 0
    nextPointY := 0

    CollectTabInfo(horizontal, procHandle, maybeHWnd
                 , curX, curY
                 , pointX, pointY
                 , left, right
                 , top, bottom
                 , width, height
                 , prevPointX, prevPointY
                 , nextPointX, nextPointY)

    targetX := direction < 0 ? prevPointX : nextPointX
    targetY := direction < 0 ? prevPointY : nextPointY

    SetMouseDelay, 1
    SetDefaultMouseSpeed, 1
    MouseMove, %targetX%, %targetY%
    Click
    MouseMove, %curX%, %curY%
}

CollectTabInfo(horizontal, procHandle, maybeHWnd
             , ByRef curX, ByRef curY
             , ByRef pointX, ByRef pointY
             , ByRef left, ByRef right
             , ByRef top, ByRef bottom
             , ByRef width, ByRef height
             , ByRef prevPointX, ByRef prevPointY
             , ByRef nextPointX, ByRef nextPointY) {
    MouseGetPos, curX, curY
    hWnd := maybeHWnd ? maybeHWnd : WinExist("A")
    ptr_pointX := 0
    ptr_pointY := 0
    ptr_prevPointX := 0
    ptr_prevPointY := 0
    ptr_nextPointX := 0
    ptr_nextPointY := 0
    ptr_left := 0
    ptr_right := 0
    ptr_top := 0
    ptr_bottom := 0

    DllCall(procHandle, Int, hWnd, Int, horizontal
          , Ptr, &ptr_pointX, Ptr, &ptr_pointY
          , Ptr, &ptr_left, Ptr, &ptr_right
          , Ptr, &ptr_top, Ptr, &ptr_bottom
          , Ptr, &ptr_prevPointX, Ptr, &ptr_prevPointY
          , Ptr, &ptr_nextPointX, Ptr, &ptr_nextPointY)

    if (A_LastError) {
        MsgBox, Error: %A_LastError%
    }

    pointX := NumGet(&ptr_pointX)
    pointY := NumGet(&ptr_pointY)
    left := NumGet(&ptr_left)
    right := NumGet(&ptr_right)
    top := NumGet(&ptr_top)
    bottom := NumGet(&ptr_bottom)
    width := right - left
    height := bottom - top
    prevPointX := NumGet(&ptr_prevPointX)
    prevPointY := NumGet(&ptr_prevPointY)
    nextPointX := NumGet(&ptr_nextPointX)
    nextPointY := NumGet(&ptr_nextPointY)

    ptr_pointX := ""
    ptr_pointY := ""
    ptr_left := ""
    ptr_right := ""
    ptr_top := ""
    ptr_bottom := ""
    ptr_prevPointX := ""
    ptr_prevPointY := ""
    ptr_nextPointX := ""
    ptr_nextPointY := ""
}
