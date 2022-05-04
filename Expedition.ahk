
; =======================================
; Expedition controls
; =======================================

; Collect all expedition rewards
NumpadSub::
    ReceiveReward(WhisperingWoodsExpedition)
    ReceiveReward(StormterrorLairExpedition)
    ReceiveReward(DihuaMarshExpedition)
    ReceiveReward(JueyunKarstExpedition)
    ReceiveReward(JinrenIslandExpedition)
return

; Send everyone on all the expeditions
NumpadAdd::
    duration := 0   ; 0 or Duration20H
    SendOnExpedition(WhisperingWoodsExpedition, 2, duration)
    SendOnExpedition(StormterrorLairExpedition, 1, duration)
    SendOnExpedition(DihuaMarshExpedition, 1, duration)
    SendOnExpedition(JueyunKarstExpedition, 2, duration)
    SendOnExpedition(JinrenIslandExpedition, 1, duration)
return


; =======================================
; Expedition utility functions
; =======================================

SelectExpedition(expedition) {
    global expeditionMapSelected
    
    ; Click on the world
    if (expedition.map != expeditionMapSelected)
    {
        WorldY := 160*1.333 + (expedition.map * 72*1.333)   ; initial position + offset between lines        
        MouseClick, left, 200*1.333, WorldY
        Sleep, 200
        
        expeditionMapSelected := expedition.map
        
        if (expedition.isFirstOnMap)
        {
            return
        }
    }
    
    ; Click on the expedition
    MouseClick, left, expedition.x, expedition.y
    Sleep, 200
}

SelectDuration(duration) {
    MouseClick, left, duration.x, duration.y
    Sleep, 200
}

; Send character to an expedition.
; characterNumberInList - starts from 1.
SendOnExpedition(expedition, characterNumberInList, duration := 0) {
    SelectExpedition(expedition)

    if (duration != 0)
        SelectDuration(duration)

    ; Click on "Select Character"
    ClickOnBottomRightButton()
    Sleep, 200

    ; Find and select the character
    FindAndSelectCharacter(characterNumberInList)
    Sleep, 200
}

FindAndSelectCharacter(characterNumberInList) {
    firstCharacterX := 100*1.333
    firstCharacterX := 150*1.333
    spacingBetweenCharacters := 125*1.333

    if (characterNumberInList <= 7) {
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

ReceiveReward(expedition) {
    SelectExpedition(expedition)

    ; receive reward
    ClickOnBottomRightButton()
    Sleep, 200

    ;skip reward menu
    Send, {Esc}
    Sleep, 500
}