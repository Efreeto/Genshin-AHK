; Create a shortcut to this file in C:\Users\{username}\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup
; with administrator access

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance Force

#Include GlobalVariables.ahk

; Rerun script with administrator rights if required.
if (!A_IsAdmin) {
    try {
        Run *RunAs "%A_ScriptFullPath%"
    } catch e {
        MsgBox, Failed to run script with administrator rights
        ExitApp
    }
}

SetTimer, SuspendOnGameInactive, -1
SetTimer, ConfigureTeamHotkeys, -1

SuspendOnGameInactive() {
	GameProcessName := "ahk_exe GenshinImpact.exe"

    Suspend ; Run suspended
    loop {
        WinWaitActive, %GameProcessName%
        Suspend, Off

        WinWaitNotActive, %GameProcessName%
        Suspend, On
    }
}

ClickOnBottomRightButton() {
    ScreenClick(0.9, 0.95)
}

ScreenClick(x, y) {
	screenX := floor(A_ScreenWidth * x)
	screenY := floor(A_ScreenHeight * y)
	Click, %screenX% %screenY%
}


; =======================================
; Enable/disable contextual bindings
; =======================================

Member1 := "hutao"
Member4 := "ganyu"
StatusCold := false

// Run at character select screen to match macros to charcters
ConfigureContextualBindings() {
	global Member1
	global Member4

	KleeColor := 0x112DB1
	HuTaoColor := 0x191C35
	
	;GetColorAtLoc()
	
	if (PixelSearchInPartySetup(KleeColor)) {
		Member1 := "klee"
	} else if (PixelSearchInPartySetup(HuTaoColor)) {
		Member1 := "hutao"
	} else {
		SoundBeep, 100
		Hotkey, ~1, ActivateRegularCharacter
		Hotkey, ~q, ActivateRegularCharacter
		Hotkey, ~3, ActivateRegularCharacter
		Hotkey, ~e, ActivateRegularCharacter
		ActivateRegularCharacter()
	}
}

PixelSearchInPartySetup(color) {
	PixelSearch, varX, varY, 480, 612, 480, 612, color, 8	; 2560x1440
	return !ErrorLevel
}

NumPad1::
	Member1 := "hutao"
	SoundPlay, %A_WinDir%\Media\chimes.wav
	ConfigureTeamHotkeys()
return

NumPad2::
	Member1 := "klee"
	SoundPlay, %A_WinDir%\Media\tada.wav
	ConfigureTeamHotkeys()
return

NumPad4::
	Member4 := "ganyu"
	SoundPlay, %A_WinDir%\Media\Windows Exclamation.wav
	ConfigureTeamHotkeys()
return

NumPad5::
	Member4 := "regular"
	SoundPlay, %A_WinDir%\Media\Windows Error.wav
	ConfigureTeamHotkeys()
return

NumpadMult::
	StatusCold := true
	SoundPlay, %A_WinDir%\Media\Windows Logoff Sound.wav
	ConfigureTeamHotkeys()
return

NumpadDiv::
	StatusCold := false
	SoundPlay, %A_WinDir%\Media\Windows Logon.wav
	ConfigureTeamHotkeys()
return

ConfigureTeamHotkeys() {
	global Member1
	global Member4
	
	if (Member1 == "hutao") {
		Hotkey, ~1, ActivateHuTao
		ActivateHuTao()
	} else if (Member1 == "klee") {
		Hotkey, ~1, ActivateKlee
		ActivateKlee()
	} else {
		Hotkey, ~1, ActivateRegularCharacter
		ActivateRegularCharacter()
	}
	
	Hotkey, ~q, ActivateRegularCharacter	
	
	Hotkey, ~3, ActivateRegularCharacter
	
	if (Member4 == "ganyu") {
		Hotkey, ~e, ActivateGanyu
	} else {
		Hotkey, ~e, ActivateRegularCharacter
	}
}

ActivateKlee() {
	Hotkey, ~XButton1, Klee_ChargeAttack
	Hotkey, ~*Numpad8, Klee_AutoAttack
}

ActivateHuTao() {
	Hotkey, ~XButton1, HuTao_ChargeAttack
	Hotkey, ~*Numpad8, Regular_AutoAttack
}

ActivateGanyu() {
	Hotkey, ~XButton1, Ganyu_ChargeAttack
	Hotkey, ~*Numpad8, Regular_AutoAttack
}

ActivateRegularCharacter() {
	Hotkey, ~XButton1, Regular_ChargeAttack
	Hotkey, ~*Numpad8, Regular_AutoAttack
}

HuTao_ChargeAttack() {
	hk := SubStr(A_ThisHotkey, 2)  ; remove '~'
	pause1 := 60
	pause2 := 50
	pause3 := 300
	pause4 := 240
    while (GetKeyState(hk, "P")) {
		Click, down
		Sleep, %pause1%
		Click, up
		Sleep, %pause2%
		Click, down
		Sleep, %pause1%
		Click, up
		Sleep, %pause2%
		Click, down
		Sleep, %pause3%
		Click, up
		Click, right
		Sleep, %pause4%
	}
}

HuTao_ChargeAttack_N2C() { ; Good at 230ms
	; Hu Tao Blood Blossom cancel (Need Constellation 1)
	Click
	Sleep, 30
	Click
	Sleep, 30
	Click
	Sleep, 30
	Click
	Sleep, 30
	Click
	Sleep, 30
	Click
	Sleep, 30
	Click, down
	Sleep, 350
	Click, right
	Sleep, 50
	Click, up
	;Sleep, 200  ; 150
}

HuTao_ChargeAttack_N2C_Hold() { ; Good at 230ms
	; Hu Tao Blood Blossom cancel (Need Constellation 1)
	hk := SubStr(A_ThisHotkey, 2)  ; remove '~'
    while (GetKeyState(hk, "P")) {
		Click
		Sleep, 30
		Click
		Sleep, 30
		Click
		Sleep, 30
		Click
		Sleep, 30
		Click
		Sleep, 30
		Click
		Sleep, 30
		Click, down
		Sleep, 350
		Click, right
		Sleep, 150
		Click, up
		Sleep, 200  ; 150
	}
}

HuTao_ChargeAttack_N1C() {
	; Hu Tao Blood Blossom cancel (Need Constellation 1)
	Click, down
	Sleep, 550  ; 600
	Click, up
	Click, right
}

HuTao_ChargeAttack_N1C_Hold() {
	; Hu Tao Blood Blossom cancel (Need Constellation 1)
	hk := SubStr(A_ThisHotkey, 2)  ; remove '~'
    while (GetKeyState(hk, "P")) {
		Click, down
		Sleep, 600  ; 600
		Click, up
		Click, right
		Sleep, 175  ; 150
	}
}

HuTao_ChargeAttack_Frozen() {
	hk := SubStr(A_ThisHotkey, 2)  ; remove '~'
	numCycle := 0
	loop
	{
		if (numCycle < 2)
		{
			Click, down
			Sleep, 425
			if (not GetKeyState(hk, "P"))
				break
			Click, right
			Sleep, 300
			if (not GetKeyState(hk, "P"))
				break
			Click, up
			Sleep, 200  ; 175
			;numCycle++
		}
		else
		{
			HuTao_ChargeAttack_N2C()
			numCycle := 0
		}
		if (not GetKeyState(hk, "P"))
			break
	}
}

Klee_ChargeAttack() {
	hk := SubStr(A_ThisHotkey, 2)  ; remove '~'
    while (GetKeyState(hk, "P")) {
		Click, down
		Sleep, 500  ; 500
		Click, up
		Send, {Space}
		Sleep, 575  ; 550
	}
}

Ganyu_ChargeAttack() {
	hk := SubStr(A_ThisHotkey, 2)  ; remove '~'
	Click	; Apply a normal attack element, if any
	Sleep, 30
	Click, down
	KeyWait, XButton1  ; (AHK bug) KeyWait doesn't work with variables
    TimeSinceKeyPressed := A_TimeSinceThisHotkey
    if (TimeSinceKeyPressed < 2000) {
        ; hold LMB minimum for 2000ms
        Sleep, % 2000 - TimeSinceKeyPressed
    }
    while (GetKeyState(hk, "P")) {
		; Hold LMB if hotkey is still pressed. I think this can be deleted?
	}
	Click, up
}

Regular_ChargeAttack() {
	Click, down
	KeyWait, XButton1  ; (AHK bug) KeyWait doesn't work with variables
    TimeSinceKeyPressed := A_TimeSinceThisHotkey
    if (TimeSinceKeyPressed < 370) {	; 350
        ; Hold LMB minimum for 370ms
        Sleep, % 370 - TimeSinceKeyPressed
    }
    Click, up
}

Klee_AutoAttack() {
	; Klee walk cancel
	
	global StatusCold
	
	if (StatusCold)
		pause := 680	; 650?
	else
		pause := 510
		
	hk := SubStr(A_ThisHotkey, 3)  ; remove '~*'
    while (GetKeyState(hk, "P")) {
        Click
        Sleep, %pause%
    }
}

Klee_AutoAttack2() {
	; Klee jump cancel
	hk := SubStr(A_ThisHotkey, 3)  ; remove '~*'
    while (GetKeyState(hk, "P")) {
		Click
		Sleep, 35
		Send, {Space}
		Sleep, 550
	}
}

Regular_AutoAttack() {
	hk := SubStr(A_ThisHotkey, 3)  ; remove '~*'
    while (GetKeyState(hk, "P")) {
        Click
        Sleep, 30
    }
}


; =======================================
; Regular actions
; =======================================

~Space:: ; ~ passes the key down through
	Sleep, 300 ; Repeat delay
	while GetKeyState(A_Space, "P")
	{
		Send, {Space} ; Repeated keydowns
		Sleep, 30 ; Repeat rate
	} ; ~ passes the keyup through
return

; Hold to exit the boat
NumPad0::Space

; Hold to animation cancel elemental skills
NumPad6::
	Send, {4}
	Click, right
return

NumPad7::LAlt

LShift::MButton

PrintScreen::!PrintScreen
;Insert::!PrintScreen

; =======================================
; Test
; =======================================

GetColorAtLocation(x, y) {
	PixelGetColor, color, x, y
	MsgBox, %x% x %y% =>%color%
}

GetColorAndLocationAtMouse() {
	MouseGetPos, mouseX, mouseY
	screenX := mouseX / A_ScreenWidth
	screenY := mouseY / A_ScreenHeight
	PixelGetColor, color, %mouseX%, %mouseY%
	MsgBox, %mouseX% (%screenX%) x %mouseY% (%screenY%) => %color%
}

NumPad9::
    ;SoundBeep, 100
	;GetColorAtLocation(480, 612)
	GetColorAndLocationAtMouse()
return


#Include Expedition.ahk