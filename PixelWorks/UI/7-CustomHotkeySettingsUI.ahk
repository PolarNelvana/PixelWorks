Gui, 5:Add, CheckBox, x15 y36 w90 h23 hwndx1 checked%varnow1% v%varpre%jenna1, HTML
Gui, 5:Add, CheckBox, x15 y61 w90 h23 hwndx2 checked%varnow2% v%varpre%jenna2, RGB [0, 255]
Gui, 5:Add, CheckBox, x15 y86 w90 h23 hwndx3 checked%varnow3% v%varpre%jenna3, RGB [0, 1]
Gui, 5:Add, CheckBox, x15 y111 w90 h23 hwndx4 checked%varnow4% v%varpre%jenna4, RGB Integer
Gui, 5:Add, CheckBox, x15 y136 w90 h23 hwndx5 checked%varnow5% v%varpre%jenna5, BGR [0, 255]
Gui, 5:Add, CheckBox, x15 y161 w90 h23 hwndx6 checked%varnow6% v%varpre%jenna6, BGR [0, 1]
Gui, 5:Add, CheckBox, x15 y186 w90 h23 hwndx7 checked%varnow7% v%varpre%jenna7, BGR Integer
Gui, 5:Add, CheckBox, x120 y36 w90 h23 hwndx8 checked%varnow8% v%varpre%jenna8, RYB [0, 255]
Gui, 5:Add, CheckBox, x120 y61 w90 h23 hwndx9 checked%varnow9% v%varpre%jenna9, RYB [0, 1]
Gui, 5:Add, CheckBox, x120 y86 w90 h23 hwndx10 checked%varnow10% v%varpre%jenna10, RYB Integer
Gui, 5:Add, CheckBox, x120 y111 w90 h23 hwndx11 checked%varnow11% v%varpre%jenna11, HEX
Gui, 5:Add, CheckBox, x120 y136 w90 h23 hwndx12 checked%varnow12% v%varpre%jenna12, HEX (BGR)
Gui, 5:Add, CheckBox, x120 y161 w90 h23 hwndx13 checked%varnow13% v%varpre%jenna13, HSB/HSV
Gui, 5:Add, CheckBox, x120 y186 w90 h23 hwndx14 checked%varnow14% v%varpre%jenna14, HSL
Gui, 5:Add, CheckBox, x225 y36 w90 h23 hwndx15 checked%varnow15% v%varpre%jenna15, HSL (255)
Gui, 5:Add, CheckBox, x225 y61 w90 h23 hwndx16 checked%varnow16% v%varpre%jenna16, HSL (240)
Gui, 5:Add, CheckBox, x225 y86 w90 h23 hwndx17 checked%varnow17% v%varpre%jenna17, HWB
Gui, 5:Add, CheckBox, x225 y111 w90 h23 hwndx18 checked%varnow18% v%varpre%jenna18, CMYK [0, 100]
Gui, 5:Add, CheckBox, x225 y136 w90 h23 hwndx19 checked%varnow19% v%varpre%jenna19, CMYK [0, 1]
Gui, 5:Add, CheckBox, x225 y161 w90 h23 hwndx20 checked%varnow20% v%varpre%jenna20, CMY [0, 100]
Gui, 5:Add, CheckBox, x225 y186 w90 h23 hwndx21 checked%varnow21% v%varpre%jenna21, CMY [0, 1]
Gui, 5:Add, CheckBox, x330 y36 w90 h23 hwndx22 checked%varnow22% v%varpre%jenna22, Delphi
Gui, 5:Add, CheckBox, x330 y61 w90 h23 hwndx23 checked%varnow23% v%varpre%jenna23, XYZ
Gui, 5:Add, CheckBox, x330 y86 w90 h23 hwndx24 checked%varnow24% v%varpre%jenna24, Yxy
Gui, 5:Add, CheckBox, x330 y111 w90 h23 hwndx25 checked%varnow25% v%varpre%jenna25, CIELab
Gui, 5:Add, CheckBox, x330 y136 w90 h23 hwndx26 checked%varnow26% v%varpre%jenna26, CIELCh(ab)
Gui, 5:Add, CheckBox, x330 y161 w90 h23 hwndx27 checked%varnow27% v%varpre%jenna27, CIELSh(ab)
Gui, 5:Add, CheckBox, x330 y186 w90 h23 hwndx28 checked%varnow28% v%varpre%jenna28, CIELuv
Gui, 5:Add, CheckBox, x435 y36 w90 h23 hwndx29 checked%varnow29% v%varpre%jenna29, CIELCh(uv)
Gui, 5:Add, CheckBox, x435 y61 w90 h23 hwndx30 checked%varnow30% v%varpre%jenna30, CIELSh(uv)
Gui, 5:Add, CheckBox, x435 y86 w90 h23 hwndx31 checked%varnow31% v%varpre%jenna31, Hunter-Lab
Gui, 5:Add, CheckBox, x435 y111 w90 h23 hwndx32 checked%varnow32% v%varpre%jenna32, YUV
Gui, 5:Add, CheckBox, x435 y136 w90 h23 hwndx33 checked%varnow33% v%varpre%jenna33, YCbCr
Gui, 5:Add, CheckBox, x435 y161 w90 h23 hwndx34 checked%varnow34% v%varpre%jenna34, Mouse Position
Gui, 5:Add, CheckBox, x435 y186 w90 h23 hwndx35 checked%varnow35% v%varpre%jenna35, Delta Mouse Position
Gui, 5:Add, Text, x105 y7 w330 h23 +0x200, Select the information that you would like to include with the hotkey:
Gui, 5:Add, Button, x230 y225 w80 h23 gcustsavehot, OK
Gui, 5:Add, Button, x385 y225 w80 h23 g5guiclose, Cancel
Gui, 5:Add, Button, x75 y225 w80 h23 gcustomhotreset, Reset
Gui, 5:+toolwindow +hwndcusthotui +owner3
if (stayon = 1)
	gui, 5:+alwaysontop
else
	gui, 5:-alwaysontop
gui, 3:+disabled
Gui, 5:Show, w540 h263, Custom Hotkey Configuration
