Gui, 6:Add, Slider, x7 y8 w245 h26 range%rangemin%-%range% +altsubmit +page10 vslidervar gsliderglide, %slider%
Gui, 6:Add, Text, x17 y35 w29 h26 +0x200, %rangemin%
Gui, 6:Add, Text, x229 y35 w41 h26 +0x200, %range%
Gui, 6:Add, Text, x148 y35 w28 h26 +0x200, %unit%
Gui, 6:Add, Edit, x118 y38 w25 h22 number limit gsliderhand vslideredit, %slider%
Gui, 6:Add, Button, x17 y76 w65 h23 gsliderreset, Reset
Gui, 6:Add, Button, x97 y76 w65 h23 gsliderk, OK
Gui, 6:Add, Button, x178 y76 w65 h23 g6guiclose, Cancel
Gui, 6:+toolwindow +hwndsliderui +owner1
if (stayon = 1)
	gui, 6:+alwaysontop
else
	gui, 6:-alwaysontop
gui, 1:+disabled
Gui, 6:Show, center w260 h115, %slidermode%