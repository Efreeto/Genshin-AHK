
CheckWarpPoint()
{
    pause1 := 10

    if (IsWarpPointSelected())
    {
        ClickWarpAndExit()
    }
    else if (IsFirstOptionWarpPoint())
    {
        ClickFirstOption()
        Sleep, %pause1%
        ClickWarpAndExit()
    }
    else if (IsSecondOptionWarpPoint())
    {
        ClickSecondOption()
        Sleep, %pause1%
        ClickWarpAndExit()
    }
    else if (IsThirdOptionWarpPoint())
    {
        ClickThirdOption()
        Sleep, %pause1%
        ClickWarpAndExit()
    }
}

IsWarpPointSelected()
{
    return IsColorAtPosition(12.3, 8.3125, 0x00FFFF)
        and IsColorAtPosition(12.3, 8.375, 0x575757)
        and IsColorAtPosition(12.3, 8.43, 0x00FFFF)
}

IsFirstOptionWarpPoint()
{
    return IsColorAtPosition(10.82, 6.08, 0xFFF500)
        and IsColorAtPosition(10.82, 6.2125, 0xFFFFFF)
}

IsSecondOptionWarpPoint()
{
    return IsColorAtPosition(10.82, 6.72, 0xFFF500)
        and IsColorAtPosition(10.82, 6.83, 0xFFFFFF)
}

IsThirdOptionWarpPoint()
{
    return IsColorAtPosition(10.82, 7.34, 0xFFF500)
        and IsColorAtPosition(10.82, 7.45, 0xFFFFFF)
}

ClickFirstOption()
{
    ScreenClick(10.82, 6.08)
}

ClickSecondOption()
{
    ScreenClick(10.82, 6.72)
}

ClickThirdOption()
{
    ScreenClick(10.82, 7.34)
}

ClickWarpAndExit()
{
    ClickOnBottomRightButton()
    Exit
}