﻿#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#MaxHotkeysPerInterval 100
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


; =======================================
; Global variables
; =======================================

; ores:
WhisperingWoodsExpedition := { MapNumber: 0, X: 1050, Y: 330 }
DadaupaGorgeExpedition := { MapNumber: 0, X: 1170, Y: 660 }
YaoguangShoalExpedition := { MapNumber: 1, X: 950, Y: 450 }

; mora:
StormterrorLairExpedition := { MapNumber: 0, X: 550, Y: 400 }
DihuaMarshExpedition := { MapNumber: 1, X: 728, Y: 332 }


; =======================================
; Technical
; =======================================

; Pause script
Pause::
    Suspend
    ; Pause ; script won't be unpaused
return

; Reload script
Numpad0::
    Reload
return

; Make ctrl+f works because off the *f bind
^f::
    Send, ^f
return



; =======================================
; Pick up on press
; =======================================

$*f::
    ;if WinActive("GenshinImpact.exe") return
    ;if WinActive("ahk_class UnityWndClass") return
    ;if WinActive("atom.exe") return
    Send, {f Down}
    Sleep, 30
    Send, {f Up}
    SetTimer, SendTheKey, 60
    keyWait, f
    SetTimer, SendTheKey, Off
return

SendTheKey:
  Send, {f Down}
  Sleep, 30
  Send, {f Up}
return



; =======================================
; Spam left click
; =======================================

Numpad7::
While ( GetKeyState( "Numpad7","P" ) ) {
      MouseClick, left
      Sleep, 20
}
return



; =======================================
; Change character group
; =======================================


Numpad4::
  ChangeParty("left")
return

Numpad6::
  ChangeParty("right")
return


ChangeParty(Direction) {
  Send, {Esc}
  Sleep, 800
  MouseClick, left, 348, 414 ; Party setup
  Sleep, 3000
  if (Direction = "left") {
    MouseClick, left, 75, 539
  } else {
    MouseClick, left, 1845, 539
  }
  Sleep, 100

  MouseClick, left, 1700, 1000 ; press Deploy button
  Sleep, 300
  Send, {Esc} ; first escape cancels the notification
  Sleep, 400
  Send, {Esc}
  return
}



; =======================================
; Expeditions
; =======================================



Numpad2::
    SendOnExpedition(DihuaMarshExpedition, "ningguang")
return

Numpad3::
    SendOnExpedition(DihuaMarshExpedition, "barbara")
return

SendOnExpedition(Expedition, CharacterName) {
    ; Click on the world
    WorldY := 160 + (DihuaMarshExpedition["MapNumber"] * 72) ; initial position + offset between lines
    MouseClick, left, 200, WorldY
    Sleep 300

    ; Click on the expedition
    MouseClick, left, Expedition[X], Expedition[Y]
    Sleep 100

    ; Select duration
    MouseClick, left, 1800, 700 ; 20h
    Sleep 100

    ; Click on "Select Character"
    MouseClick, left, 1730, 1000
    Sleep, 1500

    ; Find and select the character
    FindAndSelectCharacter(CharacterName)
    Sleep, 100
}



; Find character at character list. The caracter must not be highlighted.
; Returns array [x, y] or 0 if it's not found.
FindCharacterOnScreen(CharacterName) {
    ImageSearch, FoundX, FoundY, 40, 100, 200, 1050, *30 %CharacterName%.png
    if (ErrorLevel = 1 || ErrorLevel = 2) {
        ;MsgBox, error level %ErrorLevel%
        return
    }
    return [FoundX, FoundY]
}

; Scroll down the passed number of characters
ScrollDownCharacterList(CharacterAmount) {
    MouseMove, 950, 540

    ScrollAmount := CharacterAmount * 7
    Loop %ScrollAmount% {
        Send, {WheelDown}
        ;Sleep 17 TODO
    }
}

FindAndSelectCharacter(CharacterName) {
    loop 5 {
        CharacterXY := FindCharacterOnScreen(CharacterName)
        if (CharacterXY) {
            ; character was found, select it
            MouseClick, left, CharacterXY[1], CharacterXY[2]
            Sleep 100
            break
        } else {
            ; character was not found, scrolling down if we can
            PixelGetColor, ScrollBarColor, 935, 1013, RGB
            if (ScrollBarColor = "ECE5D8") {
                break
            }
            ScrollDownCharacterList(7)
            Sleep 100
        }
    }
}



; Debug
Numpad9::
    FindAndSelectCharacter("ningguang")
    ;PixelGetColor, ScrollBarColor, 935, 1013, RGB
    ;MsgBox, % ScrollBarColor

    ;ListVars
    ;MsgBox, % WorldY
return
