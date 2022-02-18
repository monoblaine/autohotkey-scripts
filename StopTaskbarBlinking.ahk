#SingleInstance force
#WinActivateForce           ; this may prevent task bar buttons from flashing when different windows are activated quickly one after the other


DetectHiddenWindows, On
Script_Hwnd := WinExist("ahk_class AutoHotkey ahk_pid " DllCall("GetCurrentProcessId"))
DetectHiddenWindows, Off
; Register shell hook to detect flashing windows.
DllCall("RegisterShellHookWindow", "uint", Script_Hwnd)
OnMessage(DllCall("RegisterWindowMessage", "str", "SHELLHOOK"), "ShellEvent")


ShellEvent(wParam, lParam) {
    if (wParam = 0x8006) ; HSHELL_FLASH
    {   ; lParam contains the ID of the window which flashed

        FlashWindowEx(lParam, FLASHW_STOP:=0, 0, 65535)

        ; Depending on which application you're trying
        ; to tame, the above may not work, because
        ; some applications call FlashWindow() repeatedly
        ; instead of calling FlashWindowEx() once.
        ; So, we may have to resort to:

        WinGet, hwndWasFocused, ID, A       ; remember which window originally had the focus
        BlockInput, On                      ; we can't stop keystrokes from being lost, but we can stop them from going to the wrong application
        WinActivate, ahk_id %lParam%
        WinActivate, ahk_id %hwndWasFocused%
        BlockInput, Off
    }
}



; thanks to SKAN    http://www.autohotkey.com/forum/post-280244.html#280244
;
; dwFlags can be a bitwise combination of:
;   FLASHW_ALL := 3        ; Flash both the window caption and taskbar button. This is  equivalent to setting FLASHW_CAPTION|FLASHW_TRAY flags.
;   FLASHW_CAPTION := 1    ; Flash the window caption.
;   FLASHW_STOP := 0       ; Stop flashing. The system restores the window to its orig. state.
;   FLASHW_TIMER := 4      ; Flash continuously, until the FLASHW_STOP flag is set.
;   FLASHW_TIMERNOFG := 12 ; Flash continuously until the window comes to foreground.
;   FLASHW_TRAY := 2       ; Flash the taskbar button.
FlashWindowEx( hWnd=0, dwFlags=0, uCount=0, dwTimeout=0 ) {
    Static FW="0123456789ABCDEF01234" ; FLASHWINFO Structure
    NumPut(20,FW), NumPut(hWnd,FW,4), NumPut(dwFlags,FW,8), NumPut(uCount,FW,12), NumPut(dwTimeout,FW,16)
    Return DllCall( "FlashWindowEx", UInt,&FW )
}
