; Create a shortcut in C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp
; or in C:\Users\{username}\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup
; with 
; 'Target': "C:\{AutoHotkey install location}\AutoHotkey.exe" "GenshinAHK.ahk"
; 'Start in:': {this location}

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

GetFileName() {
    WinGet, activeprocess, ProcessName, A
    MsgBox, The active ahk_exe is "%activeprocess%".
    ; "GenshinImpact.exe"
}

GetWinName() {
    WinGetTitle, Title, A
    MsgBox, The active window is "%Title%".
    ; "Genshin Impact", "원신"
}

ClickOnBottomRightButton() {
    ScreenClick(0.9, 0.95)
}

ScreenClick(x, y) {
    screenX := floor(A_ScreenWidth * x)
    screenY := floor(A_ScreenHeight * y)
    Click, %screenX% %screenY%
}

DetectDisplayLanguage() {
    WinGetTitle, winTitle, A
    if (winTitle == "Genshin Impact")
        return "EN"
    else ; "원신"
        return "KR"
}

SkipDialogue() {
    lang := DetectDisplayLanguage()
    if (lang == "KR") {
        Sleep, 500
    } else {    ; "EN"
        Sleep, 700
    }
    
    Send, {f}   ; skip dialogue
    Sleep, 200
    Send, {f}   ; close dialogue
    Sleep, 1000    
}

; =======================================
; Enable/disable contextual bindings
; =======================================

Member1 := "regular"
Member4 := "regular"

NumPad1::
    Member1 := "hutao"
    SoundPlay, %A_WinDir%\Media\chimes.wav
    ConfigureTeamHotkeys()
return

NumPad2::
    Member2 := "xingqiu"
    SoundPlay, %A_WinDir%\Media\tada.wav
    ConfigureTeamHotkeys()
return

NumPad3::
    Member1 := "klee"
    SoundPlay, %A_WinDir%\Media\tada.wav
    ConfigureTeamHotkeys()
return

NumPad7::
    Member4 := "ganyu"
    SoundPlay, %A_WinDir%\Media\Windows Exclamation.wav
    ConfigureTeamHotkeys()
return

NumPad0::
    Member1 := "regular"
    Member4 := "regular"
    SoundPlay, %A_WinDir%\Media\Windows Error.wav
    ConfigureTeamHotkeys()
return

ConfigureTeamHotkeys() {
    global Member1
    global Member2
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
    
    if (Member2 == "xingqiu") {
        Hotkey, ~q, ActivateXingQiu
    } else {
        Hotkey, ~q, ActivateRegularCharacter
    }
    
    Hotkey, ~3, ActivateRegularCharacter
    
    if (Member4 == "ganyu") {
        Hotkey, ~e, ActivateGanyu
    } else {
        Hotkey, ~e, ActivateRegularCharacter
    }
}

ActivateHuTao() {
    Hotkey, F13, Regular_AutoAttack
    Hotkey, F14, Regular_ElementalSkill
    Hotkey, F18, HuTao_ChargeAttack
}

ActivateKlee() {
    Hotkey, F13, Klee_ChargeAttack
    Hotkey, F14, Regular_ElementalSkill
    Hotkey, F18, Klee_AutoAttack
    ;Hotkey, F19, Klee_ChargeAttack
}

ActivateGanyu() {
    Hotkey, F13, Regular_AutoAttack
    Hotkey, F14, Regular_ElementalSkill
    Hotkey, F18, Ganyu_ChargeAttack
}

ActivateXingQiu() {
    Hotkey, F13, Regular_AutoAttack
    Hotkey, F14, XingQiu_ElementalSkill
    Hotkey, F18, Regular_AutoAttack
}

ActivateRegularCharacter() {
    Hotkey, F13, Regular_AutoAttack
    Hotkey, F14, Regular_ElementalSkill
    Hotkey, F18, Regular_AutoAttack
}

HuTao_ChargeAttack() {
    pause1 := 60
    pause2 := 50
    pause3 := 300
    pause4 := 240
    while (GetKeyState(A_ThisHotkey, "P")) {
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

; Hu Tao Blood Blossom cancel (Need Constellation 1)
HuTao_ChargeAttack_N2C() { ; Good at 230ms
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

; Hu Tao Blood Blossom cancel (Need Constellation 1)
HuTao_ChargeAttack_N2C_Hold() { ; Good at 230ms    
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

; Hu Tao Blood Blossom cancel (Need Constellation 1)
HuTao_ChargeAttack_N1C_Hold() {
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
    while (GetKeyState(A_ThisHotkey, "P")) {
        Click, down
        Sleep, 500  ; 500
        Click, up
        Send, {Space}
        Sleep, 575  ; 550
    }
}

; Hold to animation cancel elemental skills
XingQiu_ElementalSkill() {
    Send, {[}
    Click, right
}

Regular_ElementalSkill() {
    Send, {[ down}
    while (GetKeyState(A_ThisHotkey, "P")) {
    }
    Send, {[ up}
}

Ganyu_ChargeAttack() {
    hk := SubStr(A_ThisHotkey, 2)  ; remove '~'
    Click    ; Apply a normal attack element, if any
    Sleep, 30
    Click, down
    KeyWait, % hk  ; (AHK bug) KeyWait doesn't work with variables
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
    KeyWait, % hk  ; (AHK bug) KeyWait doesn't work with variables
    TimeSinceKeyPressed := A_TimeSinceThisHotkey
    if (TimeSinceKeyPressed < 370) {    ; 350
        ; Hold LMB minimum for 370ms
        Sleep, % 370 - TimeSinceKeyPressed
    }
    Click, up
}

; Klee walk cancel
Klee_AutoAttack() {    
    if (IsCharacterSlowed())
        pause := 590    ; at 84-88ms
    else
        pause := 508    ; at 84-88ms

    while (GetKeyState(A_ThisHotkey, "P")) {
        Click
        Sleep, %pause%
    }
}

; Klee jump cancel
Klee_AutoAttack2() {
    while (GetKeyState(A_ThisHotkey, "P")) {
        Click
        Sleep, 35
        Send, {Space}
        Sleep, 550
    }
}

Regular_AutoAttack() {
    while (GetKeyState(A_ThisHotkey, "P")) {
        Click
        Sleep, 25
    }
}

IsCharacterSlowed() {
    ;1101 (0.430078) x 1292 (0.897222) => 0xFDFDCD
    PixelSearch, varX, varY, 1100, 1290, 1102, 1292, 0xFDFDCD, 8    ; 2560x1440
    return !ErrorLevel
}


; =======================================
; Regular actions
; =======================================

TypingMode := false
; Hold to unfreeze self
~Space:: ; ~ passes the key down through
    if (TypingMode)
    {
        Sleep, 750
        if not GetKeyState(A_Space, "P")
            return
        
        ; Disable typing mode if pressed for a long time
        DisableTypingMode()
    }

    Sleep, 250 ; Repeat delay
    while GetKeyState(A_Space, "P")
    {
        Send, {Space} ; Repeated keydowns
        Sleep, 30 ; Repeat rate
    }
return

; Special interactions
~g::
    CheckTypingModeAndExit()

    if (IsNearKatheryne()) {
        SoundPlay, %A_WinDir%\Media\Speech On.wav
        
        Send, {f}   ; talk to Katherine
        SkipDialogue()
        CollectCommissionRewards()
        
        Send, {f}   ; talk to Katherine
        SkipDialogue()
        CollectExpeditionRewardsAndSendExpeditions()
    } else {
        SoundPlay, %A_WinDir%\Media\Speech Off.wav
    }
return

; Enable typing mode
~Backspace::
    EnableTypingMode()
return

EnableTypingMode() {
    global TypingMode
    TypingMode := true
    
    SoundPlay, %A_WinDir%\Media\Windows User Account Control.wav
}

DisableTypingMode() {
    global TypingMode
    TypingMode := false
    
    SoundPlay, %A_WinDir%\Media\Windows Notify Calendar.wav
}

CheckTypingModeAndExit() {
    global TypingMode
    
    if (TypingMode) {
        SoundPlay, %A_WinDir%\Media\Windows Navigation Start.wav
        Exit
    }
}

CheckEscPressedAndExit() {
    if (GetKeyState("Esc", "P"))
    {
        SoundPlay, %A_WinDir%\Media\Speech Sleep.wav
        Exit
    }
}

; Hold to exit the boat
NumpadEnter::Space

F15::]

F16::MButton

F17::
    Regular_AutoAttack()
return

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

*NumPad8::
    GetWinName()
return

*NumPad9::
    ;SoundBeep, 100
    ;GetColorAtLocation(480, 612)
    GetColorAndLocationAtMouse()
return


#Include AdventurersGuild.ahk
