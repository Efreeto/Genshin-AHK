
; =======================================
; Expedition controls
; =======================================

NumpadAdd::
CollectExpeditionRewardsAndSendExpeditions()
return

CollectCommissionRewards() {
    ScreenClick(12.8, 4.05)  ; Commissions option from Mondstadt or Liyue, not Inazuma
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
    WhisperingWoodsExpedition := { map: 0, x: 8.75, y: 2.75, isFirstOnMap: true } ; 1920 x 1080
    DadaupaGorgeExpedition := { map: 0, x: 9.75, y: 5.5 }
    yaoguangShoalExpedition := { map: 1, x: 7.92, y: 3.75 }

    ; Expeditions (mora)
    StormterrorLairExpedition := { map: 0, x: 4.58, y: 3.33 }
    GuiliPlainsExpedition := { map: 1, x: 6.67, y: 4.58 }
    JueyunKarstExpedition := { map: 1, x: 4.69, y: 4.675}
    JinrenIslandExpedition := { map: 2, x: 9.14, y: 2.28, isFirstOnMap: true }
    TarasunaExpedition := { map: 2, x: 6.9, y: 6.9 }

    ; Expeditions (food)
    WindriseExpedition := { map: 0, x: 9.26, y: 3.79 }
    DihuaMarshExpedition := { map: 1, x: 6.07, y: 2.77, isFirstOnMap: true }

    ;; Actions ;;
    ScreenClick(12.8, 5.4)   ; Expedition option from Mondstadt/Liyue
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
    duration := 20

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
        WorldY := 1.333 + (expedition.map * 0.6)   ; initial position + offset between lines
        ScreenClick(1.667, WorldY)
        Sleep, 200

        expeditionMapSelected := expedition.map

        ; If the current expedition is the first one on the map, or if this was called from ReceiveReward(), the expedition must be already selected after the map change
        if (expedition.isFirstOnMap || calledFromReceiveReward)
            return
    }

    ; Click on the expedition
    ScreenClick(expedition.x, expedition.y)
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
    firstCharacterX := 1.25
    firstCharacterY := 1.25
    spacingBetweenCharacters := 1.17

    if (characterNumberInList <= 9) {
        ScreenClick(firstCharacterX, firstCharacterY + (spacingBetweenCharacters * (characterNumberInList - 1)))
    } else {
        ScrollDownCharacterList(characterNumberInList - 7.5)
        ScreenClick(firstCharacterX, firstCharacterY + (spacingBetweenCharacters * 7))
    }
}

; Scroll down the passed number of characters
ScrollDownCharacterList(characterAmount) {
    MouseMove, X(7.92), Y(4.5)

    ScrollAmount := characterAmount * 7
    Loop %ScrollAmount% {
        Send, {WheelDown}
        Sleep, 10
    }
}