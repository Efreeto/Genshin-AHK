﻿
TeleportShortcut()
{
    Sleep(50)  ; warmup time

    if (IsWarpPointSelected())
    {
        ClickWarpAndExit()
    }

    ; Scan list items
    posX := 1082
    posY := 611.5
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
    return IsColorAtPosition(1232, 831.25, 0xFFFF00)
        and IsColorAtPosition(1232, 837.5, 0x575757)    ; 0x575757 at HDR 25
        and IsColorAtPosition(1232, 843, 0xFFFF00)
}

CheckForAllTeleportPoints(posX, posY)
{
    pause1 := 10

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
        Sleep(pause1)
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
    return IsColorAtPosition(posX, posY, 0x00F5FF)
        and IsColorAtPosition(posX, posY + 12, 0xFFFFFF)
}

CheckForStatueOfSeven(posX, posY)
{
    return IsColorAtPosition(posX, posY, 0xD6FFFF, 1)
        and IsColorAtPosition(posX, posY + 13, 0x5A5A5B, 1)
}

CheckForDomain(posX, posY)
{
    return IsColorAtPosition(posX, posY - 3, 0x00FFFF)
        and IsColorAtPosition(posX + 15, posY, 0xFFFFFF)
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