Gui, 7:Add, Edit, x10 y10 w480 h20 vnotevarre, %listtext%
Gui, 7:Add, Button, x331 y40 w75 h25 default gnotek, OK
Gui, 7:Add, Button, x247 y40 w75 h25 gnoteclear, Clear
Gui, 7:Add, Button, x415 y40 w75 h25 g7guiclose, Cancel
Gui, 7:+owner1 +toolwindow
if (stayon = 1)
	gui, 7:+alwaysontop
else
	gui, 7:-alwaysontop
gui, 1:+disabled
Gui, 7:Show, w500 h75, Add Note