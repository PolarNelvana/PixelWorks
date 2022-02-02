
Gui, 3:Add, Hotkey, x154 y10 w120 h21 vhkey1, %hot1%
Gui, 3:Add, Hotkey, x154 y40 w120 h21 vhkey2, %hot2%
Gui, 3:Add, Hotkey, x154 y70 w120 h21 vhkey3, %hot3%
Gui, 3:Add, Hotkey, x154 y100 w120 h21 vhkey4, %hot4%
Gui, 3:Add, Hotkey, x154 y130 w120 h21 vhkey5, %hot5%
Gui, 3:Add, Hotkey, x154 y160 w120 h21 vhkey6, %hot6%
Gui, 3:Add, Hotkey, x154 y190 w120 h21 vhkey7, %hot7%
Gui, 3:Add, Hotkey, x154 y220 w120 h21 vhkey8, %hot8%
Gui, 3:Add, Hotkey, x154 y250 w120 h21 vhkey9, %hot9%
Gui, 3:Add, Hotkey, x154 y280 w120 h21 vhkey10, %hot10%
Gui, 3:Add, Hotkey, x384 y10 w120 h21 vhkey11, %hot11%
Gui, 3:Add, Hotkey, x384 y40 w120 h21 vhkey12, %hot12%
Gui, 3:Add, Hotkey, x384 y70 w120 h21 vhkey13, %hot13%
Gui, 3:Add, Hotkey, x384 y100 w120 h21 vhkey14, %hot14%
Gui, 3:Add, Hotkey, x384 y130 w120 h21 vhkey15, %hot15%
Gui, 3:Add, Hotkey, x384 y160 w120 h21 vhkey16, %hot16%
Gui, 3:Add, Hotkey, x384 y190 w120 h21 vhkey17, %hot17%
Gui, 3:Add, Hotkey, x384 y220 w120 h21 vhkey18, %hot18%
Gui, 3:Add, Hotkey, x384 y250 w120 h21 vhkey19, %hot19%
Gui, 3:Add, Hotkey, x384 y280 w120 h21 vhkey20, %hot20%
Gui, 3:Add, Text, x8 y10 w138 h21 +0x200 Right, Pause/Unpause:
Gui, 3:Add, Text, x8 y40 w138 h21 +0x200 Right, Capture:
Gui, 3:Add, Text, x8 y70 w138 h21 +0x200 Right, Copy current %colorcolour%:
Gui, 3:Add, Text, x8 y100 w138 h21 +0x200 Right, Copy %colorcolour% in all formats:
Gui, 3:Add, Text, x8 y130 w138 h21 +0x200 Right, Copy mouse position:
Gui, 3:Add, Text, x8 y160 w138 h21 +0x200 Right, Copy delta mouse position:
Gui, 3:Add, Text, x8 y190 w138 h21 +0x200 Right, Copy mouse position + delta:
Gui, 3:Add, Text, x8 y220 w138 h21 +0x200 Right, Copy everything:
Gui, 3:Add, Text, x8 y250 w138 h21 +0x200 Right, Copy tooltip:
Gui, 3:Add, Text, x8 y280 w138 h21 +0x200 Right, Bring window to front:
Gui, 3:Add, Text, x280 y10 w96 h21 +0x200 Right, Cycle %colorcolour% format:
Gui, 3:Add, Text, x296 y40 w80 h21 +0x200 Right, Reverse cycle:
Gui, 3:Add, Text, x296 y70 w80 h21 +0x200 Right, Toggle tooltip:
Gui, 3:Add, Text, x296 y100 w80 h21 +0x200 Right, Toggle tray icon
Gui, 3:Add, Text, x296 y130 w80 h21 +0x200 Right, Zoom in:
Gui, 3:Add, Text, x296 y160 w80 h21 +0x200 Right, Zoom out:
Gui, 3:Add, Text, x296 y190 w80 h21 +0x200 Right, Clear all:
Gui, 3:Add, Text, x296 y220 w80 h21 +0x200 Right, Custom #1:
Gui, 3:Add, Text, x296 y250 w80 h21 +0x200 Right, Custom #2:
Gui, 3:Add, Text, x296 y280 w80 h21 +0x200 Right, Custom #3:
Gui, 3:Add, Button, x512 y219 w80 h23 vcust1 gcustfig1, Configure
Gui, 3:Add, Button, x512 y249 w80 h23 vcust2 gcustfig2, Configure
Gui, 3:Add, Button, x512 y279 w80 h23 vcust3 gcustfig3, Configure
Gui, 3:Add, Button, x344 y314 w80 h23 vokhot ghotup, OK
Gui, 3:Add, Button, x472 y314 w80 h23 vcank g3guiclose, Cancel
Gui, 3:Add, Button, x196 y314 w100 h23 vthebutton g3reset, Reset Selected
Gui, 3:Add, Button, x48 y314 w100 h23 vresetall g3resetall, Reset All
Gui, 3:+toolwindow +owner1
gui, 3:+hwndhotkeyconui
if (stayon = 1)
	gui, 3:+alwaysontop
else
	gui, 3:-alwaysontop
loop, 20
hotrememberer%a_index% := hot%a_index% ; stores the gui values temporarily for a comparison later on
gui, 1:+disabled
gui, 2:+disabled
Gui, 3:Show, w600 h350 center, Hotkey Configuration
