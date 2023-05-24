
; =======================================
; Test Functions
; =======================================

SnapshotColorAtPosition(posX, posY)
{
    mouseX := X(posX)
    mouseY := Y(posY)
    PixelGetColor, color, mouseX, mouseY
    MsgBox, %mouseX% (%posX%) x %mouseY% (%posY%) => %color%
}

SnapshotColorAtMousePosition()
{
    MouseGetPos, mouseX, mouseY
    posX := mouseX / A_ScreenWidth * 1600
    posY := mouseY / A_ScreenHeight * 900
    PixelGetColor, color, %mouseX%, %mouseY%
    MsgBox, %mouseX% (%posX%) x %mouseY% (%posY%) => %color%
}

Up::MouseMove, 0, -1, 0, Relative
Down::MouseMove, 0, 1, 0, Relative
Left::MouseMove, -1, 0, 0, Relative
Right::MouseMove, 1, 0, 0, Relative

*NumPad7::ScreenMove(1232, 837.5)

*NumPad8::SnapshotColorAtPosition(1232, 837.5)

*NumPad9::SnapshotColorAtMousePosition()

;IsColorAtPosition(1230, 831.25, 0x00FFFF)
;SoundBeep, 100