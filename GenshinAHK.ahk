; To run on Windows startup
; Create a shortcut in C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp
; or in C:\Users\{username}\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup
; with
; 'Target': "C:\{AutoHotkey install location}\AutoHotkey.exe" "GenshinAHK.ahk"
; 'Start in:': {this location}
; and change property of "C:\{AutoHotkey install location}\AutoHotkey.exe" > Compatibility > Run as Administrator
;
; To reload the script when developing it
; Create a short cut in desktop
; with
; 'Target': "{this location}\GenshinAHK.ahk"
; 'Start in:': {this location}

#HotIf WinActive("ahk_exe GenshinImpact.exe")
#SingleInstance

if not A_IsAdmin
{
    Run("*RunAs `"" A_ScriptFullPath "`"")  ; Requires v1.0.92.01+
    ExitApp()
}

SetTimer(Initialize,-1)

Initialize()
{
    ConfigureTeamHotkeys()
}

GetFileName()
{
    activeprocess := WinGetProcessName("A")
    MsgBox("The active ahk_exe is `"" activeprocess "`".")
    ; "GenshinImpact.exe"
}

GetWinName()
{
    winTitle := WinGetTitle("A")
    MsgBox("The active window is `"" winTitle "`".")
    ; "Genshin Impact", "원신"
}

DetectDisplayLanguage()
{
    winTitle := WinGetTitle("A")
    if (winTitle == "Genshin Impact")
        return "EN"
    else ; "원신"
        return "KR"
}

X(posX)
{
    return Round(A_ScreenWidth * posX / 1600)
}

Y(posY)
{
    return Round(A_ScreenHeight * posY / 900)
}

ScreenClick(posX, posY)
{
    MouseClick("left", X(posX), Y(posY))
}

ScreenMove(posX, posY)
{
    MouseMove(X(posX), Y(posY), 0)  ; Speed param: 0 is instant, default is 2
}

ClickOnBottomRightButton()
{
    ScreenClick(1400, 850)
}

IsColorAtPosition(posX, posY, rgb, variation := 0)
{
    if (variation == 0)
    {
        color := PixelGetColor(X(posX), Y(posY))
        return color = rgb
    }
    else
    {
        ErrorLevel := !PixelSearch(&_, &_, X(posX), Y(posY), X(posX), Y(posY), rgb, variation)
        return !ErrorLevel
    }
}

IsNearTalkableNPC()
{
    return IsColorAtPosition(992, 440, 0xFFFFFF)
        and IsColorAtPosition(992, 454, 0xFFFFFF)
}

SkipDialogue()
{
    ; wait for dialogue to load a bit
    lang := DetectDisplayLanguage()
    if (lang == "KR") {
        Sleep(500)
    } else {    ; "EN"
        Sleep(700)
    }

    Send("{f}")   ; load the whole dialogue
    Sleep(200)
    Send("{f}")   ; skip the dialogue
}

SelectFirstDialogueOption()
{
    ScreenClick(1082, 546)
}

ReputationShortcut()
{
    if (!IsNearTalkableNPC())
    {
        return
    }

    Send("{f}")   ; talk to NPC
    SkipDialogue()
    SkipDialogue()

    Sleep(1000)
    SelectFirstDialogueOption()
    SkipDialogue()
    Exit()
}

SpecialInteraction1()
{
    ; Perform special interaction
    ReputationShortcut()

    ; Act as the middle mouse button (Elemental Vision) if the above doesn't happen
    Send("{MButton down}")
    while (GetKeyState(A_ThisHotkey, "P"))
    {
    }
    Send("{MButton up}")
}

SpecialInteraction2()
{
    if (CheckCommissionRewards_AtMondstadtOrLiyue())
    {
        ScreenClick(1280, 410)  ; Select Commissions from Mondstadt or Liyue's Katheryne menu
        Sleep(500)
        CollectCommissionRewards()
    }
    else if (CheckCommissionRewards_AtInazumaOrSumeru())
    {
        ScreenClick(1280, 350)  ; Select Commissions from Inazuma or Sumeru's Katheryne menu
        Sleep(500)
        CollectCommissionRewards()
    }
    else if (CheckExpeditionRewards_AtMondstadtOrLiyue())
    {
        ScreenClick(1280, 540)   ; Select Expeditions from Mondstadt or Liyue's Katheryne menu
        Sleep(500)
        CollectExpeditionRewardsAndSendExpeditions()
    }
    else if (CheckExpeditionRewards_AtInazumaOrSumeru())
    {
        ScreenClick(1280, 480)   ; Select Expeditions from Inazuma or Sumeru's Katheryne menu
        Sleep(500)
        CollectExpeditionRewardsAndSendExpeditions()
    }
    else if (IsNearKatheryne())
    {
        SoundPlay(A_WinDir "\Media\Speech On.wav")
        CollectKatheryneRewards()
    }
    else if (IsAtEndOfDomain())
    {
        Send("{f}")   ; collect rewards
        Sleep(50)
        ScreenClick(631, 625)    ; use condensed resin
        Sleep(125)

        if (IsColorAtPosition(1066.7, 433.3, 0x49556F))    ; bag is full
        {
            SoundPlay(A_WinDir "\Media\ding.wav")
            ScreenClick(800, 450)    ; dismiss the pop-up
            return
        }

        ScreenClick(1478, 47)
        Sleep(125)
        ScreenClick(1478, 47)
        Sleep(150)
        ScreenClick(1478, 47)
        Sleep(150)
        ScreenClick(1478, 47)   ; skip

        ScreenMove(1000, 837)   ; put cursor at Continue challenge(sic)
        Exit()
    }

    TeleportShortcut()
}

; =======================================
; Enable/disable contextual bindings
; =======================================

Member1 := "regular"
Member4 := "regular"

NumPad1::
{
Member1 := "hutao"
SoundPlay(A_WinDir "\Media\chimes.wav")
ConfigureTeamHotkeys()
return
}

NumPad2::
{
Member1 := "klee"
SoundPlay(A_WinDir "\Media\tada.wav")
ConfigureTeamHotkeys()
return
}

NumPad4::
{
Member4 := "ganyu"
SoundPlay(A_WinDir "\Media\Windows Exclamation.wav")
ConfigureTeamHotkeys()
return
}

NumPad0::
{
Member1 := "regular"
Member4 := "regular"
SoundPlay(A_WinDir "\Media\Windows Error.wav")
ConfigureTeamHotkeys()
return
}

ConfigureTeamHotkeys()
{
    global Member1
    global Member4
    ThisHotkey := ""

    if (Member1 == "hutao")
    {
        Hotkey("~1", ActivateHuTao)
        ActivateHuTao(ThisHotkey)
    }
    else if (Member1 == "klee")
    {
        Hotkey("~1", ActivateKlee)
        ActivateKlee(ThisHotkey)
    }
    else
    {
        Hotkey("~1", ActivateRegularCharacter)
        ActivateRegularCharacter(ThisHotkey)
    }

    Hotkey("~q", ActivateRegularCharacter)

    Hotkey("~3", ActivateRegularCharacter)

    if (Member4 == "ganyu")
    {
        Hotkey("~e", ActivateGanyu)
    }
    else
    {
        Hotkey("~e", ActivateRegularCharacter)
    }
}

ActivateRegularCharacter(ThisHotkey)
{
    Hotkey("F18", Regular_AutoAttack)
    Hotkey("F19", HuTao_ChargeAttack_N2DC)
}

ActivateHuTao(ThisHotkey)
{
    Hotkey("F18", HuTao_ChargeAttack_N1JC)
    Hotkey("F19", HuTao_ChargeAttack_N2DC)
}

ActivateKlee(ThisHotkey)
{
    Hotkey("F18", Klee_AutoAttack)
    Hotkey("F19", Klee_ChargeAttack)
}

ActivateGanyu()
{
    Hotkey("F18", Regular_AutoAttack)
    Hotkey("F19", Ganyu_ChargeAttack)
}

; Hu Tao jump cancel
HuTao_ChargeAttack_N1JC(ThisHotkey)
{
    pause1 := 450
    pause2 := 600
    while (GetKeyState(ThisHotkey, "P"))
    {
        Click("down")
        Sleep(pause1)
        Send("{Space}")
        Click("up")
        Sleep(pause2)
    }
}

; Hu Tao dash cancel (Need Constellation 1)
HuTao_ChargeAttack_N2DC(ThisHotkey)
{
    pause1 := 70
    pause2 := 350
    pause3 := 500
    while (GetKeyState(ThisHotkey, "P"))
    {
        Click()
        Sleep(pause1)
        Click()
        Sleep(pause1)
        Click()
        Sleep(pause1)
        Click("down")
        Sleep(pause2)
        Click("right")
        Click("up")
        Sleep(pause3)
    }
}

; Hu Tao Blood Blossom cancel (Need Constellation 1)
; Good at 230ms, not working at 74ms
HuTao_ChargeAttack_N2C(ThisHotkey)
{
    Click()
    Sleep(30)
    Click()
    Sleep(30)
    Click()
    Sleep(30)
    Click()
    Sleep(30)
    Click()
    Sleep(30)
    Click()
    Sleep(30)
    Click("down")
    Sleep(350)
    Click("right")
    Sleep(50)
    Click("up")
    ;Sleep, 200  ; 150
}

HuTao_ChargeAttack_N1C(ThisHotkey)
{
    ; Hu Tao Blood Blossom cancel (Need Constellation 1)
    Click("down")
    Sleep(550)  ; 600
    Click("up")
    Click("right")
}

; Hu Tao Blood Blossom cancel (Need Constellation 1)
HuTao_ChargeAttack_N1C_Hold(ThisHotkey)
{
    hk := SubStr(ThisHotkey, 2)  ; remove '~'
    while (GetKeyState(hk, "P")) {
        Click("down")
        Sleep(600)  ; 600
        Click("up")
        Click("right")
        Sleep(175)  ; 150
    }
}

HuTao_ChargeAttack_Frozen(ThisHotkey)
{
    hk := SubStr(ThisHotkey, 2)  ; remove '~'
    numCycle := 0
    Loop
    {
        if (numCycle < 2)
        {
            Click("down")
            Sleep(425)
            if (not GetKeyState(hk, "P"))
                break
            Click("right")
            Sleep(300)
            if (not GetKeyState(hk, "P"))
                break
            Click("up")
            Sleep(200)  ; 175
            ;numCycle++
        }
        else
        {
            HuTao_ChargeAttack_N2C(ThisHotkey)
            numCycle := 0
        }
        if (not GetKeyState(hk, "P"))
            break
    }
}

Klee_ChargeAttack(ThisHotkey)
{
    while (GetKeyState(ThisHotkey, "P"))
    {
        Click("down")
        Sleep(500)  ; 500
        Click("up")
        Send("{Space}")
        Sleep(575)  ; 550
    }
}

; Hold to animation cancel elemental skills
RapidCanceling_ElementalSkill(ThisHotkey)
{
    ; Send, {[}
    Click("right")   ; OR Send, {Space}
    Sleep(30)
}

Regular_ElementalSkill(ThisHotkey)
{
    Send("{[ down}")
    while (GetKeyState(ThisHotkey, "P"))
    {
        ; pass
    }
    Send("{[ up}")
}

Ganyu_ChargeAttack(ThisHotkey)
{
    hk := SubStr(ThisHotkey, 2)  ; remove '~'
    Click()    ; Apply a normal attack element, if any
    Sleep(30)
    Click("down")
    KeyWait(hk)  ; (AHK bug) KeyWait doesn't work with variables
    TimeSinceKeyPressed := A_TimeSinceThisHotkey
    if (TimeSinceKeyPressed < 2000) {
        ; hold LMB minimum for 2000ms
        Sleep(2000 - TimeSinceKeyPressed)
    }
    while (GetKeyState(hk, "P")) {
        ; Hold LMB if hotkey is still pressed. I think this can be deleted?
    }
    Click("up")
}

Regular_ChargeAttack(ThisHotkey)
{
    hk := SubStr(ThisHotkey, 2)  ; remove '~'
    Click("down")
    KeyWait(hk)  ; (AHK bug) KeyWait doesn't work with variables
    TimeSinceKeyPressed := A_TimeSinceThisHotkey
    if (TimeSinceKeyPressed < 370)    ; 350
    {
        ; Hold LMB minimum for 370ms
        Sleep(370 - TimeSinceKeyPressed)
    }
    Click("up")
}

; Klee walk cancel
Klee_AutoAttack(ThisHotkey)
{
    ; if (IsCharacterSlowed())
    ;     pause1 := 590    ; at 84-88ms
    ; else
    ;     pause1 := 508    ; at 84-88ms

    pause1 := 510

    while (GetKeyState(ThisHotkey, "P"))
    {
        Click()
        Sleep(pause1)
    }
}

; Klee jump cancel
Klee_AutoAttack2(ThisHotkey)
{
    while (GetKeyState(ThisHotkey, "P"))
    {
        Click()
        Sleep(35)
        Send("{Space}")
        Sleep(550)
    }
}

Regular_AutoAttack(ThisHotkey)
{
    while (GetKeyState(ThisHotkey, "P"))
    {
        Click()
        Sleep(25)
    }
}

IsCharacterSlowed()
{
    ErrorLevel := !PixelSearch(&varX, &varY, X(6.88), Y(8.06), X(6.89), Y(8.07), 0xFDFDCD, 8, )
    return !ErrorLevel
}

IsNearKatheryne()
{
    ErrorLevel := !PixelSearch(&varX, &varY, X(9.88), Y(4.53), X(9.88), Y(4.53), 0xFFFFFF, 0, )
    if ErrorLevel
        return false

    ErrorLevel := !PixelSearch(&varX, &varY, X(9.29), Y(4.43), X(9.29), Y(4.43), 0x626262, 0, )
    if ErrorLevel
        return false

    return true
}

IsAtEndOfDomain()
{
    return IsColorAtPosition(992, 456, 0xFFFFFF)
        and IsColorAtPosition(990, 440, 0x475A70)
}

; =======================================
; Regular actions
; =======================================

TypingMode := false
; Hold to unfreeze self
Space::
{
    global TypingMode
    Send("{Space down}")
    if (TypingMode)
    {
        while (GetKeyState(A_ThisHotkey, "P"))
        {
            if (A_TimeSinceThisHotkey > 750)
            {
                ; Disable typing mode if pressed for a long time
                DisableTypingMode()
                break
            }
        }
        Send("{Space up}")
        return
    }
    else
    {
        Sleep(250) ; Repeat delay
    }

    Send("{Space up}")
    while GetKeyState(A_Space, "P")
    {
        Send("{Space}") ; Repeated keydowns
        Sleep(30) ; Repeat rate
    }
    return
}

; Enable typing mode
~Backspace::
{
EnableTypingMode()
return
} ; Added bracket before function

EnableTypingMode() {
    global TypingMode
    if (!TypingMode) {
        SoundPlay(A_WinDir "\Media\Windows User Account Control.wav")
        TypingMode := true
    }
}

DisableTypingMode() {
    global TypingMode
    if (TypingMode) {
        SoundPlay(A_WinDir "\Media\Windows Notify Calendar.wav")
        TypingMode := false
    }
}

CheckTypingModeAndExit() {
    global TypingMode
    if (TypingMode) {
        Exit()
    }
}

; Hold during a script run to cancel the script
CheckForCancelAndExit() {
    if (GetKeyState("NumpadEnter", "P")) {
        SoundPlay(A_WinDir "\Media\Speech Off.wav")
        Exit()
    }
}

; Non-repeated space key for flying upwards and exiting boat
LShift::Space

;F13::RapidCanceling_ElementalSkill()   ; Not bound to my mouse

F14::[

F15::]

F16::SpecialInteraction1()

F17::SpecialInteraction2()

; HDR Screenshot
PrintScreen::!#PrintScreen

; For keyboards without a PrintScreen key
F12::!PrintScreen

{
#Include "AdventurersGuild.ahk"
#Include "MapNavigation.ahk"
#Include "TestFunctions.ahk"
#Include "HonkaiStarRail.ahk"
}
