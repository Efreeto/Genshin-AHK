
; =======================================
; Expedition controls
; =======================================

NumpadAdd::
CollectExpeditionRewardsAndSendExpeditions()
return

CollectCommissionRewards() {
    ScreenClick(0.8, 0.45)  ; Commissions option from Mondstadt or Liyue, not Inazuma
    Sleep, 500
    Send, {f}   ; skip dialogue
    Sleep, 200
    CheckEscPressedAndExit()
    Send, {f}   ; close dialogue
    Sleep, 1500
    Send, {Esc}
}

CollectExpeditionRewardsAndSendExpeditions() {
    ;; Definitions ;;
    ; Expeditions (crystals)
    WhisperingWoodsExpedition := { map: 0, x: 1050*1.333, y: 330*1.333, isFirstOnMap: true }
    DadaupaGorgeExpedition := { map: 0, x: 1170*1.333, y: 660*1.333 }
    yaoguangShoalExpedition := { map: 1, x: 950*1.333, y: 450*1.333 }

    ; Expeditions (mora)
    StormterrorLairExpedition := { map: 0, x: 550*1.333, y: 400*1.333 }
    GuiliPlainsExpedition := { map: 1, x: 800*1.333, y: 550*1.333 }
    JueyunKarstExpedition := { map: 1, x: 559*1.333, y: 561*1.333 }
    JinrenIslandExpedition := { map: 2, x: 1097*1.333, y: 274*1.333, isFirstOnMap: true }
    TarasunaExpedition := { map: 2, x: 828*1.333, y: 828*1.333 }

    ; Expeditions (food)
    WindriseExpedition := { map: 0, x: 1111*1.333, y: 455*1.333 }
    DihuaMarshExpedition := { map: 1, x: 728*1.333, y: 332*1.333, isFirstOnMap: true }

    ;; Actions ;;
    ScreenClick(0.8, 0.6)   ; Expedition option from Mondstadt/Liyue
    Sleep, 500

    expeditionMapSelected := -1 ; Assume no map was selected by default
    CheckEscPressedAndExit()
    ReceiveReward(WhisperingWoodsExpedition)
    CheckEscPressedAndExit()    ; hold Esc to cancel script
    ReceiveReward(StormterrorLairExpedition)
    CheckEscPressedAndExit()
    ReceiveReward(GuiliPlainsExpedition)
    CheckEscPressedAndExit()
    ReceiveReward(JueyunKarstExpedition)
    CheckEscPressedAndExit()
    ReceiveReward(JinrenIslandExpedition)

    ; Choose 'duration' from 4, 8, 12, or 20. Or choose 0 to skip selection and use the last used duration
    duration := 0

    CheckEscPressedAndExit()
    SendOnExpedition(WhisperingWoodsExpedition, 2, duration)
    CheckEscPressedAndExit()
    SendOnExpedition(StormterrorLairExpedition, 1, duration)
    CheckEscPressedAndExit()
    SendOnExpedition(GuiliPlainsExpedition, 1, duration)
    CheckEscPressedAndExit()
    SendOnExpedition(JueyunKarstExpedition, 2, duration)
    CheckEscPressedAndExit()
    SendOnExpedition(JinrenIslandExpedition, 1, duration)

    Send, {Esc}
}


; =======================================
; Expedition utility functions
; =======================================

SelectExpedition(expedition, calledFromReceiveReward := false) {
    global expeditionMapSelected

    ; Click on the world
    if (expedition.map != expeditionMapSelected)
    {
        WorldY := 160*1.333 + (expedition.map * 72*1.333)   ; initial position + offset between lines
        MouseClick, left, 200*1.333, WorldY
        Sleep, 200

        expeditionMapSelected := expedition.map

        ; If the current expedition is the first one on the map, or if this was called from ReceiveReward(), the expedition must be already selected after the map change
        if (expedition.isFirstOnMap || calledFromReceiveReward)
            return
    }

    ; Click on the expedition
    MouseClick, left, expedition.x, expedition.y
}

SelectDuration(duration := 0) {
    switch duration
    {
        case 0:
            return
        case 4:
            MouseClick, left, 1500*1.333, 700*1.333
            Sleep, 150
            return
        case 20:
            MouseClick, left, 1800*1.333, 700*1.333
            Sleep, 150
            return
        Default:
            MsgBox, Choose 'duration' from 4, 8, 12, or 20. Or choose 0 to skip selection and use the last used duration
            return
    }
}

ReceiveReward(expedition) {
    SelectExpedition(expedition, true)
    Sleep, 170

    ; receive reward
    ClickOnBottomRightButton()
    Sleep, 170

    ; skip reward menu
    Send, {Esc}
    Sleep, 170
}

; characterNumberInList - starts from 1.
SendOnExpedition(expedition, characterNumberInList, duration := 0) {
    SelectExpedition(expedition)
    Sleep, 170

    SelectDuration(duration)

    ClickOnBottomRightButton()  ; click on "Select Character"
    Sleep, 170

    ; Find and select the character
    FindAndSelectCharacter(characterNumberInList)
    Sleep, 225
}

FindAndSelectCharacter(characterNumberInList) {
    firstCharacterX := 100*1.333
    firstCharacterX := 150*1.333
    spacingBetweenCharacters := 140

    if (characterNumberInList <= 9) {
        MouseClick, left, firstCharacterX, firstCharacterX + (spacingBetweenCharacters * (characterNumberInList - 1))
    } else {
        ScrollDownCharacterList(characterNumberInList - 7.5)
        MouseClick, left, firstCharacterX, firstCharacterX + (spacingBetweenCharacters * 7)
    }
}

; Scroll down the passed number of characters
ScrollDownCharacterList(characterAmount) {
    MouseMove, 950*1.333, 540*1.333

    ScrollAmount := characterAmount * 7
    Loop %ScrollAmount% {
        Send, {WheelDown}
        Sleep, 10
    }
}