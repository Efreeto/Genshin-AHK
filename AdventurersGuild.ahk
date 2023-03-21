
; =======================================
; Expedition controls
; =======================================

NumpadAdd::
CollectExpeditionRewardsAndSendExpeditions()
return

CollectKatheryneRewards()
{
    loop
    {
        Send, {f}   ; talk to Katherine
        SkipKatherineDialogue()

        if (CheckCommissionRewards_AtMondstadtOrLiyue())
        {
            ScreenClick(1280, 410)  ; Select Commissions from Mondstadt or Liyue's Katheryne menu
            CollectCommissionRewards()
        }
        else if (CheckExpeditionRewards_AtMondstadtOrLiyue())
        {
            ScreenClick(1280, 540)   ; Select Expeditions from Mondstadt or Liyue's Katheryne menu
            CollectExpeditionRewardsAndSendExpeditions()
        }
        else if (CheckCommissionRewards_AtInazumaOrSumeru())
        {
            ScreenClick(1280, 350)  ; Select Commissions from Inazuma or Sumeru's Katheryne menu
            CollectCommissionRewards()
        }
        else if (CheckExpeditionRewards_AtInazumaOrSumeru())
        {
            ScreenClick(1280, 480)   ; Select Expeditions from Inazuma or Sumeru's Katheryne menu
            CollectExpeditionRewardsAndSendExpeditions()
        }
        else
        {
            SoundPlay, %A_WinDir%\Media\Speech Sleep.wav
            ScreenClick(1150, 670)  ; Exit Katherine
            Sleep, 500
            Send, {f}   ; Skip dialogue
            Sleep, 200
            Send, {f}   ; Close dialogue
            break
        }
    }
}

SkipKatherineDialogue() {
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

CollectCommissionRewards()
{
    Sleep, 500
    Send, {f}   ; Skip dialogue
    Sleep, 200
    CheckEscPressedAndExit()
    Send, {f}   ; Close dialogue
    Sleep, 1500
    Send, {Esc}
}

CollectExpeditionRewardsAndSendExpeditions()
{
    ;; Expeditions ;;
    ; Mora
    StormterrorLair := { map: 0, x: 458, y: 333 }
    GuiliPlains := { map: 1, x: 667, y: 458 }
    JueyunKarst := { map: 1, x: 470, y: 470}
    JinrenIsland := { map: 2, x: 914, y: 228, isFirstOnMap: true }
    Tatarasuna := { map: 2, x: 690, y: 690 }
    ArdraviValley := { map: 3, x: 860, y: 510 }

    ; Crystals
    WhisperingWoods := { map: 0, x: 875, y: 275, isFirstOnMap: true }
    DadaupaGorge := { map: 0, x: 975, y: 550 }
    YaoguangShoal := { map: 1, x: 792, y: 375 }

    ; Food
    Windrise := { map: 0, x: 926, y: 379 }
    DihuaMarsh := { map: 1, x: 607, y: 277, isFirstOnMap: true }

    ;; Conditions ;;
    expeditions := [StormterrorLair, GuiliPlains, JinrenIsland, Tatarasuna, ArdraviValley] ; Choose 5 expeditions
    duration := 0    ; Choose 'duration' from 4, 8, 12, or 20. Or choose 0 to skip selection and use the last used duration
    expeditionMapSelected := -1 ; Assume no map was selected and select the map of the first expedition

    Sleep, 600

    For i, expedition in expeditions
    {
        CheckEscPressedAndExit()    ; Hold Esc to cancel script
        ReceiveReward(expedition)
    }

    For i, expedition in expeditions
    {
        CheckEscPressedAndExit()    ; Hold Esc to cancel script
        SendOnExpedition(expedition, duration)
    }

    Send, {Esc} ; Exit
}


; =======================================
; Expedition utility functions
; =======================================

CheckCommissionRewards_AtMondstadtOrLiyue()
{
    lang := DetectDisplayLanguage()
    if (lang == "KR")
    {
        PixelSearch, varX, varY, X(1113), Y(425), X(1113), Y(425), 0x00FFFF, 0
        if ErrorLevel
            return false

        PixelSearch, varX, varY, X(1334), Y(427), X(1334), Y(427), 0x00FFFF, 0
        if ErrorLevel
            return false

        return true
    }
    else    ; "EN"
    {
        PixelSearch, varX, varY, X(1109), Y(424), X(1109), Y(424), 0x00FFFF, 0
        if ErrorLevel
            return false

        PixelSearch, varX, varY, X(1495), Y(412), X(1495), Y(412), 0x00FFFF, 0
        if ErrorLevel
            return false

        return true
    }
}

CheckCommissionRewards_AtInazumaOrSumeru()
{
    lang := DetectDisplayLanguage()
    if (lang == "KR")
    {
        PixelSearch, varX, varY, X(1112), Y(363), X(1112), Y(363), 0x00FFFF, 0
        if ErrorLevel
            return false

        PixelSearch, varX, varY, X(1215), Y(350), X(1215), Y(350), 0x00FFFF, 0
        if ErrorLevel
            return false

        return true
    }
    else    ; "EN"
    {
        PixelSearch, varX, varY, X(1120), Y(351), X(1120), Y(351), 0x00FFFF, 0
        if ErrorLevel
            return false

        PixelSearch, varX, varY, X(1496), Y(360), X(1496), Y(360), 0x00FFFF, 0
        if ErrorLevel
            return false

        return true
    }
}

CheckExpeditionRewards_AtMondstadtOrLiyue()
{
    lang := DetectDisplayLanguage()
    if (lang == "KR")
    {
        PixelSearch, varX, varY, X(1110), Y(540), X(1110), Y(540), 0x00FFFF, 0
        if ErrorLevel
            return false

        PixelSearch, varX, varY, X(1198), Y(539), X(1198), Y(539), 0x00FFFF, 0
        if ErrorLevel
            return false

        return true
    }
    else    ; "EN"
    {
        PixelSearch, varX, varY, X(1110), Y(537), X(1110), Y(537), 0x00FFFF, 0
        if ErrorLevel
            return false

        PixelSearch, varX, varY, X(1503), Y(546), X(1503), Y(546), 0x00FFFF, 0
        if ErrorLevel
            return false

        return true
    }
}

CheckExpeditionRewards_AtInazumaOrSumeru()
{
    lang := DetectDisplayLanguage()
    if (lang == "KR")
    {
        PixelSearch, varX, varY, X(1122), Y(488), X(1122), Y(488), 0x00FFFF, 0
        if ErrorLevel
            return false

        PixelSearch, varX, varY, X(1193), Y(477), X(1193), Y(477), 0x00FFFF, 0
        if ErrorLevel
            return false

        return true
    }
    else    ; "EN"
    {
        PixelSearch, varX, varY, X(1120), Y(483), X(1120), Y(483), 0x00FFFF, 0
        if ErrorLevel
            return false

        PixelSearch, varX, varY, X(1383), Y(476), X(1383), Y(476), 0x00FFFF, 0
        if ErrorLevel
            return false

        return true
    }
}

ReceiveReward(expedition)
{
    pause1 := 160

    mapWasChanged := SelectMap(expedition)
    Sleep, %pause1%

    ; If there's a reward waiting on the expedition (and is before the next expedition, which is not implemented yet), the expedition must be already selected after the map change
    if (!mapWasChanged)
    {
        ScreenClick(expedition.x, expedition.y) ; Click on the expedition location
    }

    ClickOnBottomRightButton()  ; Receive reward
    Sleep, %pause1%

    Send, {Esc} ; Skip reward menu
    Sleep, %pause1%
}

SelectMap(expedition)
{
    global expeditionMapSelected

    if (expedition.map != expeditionMapSelected)
    {
        WorldY := 133.3 + (expedition.map * 60)   ; initial position + offset between lines
        ScreenClick(166.7, WorldY)
        Sleep, 200

        expeditionMapSelected := expedition.map

        return true
    }
    return false
}

SendOnExpedition(expedition, duration) {
    mapWasChanged := SelectMap(expedition)
    Sleep, 170

    ; If the current expedition is the first one on the map, the expedition must be already selected after the map change
    if (!(mapWasChanged && expedition.isFirstOnMap))
    {
        ScreenClick(expedition.x, expedition.y) ; Click on the expedition location
    }

    SelectDuration(duration)

    ClickOnBottomRightButton()  ; Click on "Select Character"
    Sleep, 170

    characterNumberInList := 1
    if (!mapWasChanged)
    {
        characterNumberInList := 2
    }
    FindAndSelectCharacter(characterNumberInList)
    Sleep, 225
}

SelectDuration(duration) {
    Switch duration {
        Case 0:
            return
        Case 4:
            ScreenClick(1250, 583)
            Sleep, 150
            return
        Case 20:
            ScreenClick(1500, 583)
            Sleep, 150
            return
        Default :
            MsgBox, Choose 'duration' from 4, 8, 12, or 20. Or choose 0 to skip selection and use the last used duration
            return
    }
}

; characterNumberInList - starts from 1.
FindAndSelectCharacter(characterNumberInList) {
    firstCharacterX := 125
    firstCharacterY := 125
    spacingBetweenCharacters := 117

    ScreenClick(firstCharacterX, firstCharacterY + (spacingBetweenCharacters * (characterNumberInList - 1)))
}