gui, 10:add, GroupBox, x7 y6 w90 h95, H
gui, 10:add, Radio, x14 y21 w56 h23 vforwardBackH1, Forward
gui, 10:add, Radio, x14 y44 w68 h23 vforwardBackH2, Backward
gui, 10:add, Radio, x14 y67 w48 h23 vforwardBackH3, Auto
gui, 10:add, GroupBox, x105 y6 w90 h95, S
gui, 10:add, Radio, x112 y21 w56 h23 vforwardBackS1, Forward
gui, 10:add, Radio, x112 y44 w68 h23 vforwardBackS2, Backward
gui, 10:add, Radio, x112 y67 w48 h23 vforwardBackS3, Auto
gui, 10:add, GroupBox, x203 y6 w90 h95, L / VB
gui, 10:add, Radio, x210 y21 w56 h23 vforwardBackL1, Forward
gui, 10:add, Radio, x210 y44 w68 h23 vforwardBackL2, Backward
gui, 10:add, Radio, x210 y67 w48 h23 vforwardBackL3, Auto
gui, 10:add, Button, x20 y110 w65 h23 g10reset, Reset
gui, 10:add, Button, x117 y110 w65 h23 g10submit, OK
gui, 10:add, Button, x216 y110 w65 h23 g10guiclose, Cancel
Gui, 10:+toolwindow +owner1
if (stayon = 1)
	gui, 10:+alwaysontop
else
	gui, 10:-alwaysontop
gui, 1:+disabled
GuiControl, 10:, forwardBackH%forwardBackH%, 1
GuiControl, 10:, forwardBackS%forwardBackS%, 1
GuiControl, 10:, forwardBackL%forwardBackL%, 1
Gui, 10:Show, center w300 h144, Direction