Gui, 2:Add, Text, x8 y8 w175 h70, PixelWorks`nVersion: 1.0`nLicense: Freeware (no modification)`nAuthor: Lucas Jaramillo`nDesign inspired by JCPicker
Gui, 2:Add, Button, g2guiclose x133 y100 w80 h23, OK
Gui, 2:Add, Picture, gsurprise x8 y82 w40 h40, C:\Users\Lucas\Projects\PixelWorks\PW.ico
gui, 2: +toolwindow +owner1 +hwndaboutui
if (stayon = 1)
	gui, 2:+alwaysontop
else
	gui, 2:-alwaysontop
gui, 1:+disabled
Gui, 2:Show, w220 h130 center, About