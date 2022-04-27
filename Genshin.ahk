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
		SoundBeep, 1000
		Hotkey, ~XButton1, HuTao_ChargeCancel, Off
		Hotkey, ~*Numpad8, Klee_AutoAttackCancel, On
	} else if (PixelSearchInPartySetup(HuTaoColor)) {
		SoundBeep, 1500
		Hotkey, ~XButton1, HuTao_ChargeCancel, On
		Hotkey, ~*Numpad8, All_AutoAttack, On
	} else {
		SoundBeep, 100
		Hotkey, ~XButton1, HuTao_ChargeCancel, Off
		Hotkey, ~*Numpad8, All_AutoAttack, On
	}
}

PixelSearchInPartySetup(color) {
	PixelSearch, varX, varY, 480, 612, 480, 612, color, 8	; 2560x1440
	return !ErrorLevel
}

; Hu Tao Blood Blossom cancel (Need Constellation 1)
HuTao_ChargeCancel() {
	hk := SubStr(A_ThisHotkey, 2)  ; remove '~'
    while(GetKeyState(hk, "P")) {
		Click, down
		Sleep, 420
		Click, right
		Click, up
		Sleep, 200
	}
}

All_AutoAttack() {
	hk := SubStr(A_ThisHotkey, 3)  ; remove '~*'
    while(GetKeyState(hk, "P")) {
        Click
        Sleep, 30
    }
}

; Klee auto attack cancel (Hold wsad together)
Klee_AutoAttackCancel() {
	hk := SubStr(A_ThisHotkey, 3)  ; remove '~*'
    while(GetKeyState(hk, "P")) {
        Click
        Sleep, 550
    }
}

~Space:: ; ~ passes the key down through
	Sleep, 300 ; Repeat delay
	while GetKeyState(A_Space, "P")
	{
		SendInput, {Space} ; Repeated keydowns
		Sleep, 30 ; Repeat rate
	} ; ~ passes the keyup through
return

Numpad0::Space ; For getting out of boat

LShift::MButton

PrintScreen::!PrintScreen

NumPad7::
	ConfigureContextualBindings()
	;ClickOnBottomRightButton()
return

; Test
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