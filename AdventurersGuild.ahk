
; =======================================
; Expedition controls
; =======================================

NumpadAdd::
    ;; Definitions ;;
    ; Expedition duration coordinates
    DurationLastUsed := 0
    Duration4H := { x: 1500*1.333, y: 700*1.333 }
    Duration20H := { x: 1800*1.333, y: 700*1.333 }
    
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
    
    isEscPressed := false

    ;; Actions ;;
    OpenKatheryneMenu()
    ScreenClick(0.8, 0.6)
    Sleep, 400
    
    expeditionMapSelected := -1 ; Assume no map was selected by default
    ReceiveReward(WhisperingWoodsExpedition)
    if (GetKeyState("Esc", "P"))    ; hold Esc to cancel script
        return
    ReceiveReward(StormterrorLairExpedition)
    if (GetKeyState("Esc", "P"))
        return
    ReceiveReward(GuiliPlainsExpedition)
    if (GetKeyState("Esc", "P"))
        return
    ReceiveReward(JueyunKarstExpedition)
    if (GetKeyState("Esc", "P"))
        return
    ReceiveReward(JinrenIslandExpedition)
    if (GetKeyState("Esc", "P"))
        return
    
    duration := DurationLastUsed
    SendOnExpedition(WhisperingWoodsExpedition, 2, duration)
    if (GetKeyState("Esc", "P"))
        return
    SendOnExpedition(StormterrorLairExpedition, 1, duration)
    if (GetKeyState("Esc", "P"))
        return
    SendOnExpedition(GuiliPlainsExpedition, 1, duration)
    if (GetKeyState("Esc", "P"))
        return
    SendOnExpedition(JueyunKarstExpedition, 2, duration)
    if (GetKeyState("Esc", "P"))
        return
    SendOnExpedition(JinrenIslandExpedition, 1, duration)
    if (GetKeyState("Esc", "P"))
        return
    
    Send, {Esc}
return

NumpadSub::
    OpenKatheryneMenu()
    ScreenClick(0.8, 0.45)
    Sleep, 500
    Send, {f}   ; skip dialogue
    Sleep, 200
    Send, {f}   ; close dialogue
    Sleep, 1500
    Send, {Esc}
    
    Send, {NumpadAdd}
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
            return
    }
    
    ; Click on the expedition
    MouseClick, left, expedition.x, expedition.y
}

SelectDuration(duration) {
    MouseClick, left, duration.x, duration.y
    Sleep, 150
}

; Send character to an expedition.
; characterNumberInList - starts from 1.
SendOnExpedition(expedition, characterNumberInList, duration := 0) {
    SelectExpedition(expedition)
    Sleep, 150

    if (duration != 0)
        SelectDuration(duration)
    
    ClickOnBottomRightButton()  ; click on "Select Character"
    Sleep, 200

    ; Find and select the character
    FindAndSelectCharacter(characterNumberInList)
    Sleep, 150
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

ReceiveReward(expedition) {
    SelectExpedition(expedition)
    Sleep, 150

    ; receive reward
    ClickOnBottomRightButton()
    Sleep, 200

    ; skip reward menu
    Send, {Esc}
    Sleep, 200
}

OpenKatheryneMenu() {
    Send, {f}   ; talk to Katherine
    Sleep, 500
    Send, {f}   ; skip dialogue
    Sleep, 200
    Send, {f}   ; close dialogue
    Sleep, 1000
}
