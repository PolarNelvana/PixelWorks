
Gui, 4:Add, CheckBox, x15 y36 w90 h23 checked%gen1% vgen1, HTML
Gui, 4:Add, CheckBox, x15 y61 w90 h23 checked%gen2% vgen2, RGB [0, 255]
Gui, 4:Add, CheckBox, x15 y86 w90 h23 checked%gen3% vgen3, RGB [0, 1]
Gui, 4:Add, CheckBox, x15 y111 w90 h23 checked%gen4% vgen4, RGB Integer
Gui, 4:Add, CheckBox, x15 y136 w90 h23 checked%gen5% vgen5, BGR [0, 255]
Gui, 4:Add, CheckBox, x15 y161 w90 h23 checked%gen6% vgen6, BGR [0, 1]
Gui, 4:Add, CheckBox, x15 y186 w90 h23 checked%gen7% vgen7, BGR Integer
Gui, 4:Add, CheckBox, x120 y36 w90 h23 checked%gen8% vgen8, RYB [0, 255]
Gui, 4:Add, CheckBox, x120 y61 w90 h23 checked%gen9% vgen9, RYB [0, 1]
Gui, 4:Add, CheckBox, x120 y86 w90 h23 checked%gen10% vgen10, RYB Integer
Gui, 4:Add, CheckBox, x120 y111 w90 h23 checked%gen11% vgen11, HEX
Gui, 4:Add, CheckBox, x120 y136 w90 h23 checked%gen12% vgen12, HEX (BGR)
Gui, 4:Add, CheckBox, x120 y161 w90 h23 checked%gen13% vgen13, HSB/HSV
Gui, 4:Add, CheckBox, x120 y186 w90 h23 checked%gen14% vgen14, HSL
Gui, 4:Add, CheckBox, x225 y36 w90 h23 checked%gen15% vgen15, HSL (255)
Gui, 4:Add, CheckBox, x225 y61 w90 h23 checked%gen16% vgen16, HSL (240)
Gui, 4:Add, CheckBox, x225 y86 w90 h23 checked%gen17% vgen17, HWB
Gui, 4:Add, CheckBox, x225 y111 w90 h23 checked%gen18% vgen18, CMYK [0, 100]
Gui, 4:Add, CheckBox, x225 y136 w90 h23 checked%gen19% vgen19, CMYK [0, 1]
Gui, 4:Add, CheckBox, x225 y161 w90 h23 checked%gen20% vgen20, CMY [0, 100]
Gui, 4:Add, CheckBox, x225 y186 w90 h23 checked%gen21% vgen21, CMY [0, 1]
Gui, 4:Add, CheckBox, x330 y36 w90 h23 checked%gen22% vgen22, Delphi
Gui, 4:Add, CheckBox, x330 y61 w90 h23 checked%gen23% vgen23, XYZ
Gui, 4:Add, CheckBox, x330 y86 w90 h23 checked%gen24% vgen24, Yxy
Gui, 4:Add, CheckBox, x330 y111 w90 h23 checked%gen25% vgen25, CIELab
Gui, 4:Add, CheckBox, x330 y136 w90 h23 checked%gen26% vgen26, CIELCh(ab)
Gui, 4:Add, CheckBox, x330 y161 w90 h23 checked%gen27% vgen27, CIELSh(ab)
Gui, 4:Add, CheckBox, x330 y186 w90 h23 checked%gen28% vgen28, CIELuv
Gui, 4:Add, CheckBox, x435 y36 w90 h23 checked%gen29% vgen29, CIELCh(uv)
Gui, 4:Add, CheckBox, x435 y61 w90 h23 checked%gen30% vgen30, CIELSh(uv)
Gui, 4:Add, CheckBox, x435 y86 w90 h23 checked%gen31% vgen31, Hunter-Lab
Gui, 4:Add, CheckBox, x435 y111 w90 h23 checked%gen32% vgen32, YUV
Gui, 4:Add, CheckBox, x435 y136 w90 h23 checked%gen33% vgen33, YCbCr
Gui, 4:Add, CheckBox, x435 y161 w90 h23 checked%gen34% vgen34, Mouse Position
Gui, 4:Add, CheckBox, x435 y186 w90 h23 checked%gen35% vgen35, Delta Mouse Position
Gui, 4:Add, Text, x105 y7 w330 h23 +0x200, Select the information that you would like to include with the tooltip:
Gui, 4:Add, Button, x230 y225 w80 h23 ggenok, OK
Gui, 4:Add, Button, x385 y225 w80 h23 g4guiclose, Cancel
Gui, 4:Add, Button, x75 y225 w80 h23 g4reset, Reset
Gui, 4:+toolwindow +owner1
if (stayon = 1)
	gui, 4:+alwaysontop
else
	gui, 4:-alwaysontop
gui, 1:+disabled
Gui, 4:Show, w540 h263, Tooltip Configuration