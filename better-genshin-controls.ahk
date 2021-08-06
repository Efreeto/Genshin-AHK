﻿#NoEnv
#MaxHotkeysPerInterval 100
#InstallKeybdHook
#InstallMouseHook
#Include WaitPixelColor.ahk

SendMode Event
SetWorkingDir %A_ScriptDir%
SetKeyDelay 0
SetMouseDelay 0

; =======================================
; Global variables
; =======================================

; Global state
BindingsEnabled = 0
AutoRun = 0

; Expedition duration coordinates
Duration4H := { X: 1500, Y: 700 }
Duration20H := { X: 1800, Y: 700 }

; Expetitions (crystals)
WhisperingWoodsExpedition := { MapNumber: 0, X: 1050, Y: 330 }
DadaupaGorgeExpedition := { MapNumber: 0, X: 1170, Y: 660 }
YaoguangShoalExpedition := { MapNumber: 1, X: 950, Y: 450 }
; Expetitions (mora)
StormterrorLairExpedition := { MapNumber: 0, X: 550, Y: 400 }
DihuaMarshExpedition := { MapNumber: 1, X: 728, Y: 332 }
JueyunKarstExpedition := { MapNumber: 1, X: 559, Y: 561 }
; Expetitions (food)
WindriseExpedition := { MapNumber: 0, X: 1111, Y: 455 }
GuiliPlainsExpedition := { MapNumber: 1, X: 800, Y: 550 }

; Handbook enemies
MitachurlEnemyNumber := 13
FatuiAgentEnemyNumber := 14
WhopperflowerEnemyNumber := 20

SelectedEnemyNumber := WhopperflowerEnemyNumber


; =======================================
; Script initialization
; =======================================

SetTimer, PauseLoop
SetTimer, ConfigureBindings, 200


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

PauseLoop() {
    Suspend ; run suspended
    loop {
        WinWaitActive, ahk_exe GenshinImpact.exe
        Suspend, Off
        WinWaitNotActive, ahk_exe GenshinImpact.exe
        Suspend, On
    }
}



; =======================================
; Enable/disable contextual bindings
; =======================================

ConfigureBindings() {
    global BindingsEnabled

    PixelGetColor, Color, 807, 1010, RGB ; left pixel of the hp bar
    HpBarFound := (Color = "0x8DC921") || (Color = "0xEF5555") || (Color = "0xEFBF2F") ; green or red or orange

    Toggled := 0
    if (HpBarFound && !BindingsEnabled) {
        ; enable bindings
        Hotkey, *~LButton, NormalAutoAttack, On
        Hotkey, *RButton, StrongAttack, On
        Hotkey, ~$*f, SpamF, On
        Toggled := 1
    } else if (!HpBarFound && BindingsEnabled) {
        ; disable bindings
        Hotkey, *~LButton, NormalAutoAttack, Off
        Hotkey, *RButton, StrongAttack, Off
        Hotkey, ~$*f, SpamF, Off,
        Toggled := 1
    }

    if (Toggled) {
        BindingsEnabled := !BindingsEnabled
    }
}



; =======================================
; Auto attack
; =======================================

NormalAutoAttack() {
    while(GetKeyState("LButton", "P")) {
        SpamLeftClick()
    }
}

SpamLeftClick() {
    MouseClick left
    Sleep, 150
}

StrongAttack() {
    Click, down
    KeyWait, RButton
    TimeSinceKeyPressed := A_TimeSinceThisHotkey
    if (TimeSinceKeyPressed < 350) {
        ; hold LMB minimum for 350ms
        Sleep, % 350 - TimeSinceKeyPressed
    }
    Click, up
}



; =======================================
; Pick up on press
; =======================================

SpamF() {
    while(GetKeyState("f", "P")) {
        Send, {f}
        Sleep, 100
    }
}



; =======================================
; Spam left click
; =======================================

XButton2::
    while(GetKeyState("XButton2" ,"P")) {
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
  Send, {l}
  Sleep, 3100
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

; Recieve all the rewards
Numpad1::
    ReceiveReward(StormterrorLairExpedition, 1000)
    ReceiveReward(DihuaMarshExpedition)
    ReceiveReward(JueyunKarstExpedition)
    ReceiveReward(WindriseExpedition)
    ReceiveReward(GuiliPlainsExpedition)
return

; Send everyone to the expedition
Numpad2::
    Duration := Duration20H
    SendOnExpedition(StormterrorLairExpedition, 4, Duration)
    SendOnExpedition(DihuaMarshExpedition, 4, Duration)
    SendOnExpedition(JueyunKarstExpedition, 5, Duration)
    SendOnExpedition(WindriseExpedition, 7, Duration)
    SendOnExpedition(GuiliPlainsExpedition, 7, Duration)
return

SelectExpedition(Expedition) {
    ; Click on the world
    WorldY := 160 + (Expedition["MapNumber"] * 72) ; initial position + offset between lines
    MouseClick, left, 200, WorldY
    Sleep, 500

    ; Click on the expedition
    MouseClick, left, Expedition["X"], Expedition["Y"]
    Sleep, 200
}

ClickOnBottomRightButton() {
    MouseClick, left, 1730, 1000
}

SelectDuration(Duration) {
    MouseClick, left, Duration["X"], Duration["Y"]
    Sleep, 100
}

SendOnExpedition(Expedition, CharacterNumberInList, Duration) {
    SelectExpedition(Expedition)

    SelectDuration(Duration)

    ; Click on "Select Character"
    ClickOnBottomRightButton()
    Sleep, 1500

    ; Find and select the character
    FindAndSelectCharacter(CharacterNumberInList)
    Sleep, 300
}

FindAndSelectCharacter(CharacterNumberInList) {
    FirstCharacterX := 100
    FirstCharacterY := 150
    SpacingBetweenCharacters := 125

    if (CharacterNumberInList <= 7) {
        MouseClick, left, FirstCharacterX, FirstCharacterY + (SpacingBetweenCharacters * (CharacterNumberInList - 1))
    } else {
        ScrollDownCharacterList(CharacterNumberInList - 7.5)
        MouseClick, left, FirstCharacterX, FirstCharacterY + (SpacingBetweenCharacters * 7)
    }
}

; Scroll down the passed number of characters
ScrollDownCharacterList(CharacterAmount) {
    MouseMove, 950, 540

    ScrollAmount := CharacterAmount * 7
    Loop %ScrollAmount% {
        Send, {WheelDown}
        Sleep, 10
    }
}

ReceiveReward(Expedition, ReceiveRewardLag := 0) {
    SelectExpedition(Expedition)

    ; receive reward
    ClickOnBottomRightButton()
    Sleep, 200
    Sleep, ReceiveRewardLag

    ;skip reward menu
    ClickOnBottomRightButton()
    Sleep, 200
}


; Select enemy from handbook
Numpad7::
    Send, {F1}
    Sleep, 1500
    MouseClick, left, 300, 550 ; "Enemies" tab
    Sleep, 200
    MouseMove, 550, 350 ; first item in the list
    Sleep, 200

    ScrollAmount := 10 * (SelectedEnemyNumber - 1) ; 10 scrolls for item
    loop %ScrollAmount% {
        Send, {WheelDown}
        Sleep, 20
    }
    MouseClick, left
    Sleep, 200

    MouseClick, left, 1400, 850 ; "Navigate" button
return

; Lock artifact
Numpad8::
    MouseGetPos, X, Y
    MouseClick, left, 1738, 440
    Sleep, 50
    MouseClick, left, X, Y
return

; Select max stacks and craft ores
Numpad9::
    MouseClick, left, 1467, 669 ; max stacks
    Sleep, 50
    ClickOnBottomRightButton()
return

; Go to the Serenitea Pot
Numpad5::
    Send, {b}
    Sleep, 900
    MouseClick, left, 1050, 50
    Sleep, 250
    MouseClick, left, 270, 180
    Sleep, 250
    ClickOnBottomRightButton()
    Sleep, 700
    Send, {f}
return

; Relogin
Numpad3::
    Send, {Esc}
    WaitPixelColor(0xECE5D8, 729, 63, 800) ; wait for menu

    MouseClick, left, 49, 1022 ; logout button
    WaitPixelColor(0xD6AF32, 1024, 753, 100) ; wait logout menu

    MouseClick, left, 1197, 759 ; confirm
    WaitPixelColor(0x222222, 1823, 794, 8000) ; wait for settings icon

    MouseClick, left, 500, 500
    Sleep, 500
    WaitPixelColor(0xFEFEFE, 1808, 793, 15000) ; wait for "click to begin"

    MouseClick, left, 600, 500
return

; Hold 1-4 to switch character
*1::
    while(GetKeyState("1", "P")) {
        Send, {1}
        Sleep, 100
    }
return

*2::
    while(GetKeyState("2", "P")) {
        Send, {2}
        Sleep, 100
    }
return

*3::
    while(GetKeyState("3", "P")) {
        Send, {3}
        Sleep, 100
    }
return

*4::
    while(GetKeyState("4", "P")) {
        Send, {4}
        Sleep, 100
    }
return

; =======================================
; Debug
; =======================================

*XButton1::
    if (AutoRun) {
        ControlSend ,, {w Down}, ahk_exe GenshinImpact.exe
    } else {
        ControlSend ,, {w Up}, ahk_exe GenshinImpact.exe
    }
    AutoRun := !AutoRun
return

NumpadDot::
    ;KeyHistory

    LBState := GetKeyState("LButton", "P")
    FState := GetKeyState("f", "P")
    XBState := GetKeyState("XButton2" ,"P")

    GetKeyState, LBStateHack, LButton, P
    GetKeyState, FStateHack, f, P
    GetKeyState, XB2StateHack, XButton2, P

    MsgBox, lb: %LBState%, xb: %XBState%, f: %FState% | lb(hack): %LBStateHack%, xb(hack): %XB2StateHack%, f(hack): %FStateHack%

    ;ListVars
;    ControlSend, , {tab}, ahk_exe GenshinImpact.exe
;    ControlSend, , 12345, ahk_exe notepad.exe
;    Send, {tab}
return
