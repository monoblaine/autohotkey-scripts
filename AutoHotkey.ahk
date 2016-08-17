#NoTrayIcon 
#SingleInstance force

#a:: Winset, Alwaysontop, , A

;title: ClipChain
;description: Clipboard utility for copying multiple strings into one long "chain"
;author: Dustin Luck
;version: 0.1
;homepage: http://lifehacker.com/5306452/clipchain-copies-multiple-text-strings-for-easy-pasting

;DEFINE COPY HOTKEY
CapsLock & c::
;clear the clipboard and send copy command
Clipboard =
Send ^c
;wait for clipboard data
ClipWait 1
if ErrorLevel
    return
;append the newly copied data to the ClipChain
;add the separator only if ClipChain has something in it
if (ClipChain <> "") {
    ClipChain = %ClipChain%%ClipSep%%Clipboard%
} else {
    ClipChain = %Clipboard%
}
return

;DEFINE CUT HOTKEY
CapsLock & x::
;clear the clipboard and send cut command
Clipboard =
Send ^x
;wait for clipboard data
ClipWait 1
if ErrorLevel
    return
;append the newly copied data to the ClipChain
;add the separator only if ClipChain has something in it
if (ClipChain <> "") {
    ClipChain = %ClipChain%%ClipSep%%Clipboard%
} else {
    ClipChain = %Clipboard%
}
return

;DEFINE PASTE HOTKEY
CapsLock & v::
;replace the clipboard contents with the stored ClipChain and send paste command
Clipboard := ClipChain
Send ^v
;clear ClipChain
ClipChain =
return

;DEFINE SEPARATOR HOTKEYS
CapsLock & -::
CapsLock & NumpadSub:: ClipSep := "-"
CapsLock & ,:: ClipSep := ","
CapsLock & |:: ClipSep := "|"
CapsLock & /:: ClipSep := "/"
CapsLock & Space:: ClipSep := A_Space
CapsLock & Tab:: ClipSep := A_Tab
CapsLock & Enter:: ClipSep := "`r`n"
;no separator
CapsLock & Esc:: ClipSep :=

;DEFINE CLEAR CONTENTS HOTKEY
CapsLock & BS:: ClipChain =

;DEFINE raw paste
^+v::                            ; Text–only paste from ClipBoard
   Clip0 = %ClipBoardAll%
   ClipBoard = %ClipBoard%       ; Convert to text
   Send ^v                       ; For best compatibility: SendPlay
   Sleep 50                      ; Don't change clipboard while it is pasted! (Sleep > 0)
   ClipBoard = %Clip0%           ; Restore original ClipBoard
   VarSetCapacity(Clip0, 0)      ; Free memory
Return

+^#Up::
	{
		Send {Volume_Up}
		return
	}

+^#Down::
	{
		Send {Volume_Down}
		return
	}
	
	
:*:;;today::  ; This hotstring replaces ";;today" with the current date and time via the commands below.
FormatTime, CurrentDateTime,, yyy-MM-dd  ; It will look like 2009-10-13
SendInput %CurrentDateTime%
return

:*:;;now::  ; This hotstring replaces ";;now" with the current date and time via the commands below.
FormatTime, CurrentDateTime,, yyy-MM-dd HH.mm  ; It will look like 2009-10-13 10.57
SendInput %CurrentDateTime%
return

:*:;;vnow::  ; This hotstring replaces ";;vnow" with the current date and time via the commands below.
FormatTime, CurrentDateTime,, yyyMMddHHmm  ; It will look like 200910131057
SendInput %CurrentDateTime%
return

:*:;;time::  ; This hotstring replaces ";;time" with the current time and date via the commands below.
FormatTime, CurrentDateTime, L1055, d MMMM yyy dddd, HH.mm  ; It will look like 13 August 2013 Tuesday, 13.17
SendInput %CurrentDateTime%
return

:*:;;date::  ; This hotstring replaces ";;Date" with the current date via the commands below.
FormatTime, CurrentDateTime, L1055, d MMMM yyy dddd  ; It will look like 26 April 2010 Monday
SendInput %CurrentDateTime%
return

:*:;;pipe::
SendInput {Raw}==============================================================================
return

:*:;;dash::
SendInput {Raw}------------------------------------------------------------------------------
return

;RShift & Space::
;Send {Space}
;Send {Left down}{Left up}


; double click
^!+o::
Send {Click 2}
return

; single click
^!+q::
Send {Click 1}
return

; Move mouse pointer to somewhere safe
^!+w::
CoordMode, Mouse, Screen
MouseMove, A_ScreenWidth - 145, 0
Return

; Move mouse pointer to somewhere safe (alternate)
^!+e::
CoordMode, Mouse, Screen
MouseMove, A_ScreenWidth - 23, 50
Return

; Move mouse pointer to somewhere safe (alternate-top)
^!+g::
CoordMode, Mouse, Screen
MouseMove, A_ScreenWidth / 2, 1
Return

; Move mouse pointer to somewhere safe (alternate-bottom)
^!+b::
CoordMode, Mouse, Screen
MouseMove, A_ScreenWidth / 2, A_ScreenHeight - 3
Return

; Move mouse pointer to somewhere safe (alternate-bottom-right)
^!+n::
CoordMode, Mouse, Screen
MouseMove, A_ScreenWidth - 23, A_ScreenHeight - 3
Return

; Media stuff
^!+Left::Send   {Media_Prev}
^!+Right::Send  {Media_Next}
^!+Down::Send   {Media_Play_Pause}
^!+Up::Send   {Media_Stop}

; Launch "Everything" when Ctrl + F is pressed within File Explorer
#IfWinActive, ahk_class CabinetWClass
^F::
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

#IfWinActive, ahk_exe Meld.exe
    Esc::Send !{f4}
#IfWinActive, ahk_exe 7zFM.exe
    Esc::Send !{f4}
#IfWinActive

; print [ ]
^!+x::
SendInput [ ]{Space}
return

; print * (But not in Visual Studio)
#IfWinNotActive, ahk_exe devenv.exe
    ^!+c::
    SendInput *{Space}
    return
#IfWinNotActive

; replace all the \ characters within the text in clipboard with /
^!+h::
StringReplace, clipboard, clipboard, `\ , `/ , All
return
