
TeleportShortcut()
{
    Sleep(50)  ; warmup time

    if (IsWarpPointSelected())
    {
        ClickWarpAndExit()
    }

    ; Scan list items
    posX := 1080
    posY := 610

    Loop 3
    {
        CheckForAllTeleportPoints(posX, posY)

        posY := posY + 62.5
    }

    ; Scan skewed list items when there are too many
    posY := 761
    Loop 10
    {
        CheckForAllTeleportPoints(posX, posY)

        posY := posY - 62
    }

    SoundPlay(A_WinDir "\Media\Windows Navigation Start.wav")
}

IsWarpPointSelected()
{
    If DetectHDR()
    {
        yellowColor := 0xFFFF00
        blackColor := 0x595859
    }
    Else
    {
        yellowColor := 0xFFCC33
        blackColor := 0x323232
    }

    return IsColorAtPosition(1230, 831, yellowColor)
        and IsColorAtPosition(1230, 836, blackColor)
        and IsColorAtPosition(1230, 842, yellowColor)
}

CheckForAllTeleportPoints(posX, posY)
{
    pause1 := 30
    pause2 := 150

    if (CheckForWarpPoint(posX, posY))
    {
        ScreenClick(posX, posY)
        Sleep(pause1)
        ClickWarpAndExit()
    }

    if (CheckForStatueOfSeven(posX, posY))
    {
        ScreenClick(posX, posY)
        Sleep(pause1)
        ClickWarpAndExit()
    }

    if (CheckForDomain(posX, posY))
    {
        ScreenClick(posX, posY)
        Sleep(pause2)
        ClickWarpAndExit()
    }

    if (CheckForPocketWarpPoint(posX, posY))
    {
        ScreenClick(posX, posY)
        Sleep(pause1)
        ClickWarpAndExit()
    }

    if (CheckForSereniteaPotWarpPoint(posX, posY))
    {
        ScreenClick(posX, posY)
        Sleep(pause1)
        ClickWarpAndExit()
    }
}

CheckForWarpPoint(posX, posY)
{
    If DetectHDR()
        blueColor := 0x00F5FF
    Else
        blueColor := 0x2D91D9

    return IsColorAtPosition(posX, posY, blueColor)
        and IsColorAtPosition(posX, posY + 12, 0xFFFFFF)
}

CheckForStatueOfSeven(posX, posY)
{
    If DetectHDR()
        blueColor := 0xD6FFFF
    Else
        blueColor := 0x99ECF5

    return IsColorAtPosition(posX, posY, blueColor, 1)
        and IsColorAtPosition(posX + 5, posY + 5, blueColor, 1)
}

CheckForDomain(posX, posY)
{
    return IsColorAtPosition(posX, posY - 3, 0x00FFFF)
        and IsColorAtPosition(posX + 17, posY, 0xFFFFFF)
}

CheckForPocketWarpPoint(posX, posY)
{
    return IsColorAtPosition(posX, posY, 0xFFFFFF)
        and IsColorAtPosition(posX, posY + 12, 0x00FFFF)
}

CheckForSereniteaPotWarpPoint(posX, posY)
{
    return IsColorAtPosition(posX, posY, 0xFFFFFF)
        and IsColorAtPosition(posX, posY + 12, 0xFFFF00)
}

ClickWarpAndExit()
{
    ClickOnBottomRightButton()
    Exit()
}