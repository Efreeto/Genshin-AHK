; Put this file in C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp
; or in C:\Users\{username}\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup

; Credits to https://github.com/onoderis/bgc-script

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance Force

; Rerun script with administrator rights if required.
if (!A_IsAdmin) {
    try {
        Run *RunAs "%A_ScriptFullPath%"
    } catch e {
        MsgBox, Failed to run script with administrator rights
        ExitApp
    }
}

GameProcessName := "ahk_exe GenshinImpact.exe"

SetTimer, SuspendOnGameInactive, -1
SetTimer, HuTao_First, -1

SuspendOnGameInactive() {
    global GameProcessName

    Suspend ; Run suspended
    loop {
        WinWaitActive, %GameProcessName%
        Suspend, Off

        WinWaitNotActive, %GameProcessName%
        Suspend, On
    }
}

; =======================================
; Enable/disable contextual bindings
; =======================================

ConfigureContextualBindings() {
	KleeColor := 0x112DB1
	HuTaoColor := 0x191C35
	
	;GetColorAtLoc()
	
	if (PixelSearchInPartySetup(KleeColor)) {
		Klee_First()
	} else if (PixelSearchInPartySetup(HuTaoColor)) {
		HuTao_First()
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

Klee_First() {
	SoundBeep, 1000
	Hotkey, ~1, ActivateKlee
	Hotkey, ~q, ActivateRegularCharacter
	Hotkey, ~3, ActivateRegularCharacter
	Hotkey, ~e, ActivateGanyu
	ActivateKlee()
}

HuTao_First() {
	SoundBeep, 1500
	Hotkey, ~1, ActivateHuTao
	Hotkey, ~q, ActivateRegularCharacter
	Hotkey, ~3, ActivateRegularCharacter
	Hotkey, ~e, ActivateRegularCharacter
	ActivateHuTao()
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

HuTao_ChargeAttack() { ; Good at 230ms
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
	Sleep, 150
	Click, up
	;Sleep, 200  ; 150
}

HuTao_ChargeAttack_Hold() { ; Good at 230ms
	; Hu Tao Blood Blossom cancel (Need Constellation 1)
	hk := SubStr(A_ThisHotkey, 2)  ; remove '~'
    while(GetKeyState(hk, "P")) {
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
    while(GetKeyState(hk, "P")) {
		Click, down
		Sleep, 600  ; 600
		Click, up
		Click, right
		Sleep, 175  ; 150
	}
}

Klee_ChargeAttack() {
	hk := SubStr(A_ThisHotkey, 2)  ; remove '~'
    while(GetKeyState(hk, "P")) {
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
    while(GetKeyState(hk, "P")) {
		; hold LMB if hotkey is still pressed. I think this can be deleted?
	}
	Click, up
}

Regular_ChargeAttack() {
	Click, down
	KeyWait, XButton1  ; (AHK bug) KeyWait doesn't work with variables
    TimeSinceKeyPressed := A_TimeSinceThisHotkey
    if (TimeSinceKeyPressed < 370) {	; 350
        ; hold LMB minimum for 370ms
        Sleep, % 370 - TimeSinceKeyPressed
    }
    Click, up
}

Klee_AutoAttack() {
	; Klee walk cancel
	hk := SubStr(A_ThisHotkey, 3)  ; remove '~*'
    while(GetKeyState(hk, "P")) {
        Click
        Sleep, 575  ; 550
    }
}

Klee_AutoAttack2() {
	; Klee jump cancel
	hk := SubStr(A_ThisHotkey, 3)  ; remove '~*'
    while(GetKeyState(hk, "P")) {
		Click
		Sleep, 35
		Send, {Space}
		Sleep, 550
	}
}

Regular_AutoAttack() {
	hk := SubStr(A_ThisHotkey, 3)  ; remove '~*'
    while(GetKeyState(hk, "P")) {
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

; For getting out of boat
Numpad0::Space

LShift::MButton

;PrintScreen::!PrintScreen
Insert::!PrintScreen

NumPad7::
	ConfigureContextualBindings()
	;ClickOnBottomRightButton()
return

NumPad1::
	Hutao_First()
return

NumPad2::
	Klee_First()
return

; =======================================
; Test
; =======================================

ScreenClick(X, Y) {
	ScreenX := floor(A_ScreenWidth * X)
	ScreenY := floor(A_ScreenHeight * Y)
	Click, %ScreenX% %ScreenY%
}

X_(X) {
	return floor(A_ScreenWidth * X)
}

Y_(Y) {
	return floor(A_ScreenHeight * Y)
}

GetColorAndPoseAtMouse() {
	MouseGetPos, MouseX, MouseY
	PixelGetColor, color, %MouseX%, %MouseY%
	MsgBox, %MouseX% x %MouseY% => %color%
	;ScreenX := MouseX / A_ScreenWidth
	;ScreenY := MouseY / A_ScreenHeight
	;MsgBox, %ScreenX% x %ScreenY% => %color%
}

GetColorAtLoc() {
	PixelGetColor, color, 480, 612
	MsgBox, colorAtLoc %color%
}

;RButton::
;	GetColorAtLoc()
;return


; =======================================
; Expeditions
; =======================================

ReceiveReward() {
    ; SelectExpedition(Expedition)

    ; receive reward
    ClickOnBottomRightButton()
    Sleep, 200
    ; Sleep, ReceiveRewardLag

    ;skip reward menu
    ClickOnBottomRightButton()
    Sleep, 200
}

ClickOnBottomRightButton() {
    ScreenClick(0.9, 0.95)
}