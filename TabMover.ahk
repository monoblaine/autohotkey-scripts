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

MovementMethod := { mouseClickDrag: 1, sendEvent: 2, foobar2000: 3, thunderbird: 4 }

hModule := DllCall("LoadLibrary", Str, "ActiveTabSpy.dll", Ptr)
procHandle_MsEdge := DllCall("GetProcAddress", Ptr, hModule, AStr, "inspectActiveTabOnMsEdge", Ptr)
procHandle_Firefox := DllCall("GetProcAddress", Ptr, hModule, AStr, "inspectActiveTabOnFirefox", Ptr)
procHandle_Vs2019 := DllCall("GetProcAddress", Ptr, hModule, AStr, "inspectActiveTabOnVs2019", Ptr)
procHandle_Vs2022 := DllCall("GetProcAddress", Ptr, hModule, AStr, "inspectActiveTabOnVs2022", Ptr)
procHandle_Ssms18 := DllCall("GetProcAddress", Ptr, hModule, AStr, "inspectActiveTabOnSsms18", Ptr)
procHandle_Foobar2000 := DllCall("GetProcAddress", Ptr, hModule, AStr, "inspectActiveTabOnFoobar2000", Ptr)
procHandle_Cleanup := DllCall("GetProcAddress", Ptr, hModule, AStr, "cleanup", Ptr)

CoordMode, Mouse, Screen

OnExit, Exit
return

Exit:
   DllCall(procHandle_Cleanup)
   DllCall("CloseHandle", Ptr, procHandle_MsEdge)
   DllCall("CloseHandle", Ptr, procHandle_Firefox)
   DllCall("CloseHandle", Ptr, procHandle_Vs2019)
   DllCall("CloseHandle", Ptr, procHandle_Vs2022)
   DllCall("CloseHandle", Ptr, procHandle_Ssms18)
   DllCall("CloseHandle", Ptr, procHandle_Foobar2000)
   DllCall("CloseHandle", Ptr, procHandle_Cleanup)
   DllCall("FreeLibrary", Ptr, hModule)
   ExitApp

#IfWinActive ahk_exe msedge.exe
    ^!PgUp::MoveTab(1, -1, procHandle_MsEdge, MovementMethod.mouseClickDrag)
    ^!PgDn::MoveTab(1, 1, procHandle_MsEdge, MovementMethod.mouseClickDrag)
#IfWinActive

#IfWinActive ahk_exe thunderbird.exe
    ^!PgUp::MoveTab(1, -1, procHandle_Firefox, MovementMethod.thunderbird)
    ^!PgDn::MoveTab(1, 1, procHandle_Firefox, MovementMethod.thunderbird)
#IfWinActive

#IfWinActive ahk_class MozillaWindowClass
    ^!PgUp::MoveTab(1, -1, procHandle_Firefox, MovementMethod.sendEvent)
    ^!PgDn::MoveTab(1, 1, procHandle_Firefox, MovementMethod.sendEvent)
#IfWinActive

#IfWinActive ahk_exe devenv.exe
    ^!PgUp::MoveVisualStudioTab(-1)
    ^!PgDn::MoveVisualStudioTab(1)
#IfWinActive

#IfWinActive ahk_exe Ssms.exe
    ^!PgUp::MoveTab(1, -1, procHandle_Ssms18, MovementMethod.mouseClickDrag)
    ^!PgDn::MoveTab(1, 1, procHandle_Ssms18, MovementMethod.mouseClickDrag)
#IfWinActive

#IfWinActive ahk_exe foobar2000.exe
    ^!PgUp::MoveTab(1, -1, procHandle_Foobar2000, MovementMethod.foobar2000)
    ^!PgDn::MoveTab(1, 1, procHandle_Foobar2000, MovementMethod.foobar2000)
#IfWinActive

MoveVisualStudioTab(directionMultiplier) {
    global procHandle_Vs2019
    global procHandle_Vs2022
    global MovementMethod

    hWnd := WinExist("A")
    WinGet, pathToVsExe, ProcessPath
    procHandle := InStr(pathToVsExe, "2022") ? procHandle_Vs2022 : procHandle_Vs2019
    MoveTab(1, directionMultiplier, procHandle, MovementMethod.mouseClickDrag, hWnd)
}

MoveTab(horizontal, directionMultiplier, procHandle, movementMethodId, maybeHWnd := 0) {
    global MovementMethod

    MouseGetPos, curX, curY
    hWnd := maybeHWnd ? maybeHWnd : WinExist("A")
    ptr_pointX := 0
    ptr_pointY := 0
    ptr_left := 0
    ptr_right := 0
    ptr_top := 0
    ptr_bottom := 0

    DllCall(procHandle, Int, hWnd, Int, horizontal, Ptr, &ptr_pointX, Ptr, &ptr_pointY, Ptr, &ptr_left, Ptr, &ptr_right, Ptr, &ptr_top, Ptr, &ptr_bottom)

    if (A_LastError) {
        MsgBox, Error: %A_LastError%
    }

    pointX := NumGet(&ptr_pointX)
    pointY := NumGet(&ptr_pointY)
    left := NumGet(&ptr_left)
    right := NumGet(&ptr_right)
    top := NumGet(&ptr_top)
    bottom := NumGet(&ptr_bottom)

    ptr_pointX := ""
    ptr_pointY := ""
    ptr_left := ""
    ptr_right := ""
    ptr_top := ""
    ptr_bottom := ""

    ; MsgBox, pointX: %pointX%, pointY: %pointY%, left: %left%, right: %right%, top: %top%, bottom: %bottom%
    targetX := horizontal ? (directionMultiplier < 0 ? (left - 1) : (right + 1)) : pointX
    targetY := horizontal ? pointY : (directionMultiplier < 0 ? (top - 1) : (bottom + 1))

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

            if (directionMultiplier < 0)
                Send m
            else
                Send o

        case MovementMethod.thunderbird:
            SetMouseDelay, 3
            SetDefaultMouseSpeed, 3
            width := right - left
            targetX := horizontal ? (directionMultiplier < 0 ? (left - 1 - width) : (right + 1 + width)) : pointX
            SendEvent {Click %pointX% %pointY% Down}{Click %targetX% %targetY% Up}
    }

    MouseMove, %curX%, %curY%
}
