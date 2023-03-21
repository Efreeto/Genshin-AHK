
TeleportShortcut()
{
    if (IsWarpPointSelected())
    {
        ClickWarpAndExit()
    }

    ; Scan list items
    posX := 1082
    posY := 611.5
    loop 3
    {
        CheckForAllTeleportPoints(posX, posY)

        posY := posY + 62.5
    }

    ; Scan skewed list items when there are too many
    posY := 203
    loop 10
    {
        CheckForAllTeleportPoints(posX, posY)

        posY := posY + 62
    }
}

IsWarpPointSelected()
{
    return IsColorAtPosition(1230, 831.25, 0x00FFFF)
        and IsColorAtPosition(1230, 837.5, 0x575757)
        and IsColorAtPosition(1230, 843, 0x00FFFF)
}

CheckForAllTeleportPoints(posX, posY)
{
    pause1 := 10

    if (CheckForWarpPoint(posX, posY))
    {
        ScreenMove(posX, posY)
        SoundBeep, 100
        exit
        ;Sleep, %pause1%
        ;ClickWarpAndExit()
    }

    if (CheckForStatueOfSeven(posX, posY))
    {
        ScreenMove(posX, posY)
        SoundBeep, 300
        SoundBeep, 100
        exit
        ;Sleep, %pause1%
        ;ClickWarpAndExit()
    }

    if (CheckForDomain(posX, posY))
    {
        ScreenMove(posX, posY)
        SoundBeep, 500
        SoundBeep, 300
        SoundBeep, 100
        exit
        ;Sleep, %pause1%
        ;ClickWarpAndExit()
    }

    if (CheckForSereniteaPotWarpPoint(posX, posY))
    {
        ScreenMove(posX, posY)
        SoundBeep, 700
        SoundBeep, 500
        SoundBeep, 300
        SoundBeep, 100
        exit
        ;Sleep, %pause1%
        ;ClickWarpAndExit()
    }
}

CheckForWarpPoint(posX, posY)
{
    return IsColorAtPosition(posX, posY, 0xFFF500)
        and IsColorAtPosition(posX, posY + 12, 0xFFFFFF)
}

CheckForStatueOfSeven(posX, posY)
{
    return IsColorAtPosition(posX, posY, 0xFFFFD6)
        and IsColorAtPosition(posX, posY + 13, 0x5C5A5A)
}

CheckForDomain(posX, posY)
{
    return IsColorAtPosition(posX, posY + 15, 0xFFFFFF)
        and IsColorAtPosition(posX + 15, posY, 0xFFFFFF)
}

CheckForSereniteaPotWarpPoint(posX, posY)
{
    return IsColorAtPosition(posX, posY, 0xFFFFFF)
        and IsColorAtPosition(posX, posY + 12, 0x00FFFF)
}

ClickWarpAndExit()
{
    ClickOnBottomRightButton()
    Exit
}