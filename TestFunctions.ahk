
; =======================================
; Test Functions
; =======================================

GetFileName()
{
    activeprocess := WinGetProcessName("A")
    MsgBox("The active ahk_exe is `"" activeprocess "`".")
    ; "GenshinImpact.exe"
}

GetWinName()
{
    winTitle := WinGetTitle("A")
    MsgBox("The active window is `"" winTitle "`".")
    ; "Genshin Impact", "원신"
}

SnapshotColorAtPosition(posX, posY)
{
    mouseX := X(posX)
    mouseY := Y(posY)
    color := PixelGetColor(mouseX, mouseY)
    MsgBox mouseX "(" posX ") x " mouseY "(" posY ") => " color
}

SnapshotColorAtMousePosition()
{
    MouseGetPos &mouseX, &mouseY
    posX := mouseX / A_ScreenWidth * 1600
    posY := mouseY / A_ScreenHeight * 900
    color := PixelGetColor(mouseX, mouseY)
    MsgBox mouseX "(" posX ") x " mouseY "(" posY ") => " color
}

Up::MouseMove(0, -1, 0, "Relative")
Down::MouseMove(0, 1, 0, "Relative")
Left::MouseMove(-1, 0, 0, "Relative")
Right::MouseMove(1, 0, 0, "Relative")

*NumPad7::DetectHDR()

*NumPad8::ScreenMove(1230, 836)
*-::ScreenMove(1230, 836)

*NumPad9::SnapshotColorAtMousePosition()
*\::SnapshotColorAtMousePosition()

; IsColorAtPosition(1230, 831.25, 0x00FFFF)
; SoundBeep 300