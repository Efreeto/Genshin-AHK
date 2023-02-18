
CheckWarpPoint()
{
    pause1 := 10

    if (IsWarpPointSelected())
    {
        ClickWarpAndExit()
    }

    ; Scan list items
    posX := 1082
    posY := 608
    loop 3
    {
        if (CheckForWarpPoint(posX, posY))
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

    ; Scan skewed list items when there are too many
    posY := 450
    loop 6
    {
        if (CheckForWarpPoint(posX, posY))
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
}

IsWarpPointSelected()
{
    return IsColorAtPosition(1230, 831.25, 0x00FFFF)
        and IsColorAtPosition(1230, 837.5, 0x575757)
        and IsColorAtPosition(1230, 843, 0x00FFFF)
}

CheckForWarpPoint(posX, posY)
{
    return IsColorAtPosition(posX, posY, 0xFFF500)
        and IsColorAtPosition(posX, posY + 12, 0xFFFFFF)
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