Gui, 9:Add, GroupBox, x8 y7 w153 h130, Font %colortitle%:
Gui, 9:Add, Radio, x17 y22 w120 h23 checked%f1% vcaptfont gcaptfon, Automatic
Gui, 9:Add, Radio, x17 y45 w120 h23 checked%f2% vfontsel gencapback, Select from List
Gui, 9:Add, Radio, x17 y68 w140 h23 checked%f3% vfontdiag gfontdiagsel, Select from %colortitle% Dialog
Gui, 9:Add, GroupBox, x168 y7 w153 h130, Background %colortitle%:
Gui, 9:Add, Radio, x177 y22 w120 h23 checked%b1% vcaptback gcaptback, Automatic
Gui, 9:Add, Radio, x177 y45 w120 h23 checked%b2% vbacksel gencapfon, Select from List
Gui, 9:Add, Radio, x177 y68 w140 h23 checked%b3% vbackdiag gbackdiagsel, Select from %colortitle% Dialog
Gui, 9:Add, Progress, x16 y98 w30 h30 +border background%ccolor3% vprogchoosefont, 0
Gui, 9:Add, Progress, x177 y98 w30 h30 +border background%ccolor2% vprogchooseback, 0
;Gui, 9:Add, Button, x7 y144 w80 h23 gresetcolorsbutton, Reset
Gui, 9:Add, Button, x124 y144 w80 h23 gccall, OK
Gui, 9:Add, Button, x242 y144 w80 h23 g9guiclose, Cancel
gui, 9:+toolwindow +owner1 +hwndColoryUI
if (stayon = 1)
	gui, 9:+alwaysontop
else
	gui, 9:-alwaysontop
gui, 1:+disabled
if (f1 = 1)
	gosub captfon
if (b1 = 1)
	gosub, captback
ccolor2temp := ccolor2
ccolor3temp := ccolor3
Gui, 9:Show, w329 h175, %colortitle% Configuration