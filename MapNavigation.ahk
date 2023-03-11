
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
    posY := 325
    loop 7
    {
        CheckForAllTeleportPoints(posX, posY)

        posY := posY + 62.5
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
        ScreenClick(posX, posY)
        Sleep, %pause1%
        ClickWarpAndExit()
    }

    if (CheckForStatueOfSeven(posX, posY))
    {
        ScreenClick(posX, posY)
        Sleep, %pause1%
        ClickWarpAndExit()
    }

    if (CheckForDomain(posX, posY))
    {
        ScreenClick(posX, posY)
        Sleep, %pause1%
        ClickWarpAndExit()
    }

    if (CheckForSereniteaPotWarpPoint(posX, posY))
    {
        ScreenClick(posX, posY)
        Sleep, %pause1%
        ClickWarpAndExit()
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
    return IsColorAtPosition(posX, posY, 0xFFFF00)
       and IsColorAtPosition(posX, posY + 15, 0xFFFFFF)
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