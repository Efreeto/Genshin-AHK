
; =======================================
; Expedition controls
; =======================================

NumpadAdd::
CollectExpeditionRewardsAndSendExpeditions()
return

CollectKatheryneRewards()
{
    Loop
    {
        Send, {f}   ; talk to Katherine
        SkipDialogue()

        if (CheckCommissionRewards_AtMondstadtOrLiyue())
        {
            ScreenClick(12.8, 4.1)  ; Select Commissions from Mondstadt or Liyue's Katheryne menu
            Sleep, 500
            CollectCommissionRewards()
        }
        else if (CheckCommissionRewards_AtInazumaOrSumeru())
        {
            ScreenClick(12.8, 3.5)  ; Select Commissions from Inazuma or Sumeru's Katheryne menu
            Sleep, 500
            CollectCommissionRewards()
        }
        else if (CheckExpeditionRewards_AtMondstadtOrLiyue())
        {
            ScreenClick(12.8, 5.4)   ; Select Expeditions from Mondstadt or Liyue's Katheryne menu
            Sleep, 500
            CollectExpeditionRewardsAndSendExpeditions()
        }
        else if (CheckExpeditionRewards_AtInazumaOrSumeru())
        {
            ScreenClick(12.8, 4.8)   ; Select Expeditions from Inazuma or Sumeru's Katheryne menu
            Sleep, 500
            CollectExpeditionRewardsAndSendExpeditions()
        }
        else
        {
            SoundPlay, %A_WinDir%\Media\Speech Sleep.wav
            break
        }
    }
}

CollectCommissionRewards()
{
    Send, {f}   ; skip dialogue
    Sleep, 200
    CheckEscPressedAndExit()
    Send, {f}   ; close dialogue
    Sleep, 1500
    Send, {Esc}
}

CollectExpeditionRewardsAndSendExpeditions()
{
    ;; Definitions ;;
    ; Expeditions (crystals)
    WhisperingWoods := { map: 0, x: 8.75, y: 2.75, isFirstOnMap: true }
    DadaupaGorge := { map: 0, x: 9.75, y: 5.5 }
    YaoguangShoal := { map: 1, x: 7.92, y: 3.75 }

    ; Expeditions (mora)
    StormterrorLair := { map: 0, x: 4.58, y: 3.33 }
    GuiliPlains := { map: 1, x: 6.67, y: 4.58 }
    JueyunKarst := { map: 1, x: 4.7, y: 4.7}
    JinrenIsland := { map: 2, x: 9.14, y: 2.28, isFirstOnMap: true }
    Tatarasuna := { map: 2, x: 6.9, y: 6.9 }
    ArdraviValley := { map: 3, x: 8.6, y: 5.1 }

    ; Expeditions (food)
    Windrise := { map: 0, x: 9.26, y: 3.79 }
    DihuaMarsh := { map: 1, x: 6.07, y: 2.77, isFirstOnMap: true }

    ;; Conditions ;;
    expeditions := [WhisperingWoods, StormterrorLair, GuiliPlains, JinrenIsland, Tatarasuna] ; Choose 5 expeditions
    duration := 0    ; Choose 'duration' from 4, 8, 12, or 20. Or choose 0 to skip selection and use the last used duration
    expeditionMapSelected := -1 ; Assume no map was selected and select the map of the first expedition

    For i, expedition in expeditions
    {
        CheckEscPressedAndExit()    ; Hold Esc to cancel script
        ReceiveReward(expedition)
    }

    For i, expedition in expeditions
    {
        CheckEscPressedAndExit()    ; Hold Esc to cancel script
        SendOnExpedition(expedition)
    }

    Send, {Esc} ; Exit
}


; =======================================
; Expedition utility functions
; =======================================

ReceiveReward(expedition)
{
    mapWasChanged := SelectMap(expedition)
    Sleep, 170

    ; If there's a reward waiting on the expedition (and is before the next expedition, which is not implemented yet), the expedition must be already selected after the map change
    if (!mapWasChanged)
    {
        ScreenClick(expedition.x, expedition.y) ; Click on the expedition location
    }

    ClickOnBottomRightButton()  ; Receive reward
    Sleep, 170

    Send, {Esc} ; Skip reward menu
    Sleep, 170
}

SelectMap(expedition)
{
    global expeditionMapSelected

    if (expedition.map != expeditionMapSelected)
    {
        WorldY := 1.333 + (expedition.map * 0.6)   ; initial position + offset between lines
        ScreenClick(1.667, WorldY)
        Sleep, 200

        expeditionMapSelected := expedition.map

        return true
    }
    return false
}

SendOnExpedition(expedition, duration := 0) {
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

SelectDuration(duration := 0) {
    Switch duration {
        Case 0:
            return
        Case 4:
            ScreenClick(12.5, 5.83)
            Sleep, 150
            return
        Case 20:
            ScreenClick(15, 5.83)
            Sleep, 150
            return
        Default :
            MsgBox, Choose 'duration' from 4, 8, 12, or 20. Or choose 0 to skip selection and use the last used duration
            return
    }
}

; characterNumberInList - starts from 1.
FindAndSelectCharacter(characterNumberInList) {
    firstCharacterX := 1.25
    firstCharacterY := 1.25
    spacingBetweenCharacters := 1.17

    ScreenClick(firstCharacterX, firstCharacterY + (spacingBetweenCharacters * (characterNumberInList - 1)))
}