; Put this file in C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp

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
	Hotkey, ~e, ActivateRegularCharacter
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

ActivateRegularCharacter() {
	Hotkey, ~XButton1, Regular_ChargeAttack
	Hotkey, ~*Numpad8, Regular_AutoAttack
}

HuTao_ChargeAttack() {
	; Hu Tao Blood Blossom cancel (Need Constellation 1)
	hk := SubStr(A_ThisHotkey, 2)  ; remove '~'
    while(GetKeyState(hk, "P")) {
		Click, down
		Sleep, 600
		Click, up
		Click, right
		Sleep, 150
	}
}

Klee_ChargeAttack() {
	hk := SubStr(A_ThisHotkey, 2)  ; remove '~'
    while(GetKeyState(hk, "P")) {
		Click, down
		Sleep, 500
		Click, up
		Send, {Space}
		Sleep, 550
	}
}

Regular_ChargeAttack() {
	;hk := SubStr(A_ThisHotkey, 2)  ; remove '~'
    TimeSinceKeyPressed := A_TimeSinceThisHotkey
	Click, down
	KeyWait, XButton1  ; variable doesn't work with KeyWait
    if (TimeSinceKeyPressed < 350) {
        ; hold LMB minimum for 350ms
        Sleep, 350 - %TimeSinceKeyPressed%
    }
    Click, up
}

Klee_AutoAttack() {
	; Klee walk cancel
	hk := SubStr(A_ThisHotkey, 3)  ; remove '~*'
    while(GetKeyState(hk, "P")) {
        Click
        Sleep, 550
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

PrintScreen::!PrintScreen

NumPad7::
	ConfigureContextualBindings()
	;ClickOnBottomRightButton()
return

NumPad1::
	Klee_First()
	;ActivateKlee()
return

NumPad2::
	Hutao_First()
	;ActivateHuTao()
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