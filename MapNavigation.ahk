
TeleportShortcut()
{
    if (IsWarpPointSelected())
    {
        ClickWarpAndExit()
    }

    ; Scan list items
    posX := 1082
    posY := 610
    loop 3
    {
        CheckForAllTeleportPoints(posX, posY)
    }

    ; Scan skewed list items when there are too many
    posY := 450
    loop 6
    {
        CheckForAllTeleportPoints(posX, posY)
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

    if (CheckForSereniteaPotWarpPoint(posX, posY))
    {
        ScreenClick(posX, posY)
        Sleep, %pause1%
        ClickWarpAndExit()
    }

    posY := posY + 62.5
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