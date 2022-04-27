
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
    Duration := Duration20H
    SendOnExpedition(WhisperingWoodsExpedition, 2, Duration)
    SendOnExpedition(StormterrorLairExpedition, 1, Duration)
    SendOnExpedition(DihuaMarshExpedition, 1, Duration)
    SendOnExpedition(JueyunKarstExpedition, 2, Duration)
    SendOnExpedition(JinrenIslandExpedition, 1, Duration)
return


; =======================================
; Expedition utility functions
; =======================================

SelectExpedition(Expedition) {
    ; Click on the world
    WorldY := 160*1.333 + (Expedition["MapNumber"] * 72*1.333) ; initial position + offset between lines
	
    MouseClick, left, 200*1.333, WorldY
    Sleep, 200

    ; Click on the expedition
    MouseClick, left, Expedition["X"], Expedition["Y"]
    Sleep, 200
}

SelectDuration(Duration) {
    MouseClick, left, Duration["X"], Duration["Y"]
    Sleep, 200
}

; Send character to an expedition.
; CharacterNumberInList - starts from 1.
SendOnExpedition(Expedition, CharacterNumberInList, Duration) {
    SelectExpedition(Expedition)

    SelectDuration(Duration)

    ; Click on "Select Character"
    ClickOnBottomRightButton()
    Sleep, 200

    ; Find and select the character
    FindAndSelectCharacter(CharacterNumberInList)
    Sleep, 200
}

FindAndSelectCharacter(CharacterNumberInList) {
    FirstCharacterX := 100*1.333
    FirstCharacterY := 150*1.333
    SpacingBetweenCharacters := 125*1.333

    if (CharacterNumberInList <= 7) {
        MouseClick, left, FirstCharacterX, FirstCharacterY + (SpacingBetweenCharacters * (CharacterNumberInList - 1))
    } else {
        ScrollDownCharacterList(CharacterNumberInList - 7.5)
        MouseClick, left, FirstCharacterX, FirstCharacterY + (SpacingBetweenCharacters * 7)
    }
}

; Scroll down the passed number of characters
ScrollDownCharacterList(CharacterAmount) {
    MouseMove, 950*1.333, 540*1.333

    ScrollAmount := CharacterAmount * 7
    Loop %ScrollAmount% {
        Send, {WheelDown}
        Sleep, 10
    }
}

ReceiveReward(Expedition) {
    SelectExpedition(Expedition)

    ; receive reward
    ClickOnBottomRightButton()
    Sleep, 200

    ;skip reward menu
    Send, {Esc}
    Sleep, 500
}