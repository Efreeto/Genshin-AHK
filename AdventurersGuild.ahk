
; =======================================
; Expedition controls
; =======================================

NumpadAdd::CollectExpeditionRewardsAndSendExpeditions()

CollectKatheryneRewards()
{
    Loop
    {
        Send("{f}")   ; talk to Katherine
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
            SoundPlay(A_WinDir "\Media\Speech Sleep.wav")
            ScreenClick(1150, 670)  ; Exit Katherine
            Sleep(500)
            Send("{f}")   ; Skip dialogue
            Sleep(200)
            Send("{f}")   ; Close dialogue
            break
        }
    }
}

SkipKatherineDialogue()
{
    lang := DetectDisplayLanguage()
    if (lang == "KR") {
        Sleep(500)
    } else {    ; "EN"
        Sleep(700)
    }

    Send("{f}")   ; skip dialogue
    Sleep(200)
    Send("{f}")   ; close dialogue
    Sleep(1000)
}

CollectCommissionRewards()
{
    Sleep(500)
    Send("{f}")   ; Skip dialogue
    Sleep(200)
    CheckForCancelAndExit()
    Send("{f}")   ; Close dialogue
    Sleep(1500)
    Send("{Esc}")
    Exit()
}


; =======================================
; Expedition utility functions
; =======================================

CheckCommissionRewards_AtMondstadtOrLiyue()
{
    If DetectHDR()
        yellowColor := 0xFFFF00
    Else
        yellowColor := 0xFFCC32
    lang := DetectDisplayLanguage()
    if (lang == "KR")
    {
        ErrorLevel := !PixelSearch(&varX, &varY, X(1113), Y(425), X(1113), Y(425), yellowColor, 0)
        if ErrorLevel
            return false

        ErrorLevel := !PixelSearch(&varX, &varY, X(1334), Y(427), X(1334), Y(427), yellowColor, 0)
        if ErrorLevel
            return false

        return true
    }
    else    ; "EN"
    {
        ErrorLevel := !PixelSearch(&varX, &varY, X(1109), Y(424), X(1109), Y(424), yellowColor, 0)
        if ErrorLevel
            return false

        ErrorLevel := !PixelSearch(&varX, &varY, X(1495), Y(412), X(1495), Y(412), yellowColor, 0)
        if ErrorLevel
            return false

        return true
    }
}

CheckCommissionRewards_AtInazumaOrSumeru()
{
    If DetectHDR()
        yellowColor := 0xFFFF00
    Else
        yellowColor := 0xFFCC32
    lang := DetectDisplayLanguage()
    if (lang == "KR")
    {
        ErrorLevel := !PixelSearch(&varX, &varY, X(1112), Y(363), X(1112), Y(363), yellowColor, 0)
        if ErrorLevel
            return false

        ErrorLevel := !PixelSearch(&varX, &varY, X(1215), Y(350), X(1215), Y(350), yellowColor, 0)
        if ErrorLevel
            return false

        return true
    }
    else    ; "EN"
    {
        ErrorLevel := !PixelSearch(&varX, &varY, X(1120), Y(351), X(1120), Y(351), yellowColor, 0)
        if ErrorLevel
            return false

        ErrorLevel := !PixelSearch(&varX, &varY, X(1496), Y(360), X(1496), Y(360), yellowColor, 0)
        if ErrorLevel
            return false

        return true
    }
}

CheckExpeditionRewards_AtMondstadtOrLiyue()
{
    If DetectHDR()
        yellowColor := 0xFFFF00
    Else
        yellowColor := 0xFFCC32
    lang := DetectDisplayLanguage()
    if (lang == "KR")
    {
        ErrorLevel := !PixelSearch(&varX, &varY, X(1110), Y(540), X(1110), Y(540), yellowColor, 0)
        if ErrorLevel
            return false

        ErrorLevel := !PixelSearch(&varX, &varY, X(1198), Y(539), X(1198), Y(539), yellowColor, 0)
        if ErrorLevel
            return false

        return true
    }
    else    ; "EN"
    {
        ErrorLevel := !PixelSearch(&varX, &varY, X(1110), Y(537), X(1110), Y(537), yellowColor, 0)
        if ErrorLevel
            return false

        ErrorLevel := !PixelSearch(&varX, &varY, X(1503), Y(546), X(1503), Y(546), yellowColor, 0)
        if ErrorLevel
            return false

        return true
    }
}

CheckExpeditionRewards_AtInazumaOrSumeru()
{
    If DetectHDR()
        yellowColor := 0xFFFF00
    Else
        yellowColor := 0xFFCC32
    lang := DetectDisplayLanguage()
    if (lang == "KR")
    {
        ErrorLevel := !PixelSearch(&varX, &varY, X(1122), Y(488), X(1122), Y(488), yellowColor, 0)
        if ErrorLevel
            return false

        ErrorLevel := !PixelSearch(&varX, &varY, X(1192), Y(476), X(1192), Y(476), yellowColor, 0)
        if ErrorLevel
            return false

        return true
    }
    else    ; "EN"
    {
        ErrorLevel := !PixelSearch(&varX, &varY, X(1120), Y(483), X(1120), Y(483), yellowColor, 0)
        if ErrorLevel
            return false

        ErrorLevel := !PixelSearch(&varX, &varY, X(1383), Y(476), X(1383), Y(476), yellowColor, 0)
        if ErrorLevel
            return false

        return true
    }
}

; Configure "Conditions" first
CollectExpeditionRewardsAndSendExpeditions()
{
    global _selectedMap

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
    expeditions := [StormterrorLair, GuiliPlains, JinrenIsland, Tatarasuna, ArdraviValley] ; Choose 5 mora expeditions
    ;expeditions := [WhisperingWoods, StormterrorLair, GuiliPlains, JinrenIsland, ArdraviValley] ; Choose 4 short mora expeditions + 1 rock expedition
    ;expeditions := [StormterrorLair, StormterrorLair, GuiliPlains, JinrenIsland, ArdraviValley] ; Choose 4 long mora expeditions + 1 rock expedition
    duration := 0    ; Choose 'duration' from 4, 8, 12, or 20. Or choose 0 to skip selection and use the last used duration
    _selectedMap := -1 ; Assume no map was selected and select the map of the first expedition

    ; Check each map for completed expeditions. Then check each map again for second completed expeditions of the same map.
    ; TODO: This won't work if there are >2 expeditions on the same map. In this case, work around by duplicating the loop segment
    CollectExpeditionRewards()

    SendExpeditions(expeditions, duration)

    Send("{Esc}") ; Exit
    Exit()
}

IsRewardReady()
{
    If DetectHDR()
        yellowColor := 0xFCFF47
    Else
        yellowColor := 0x99CC33

    return IsColorAtPosition(1333, 850, yellowColor, 1)
}

CollectExpeditionRewards()
{
    pause1 := 200
    pause2 := 170
    pause3 := 300

    numRemainigRewards := 5     ; Exit the loop when 5 rewards have been collected, or ...
    numTotalMaps := 5           ; all maps are checked for no rewards to collect.
    checkedMapsDict := Map()

    mapNumber := 0 ; 0=Mondstadt, 1=Liyue, ...

    Sleep(pause1) ; warmup time

    while (numRemainigRewards > 0 and checkedMapsDict.Count < numTotalMaps)
    {
        SelectMap(mapNumber)  ; Select map (0=Mondstadt, 1=Liyue, ...)

        CheckForCancelAndExit()

        if (IsRewardReady())
        {
            numRemainigRewards--

            ClickOnBottomRightButton()  ; Collect reward
            Sleep(pause2)

            Send("{Esc}") ; Skip reward menu
            Sleep(pause3)
        }
        else
        {
            checkedMapsDict[mapNumber] := 1 ; 1 is meaningless. This dict is used like a set
        }

        mapNumber++
        mapNumber := Mod(mapNumber, numTotalMaps)  ; If mapNumber reached end, start again from the first map. For example, after checking 3(Sumeru), go back to 0(Mondstadt).
    }
}

SendExpedition(expedition, duration)
{
    pause1 := 270
    pause2 := 450

    mapWasChanged := SelectMap(expedition.map)

    ; If the expedition is the "first one on the map", the expedition is already selected when the map changes, so clicking the expedition location can be skipped
    if (!(mapWasChanged && expedition.HasOwnProp("isFirstOnMap")))
    {
        ScreenClick(expedition.x, expedition.y) ; Click on the expedition location
        Sleep(pause1)
    }

    if (duration != 0)
    {
        SelectDuration(duration)
        Sleep(pause1)
    }

    ClickOnBottomRightButton()  ; Click on "Select Character"
    Sleep(pause1)

    characterNumberInList := 1
    if (!mapWasChanged)
    {
        characterNumberInList := 2
    }
    FindAndSelectCharacter(characterNumberInList)
    Sleep(pause2)
}

SendExpeditions(expeditions, duration)
{
    ; Ignore `duration` passed here and force it to 20 if a key is held down
    If (GetKeyState("NumpadAdd", "P"))
    {
        duration := 20
    }

    For _, expedition in expeditions
    {
        CheckForCancelAndExit()
        SendExpedition(expedition, duration)
    }
}

SelectMap(mapNumber)
{
    global _selectedMap

    if (mapNumber != _selectedMap)
    {
        WorldY := 133.3 + (mapNumber * 60)   ; initial position + offset between lines
        ScreenClick(166.7, WorldY)
        Sleep(300)

        _selectedMap := mapNumber
        return true
    }
    return false
}

SelectDuration(duration)
{
    switch duration
    {
        case 4:
            ScreenClick(1250, 583)
            return
        case 20:
            ScreenClick(1500, 583)
            return
        default:
            MsgBox("Choose 'duration' from 4, 8, 12, or 20. Or choose 0 to skip selection and use the last used duration")
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