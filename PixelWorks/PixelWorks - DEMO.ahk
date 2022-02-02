; Written by Lucas Jaramillo. Started this project on 11/15/18. A work still in progress...
; Thank you Lord for giving me the brain capacity to do this!
; Please don't steal or modify this source code. I worked really hard on it!
; If you find this source, shoot me an email at cpumood@gmail.com!

; DIRECTIVES
#NoEnv
#Notrayicon
#SingleInstance Force
#Maxthreads 255
#InstallKeybdHook

; listvars

; CONDITIONS
fileEncoding, UTF-8
setwindelay, 0
setbatchlines, -1
setcontroldelay, 0
detecthiddenwindows, on
CoordMode, Pixel, Screen 
CoordMode, Mouse, Screen

; CREATE IMPORTANT VARIABLES
PID := DllCall("GetCurrentProcessId")
workingDir = %a_appdata%\PixelWorks
global workingDirSVG := a_temp . "\PixelWorks"
combosName := ["HTML", "RGB `[0`, 255`]", "RGB `[0`, 1`]", "RGB Integer", "BGR `[0`, 255`]", "BGR `[0`, 1`]", "BGR Integer", "RYB `[0`, 255`]", "RYB `[0`, 1`]", "RYB Integer", "HEX", "HEX (BGR)", "HSB/HSV", "HSL", "HSL (255)", "HSL (240)", "HWB", "CMYK `[0`, 100`]", "CMYK `[0`, 1`]", "CMY `[0`, 100`]", "CMY `[0`, 1`]", "Delphi", "XYZ", "Yxy", "CIELab", "CIELCh(ab)", "CIELSh(ab)", "CIELuv", "CIELCh(uv)", "CIELSh(uv)", "Hunter-Lab", "YUV", "YCbCr", "Mouse Position", "Delta Mouse Position"]
hu3 = 0
saturat3 = 0
lightn3 = 94
$FontName := "Arial"
$FontOptions := "s20 cD59453"
whichcolumn = 0
picking = 0

; READ CUSTOM SETTINGS
IniRead, zoom, %workingDir%\Settings.ini, Magnifier, 1
if zoom is not integer
	zoom = 18
else if ((zoom < 0) || (zoom > 512))
	zoom = 18
IniRead, antialize, %workingDir%\Settings.ini, Magnifier, 2
if antialize not in 0,1
	antialize = 1
IniRead, showcross, %workingDir%\Settings.ini, Magnifier, 3
if showcross not in 0,1
	showcross = 1

IniRead, autotool, %workingDir%\Settings.ini, Tooltip, 1
if autotool not in 0,1
	autotool = 1
IniRead, alwystooltip, %workingDir%\Settings.ini, Tooltip, 2
if alwystooltip not in 0,1
	alwystooltip = 0
if ((autotool = 1) && (alwystooltip = 1))
{
	autotool = 1
	alwystooltip = 0
}
IniRead, hoverblock, %workingDir%\Settings.ini, Tooltip, 3
if hoverblock not in 0,1
	hoverblock = 1
loop, 35
{
	Iniread, gen%a_index%, %workingDir%\Settings.ini, ToolTipMod, %a_index%
	if gen%a_index% not in 0,1
		gen%a_index% = 0
	else
		envadd, amountselected, 1
}
if (amountselected = "")
{
	gen2 = 1
	gen3 = 1
	gen4 = 1
	gen11 = 1
	gen13 = 1
	gen16 = 1
	gen18 = 1
	gen20 = 1
	gen25 = 1
	gen34 = 1
}

IniRead, autotray, %workingDir%\Settings.ini, TrayTip, 1
if autotray not in 0,1
	autotray = 1
IniRead, alwystray, %workingDir%\Settings.ini, TrayTip, 2
if alwystray not in 0,1
	alwystray = 0
if ((autotray = 1) && (alwystray = 1))
{
	autotray = 1
	alwystray = 0
}

IniRead, copycurcolor, %workingDir%\Settings.ini, AutoCopy, 1
if copycurcolor not in 0,1
	copycurcolor = 1
IniRead, copytool, %workingDir%\Settings.ini, AutoCopy, 2
if copytool not in 0,1
	copytool = 1
if ((copycurcolor = 1) && (copytool = 1))
{
	copycurcolor = 1
	copytool = 0
}
IniRead, formatuse, %workingDir%\Settings.ini, AutoCopy, 3
if formatuse not in 0,1
	formatuse = 1

IniRead, delay, %workingDir%\Settings.ini, Options, 1
if delay is not integer
	delay = 0
else if ((delay < 0) || (delay > 500))
	delay = 0
IniRead, colormode, %workingDir%\Settings.ini, Options, 2
if colormode not in 0,1
	colormode = 0
if (colormode = 1)
{
	colorcolour = color
	colortitle = Color
}
else
{
	colorcolour = colour
	colortitle = Colour
}
IniRead, animate, %workingDir%\Settings.ini, Options, 3
if animate not in 0,1
	animate = 1
IniRead, stayon, %workingDir%\Settings.ini, Options, 4
if stayon not in 0,1
	stayon = 1
IniRead, pausehuv, %workingDir%\Settings.ini, Options, 5
if pausehuv not in 0,1
	pausehuv = 1

loop, 20
{
	IniRead, hot%a_index%, %workingDir%\Settings.ini, Hotkeys, %a_index%,%a_space%
	ifnotequal, hot%a_index%, ; if not blank, add #1
		envadd, amountw, 1
}
if (amountw = "")
{
	hot1 = !P
	hot2 = !X
	hot3 = !C
	hot4 = !A
	hot5 = !M
	hot6 = !D
	hot7 = !B
	hot8 = !E
	hot9 = !T
	hot10 = !F
	hot11 = !Down
	hot12 = !Up
	hot13 = !G
	hot14 = !R
	hot15 = !=
	hot16 = !-
	hot17 = !L
	loop, 17
	{
		var := % hot%a_index% . " Up"
		Hotkey, %var%, hotzone%a_index%
	}
}
else
{
	loop 20
	{
		var := % hot%a_index% . " Up"
		Hotkey, %var%, hotzone%a_index%
	}
}

IniRead, whichcalc, %workingDir%\Settings.ini, Recaller, 1
if whichcalc is not integer
	whichcalc = 1
else if ((whichcalc < 1) || (whichcalc > 33))
	whichcalc = 1
IniRead, updownpos, %workingDir%\Settings.ini, Recaller, 2
if updownpos not in 0,1
	updownpos = 1
IniRead, whichharmony, %workingir%\Settings.ini, Recaller, 3
if whichharmony not in 1,2,3,4,5,6,7,8,9,10
	whichharmony = 1
IniRead, defharmode, %workingDir%\Settings.ini, Recaller, 4
if defharmode not in 1,2
	defharmode = 1
IniRead, whichgrad, %workingDir%\Settings.ini, Recaller, 5
if whichgrad not in 1,2,3,4
	whichgrad = 4
IniRead, whichpattern, %workingDir%\Settings.ini, Recaller, 6
if whichpattern is not integer
	whichpattern = 1
else if ((whichpattern < 1) || (whichpattern > 45))
	whichpattern = 1
IniRead, analyziz, %workingDir%\Settings.ini, Recaller, 7
if analyziz not in 1,2,3,4
	analyziz = 3

IniRead, a1, %workingDir%\Settings.ini, AdvancedRecaller, 1
if a1 not in 1,2,3,4,5,6,7,8,9,10,11,12,13,14
	a1 = 1
IniRead, a3, %workingDir%\Settings.ini, AdvancedRecaller, 2
if a3 not in 1,2
	a3 = 1
IniRead, a7, %workingDir%\Settings.ini, AdvancedRecaller, 3
if a7 is not integer
	a7 = 360
else if ((a7 < 1) || (a7 > 360))
	a7 = 360
IniRead, a10, %workingDir%\Settings.ini, AdvancedRecaller, 4
if a10 is not integer
	a10 = 0
else if ((a10 < 0) || (a10 > 360))
	a10 = 0
IniRead, a13, %workingDir%\Settings.ini, AdvancedRecaller, 5
if a13 is not integer
	a13 = 0
else if ((a13 < 0) || (a13 > 128))
	a13 = 0
IniRead, a23, %workingDir%\Settings.ini, AdvancedRecaller, 6
if a23 not in 0,1
	a23 = 1
IniRead, nType, %workingDir%\Settings.ini, AdvancedRecaller, 7
if nType not in 1,2,3
	nType = 1

IniRead, forwardBackH, %workingDir%\Settings.ini, Direct, 1
if forwardBackH not in 1,2,3
	forwardBackH = 3
IniRead, forwardBackS, %workingDir%\Settings.ini, Direct, 2
if forwardBackS not in 1,2,3
	forwardBackS = 3
IniRead, forwardBackL, %workingDir%\Settings.ini, Direct, 3
if forwardBackL not in 1,2,3
	forwardBackL = 3

IniRead, fontfig, %workingDir%\Settings.ini, ColorWorks, 1
if fontfig not in 1,2,3
	fontfig = 2
IniRead, backfig, %workingDir%\Settings.ini, ColorWorks, 2
if backfig not in 1,2,3
	backfig = 1
if ((fontfig = 1) && (backfig = 1))
{
	fontfig = 1
	backfig = 3
}
IniRead, ccolor, %workingDir%\Settings.ini, ColorWorks, 3
if ccolor is not xdigit
	ccolor = 0xEFEFEF
clength := strlen(ccolor)
if (clength != 8)
	ccolor = 0xEFEFEF
IniRead, ccolor2, %workingDir%\Settings.ini, ColorWorks, 4
if ccolor2 is not xdigit
	ccolor2 = 0xFFFFFF
clength := strlen(ccolor2)
if (clength != 8)
	ccolor2 = 0xFFFFFF
IniRead, ccolor3, %workingDir%\Settings.ini, ColorWorks, 5
if ccolor3 is not xdigit
	ccolor3 = 0x000000
clength := strlen(ccolor3)
if (clength != 8)
	ccolor3 = 0x000000
if (fontfig = 1)
{
	f1 = 1
	f2 = 0
	f3 = 0
}
else if (fontfig = 2)
{
	f1 = 0
	f2 = 1
	f3 = 0
}
else if (fontfig = 3)
{
	f1 = 0
	f2 = 0
	f3 = 1
}
if (backfig = 1)
{
	b1 = 1
	b2 = 0
	b3 = 0
}
else if (backfig = 2)
{
	b1 = 0
	b2 = 1
	b3 = 0
}
else if (backfig = 3)
{
	b1 = 0
	b2 = 0
	b3 = 1
}
colorgetfunc("mycolornew", "HSBSPLITSep", ccolor)
ccolor2 := substr(ccolor2, -5)
ccolor3 := substr(ccolor3, -5)
ccolor2temp := ccolor2
ccolor3temp := ccolor3

IniRead, UIDef, %workingDir%\Settings.ini, DefaultUI, 1
if uidef not in 1,2,3,4,5
{
	UIDef = 1
	curryui = 1
}
else
	curryui := uidef

; SET THE CURRENT UI
enter:
if (curryui = 1)
	goto, compactUI
if (curryui = 2)
	goto, colorPrev
if (curryui = 3)
	goto, magnif
if (curryui = 4)
	goto, theworks
if (curryui = 5)
	goto, powertools
msgbox, 0x10, PixelWorks.exe, Something happened.
exitapp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; UIS

; UI FOR COLOR PREVIEW MODE
colorPrev:
gosub, menumaker
gui, +resize
gui, show, center w300 h300, PixelWorks %colortitle% Preview
gosub, redraw4colorprev
return

; UI FOR MAGNIFIER MODE
magnif:
gosub, menumaker
gui, +resize
gui, +hwndcompactUI
gui, Show, NoActivate w400 h400 center, PixelWorks Magnifier
gosub, magnificent
gosub, redraw4magnif
return

theworks:
convtable:
powertools:

; UI FOR COMPACT MODE
compactUI:
gosub, menumaker
colordef = Null
start_x = 0
start_y = 0
deltaxvar = 0
deltayvar = 0
diffile = 0 ; PAIRS WITH SAVE LIST ROUTINE
Menu, rightlistclick, Add, Copy ALL to Clipboard, menuhandler
Menu, rightlistclick, Add, Add Note, notes
Menu, rightlistclick, Add, Delete, deletah

Gui, Add, Progress, x6 y5 w99 h50 BackgroundF0F0F0 +border vProg
Gui, Add, Text, x6 y65 w98 h30 vtexty, [%start_x%, %start_y%]`n|%deltaxvar%, %deltayvar%|
Gui, Add, ListView, x218 y5 w176 h100 gwhichClick +0x100 readonly altsubmit vLV_Sample, #|%colortitle%|Format|Notes
Gui, Add, DropDownList, x6 y112 w98 r5 choose%whichcalc% hwndcombox vcombos, HTML|RGB [0, 255]|RGB [0, 1]|RGB Integer|BGR [0, 255]|BGR [0, 1]|BGR Integer|RYB [0, 255]|RYB [0, 1]|RYB Integer|HEX|HEX (BGR)|HSB/HSV|HSL|HSL (255)|HSL (240)|HWB|CMYK [0, 100]|CMYK [0, 1]|CMY [0, 100]|CMY [0, 1]|Delphi|XYZ|Yxy|CIELab|CIELCh(ab)|CIELSh(ab)|CIELuv|CIELCh(uv)|CIELSh(uv)|Hunter-Lab|YUV|YCbCr
;CB_SETDROPPEDWIDTH := 0x0160
;PostMessage, CB_SETDROPPEDWIDTH, 145,,, ahk_id %combox%
Gui, Add, Edit, x111 y112 w100 h21 vcolory, %colordef%
Gui, Add, Button, x217 y111 w128 h23, Copy Value
if (updownpos = 1)
	Gui, Add, Button, x350 y111 w45 h23 vud gupdownconf, ▲
else
	Gui, Add, Button, x350 y111 w45 h23 vud gupdownconf, ▼
Gui, Add, Button, Default hidden glistener x0 y0 w1 h1, Null ; for detecting keyboard input (as it is default)
Gui, Add, Tab, x5 y140 w390 h255, Harmonies|Gradients|Patterns|Fonts|Analysis
Gui, Add, Text, x20 y179 w80 h23, Select a format:
Gui, Add, DropDownList, x103 y175 w150 glayoutconfig vwhichharmony +altsubmit choose%whichharmony%, Full %colortitle% Wheel|Complementary|Split-Complementary|Triad|Square|Rectangle 1|Rectangle 2|Analogous|Analogous w/Complement|Hexad
Gui, Add, Text, x20 y326 w79 h23, Selected value:
Gui, Add, Edit, x103 y323 w136 h21 vselectedhar +ReadOnly, None
Gui, Add, Button, x250 y322 w60 h23 +disabled vcopyhan gcopyharmony, Copy
Gui, Add, Button, x321 y322 w60 h23 +disabled vinserter ginsertharmony, Insert
Gui, Add, Text, x20 y362 w31 h23, Mode:
Gui, Add, DropDownList, x59 y358 w120 +altsubmit vdefharmode gsinglev2 choose%defharmode%, RYB (Artistic)|RGB (Scientific)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 1
Gui, Add, text, x20 y210 w61 h50 +BackgroundTrans cEFEFEF gclickprog vtextr1
	Gui, Add, Progress, x20 y210 w61 h50 vhar1 +border
Gui, Add, text, x80 y210 w61 h50 +BackgroundTrans cEFEFEF gclickprog vtextr2
	Gui, Add, Progress, x80 y210 w61 h50 vhar2 +border
Gui, Add, text, x140 y210 w61 h50 +BackgroundTrans cEFEFEF gclickprog vtextr3
	Gui, Add, Progress, x140 y210 w61 h50 vhar3 +border
Gui, Add, text, x200 y210 w61 h50 +BackgroundTrans cEFEFEF gclickprog vtextr4
	Gui, Add, Progress, x200 y210 w61 h50 vhar4 +border
Gui, Add, text, x260 y210 w61 h50 +BackgroundTrans cEFEFEF gclickprog vtextr5
	Gui, Add, Progress, x260 y210 w61 h50 vhar5 +border
Gui, Add, text, x320 y210 w61 h50 +BackgroundTrans cEFEFEF gclickprog vtextr6
	Gui, Add, Progress, x320 y210 w61 h50 vhar6 +border
Gui, Add, text, x20 y259 w61 h50 +BackgroundTrans cEFEFEF gclickprog vtextr7
	Gui, Add, Progress, x20 y259 w61 h50 vhar7 +border
Gui, Add, text, x80 y259 w61 h50 +BackgroundTrans cEFEFEF gclickprog vtextr8
	Gui, Add, Progress, x80 y259 w61 h50 vhar8 +border
Gui, Add, text, x140 y259 w61 h50 +BackgroundTrans cEFEFEF gclickprog vtextr9
	Gui, Add, Progress, x140 y259 w61 h50 vhar9 +border
Gui, Add, text, x200 y259 w61 h50 +BackgroundTrans cEFEFEF gclickprog vtextr10
	Gui, Add, Progress, x200 y259 w61 h50 vhar10 +border
Gui, Add, text, x260 y259 w61 h50 +BackgroundTrans cEFEFEF gclickprog vtextr11
	Gui, Add, Progress, x260 y259 w61 h50 vhar11 +border
Gui, Add, text, x320 y259 w61 h50 +BackgroundTrans cEFEFEF gclickprog vtextr12
	Gui, Add, Progress, x320 y259 w61 h50 vhar12 +border
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 2
Gui, Add, text, x20 y210 w361 h50 +BackgroundTrans cEFEFEF gclickprog vtextr13
	Gui, Add, Progress, x20 y210 w361 h50 vhar13 +border
Gui, Add, text, x20 y259 w361 h50 +BackgroundTrans cEFEFEF gclickprog vtextr14
	Gui, Add, Progress, x20 y259 w361 h50 vhar14 +border
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 3
Gui, Add, text, x20 y210 w361 h50 +BackgroundTrans cEFEFEF gclickprog vtextr15
	Gui, Add, Progress, x20 y210 w361 h50 vhar15 +border
Gui, Add, text, x20 y259 w181 h50  +BackgroundTrans cEFEFEF gclickprog vtextr16
	Gui, Add, Progress, x20 y259 w181 h50 vhar16 +border
Gui, Add, text, x200 y259 w181 h50 +BackgroundTrans cEFEFEF gclickprog vtextr17
	Gui, Add, Progress, x200 y259 w181 h50 vhar17 +border
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 4
Gui, Add, text, x20 y210 w361 h50 +BackgroundTrans cEFEFEF gclickprog vtextr18
	Gui, Add, Progress, x20 y210 w361 h50 vhar18 +border
Gui, Add, text, x20 y259 w181 h50 +BackgroundTrans cEFEFEF gclickprog vtextr19
	Gui, Add, Progress, x20 y259 w181 h50 vhar19 +border
Gui, Add, text, x200 y259 w181 h50 +BackgroundTrans cEFEFEF gclickprog vtextr20
	Gui, Add, Progress, x200 y259 w181 h50 vhar20 +border
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 5
Gui, Add, text, x20 y210 w181 h50 +BackgroundTrans cEFEFEF gclickprog vtextr21
	Gui, Add, Progress, x20 y210 w181 h50 vhar21 +border
Gui, Add, text, x200 y210 w180 h50 +BackgroundTrans cEFEFEF gclickprog vtextr22
	Gui, Add, Progress, x200 y210 w181 h50 vhar22 +border
Gui, Add, text, x20 y259 w181 h50 +BackgroundTrans cEFEFEF gclickprog vtextr23
	Gui, Add, Progress, x20 y259 w181 h50 vhar23 +border
Gui, Add, text, x200 y259 w181 h50 +BackgroundTrans cEFEFEF gclickprog vtextr24
	Gui, Add, Progress, x200 y259 w181 h50 vhar24 +border
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 6
Gui, Add, text, x20 y210 w181 h50 +BackgroundTrans cEFEFEF gclickprog vtextr25
	Gui, Add, Progress, x20 y210 w181 h50 vhar25 +border
Gui, Add, text, x200 y210 w181 h50 +BackgroundTrans cEFEFEF gclickprog vtextr26
	Gui, Add, Progress, x200 y210 w181 h50 vhar26 +border
Gui, Add, text, x20 y259 w181 h50 +BackgroundTrans cEFEFEF gclickprog vtextr27
	Gui, Add, Progress, x20 y259 w181 h50 vhar27 +border
Gui, Add, text, x200 y259 w181 h50 +BackgroundTrans cEFEFEF gclickprog vtextr28
	Gui, Add, Progress, x200 y259 w181 h50 vhar28 +border
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 7
Gui, Add, text, x20 y210 w181 h50 +BackgroundTrans cEFEFEF gclickprog vtextr29
	Gui, Add, Progress, x20 y210 w181 h50 vhar29 +border
Gui, Add, text, x200 y210 w181 h50 +BackgroundTrans cEFEFEF gclickprog vtextr30
	Gui, Add, Progress, x200 y210 w181 h50 vhar30 +border
Gui, Add, text, x20 y259 w181 h50 +BackgroundTrans cEFEFEF gclickprog vtextr31
	Gui, Add, Progress, x20 y259 w181 h50 vhar31 +border
Gui, Add, text, x200 y259 w181 h50 +BackgroundTrans cEFEFEF gclickprog vtextr32
	Gui, Add, Progress, x200 y259 w181 h50 vhar32 +border
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 8
Gui, Add, text, x20 y210 w361 h50 +BackgroundTrans cEFEFEF gclickprog vtextr33
	Gui, Add, Progress, x20 y210 w361 h50 vhar33 +border
Gui, Add, text, x20 y259 w181 h50 +BackgroundTrans cEFEFEF gclickprog vtextr34
	Gui, Add, Progress, x20 y259 w181 h50 vhar34 +border
Gui, Add, text, x200 y259 w181 h50 +BackgroundTrans cEFEFEF gclickprog vtextr35
	Gui, Add, Progress, x200 y259 w181 h50 vhar35 +border
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 9
Gui, Add, text, x20 y210 w181 h50 +BackgroundTrans cEFEFEF gclickprog vtextr36
	Gui, Add, Progress, x20 y210 w181 h50 vhar36 +border
Gui, Add, text, x200 y210 w181 h50 +BackgroundTrans cEFEFEF gclickprog vtextr37
	Gui, Add, Progress, x200 y210 w181 h50 vhar37 +border
Gui, Add, text, x20 y259 w181 h50 +BackgroundTrans cEFEFEF gclickprog vtextr38
	Gui, Add, Progress, x20 y259 w181 h50 vhar38 +border
Gui, Add, text, x200 y259 w181 h50 +BackgroundTrans cEFEFEF gclickprog vtextr39
	Gui, Add, Progress, x200 y259 w181 h50 vhar39 +border
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 10
Gui, Add, text, x20 y210 w121 h50 +BackgroundTrans cEFEFEF gclickprog vtextr40
	Gui, Add, Progress, x20 y210 w121 h50 vhar40 +border
Gui, Add, text, x140 y210 w121 h50 +BackgroundTrans cEFEFEF gclickprog vtextr41
	Gui, Add, Progress, x140 y210 w121 h50 vhar41 +border
Gui, Add, text, x260 y210 w121 h50 +BackgroundTrans cEFEFEF gclickprog vtextr42
	Gui, Add, Progress, x260 y210 w121 h50 vhar42 +border
Gui, Add, text, x20 y259 w121 h50 +BackgroundTrans cEFEFEF gclickprog vtextr43
	Gui, Add, Progress, x20 y259 w121 h50 vhar43 +border
Gui, Add, text, x140 y259 w121 h50 +BackgroundTrans cEFEFEF gclickprog vtextr44
	Gui, Add, Progress, x140 y259 w121 h50 vhar44 +border
Gui, Add, text, x260 y259 w121 h50 +BackgroundTrans cEFEFEF gclickprog vtextr45
	Gui, Add, Progress, x260 y259 w121 h50 vhar45 +border

Gui, Tab, 2
Gui, Add, Text, x20 y179 w80 h23, Select a format:
Gui, Add, DropDownList, x103 y175 w140 vwhichgrad gconfigrad choose%whichgrad% +altsubmit, Saturation|Lightness|Saturation and Lightness|To Another %colortitle%
Gui, Add, Button, x20 y357 w120 h23 vvance gadvancer, Advanced Mode
Gui, Add, Button, x250 y357 w131 h23 vresetchos greschos, Reset Chosen %colortitle%
Gui, Add, Button, x254 y174 w80 h23 vchoosegrad gpicker, Select
Gui, Add, Progress, x345 y175 w22 h22 Background%ccolor% +border vProgChoose
Menu, choocolor, add, Select From List, pickerv3
Menu, choocolor, add, Select From %colortitle% Dialog, pickerv2
if (whichgrad != 4)
{
	GuiControl, Disable, resetchos
	GuiControl, Disable, choosegrad
	GuiControl, Disable, progchoose
}
Gui, Add, Text, x20 y326 w79 h23 vgradselval, Selected value:
Gui, Add, Edit, x103 y323 w136 h21 vselectedgrad +ReadOnly, None
Gui, Add, Button, x250 y322 w60 h23 +disabled vcopygrad gcopygrad, Copy
Gui, Add, Button, x321 y322 w60 h23 +disabled vinsertgrad ginsertgradient, Insert
Gui, Add, text, x20 y210 w31 h50 +BackgroundTrans cEFEFEF gclickprog2 vtextgrad1
	Gui, Add, Progress, x20 y210 w31 h50 vgrad1 +border
Gui, Add, text, x50 y210 w31 h50 +BackgroundTrans cEFEFEF gclickprog2 vtextgrad2
	Gui, Add, Progress, x50 y210 w31 h50 vgrad2 +border
Gui, Add, text, x80 y210 w31 h50 +BackgroundTrans cEFEFEF gclickprog2 vtextgrad3
	Gui, Add, Progress, x80 y210 w31 h50 vgrad3 +border
Gui, Add, text, x110 y210 w31 h50 +BackgroundTrans cEFEFEF gclickprog2 vtextgrad4
	Gui, Add, Progress, x110 y210 w31 h50 vgrad4 +border
Gui, Add, text, x140 y210 w31 h50 +BackgroundTrans cEFEFEF gclickprog2 vtextgrad5
	Gui, Add, Progress, x140 y210 w31 h50 vgrad5 +border
Gui, Add, text, x170 y210 w31 h50 +BackgroundTrans cEFEFEF gclickprog2 vtextgrad6
	Gui, Add, Progress, x170 y210 w31 h50 vgrad6 +border
Gui, Add, text, x200 y210 w31 h50 +BackgroundTrans cEFEFEF gclickprog2 vtextgrad7
	Gui, Add, Progress, x200 y210 w31 h50 vgrad7 +border
Gui, Add, text, x230 y210 w31 h50 +BackgroundTrans cEFEFEF gclickprog2 vtextgrad8
	Gui, Add, Progress, x230 y210 w31 h50 vgrad8 +border
Gui, Add, text, x260 y210 w31 h50 +BackgroundTrans cEFEFEF gclickprog2 vtextgrad9
	Gui, Add, Progress, x260 y210 w31 h50 vgrad9 +border
Gui, Add, text, x290 y210 w31 h50 +BackgroundTrans cEFEFEF gclickprog2 vtextgrad10
	Gui, Add, Progress, x290 y210 w31 h50 vgrad10 +border
Gui, Add, text, x320 y210 w31 h50 +BackgroundTrans cEFEFEF gclickprog2 vtextgrad11
	Gui, Add, Progress, x320 y210 w31 h50 vgrad11 +border
Gui, Add, text, x350 y210 w31 h50 +BackgroundTrans cEFEFEF gclickprog2 vtextgrad12
	Gui, Add, Progress, x350 y210 w31 h50 vgrad12 +border
Gui, Add, text, x20 y259 w31 h50 +BackgroundTrans cEFEFEF gclickprog2 vtextgrad13
	Gui, Add, Progress, x20 y259 w31 h50 vgrad13 +border
Gui, Add, text, x50 y259 w31 h50 +BackgroundTrans cEFEFEF gclickprog2 vtextgrad14
	Gui, Add, Progress, x50 y259 w31 h50 vgrad14 +border
Gui, Add, text, x80 y259 w31 h50 +BackgroundTrans cEFEFEF gclickprog2 vtextgrad15
	Gui, Add, Progress, x80 y259 w31 h50 vgrad15 +border
Gui, Add, text, x110 y259 w31 h50 +BackgroundTrans cEFEFEF gclickprog2 vtextgrad16
	Gui, Add, Progress, x110 y259 w31 h50 vgrad16 +border
Gui, Add, text, x140 y259 w31 h50 +BackgroundTrans cEFEFEF gclickprog2 vtextgrad17
	Gui, Add, Progress, x140 y259 w31 h50 vgrad17 +border
Gui, Add, text, x170 y259 w31 h50 +BackgroundTrans cEFEFEF gclickprog2 vtextgrad18
	Gui, Add, Progress, x170 y259 w31 h50 vgrad18 +border
Gui, Add, text, x200 y259 w31 h50 +BackgroundTrans cEFEFEF gclickprog2 vtextgrad19
	Gui, Add, Progress, x200 y259 w31 h50 vgrad19 +border
Gui, Add, text, x230 y259 w31 h50 +BackgroundTrans cEFEFEF gclickprog2 vtextgrad20
	Gui, Add, Progress, x230 y259 w31 h50 vgrad20 +border
Gui, Add, text, x260 y259 w31 h50 +BackgroundTrans cEFEFEF gclickprog2 vtextgrad21
	Gui, Add, Progress, x260 y259 w31 h50 vgrad21 +border
Gui, Add, text, x290 y259 w31 h50 +BackgroundTrans cEFEFEF gclickprog2 vtextgrad22
	Gui, Add, Progress, x290 y259 w31 h50 vgrad22 +border
Gui, Add, text, x320 y259 w31 h50 +BackgroundTrans cEFEFEF gclickprog2 vtextgrad23
	Gui, Add, Progress, x320 y259 w31 h50 vgrad23 +border
Gui, Add, text, x350 y259 w31 h50 +BackgroundTrans cEFEFEF gclickprog2 vtextgrad24
	Gui, Add, Progress, x350 y259 w31 h50 vgrad24 +border
Gui, Add, DropDownList, x103 y175 w160 gadvancedSelect va1 choose%a1% +altsubmit, Darker|Lighter|Brighter|More Saturated|Less Saturated|More Saturated and Darker|More Saturated and Lighter|More Saturated and Brighter|Less Saturated and Darker|Less Saturated and Lighter|Less Saturated and Brighter|Cooler|Warmer|To Another Colour
Gui, Add, Text, x20 y214 w74 h23 va2, Select a style:
Gui, Add, DropDownList, x103 y210 w120 va3 gRadChange choose%a3% +altsubmit, Linear|Radial|Conical
Gui, Add, CheckBox, x237 y209 w120 h23 va4, Inversed
Gui, Add, Text, x20 y248 w35 h23 va5, Steps:
Gui, Add, Edit, x55 y245 w33 h21 va6 gStepsType +Center +Number +Limit3, %a7%
Gui, Add, Slider, x11 y269 w120 h32 va7 gStepsGlide Range1-360 +altsubmit +page8, %a7%
Gui, Add, Text, x148 y248 w48 h23 va8, Rotation:
Gui, Add, Edit, x196 y245 w33 h21 va9 gRotateType +Center +Number +Limit3, %a10%
Gui, Add, Slider, x140 y269 w120 h32 va10 gRotateGlide Range0-360 +altsubmit +page8, %a10%
Gui, Add, Text, x278 y248 w35 h23 va11, Noise:
Gui, Add, Edit, x313 y245 w33 h21 va12 gNoiseType +Center +Number +Limit3, %a13%
Gui, Add, Slider, x270 y269 w120 h32 va13 gnoiseGlide Range0-128 +altsubmit +page8, %a13%
Gui, Add, Progress, x357 y175 w23 h21 va14 +border, 0
Gui, Add, Button, x275 y174 w70 h23 va15 gpicker, Select
Gui, Add, Button, x18 y316 w80 h24 va16 gadvanceB1, Generate
Gui, Add, Button, x18 y350 w80 h24 va17 gadvanceB2, Save As...
Gui, Add, Button, x108 y316 w80 h24 va18 gadvanceB3, View Code
Gui, Add, Button, x108 y350 w80 h24 va19 gadvanceB4, Open With
Gui, Add, Text, x199 y308 w1 h75 va20 +0x1 +0x10
Gui, Add, Button, x212 y316 w80 h24 va21 gshowNoisey, Noise Type
Gui, Add, Button, x212 y350 w80 h24 va22 gdirector, Direction
Gui, Add, Button, x302 y316 w80 h24 gbriefer va23, Brief Mode
Gui, Add, Button, x302 y350 w80 h24 va24 gadvanMennu, Reset
if (a1 != 14)
{
	GuiControl, Disable, a14
	GuiControl, Disable, a15
	GuiControl, Disable, a22
}
if (a23 = 1)
	gosub, advancerpre
else
	gosub, briefpre
Menu, noisey, add, H, noiseyH, +Radio
Menu, noisey, add, S, noiseyS, +Radio
Menu, noisey, add, L / VB, noiseyL, +Radio
Menu, resetty, add, Reset Chosen %colortitle%, resetct
Menu, resetty, add, Reset All Options, advanRst
if (nType = 1)
	gosub, noiseyH
else if (nType = 2)
	gosub, noiseyS
else
	gosub, noiseyL

Gui, Tab, 3
Gui, Add, Text, x20 y179 w80 h23, Select a pattern:
Gui, Add, ListBox, x20 y204 w140 h175 0x100 choose%whichpattern% vprevsvg +altsubmit, 3D Cubes|Architect|Bathroom Floor|Boxes|Brick Wall|Bubbles|Checkers|Circuit Board|Corkscrew|Curtain|Cutout|Dalmatian Spots|Death Star|Diagonal Stripes|Diamonds|Dominos|Dots|Endless Clouds|Eyes|Falling Triangles|Flipped Diamonds|Floating Cogs|Formal Invitation|Graph Paper|Happy Intersection|Heavy Rain|Hexagons|Hideout|Houndstooth|Jigsaw|Jupiter|Kiwi|Leaf|Line in Motion|Lips|Melt|Morphing Diamonds|Overcast|Overlapping Circles|Overlapping Hexagons|Parkay Floor|Pie Factory|Pixel Dots|Polka Dots|Rain|Random Shapes|Signal|Slanted Stars|Squares in Squares|Squares|Steel Beams|Stripes|Tic-tac-toe|Topography|Trippy Squares|Velvet|Wallpaper|Waves|Wiggle|YYY
Gui, Add, Text, x173 y179 w200 h40, An SVG file will be generated when previewed. It can be opened with your default browser or image editing program.
Gui, Add, Button, x173 y234 w80 h23 gsvgprev, Generate
Gui, Add, Button, x173 y275 w80 h23 gsavevg, Save As...
Gui, Add, Button, x173 y316 w80 h23 gopewith, Open With
Gui, Add, Button, x173 y357 w80 h23 gviewc, View Code

Gui, Tab, 4
Gui, Add, Edit, x6 y161 w389 h194 hwndhEdit vMyEdit, The quick brown fox jumps over the lazy dog.`n`n1234567890`n`n!@#$`%^&*()[]\/{}<>-_=+|`;':",.?``~¡¢£¥¦©®™°±¿`n`nJackdaws love my big sphinx of quartz.
if ((f1 = 1) && (b1 != 1)) ; if font is automatic but background is stationary
	CtlColors.Attach(hEdit, ccolor2, "Black")
if ((f1 != 1) && (b1 = 1)) ; if font is stationary but background is automatic
	CtlColors.Attach(hEdit, "White", ccolor3)
Gui, Add, Button, x13 y363 w80 h23 gconfigfont, Configure Font
Gui, Add, Button, x99 y363 w93 h23 gconfigcolur, Configure %colortitle%s
Gui, Add, Button, x198 y363 w80 h23 gresetmenu, Reset
Menu, resetcolor, add, Reset Font, resetfontbutton
Menu, resetcolor, add, Reset %colortitle%s, resetcolorsbutton
Menu, resetcolor, add, Reset Text, resettextbutton
Menu, resetcolor, add, Reset All, resetallbutton
if (analyziz = 1)
{
	bayl1 = FF0000
	bayl2 = 008000
	bayl3 = 0000FF
	txayl1 = Red
	txayl2 = Green
	txayl3 = Blue
}
else if (analyziz = 2)
{
	bayl1 = FF0000
	bayl2 = FFFF00
	bayl3 = 0000FF
	txayl1 = Red
	txayl2 = Yellow
	txayl3 = Blue
}
else if (analyziz = 3)
{
	bayl1 = 00FFFF
	bayl2 = FF00FF
	bayl3 = FFFF00
	txayl1 = Cyan
	txayl2 = Magenta
	txayl3 = Yellow
}

Gui, Tab, 5
Gui, Add, Text, x20 y179 w80 h23, Select a format:
Gui, Add, DropDownList, x103 y175 w140 gysisfig +altsubmit choose%analyziz% vanalyziz, RGB|RYB|CMY|CMYK
Gui, Add, Progress, x65 y230 w50 h130 vanprog1 +c%bayl1% +Vertical +Border, 0
Gui, Add, Progress, x175 y230 w50 h130 vanprog2 +c%bayl2% +Vertical +Border, 0
Gui, Add, Progress, x285 y230 w50 h130 vanprog3 +c%bayl3% +Vertical +Border, 0
Gui, Add, Text, x65 y207 w50 h23 vantext1 +0x200 +Center, 0`%
Gui, Add, Text, x175 y207 w50 h23 vantext2 +0x200 +Center, 0`%
Gui, Add, Text, x285 y207 w50 h23 vantext3 +0x200 +Center, 0`%
Gui, Add, Text, x65 y360 w50 h23 vptext1 +0x200 +Center, %txayl1%
Gui, Add, Text, x175 y360 w50 h23 vptext2 +0x200 +Center, %txayl2%
Gui, Add, Text, x285 y360 w50 h23 vptext3 +0x200 +Center, %txayl3%
Gui, Add, Progress, x43 y230 w50 h130 v2anprog1 +c00FFFF +Vertical +Border, 0
Gui, Add, Progress, x131 y230 w50 h130 v2anprog2 +cFF00FF +Vertical +Border, 0
Gui, Add, Progress, x219 y230 w50 h130 v2anprog3 +cFFFF00 +Vertical +Border, 0
Gui, Add, Progress, x307 y230 w50 h130 v2anprog4 +c000000 +Vertical +Border, 0
Gui, Add, Text, x43 y207 w50 h23 +0x200 v2antext1 +Center, 0`%
Gui, Add, Text, x131 y207 w50 h23 +0x200 v2antext2 +Center, 0`%
Gui, Add, Text, x219 y207 w50 h23 +0x200 v2antext3 +Center, 0`%
Gui, Add, Text, x307 y207 w50 h23 +0x200 v2antext4 +Center, 0`%
Gui, Add, Text, x43 y360 w50 h23 v2ptext1 +0x200 +Center, Cyan
Gui, Add, Text, x131 y360 w50 h23 v2ptext2 +0x200 +Center, Magenta
Gui, Add, Text, x219 y360 w50 h23 v2ptext3 +0x200 +Center, Yellow
Gui, Add, Text, x307 y360 w50 h23 v2ptext4 +0x200 +Center, Black

gosub, barappear
gosub, fixtext
gosub, layoutconfig
donecreating = 1
Gui, 1:+hwndcompactUI
LV_ColorInitiate()
if (stayon = 1)
	gui, 1:+alwaysontop
else
	gui, 1:-alwaysontop
Hotkey, Del, deleteselected, On
gui, 1:show, hide center w400 h400, PixelWorks
if (updownpos = 1)
	gui, 1:show, w400 h400, PixelWorks
else
	gui, 1:show, w400 h140, PixelWorks
gosub, magnificent
R = 50
ifexist, %1%
{
	opener = %1%
	gosub skipfileselectfile
}
gosub, redraw4compact
Return

advancedSelect:
gui, 1:submit, NoHide
if (a1 != 14)
{
	GuiControl, Disable, a14
	GuiControl, Disable, a15
	GuiControl, Disable, a22
}
else
{
	GuiControl, Enable, a14
	GuiControl, Enable, a15
	GuiControl, Enable, a22
}
return

noiseGlide:
gui, 1:submit, nohide
GuiControl, 1:, a12, %a13%
return

noiseType:
gui, 1:submit, nohide
if (a12 > 128)
{
	a12 = 128
	guicontrol, 1:, a12, %a12%
}
guicontrol, 1:, a13, %a12%
return

advanceB1:
genPress = 1
goto advancedGen

advanceB2:
genPress = 2
goto advancedGen

advanceB3:
genPress = 3
goto advancedGen

advanceB4:
genPress = 4
goto advancedGen

advancedGen:
gui, 1:submit, NoHide
if (a12 > a6)
{
	gui, 1:+OwnDialogs
	msgbox, 0x10, Error, The noise level cannot be higher than the number of steps.
	return
}
colorArr := gradientMachine(storedhu, storedinisat, storedinilight, a6, a1, hu3, saturat3, lightn3, forwardBackH-1, forwardBackS-1, forwardBackL-1, 0)
if (a4 = 1) ; Inverse
{
	tempArray := []
	loop, % colorArr.length()
		tempArray.push(colorArr[colorArr.length() - a_index + 1])
	loop, % colorArr.length()
		colorArr[a_index] := tempArray[a_index]
}
fileloc := svgGrad(colorArr, a3, a6, a12, nType, a9)
if (genPress = 1)
	goto prevAdvance
else if (genPress = 2)
{
	if (fileloc = "F")
		return
	filename = Gradient
	goto saveAdvance
}
else if (genPress = 3)
	goto noteAdvance
else
	goto withAdvance
return

noiseyH:
nType = 1
Menu, noisey, Uncheck, S
Menu, noisey, Uncheck, L / VB
Menu, noisey, Check, H
return

noiseyS:
nType = 2
Menu, noisey, Uncheck, H
Menu, noisey, Uncheck, L / VB
Menu, noisey, Check, S
return

noiseyL:
nType = 3
Menu, noisey, Uncheck, H
Menu, noisey, Uncheck, S
Menu, noisey, Check, L / VB
return

resetct:
gui +OwnDialogs
msgbox, 0x34, Warning, Are you sure that you want to reset the chosen %colorcolour%?
IfMsgbox No
	return
resetctskipdiag:
hu3 = 0
saturat3 = 0
lightn3 = 94
guicontrol, +BackgroundEFEFEF, a14
return

advanMennu:
menu, resetty, show
return

advanRst:
gui, 1:+OwnDialogs
msgbox, 0x34, Warning, Are you sure that you want to reset all of the options?
IfMsgBox, No
	return
GuiControl, Choose, a1, 1
GuiControl, Choose, a3, 1
guicontrol, text, a8, Rotation:
GuiControl,, a4, 0
GuiControl,, a6, 360
GuiControl,, a7, 360
GuiControl,, a9, 0
GuiControl,, a10, 0
guicontrol, +Range0-360 +page8, a10
GuiControl,, a12, 0
GuiControl,, a13, 0
gosub, resetctskipdiag
GuiControl, Disable, a14
GuiControl, Disable, a15
GuiControl, Disable, a22
gosub, noiseyH
return

showNoisey:
menu, noisey, show
return

RadChange:
gui, 1:submit, nohide
if (a3 = 3)
{
	guicontrol, text, a8, Radius:
	guicontrol,, a9, 0
	guicontrol,, a10, 0
	guicontrol, +Range0-50 +page5, a10
	guicontrol, enable, a8
	guicontrol, enable, a9
	guicontrol, enable, a10
}
else if (a3 = 2)
{
	guicontrol, disable, a8
	guicontrol, disable, a9
	guicontrol, disable, a10
}
else
{
	guicontrol, text, a8, Rotation:
	guicontrol,, a9, 0
	guicontrol,, a10, 0
	guicontrol, +Range0-360 +page8, a10
	guicontrol, enable, a8
	guicontrol, enable, a9
	guicontrol, enable, a10
}
return

rotateGlide:
gui, 1:submit, nohide
GuiControl, 1:, a9, %a10%
return

rotateType:
gui, 1:submit, nohide
if (a9 > 360)
{
	a9 = 360
	guicontrol, 1:, a9, %a9%
}
guicontrol, 1:, a10, %a9%
return

stepsGlide:
gui, 1:submit, nohide
GuiControl, 1:, a6, %a7%
return

stepsType:
gui, 1:submit, nohide
if (a6 > 360)
{
	a6 = 360
	guicontrol, 1:, a6, %a6%
}
else if (a6 < 1)
{
	a6 = 1
	guicontrol, 1:, a6, %a6%
}
guicontrol, 1:, a7, %a6%
return

advancerpre: ; Hide elements from brief mode
guicontrol, hide, whichgrad
guicontrol, hide, vance
guicontrol, hide, resetchos
guicontrol, hide, choosegrad
guicontrol, hide, progchoose
guicontrol, hide, gradselval
guicontrol, hide, selectedgrad
guicontrol, hide, copygrad
guicontrol, hide, insertgrad
loop, 24
{
	guicontrol, hide, textgrad%a_index%
	guicontrol, hide, grad%a_index%
}
hu3 = 0
saturat3 = 0
lightn3 = 94
guicontrol, +BackgroundEFEFEF, a14
return

advancer:
a23 = 1
gosub, advancerpre
loop, 24
	guicontrol, show, a%a_index%
return

briefpre:
a23 = 0
loop, 24
	guicontrol, hide, a%a_index%
hu3 = 0
saturat3 = 0
lightn3 = 94
guicontrol, +BackgroundEFEFEF, ProgChoose
return

briefer:
gosub, briefpre
guicontrol, show, whichgrad
guicontrol, show, vance
guicontrol, show, resetchos
guicontrol, show, choosegrad
guicontrol, show, progchoose
guicontrol, show, gradselval
guicontrol, show, selectedgrad
guicontrol, show, copygrad
guicontrol, show, insertgrad
loop, 24
{
	guicontrol, show, textgrad%a_index%
	guicontrol, show, grad%a_index%
}
return

; ABOUT UI
aboutui:
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
Return

; CONFIGURE HOTKEY GUI ROUTINE
hotkeyconfigui:
suspend, on
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
currentfocus = hkey1
onmessage(0x202, "which") ; left mouse click release
onmessage(0x101, "which") ; keyboard release
Return

; TOOLTIP CONFIGURATION UI
genconfigui:
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
Return

; SETS UP VARIABLES FOR CUSTOM HOTKEY UI
custfig1:
varpre = a
goto custhotkeyconf

custfig2:
varpre = b
goto custhotkeyconf

custfig3:
varpre = c
goto custhotkeyconf

; CUSTOM HOTKEY UI
custhotkeyconf:
loop, 35
{
	ifequal, %varpre%jenna%a_index%,
		%varpre%jenna%a_index% = 0
	varnow%a_index% := % %varpre%jenna%a_index%
}
; WE HAVE TO USE HWND IN THIS CASE AS WE HAVE 3 SETS OF VARIABLES AND WHEN USER PRESSES "RESET" IT IS MORE EFFICENT TO CALL ONLY 1 VARIABLE INSTEAD OF FIGURING OUT WHICH PAIR
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
Return

; SETS UP CREATION OF ZOOM CHANGE UI
zoomyui:
slidermode = Zoom
slider := zoom
if (curryui = 1)
	range = 50
else
	range = 512
rangemin = 1
unit = `%
defaultslide = 18
goto sliderui

; SETS UP CREATION OF DELAY CHANGE UI
delayyui:
slidermode = Delay
slider := delay
range = 500
rangemin = 0
unit = ms
defaultslide = 0

; MINI SLIDER UI
sliderui:
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
Return

; ADD NOTES TO LIST ENTRY
notes:
NumBHEART := LV_GetNext(0)
LV_GetText(listText, numBHEART, 4)
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
return

; WARNING ON GUI CLOSE
guiwarning:
shouldiclose := preclosemsg()
if (shouldiclose = 1)
	exitapp
Return

preclosemsg()
{
	global checkedneveragain,compactUI,colorcolour
	Instruction := "Are you sure that you want to close PixelWorks?"
	Content := "All picked " . colorcolour . "s will be lost unless you saved the " . colorcolour . " list."
	Title := "Warning"
	MainIcon := LoadPicture("shell32.dll", "w32 Icon66", ImageType)
	Flags := 0x102
	Buttons := 0x6
	CheckText := "In the future, do not show me this dialog box"
	Parent := compactUI

	; TASKDIALOGCONFIG structure
	x64 := A_PtrSize == 8
	NumPut(VarSetCapacity(TDC, x64 ? 160 : 96, 0), TDC, 0, "UInt") ; cbSize
	NumPut(Parent, TDC, 4, "Ptr") ; hwndParent
	NumPut(Flags, TDC, x64 ? 20 : 12, "Int") ; dwFlags
	NumPut(Buttons, TDC, x64 ? 24 : 16, "Int") ; dwCommonButtons
	NumPut(&Title, TDC, x64 ? 28 : 20, "Ptr") ; pszWindowTitle
	NumPut(MainIcon, TDC, x64 ? 36 : 24, "Ptr") ; pszMainIcon
	NumPut(&Instruction, TDC, x64 ? 44 : 28, "Ptr") ; pszMainInstruction
	NumPut(&Content, TDC, x64 ? 52 : 32, "Ptr") ; pszContent
	NumPut(&CheckText, TDC, x64 ? 92 : 60, "Ptr") ; pszVerificationText
	soundplay *48
	DllCall("Comctl32.dll\TaskDialogIndirect", "Ptr", &TDC, "Int*", Button := 0, "Int*", Radio := 0, "Int*", Checked := 0)

	If (Button == 6)
		var = 1
	Else If (Button == 7)
		var = 0
	If (Checked)
		checkedneveragain = 1
	else
		checkedneveragain = 0
	return var
}

; CONFIGURE FONT COLOR DIALOG
configcolur:
uimade = 0
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
uimade = 1
Return

director:
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
Return

10submit:
gui, 10:submit, nohide
loop, 3
{
	ifequal, forwardBackH%a_index%, 1
		forwardBackH := a_index
	ifequal, forwardBackS%a_index%, 1
		forwardBackS := a_index
	ifequal, forwardBackL%a_index%, 1
		forwardBackL := a_index
}
gui, 1:-disabled
gui, 10:Destroy
return

10reset:
GuiControl, 10:, forwardBackH3, 1
GuiControl, 10:, forwardBackS3, 1
GuiControl, 10:, forwardBackL3, 1
return

; ACTIVATES ON CLICK OF COLOR LIST TO SHOW COLOR DIALOG OR MODIFY COLOR IN HARMONY ZONE
whichClick:
if a_guievent not in Normal,DoubleClick ; We only want to focus on click or doubleclick events. we don't care about dragging or keyboard focus events
	return
skipeventprep:
; Now, due to AutoHotkey limitations, we have to do a workaround to determine if we have a double or single click. we use settimer as a workaround
if (winc_presses > 0) ; SetTimer already started, so we log the keypress instead.
{
	currentclick := LV_GetNext(0) ; It's possible that in the 250 millisecond timeframe, the user could select 1 value and quickly select another - we have done this to make it so the color picker doesn't show up if there's been 2 different values clicked in this timeframe
	if (originalclick != currentclick)
		winc_presses = 0
    winc_presses += 1
    return
}
originalclick := LV_GetNext(0) ; Relates to the previous comment
winc_presses = 1
SetTimer, KeyWinC, -250 ; Wait for more presses within a 250 millisecond window.
return

KeyWinC:
if (winc_presses = 1) ; The key was pressed once.
{
	gosub resetcount
	goto single
}
else if (winc_presses >= 2) ; The key was pressed twice or more than that
{
	gosub resetcount
	goto double
}

; Regardless of which action above was triggered, reset the count for all variables
resetcount:
winc_presses = 0
originalclick = 0
currentclick = 0
return

listener:
GuiControlGet, FocusedControl, FocusV
if (FocusedControl != "LV_Sample")
	return
else
	goto skipeventprep

singlev2:
if (lastselected = "")
	return
LV_GetText(typeselected, lastselected, 3)
insert2harmon := % Line_Color_%lastselected%_Back
insert2harmon := flipper(insert2harmon)
1click = 1
goto configharmony

single:
singleclicked := LV_GetNext(0)
lastselected := singleclicked
if (singleclicked = 0)
{
	if picking in 1,2,3
	{
		if picking in 2,3
			gui, 1:+disabled
		picking = 0
	}
	return
}
if (picking = 1)
{
	picking = 0
	mycolor :=  % Line_Color_%singleclicked%_Back
	mycolor := flipper(mycolor)
	colorgetfunc("mycolornew", "HSBSPLITSep", mycolor)
	if (a23 != 1)
	{
		guicontrol, +Background%mycolor%, ProgChoose
		guicontrol, 1:disable, copygrad
		guicontrol, 1:disable, insertgrad
		guicontrol, 1:, selectedgrad, None
		goto configrad
	}
	else
	{
		guicontrol, +Background%mycolor%, a14
		return
	}
}
else if (picking = 2)
{
	picking = 0
	ccolor2temp := % Line_Color_%singleclicked%_Back
	ccolor2temp := flipper(ccolor2temp)
	guicontrol, 9:+Background%ccolor2temp%, ProgChooseBack
	ccolor2temp := substr(ccolor2temp, -5)
	gui, 1:+disabled
	return
}
else if (picking = 3)
{
	picking = 0
	ccolor3temp := % Line_Color_%singleclicked%_Back
	ccolor3temp := flipper(ccolor3temp)
	guicontrol, 9:+Background%ccolor3temp%, ProgChooseFont
	ccolor3temp := substr(ccolor3temp, -5)
	gui, 1:+disabled
	return
}
LV_GetText(typeselected, singleclicked, 3)
insert2harmon := % Line_Color_%singleclicked%_Back
insert2harmon := flipper(insert2harmon)
colorpreva := substr(insert2harmon, -5)
if ((f1 = 1) && (b1 != 1)) ; If font color is automatic but background is not
{
	ccolor3 := colorpreva
	ccolor3temp := ccolor3 ; We want to set the temp var in this case because if the user selects to pick a color from the list and they don't select anything and hit ok, it will use the current temp variable
	CtlColors.Change(hEdit, ccolor2, colorpreva)
}
else if ((f1 != 1) && (b1 = 1)) ; If back color is automatic but font is not
{
	ccolor2 := colorpreva
	ccolor2temp := ccolor2
	CtlColors.Change(hEdit, colorpreva, ccolor3)
}
1click = 1
goto configharmony
return

double:
if (picking != 0)
	goto single
leftclicked := LV_GetNext(0) ; Get the current selected item
if (leftclicked = 0)
	return
lastselected := leftclicked
LV_GetText(formatdialog, leftclicked, 3) ; Get the format of the selected item
insert2harmon := % Line_Color_%leftclicked%_Back
insert2harmon := flipper(insert2harmon)
1click = 1
gosub configharmony
ccolor := % Line_Color_%leftclicked%_Back
skihp:
Colors := []
if picking not in 2,3
	Colors := [ccolor]
else
{
	if (picking = 2)
		Colors := [flipper("0x" . ccolor2temp)]
	else if (picking = 3)
		Colors := [flipper("0x" . ccolor3temp)]
	else
	{
		gui, 9:+owndialogs
		msgbox, 0x10, Unknown Error, Something happened.
		return
	}
}
format := a_formatinteger
SetFormat IntegerFast, H
if picking not in 2,3
	MyColor := ChooseColor(Colors[1], compactUI, , , Colors*)
else
	MyColor := ChooseColor(Colors[1], coloryui, , , Colors*)
stringtrimleft, mycolor, mycolor, 2
checklen:
lenth := strlen(mycolor)
if (lenth < 6) ; We are doing this since the color dialog will not return the proper value if beginning in zeroes. e.g. it gives 0xF0 instead of 0x0000F0
{
	mycolor = 0%mycolor%
	goto checklen
}
mycolor := "0x" . mycolor
if (picking = 1)
{
	picking = 0
	setformat, integerfast, %format%
	if (mycolor != ccolor)
		ccolor := mycolor
	else
		return
	mycolor := flipper(mycolor)
	colorgetfunc("mycolornew", "HSBSPLITSep", mycolor)
	if (a23 != 1)
	{
		guicontrol, +Background%mycolor%, ProgChoose
		guicontrol, 1:disable, copygrad
		guicontrol, 1:disable, insertgrad
		guicontrol,, selectedgrad, None
		goto configrad
	}
	else
	{
		guicontrol, +Background%mycolor%, a14
		return
	}
}
if (picking = 2)
{
	picking = 0
	if (mycolor != ccolor2temp)
		ccolor2temp := flipper(mycolor)
	guicontrol, 9:+Background%ccolor2temp%, ProgChooseBack
	ccolor2temp := substr(ccolor2temp, -5)
	return
}
if (picking = 3)
{
	picking = 0
	if (mycolor != ccolor3temp)
		ccolor3temp := flipper(mycolor)
	guicontrol, 9:+Background%ccolor3temp%, ProgChooseFont
	ccolor3temp := substr(ccolor3temp, -5)
	return
}
if (mycolor = ccolor)
	return
else
	Line_Color_%leftclicked%_Back := mycolor
setformat, integerfast, %format%
colorgetfunc("mycolorconverted", formatdialog, mycolor)
LV_Modify(leftclicked,,, mycolorconverted)
goto single
return

; CREATES THE COLOR DIALOG WINDOW
ChooseColor(pRGB := 0, hOwner := 0, DlgX := 0, DlgY := 0, Palette*)
{
	static CustColors    ; Custom colors are remembered between calls
	static SizeOfCustColors := VarSetCapacity(CustColors, 64, 0)
	static StructSize := VarSetCapacity(ChooseColor, 9 * A_PtrSize, 0)

	CustData := (DlgX << 16) | DlgY    ; Store X in high word, Y in the low word

	; Load user's custom colors
	for Index, Value in Palette
		NumPut(Value, CustColors, (Index - 1) * 4, "UInt")

	; Set up a ChooseColor structure as described in the MSDN
	NumPut(StructSize, ChooseColor, 0, "UInt")
	NumPut(hOwner, ChooseColor, A_PtrSize, "UPtr")
	NumPut(pRGB, ChooseColor, 3 * A_PtrSize, "UInt")
	NumPut(&CustColors, ChooseColor, 4 * A_PtrSize, "UPtr")
	NumPut(0x113, ChooseColor, 5 * A_PtrSize, "UInt")
	NumPut(CustData, ChooseColor, 6 * A_PtrSize, "UInt")
	NumPut(RegisterCallback("ColorWindowProc"), ChooseColor, 7 * A_PtrSize, "UPtr")

	; Call the function
	ErrorLevel := ! DllCall("comdlg32\ChooseColor", "UPtr", &ChooseColor, "UInt")
	
	; Save the changes made to the custom colors
	if not ErrorLevel
	{
		Loop 16
			Palette[A_Index] := NumGet(CustColors, (A_Index - 1) * 4, "UInt")
	}
       
	return NumGet(ChooseColor, 3 * A_PtrSize, "UINT")
}

; SUBROUTINE FOR PREVIOUS FUNCTION
ColorWindowProc(hwnd, msg, wParam, lParam)
{
	static WM_INITDIALOG := 0x0110

	if (msg != WM_INITDIALOG)
		return 0
    
	hOwner := NumGet(lParam+0, A_PtrSize, "UPtr")
	if (hOwner)
		return 0

	DetectSetting := A_DetectHiddenWindows
	DetectHiddenWindows On
	CustData := NumGet(lParam+0, 6 * A_PtrSize, "UInt")
	DlgX := CustData >> 16, DlgY := CustData & 0xFFFF
	WinMove ahk_id %hwnd%, , %DlgX%, %DlgY%
   
	DetectHiddenWindows %DetectSetting%
	return 0
}

; CHOOSE COLOR DIALOG FOR GRADIENT
picker:
menu, choocolor, show
return

pickerv2:
picking = 1
goto skihp

pickerv3:
picking = 1
OnMessage(0x201, "REMOVEVAR")
return

REMOVEVAR(wParam, lParam)
{
	global picking
	if (A_guicontrol != "LV_Sample")
		picking = 0
	OnMessage(0x201, "")
	return
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; BUTTON ROUTINES

; X BUTTON ROUTINES BELOW (GUICLOSE)
GuiClose:
if (whichcolumn > 0)
	goto guiwarning
skipwa:
gosub, dllclose
ExitApp

2guiclose:
gui, 1:-disabled
gui, 2:destroy
return

3GuiClose:
gui, 1:-disabled
gui, 2:-disabled
gui, 3:destroy
onmessage(0x202,"")
onmessage(0x101,"")
suspend, off
return

4GuiClose:
gui, 1:-disabled
gui, 4:destroy
return

5guiclose:
gui, 3:-disabled
gui, 5:destroy
return

6GuiClose:
gui, 1:-disabled
gui, 6:destroy
return

7guiclose:
gui, 1:-disabled
gui, 7:destroy
return

9guiclose:
picking = 0
gui, 1:-disabled
gui, 9:destroy
return

10guiclose:
gui, 1:-disabled
gui, 10:destroy
return

dllclose: ; Subroutine of guiclose to free GDI objects from memory
DllCall("gdi32.dll\DeleteObject", UInt,hbm_buffer)
DllCall("gdi32.dll\DeleteDC", UInt,hdc_frame )
DllCall("gdi32.dll\DeleteDC", UInt,hdd_frame )
DllCall("gdi32.dll\DeleteDC", UInt,hdc_buffer)
return

; FONT COLOR UI ROUTINES
captfon:
guicontrol, 9:disable, captback
picking = 0
gui, 1:+disabled
if (uimade = 1)
{
	guicontrol, 9:+Background%colorpreva%, ProgChooseFont
	ccolor3temp := colorpreva
}
return

captback:
guicontrol, 9:disable, captfont
picking = 0
gui, 1:+disabled
if (uimade = 1)
{
	guicontrol, 9:+Background%colorpreva%, ProgChooseBack
	ccolor2temp := colorpreva
}
return

encapback:
guicontrol, 9:enable, captback
picking = 3
gui, 1:-disabled
return

encapfon:
guicontrol, 9:enable, captfont
picking = 2
gui, 1:-disabled
return

fontdiagsel:
guicontrol, 9:enable, captback
gui, 1:+disabled
picking = 3
goto skihp

backdiagsel:
guicontrol, 9:enable, captfont
gui, 1:+disabled
picking = 2
goto skihp

ccall:
picking = 0
gui, 1:+disabled
GuiControlGet, firsttest,9:, captfont
GuiControlGet, secondtest,9:, captback
if ((firsttest != 1) && (secondtest != 1)) ; If none are automatic
{
	if (ccolor2temp = ccolor3temp) ; If colors are same
	{
		gui, 9:+owndialogs
		msgbox, 0x10, Error, The font %colorcolour% cannot be equal to the background %colorcolour% when automatic mode is disabled for both options.`n`nPlease correct this problem in order to continue.
		return
	}
}
gui, 9:submit
gui, 1:-disabled
gui, 9:destroy
f1 := captfont
f2 := fontsel
f3 := fontdiag
b1 := captback
b2 := backsel
b3 := backdiag
if ((f1 != 1) && (b1 != 1))
{
	ccolor3 := ccolor3temp
	ccolor2 := ccolor2temp
	CtlColors.Change(hEdit, ccolor2, ccolor3)
}
else if ((f1 = 1) && (b1 != 1))
{
	ccolor2 := ccolor2temp
	ccolor3 := colorpreva
	CtlColors.Change(hEdit, ccolor2, colorpreva)
}
else if ((f1 != 1) && (b1 = 1))
{
	ccolor2 := colorpreva
	ccolor3 := ccolor3temp
	CtlColors.Change(hEdit, colorpreva, ccolor3)
}
return

; ACTIVATES WHEN CONFIG FONT BUTTON IS PRESSED
configfont:
gui, 1:submit, nohide
Fnt_ChooseFontDlg(compactUI,$fontname, $fontoptions,"0x2","0","")
; Create new font
old_hFont := hFont
fixtext:
hFont :=Fnt_CreateFont($FontName,$FontOptions)
; Attach to the main Edit control
Fnt_SetFont(hEdit,hFont)
; Note: Do not redraw here.  It will be redrawn later.
; Delete the previous font, if any
Fnt_DeleteFont(old_hFont)
GUIControl, 1: +c#%colorpreva%, MyEdit
GUIControl, 1:+Redraw, MyEdit
return

; RESET FONT/COLOURS ROUTINE
resetcolorsbutton:
gui, 1:+owndialogs
msgbox, 0x34, Warning, Are you sure that you want to reset all of the %colorcolour%s?`n`nThis includes the %colorcolour% of the font as well as the %colorcolour% of the background.
ifmsgbox No
	return
rescb:
f1 = 0
f2 = 1
f3 = 0
b1 = 1
b2 = 0
b3 = 0

resetcolors:
ccolor2 = FFFFFF
ccolor2temp = FFFFFF
ccolor3 = 000000
ccolor3temp = 000000
if (f1 = 1)
	colorpreva = 000000
else if (b1 = 1)
	colorpreva = FFFFFF
else
	colorpreva = 000000
CtlColors.Change(hEdit, ccolor2, ccolor3)
return

resetfontbutton:
gui, 1:+owndialogs
msgbox, 0x34, Warning, Are you sure that you want to reset the font?`n`nThis includes the font face, size, style, and quality.
ifmsgbox No
	return
resfb:
$FontName :="Arial"
$FontOptions :="s20 cD59453"
goto fixtext

resettextbutton:
gui, 1:+OwnDialogs
msgbox, 0x34, Warning, Are you sure that you want to reset the text?`n`nThis will undo everything that you have typed.
IfMsgBox, No
	return
restb:
guicontrol,, myEdit, The quick brown fox jumps over the lazy dog.`n`n1234567890`n`n!@#$`%^&*()[]\/{}<>-_=+|`;':",.?``~¡¢£¥¦©®™°±¿`n`nJackdaws love my big sphinx of quartz.
return

resetallbutton:
gui, 1:+owndialogs
msgbox, 0x34, Warning, Are you sure that you want to reset the font, %colorcolour%s, and text?`n`nThis includes the font face, size, style, quality, %colorcolour%, background %colorcolour%, and all of the things that you have typed.
ifmsgbox No
	return
gosub, rescb
gosub, resfb
gosub, restb
return

resetmenu:
Menu, resetcolor, show
return

; SVG PREVIEW BUTTON
svgprev:
gui, 1:submit, nohide
controlvar := "#" . substr(varwhich, -5) ; varwhich is the variable used to determine the first color of each group of harmony boxes. we can't use colorpreva since this variable overlaps with the font function
fileloc := svgfunc(prevsvg, controlvar)
prevAdvance:
if (fileloc = "F")
	return
try
	run, %fileloc%
catch
	msgbox, 0x10, Error, Could not open the SVG file.`n`n[%fileloc%]
return

; VIEW CODE BUTTON
viewc:
gui, 1:submit, nohide
controlvar := "#" . substr(varwhich, -5)
fileloc := svgfunc(prevsvg, controlvar)
noteAdvance:
if (fileloc = "F")
	return
try
	run, notepad.exe "%fileloc%"
catch
	msgbox, 0x10, Error, Could not open the code of the SVG file.`n`n["%fileloc%"]
return

; SVG OPEN WITH
opewith:
gui, 1:submit,nohide
controlvar := "#" . substr(varwhich, -5)
fileloc := svgfunc(prevsvg, controlvar)
withAdvance:
if (fileloc = "F")
	return
DllCall("shell32\OpenAs_RunDLL" (A_IsUnicode ? "W" : ""),"UInt",0,"UInt",0,"Str",fileloc)
return

; SAVE SVG ROUTINE
savevg:
gui, 1:submit, nohide
controlvar := "#" . substr(varwhich, -5)
fileloc := svgfunc(prevsvg, controlvar)
if (fileloc = "F")
	return
guicontrol, -altsubmit, prevsvg
guicontrolget, filename,, prevsvg
guicontrol, +altsubmit, prevsvg
saveAdvance:
gui, 1:+owndialogs
locat := SelectFile(compactUI, "Save As", "SVG Files (*.svg)|All Files (*.*)", "1", filename, ".svg", "S CREATEPROMPT OVERWRITEPROMPT")
if (locat = "")
	return
else
{
	ifexist, %fileloc%
	{
		try
			filemove, %fileloc%, %locat%, 1
		catch
			msgbox, 0x10, Error, Failed to save the SVG file.`n`n[%locat%]
	}
	else
		msgbox, 0x10, Error, Temp file has gone missing.`n`n[%fileloc%]
}
return

; ACTIVATES WHEN THE UP/DOWN BUTTON IS PRESSED
updownconf:
if (updownpos = 1)
	updownpos = 0
else
	updownpos = 1

; THIS LABEL IS HERE TO SKIP THE PREVIOUS SECTION IN THE INITIAL UI CREATION SINCE WE ARE NOT TRYING TO FLIP THE VALUES
updown:
if (animate = 1)
	critical
else
	critical, off
if (updownpos = 1)
{
	guicontrol,, ud, ▲
	newheight = 140
	if (animate = 1)
	{
		loop, 65
		{
			newheight := newheight + 4
			gui, show, w400 h%newheight%, PixelWorks
		}
	}
	else
		gui, show, w400 h400, PixelWorks
}
else
{
	guicontrol,,ud, ▼
	newheight = 400
	if (animate = 1)
	{
		loop, 65
		{
			newheight := newheight - 4
			gui, show, w400 h%newheight%, PixelWorks
		}
	}
	else
		gui, show, w400 h140, PixelWorks
}
critical, off
return

; THE COPY HARMONY BUTTON
copyharmony:
guicontrolget, insertion,, selectedhar
clipboard := insertion
return

copygrad:
guicontrolget, insertion,, selectedgrad
clipboard := insertion
return

clickprog2:
mode = grad
goto prog

; ACTIVATES WHEN YOU CLICK ON A COLOR TO INSERT CODE INTO EDIT BOX
clickprog:
mode = harmon

prog:
guicontrolget, text,, %A_GuiControl%
stringtrimleft, text, text, 5 ; Remove new line chars
if (text = "")
	return
else
	colorgetfunc("textins", typeselected, text)
if (mode = "harmon")
{
	insertoriginalh := text
	guicontrol,, selectedhar, %textins%
	guicontrol, 1:enable, inserter
	guicontrol, 1:enable, copyhan
}
else
{
	insertoriginalg := text
	guicontrol,, selectedgrad, %textins%
	guicontrol, 1:enable, insertgrad
	guicontrol, 1:enable, copygrad
}
return

; EASTER EGG
surprise:
eegglaunch = 1
try
	runwait, %a_workingDir%\Karma Chameleon.scr /s
catch
{
	gui, 2:+owndialogs
	msgbox, 0x10, Error, Could not launch Easter Egg! :(
}
eegglaunch = 0
return

; HOTKEY OK BUTTON
hotup:
hot =
loop, 20 ; Get the contents of the gui controls without submitting the gui. this functions as a temporary storage to verify to see if the values do not have any errors - if all values are good to go, we will store the values later on
{
	guicontrolget, hot2%a_index%, 3:,hkey%a_index%
	if (hot2%a_index% != "") ; Check if value is not blank - we care about this because soon, we will check for duplicates - blank values are the only duplicates allowed, so we don't care about them while checking for duplicates
	{
		if (a_index > 1) ; During the first loop we do not want a leading pipe at the beginning of the string
			hot := hot . "|" . hot2%a_index% ; Create a list of the control contents separated by a pipe (|)
		else
			hot := hot2%a_index%
	}
}
Sort, hot, d| u ; Sorts the contents of the list while removing duplicates and storing the amount removed as errorlevel
if (errorlevel > 0)
{
	gui, 3:+owndialogs
	msgbox, 0x10, Error, Duplicate hotkeys are not allowed.`n`nPlease correct the value(s).
	gui, 3:-owndialogs
	return
}
gui, 3:submit,nohide
loop, 20 ; This part of the code stores the new hotkey value into the control variables on the GUI and disables all hotkeys
{
	hot%a_index% := hkey%a_index%
	varrem := % hotrememberer%a_index% . " Up" ; The "up" thing basically makes the hotkey only work on release
	ifnotequal, varrem, %a_space%Up
		hotkey, %varrem%, Off
}
loop, 20
{
	if (hot%a_index% != "")
	{
		var := % hot%a_index% . " Up"
		hotrememberer%a_index% := var
		Hotkey, %var%, hotzone%a_index%, on ; Turn the new hotkey on
	}
}
goto 3guiclose

; HOTKEY RESET ROUTINE
3reset:
if (currentfocus = hkey1)
	GuiControl, 3:, hkey1, !P
else if (currentfocus = hkey2)
	GuiControl, 3:, hkey2, !X
else if (currentfocus = hkey3)
	GuiControl, 3:, hkey3, !C
else if (currentfocus = hkey4)
	GuiControl, 3:, hkey4, !A
else if (currentfocus = hkey5)
	GuiControl, 3:, hkey5, !M
else if (currentfocus = hkey6)
	GuiControl, 3:, hkey6, !D
else if (currentfocus = hkey7)
	GuiControl, 3:, hkey7, !B
else if (currentfocus = hkey8)
	GuiControl, 3:, hkey8, !E
else if (currentfocus = hkey9)
	GuiControl, 3:, hkey9, !T
else if (currentfocus = hkey10)
	GuiControl, 3:, hkey10, !F
else if (currentfocus = hkey11)
	GuiControl, 3:, hkey11, !Down
else if (currentfocus = hkey12)
	GuiControl, 3:, hkey12, !Up
else if (currentfocus = hkey13)
	GuiControl, 3:, hkey13, !G
else if (currentfocus = hkey14)
	GuiControl, 3:, hkey14, !R
else if (currentfocus = hkey15)
	GuiControl, 3:, hkey15, !=
else if (currentfocus = hkey16)
	GuiControl, 3:, hkey16, !-
else if (currentfocus = hkey17)
	GuiControl, 3:, hkey17, !L
else if (currentfocus = hkey18)
	GuiControl, 3:, hkey18, None
else if (currentfocus = hkey19)
	GuiControl, 3:, hkey19, None
else if (currentfocus = hkey20)
	GuiControl, 3:, hkey20, None
return

; HOTKEY RESET ALL ROUTINE
3resetall:
GuiControl, 3:, hkey1, !P
GuiControl, 3:, hkey2, !X
GuiControl, 3:, hkey3, !C
GuiControl, 3:, hkey4, !A
GuiControl, 3:, hkey5, !M
GuiControl, 3:, hkey6, !D
GuiControl, 3:, hkey7, !B
GuiControl, 3:, hkey8, !E
GuiControl, 3:, hkey9, !T
GuiControl, 3:, hkey10, !F
GuiControl, 3:, hkey11, !Down
GuiControl, 3:, hkey12, !Up
GuiControl, 3:, hkey13, !G
GuiControl, 3:, hkey14, !R
GuiControl, 3:, hkey15, !=
GuiControl, 3:, hkey16, !-
GuiControl, 3:, hkey17, !L
GuiControl, 3:, hkey18, None
GuiControl, 3:, hkey19, None
GuiControl, 3:, hkey20, None
return

; TOOLTIP OK BUTTON
genok:
amountselected = 0
loop, 35
{
	guicontrolget, genz%a_index%, 4:,gen%a_index%
	ifequal, genz%a_index%, 1
		envadd, amountselected, 1
}
if (amountselected > 10)
{
	gui, 4:+owndialogs
	msgbox, 0x34, Warning, You have selected more than 10 items to be displayed in the tooltip.`n`nThis might cause the application perform poorly. The tooltip might also be too large and take up too much screen space.`n`nAre you sure that you want to continue?
	gui, 4:-owndialogs
	ifmsgbox No
		return
}
gui, 4:submit, nohide
goto 4guiclose
return

; RESET TOOLTIP BUTTON
4reset:
guicontrol, 4:, gen1, 0
guicontrol, 4:, gen2, 1
guicontrol, 4:, gen3, 1
guicontrol, 4:, gen4, 1
guicontrol, 4:, gen5, 0
guicontrol, 4:, gen6, 0
guicontrol, 4:, gen7, 0
guicontrol, 4:, gen8, 0
guicontrol, 4:, gen9, 0
guicontrol, 4:, gen10, 0
guicontrol, 4:, gen11, 1
guicontrol, 4:, gen12, 0
guicontrol, 4:, gen13, 1
guicontrol, 4:, gen14, 0
guicontrol, 4:, gen15, 0
guicontrol, 4:, gen16, 1
guicontrol, 4:, gen17, 0
guicontrol, 4:, gen18, 1
guicontrol, 4:, gen19, 0
guicontrol, 4:, gen20, 1
guicontrol, 4:, gen21, 0
guicontrol, 4:, gen22, 0
guicontrol, 4:, gen23, 0
guicontrol, 4:, gen24, 0
guicontrol, 4:, gen25, 1
guicontrol, 4:, gen26, 0
guicontrol, 4:, gen27, 0
guicontrol, 4:, gen28, 0
guicontrol, 4:, gen29, 0
guicontrol, 4:, gen30, 0
guicontrol, 4:, gen31, 0
guicontrol, 4:, gen32, 0
guicontrol, 4:, gen33, 0
guicontrol, 4:, gen34, 1
guicontrol, 4:, gen35, 0
return

; CUSTOM SAVE HOTKEY
custsavehot:
matchlistem =
array%varpre% := []
arraycount%varpre% =
loop, 35
{
	guicontrolget, itemn, 5:, %varpre%jenna%a_index%
	if (itemn = 1)
	{
		guicontrolget, itemn, 5:, %varpre%jenna%a_index%, Text
		array%varpre%.Push(itemn)
		%varpre%jenna%a_index% = 1
		envadd, arraycount%varpre%, 1
	}
	else
		%varpre%jenna%a_index% = 0
}
goto 5guiclose

; CUSTOM HOTKEY RESET ROUTINE
customhotreset:
loop, 35
{
	currentReset := x%a_index%
	control, uncheck,,, ahk_id %currentReset%
}
return

; OK BUTTON ON SLIDER UI
sliderk:
gui, 6:submit, nohide
if (slidermode = "Zoom")
	zoom := slidervar
if (slidermode = "Delay")
	delay := slidervar
goto 6guiclose

; RESET SLIDER
sliderreset:
guicontrol, 6:, slidervar, %defaultslide%
guicontrol, 6:, slideredit, %defaultslide%
return

; ACTIVATES WHEN USER SELECTS OK ON NOTE DIALOG
notek:
try
	guicontrolget, thenote,, notevarre
catch
{
	gui, 7:+owndialogs
	msgbox, 0x10, Error, Something happened.
	goto noteclear
}
lenth := strlen(thenote)
if (lenth > 500)
{
	amountnote := lenth - 500
	gui, 7:+owndialogs
	msgbox, 0x10, Error, The string is too long.`n`nPlease remove at least %amountnote% character(s) in order to continue.
	return
}
ifinstring, thenote, |
{
	gui, 7:+owndialogs
	msgbox, 0x10, Error, The pipe character "|" is not allowed.
	return
}
gui, 1:default
LV_Modify(numBHEART, "Col4", thenote)
goto 7guiclose
return

; CLEAR NOTE ROUTINE
noteclear:
guicontrol,, notevarre,
return

; RESET CHOSEN COLOUR ROUTINE
reschos:
gui +OwnDialogs
msgbox, 0x34, Warning, Are you sure that you want to reset the chosen %colorcolour%?
IfMsgbox No
	return
ccolor = 0xEFEFEF
hu3 = 0
saturat3 = 0
lightn3 = 94
guicontrol, +Background%ccolor%, ProgChoose
guicontrol, 1:disable, copygrad
guicontrol, 1:disable, insertgrad
guicontrol,, selectedgrad, None
goto configrad
return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; MENU ROUTINES

; CREATE MENU ON GUI
menumaker:
menu, tray, nostandard
menu, tray, deleteall
if curryui in 1,4
{
	Menu, FileMenu, Add, Open..., canopener
	Menu, FileMenu, Add, Save List, saver
	Menu, FileMenu, Add, Save List As..., savelistas
	Menu, FileMenu, Add, Clear All, clearer
	menu, FileMenu, Add, Exit, guiclose
	menu, FileMenu, disable, Save List
	menu, FileMenu, disable, Save List As...
	menu, FileMenu, disable, Clear All
	disabledfilemenu = 1
	Menu, MenuBar, Add, File, :FileMenu
	Menu, Tray, Add, File, :FileMenu
}
if curryui in 1,3
{
	Menu, MagnifierMenu, Add, Zoom, zoomyui
	Menu, MagnifierMenu, Add, Antialize, anti
	if (antialize = 1)
		menu, MagnifierMenu, check, Antialize
	else
		menu, MagnifierMenu, uncheck, Antialize
	Menu, MagnifierMenu, Add, Show Cross Lines, showcrs
	if (showcross = 1)
		menu, MagnifierMenu, check, Show Cross Lines
	else
		menu, MagnifierMenu, uncheck, Show Cross Lines
	Menu, OptionsMenu, Add, Magnifier, :MagnifierMenu
}
Menu, TooltipMenu, Add, Configure, genconfigui
Menu, TooltipMenu, Add, Auto Tooltip, autotltiphandl, +radio
if (autotool = 1)
	menu, TooltipMenu, check, Auto Tooltip
else
	menu, TooltipMenu, uncheck, Auto Tooltip
Menu, TooltipMenu, Add, Always Show, alwahandler, +radio
if (alwystooltip = 1)
{
	menu, TooltipMenu, check, Always Show
	menu, TooltipMenu, uncheck, Auto Tooltip
}
else
	menu, TooltipMenu, uncheck, Always Show
Menu, TooltipMenu, Add, Hide on Self-Hover, hoverhide
if (hoverblock = 1)
	menu, TooltipMenu, check, Hide on Self-Hover
else
	menu, TooltipMenu, uncheck, Hide on Self-Hover
if (pausehuv = 1)
	menu, TooltipMenu, disable, Hide on Self-Hover
Menu, TrayTipMenu, Add, Auto Tray Icon, autotrayic, +radio
if (autotray = 1)
	menu, TrayTipMenu, check, Auto Tray Icon
else
	menu, TrayTipMenu, uncheck, Auto Tray Icon
Menu, TrayTipMenu, Add, Always Show, alwaytray, +radio
if (alwystray = 1)
{
	menu, TrayTipMenu, check, Always Show
	menu, TrayTipMenu, uncheck, Auto Tray Icon
}
else
	menu, TrayTipMenu, uncheck, Always Show

Menu, CopyMenu, Add, Auto Copy Current %colortitle%, copycc, +radio
if (copycurcolor = 1)
	menu, CopyMenu, check, Auto Copy Current %colortitle%
else
	menu, CopyMenu, uncheck, Auto Copy Current %colortitle%
Menu, CopyMenu, Add, Auto Copy Tooltip, copyt, +radio
if (copytool = 1)
	menu, CopyMenu, check, Auto Copy Tooltip
else
	menu, CopyMenu, uncheck, Auto Copy Tooltip
Menu, CopyMenu, Add, Include Format, formatinc
if (formatuse = 1)
	menu, CopyMenu, check, Include Format
else
	menu, CopyMenu, uncheck, Include Format
Menu, OptionsMenu, Add, Tooltip, :TooltipMenu
Menu, OptionsMenu, Add, Tray Icon, :TrayTipMenu
Menu, OptionsMenu, Add, Copying, :CopyMenu
Menu, OptionsMenu, Add, Delay, delayyui
Menu, OptionsMenu, Add, Hotkeys, hotkeyconfigui
if (colormode = 1)
	Menu, OptionsMenu, Add, Replace "Color" with "Colour", nameswap
else
	Menu, OptionsMenu, Add, Replace "Colour" with "Color", nameswap
if (animate = 1)
	Menu, OptionsMenu, Add, Disable Animation, animae
else
	Menu, OptionsMenu, Add, Enable Animation, animae
Menu, OptionsMenu, Add, Stay on Top, stayer
if (stayon = 1)
	menu, OptionsMenu, check, Stay on Top
else
	menu, OptionsMenu, uncheck, Stay on Top
Menu, OptionsMenu, Add, Pause on Self-Hover, pauser
if (pausehuv = 1)
	menu, OptionsMenu, check, Pause on Self-Hover
else
	menu, OptionsMenu, uncheck, Pause on Self-Hover
Menu, OptionsMenu, Add, Set as Default Window, setasdef
if (uidef = curryui)
{
	menu, OptionsMenu, check, Set as Default Window
	if (uidef = 1)
		menu, OptionsMenu, Disable, Set as Default Window
}
else
{
	menu, OptionsMenu, uncheck, Set as Default Window
	if (uidef != 1)
		menu, OptionsMenu, Enable, Set as Default Window
}
Menu, SystemDiags, Add, %colortitle% Dialog, MenuHandler
Menu, SystemDiags, Add, Font Dialog, MenuHandler
Menu, ToolsMenu, Add, System Dialogs, :systemdiags
Menu, ToolsMenu, Add, %colortitle% Recorder, MenuHandler
Menu, ToolsMenu, Add, PixelSearch, MenuHandler
Menu, ToolsMenu, Add, Random %colortitle% Generator, MenuHandler
Menu, ToolsMenu, Add, Converter, MenuHandler
Menu, WindowsListMenu, Add, Everything (Compact Mode), compactUIenable
if (curryui = 1)
	menu, WindowsListMenu, check, Everything (Compact Mode)
Menu, WindowsListMenu, Add, %colortitle% Preview, colorprevenable
if (curryui = 2)
	menu, WindowsListMenu, check, %colortitle% Preview
Menu, WindowsListMenu, Add, Magnifier, magenable
if (curryui = 3)
	menu, WindowsListMenu, check, Magnifier
Menu, WindowsListMenu, Add, The Works, theworksenable
if (curryui = 4)
	menu, WindowsListMenu, check, The Works
Menu, WindowsListMenu, Add, Tooltip, tooltipenable
if (curryui = 5)
	menu, WindowsListMenu, check, Tooltip
Menu, MenuBar, Add, Options, :OptionsMenu
Menu, MenuBar, Add, Tools, :ToolsMenu
Menu, MenuBar, Add, Windows, :WindowsListMenu
Menu, MenuBar, Add, About, AboutUI
Menu, Tray, Add, Options, :OptionsMenu
Menu, Tray, Add, Tools, :ToolsMenu
Menu, Tray, Add, Windows, :WindowsListMenu
Menu, Tray, Add, About, AboutUI
Gui, Menu, MenuBar
return

; ACTIVATES ON RIGHT CLICK FOR THE COLOR LIST
guicontextmenu:
if (A_GuiControl != "LV_Sample")
	return
amslist := LV_GetCount("S")
if (amslist = 0)
{
	menu, rightlistclick, disable, Copy ALL to Clipboard
	menu, rightlistclick, disable, Add Note
	menu, rightlistclick, disable, Delete
}
else
{
	menu, rightlistclick, enable, Copy ALL to Clipboard
	menu, rightlistclick, enable, Delete
	if (amslist > 1)
		menu, rightlistclick, disable, Add Note
	else
		menu, rightlistclick, enable, Add Note
}
Menu, rightlistclick, show
return

; ACTIVATES ON DELETION OF COLOR LIST ENTRY
deletah:
deleteDESIRE = 0
deletelist =
amount2fix =
preamount2fix =
amountremoved =
amountloop =
lastitem =
preamount2fix := LV_GetCount()
loop
{
	deleteDESIRE := LV_GetNext(deleteDESIRE) ; Get next item to delete
	if not deleteDESIRE ; If there are no more items, break
		break
	deletelist := deletelist . deleteDESIRE . "," ; Create list of items to delete
}
stringtrimright, deletelist, deletelist, 1 ; Get rid of last comma
sort, deletelist, N R D, ; Reverse the list. we want to delete the last item, then the first, etc. this is because if we DONT go in reverse order, it screws up the index
loop, parse, deletelist, CSV
{
	if (a_index = 1)
		lastitem := a_loopfield ; Gets the last item (which is the first in the list)
	LV_Delete(a_loopfield) ; Delete the last item all the way to the first
}
gui, 1:default
amount2fix := LV_GetCount() ; See how many items we need to reindex
amountremoved := preamount2fix - amount2fix ; See how many items removed
loop %amount2fix%
{
	nextitem := lastitem + a_index
	newnumber := nextitem - amountremoved
	Line_Color_%newnumber%_Text = % Line_Color_%nextitem%_Text ; Re-indexes the variables that define the color. without this, the wrong colors get paired with the values!
	Line_Color_%newnumber%_Back = % Line_Color_%nextitem%_Back
}
loop %amount2fix%
LV_Modify(a_index, "Col1", a_index) ; Set the # to the proper index
gosub, resetharmony
gosub, resetcolors
whichcolumn := amount2fix
lastselected =
insert2harmon =
if (whichcolumn = 0)
	goto refreshvariables
return

; CLEAR ALL ITEMS IN COLOR LIST
clearer:
gui +OwnDialogs
msgbox, 0x34, Warning, Are you sure that you want to clear all of the entries in the %colorcolour% list?
IfMsgbox No
	return
lv_delete()
gosub, resetharmony
refreshvariables:
whichcolumn = 0
fileopened = 0
hotkeyed = 0
waint = 0
deltaxvar = 0
deltayvar = 0
colorpreva = 000000
lastselected =
storedinilight =
storedinisat =
varwhich =
insert2harmon =
gosub, resetcolors
gosub, filemenuworker2
return

; RESTORE DEFAULT VALUES TO ALL HARMONIES
resetharmony:
guicontrol, 1:disable, inserter
guicontrol, 1:disable, copyhan
guicontrol,, selectedhar, None
loop, 45
{
	guicontrol, -Background, har%a_index%
	guicontrol,, textr%a_index%,
}
loop, 24
{
	guicontrol, -Background, grad%a_index%
	guicontrol,, textgrad%a_index%,
}
loop, 3
{
	guicontrol, 1:, anprog%a_index%, 0
	guicontrol, 1:, antext%a_index%, 0`%
	guicontrol, 1:, 2anprog%a_index%, 0
	guicontrol, 1:, 2antext%a_index%, 0`%
	guicontrol, 1:movedraw, anprog%a_index%
	guicontrol, 1:movedraw, 2anprog%a_index%
}
guicontrol, 1:, 2anprog4, 0
guicontrol, 1:, 2antext4, 0`%
guicontrol, 1:movedraw, 2anprog4
return

; ENABLE CONTEXT MENU ENTRIES FOR RIGHT CLICK OF COLOR LIST
filemenuworker1:
if (disabledfilemenu = 1)
{
	menu, FileMenu, enable, Save List
	menu, FileMenu, enable, Save List As...
	menu, FileMenu, enable, Clear All
	disabledfilemenu = 0
}
return

; OPPOSITE OF ABOVE
filemenuworker2:
if (disabledfilemenu = 0)
{
	menu, FileMenu, disable, Save List
	menu, FileMenu, disable, Save List As...
	menu, FileMenu, disable, Clear All
	disabledfilemenu = 1
}
return

; SAVE LIST ROUTINE
savelistas:
diffile = 1
saver:
loopamount := LV_GetCount()
if loopamount in ,0
{
	msgbox, 0x10, Error, IT'S BLANK!!!`n`nThere is nothing to save.`n`nAnyway, this button should be disabled. How did you even obtain access to this button?!
	return
}
finalvar =
loop %loopamount%
{
	LV_GetText(tempop2, a_index, 2)
	LV_GetText(tempop3, a_index, 3)
	LV_GetText(tempop4, a_index, 4)
	textvar := % Line_Color_%a_index%_Text
	backgroundvar := % Line_Color_%a_index%_Back
	finalvar := finalvar . "#" . a_index . " | " . tempop2 . " | " . tempop3 . " | " tempop4 . " | " . textvar . " | " . backgroundvar . "`n"
}
Gui +OwnDialogs
if ((fileopened = 1) && (diffile = 0))
	savelocal := opener
else
{
	tempvar = %colortitle% List (*.pwf; *.txt)|All Files (*.*)
	gui, 1:+owndialogs
	savelocal := SelectFile(compactUI, "Save As", tempvar, "1", filename, ".pwf", "S CREATEPROMPT OVERWRITEPROMPT")
	if (savelocal = "")
	{
		diffile = 0
		return
	}
}
try
{	
	ifexist, %savelocal%
		filedelete, %savelocal%
	fileappend, %finalvar%, %savelocal%
}
catch
{
	gui, +owndialogs
	msgbox, 0x10, Error, Failed to save the %colorcolour% list!`n`nMake sure that you have appropriate administrative privileges.
}
diffile = 0
fileopened = 1
return

; OPEN LIST ROUTINE
canopener:
if ((fileopened = 1) || (hotkeyed = 1))
{
	gui +owndialogs
	msgbox, 0x34, Warning, Opening a new file will clear all of the entries in the list.`n`nAre you sure that you want to continue?
	ifmsgbox No
		return
}
gui, +owndialogs
fileselectfile, opener, 1,, Open, (*.txt; *.pwf)
skipfileselectfile:
globalindex = 0
wadt = 0
loop, read, %opener%
{
	envadd, globalindex, 1
	if (a_loopreadline = "")
		break
	loop, parse, a_loopreadline, |
	{
		if (a_index != 6)
			varcano := stringtrimmer(a_loopfield)
		else
			stringtrimleft, varcano, a_loopfield, 1
		if (a_index = 1)
		{
			if (varcano != globalindex)
			{
				reason = 1
				goto callerror
			}
		}
		else if (a_index = 2)
			var2 := varcano
		else if (a_index = 3)
		{
			
			if varcano in HTML,RGB [0,, 255],RGB [0,, 1],RGB Integer,BGR [0,, 255],BGR [0,, 1],BGR Integer,RYB [0,, 255],RYB [0,, 1],RYB Integer,HEX,HEX (BGR),HSB/HSV,HSL,HSL (255),HSL (240),HWB,CMYK [0,, 100],CMYK [0,, 1],CMY [0,, 100],CMY [0,, 1],Delphi,XYZ,Yxy,CIELab,CIELCh(ab),CIELSh(ab),CIELuv,CIELCh(uv),CIELSh(uv),Hunter-Lab,YUV,YCbCr
				var3 := varcano
			else
			{
				reason = 2
				goto callerror
			}
		}
		else if (a_index = 4)
		{
			lenth := strlen(varcano)
			if (lenth <= 500)
				var4 := varcano
			else
			{
				reason = 3
				goto callerror
			}
		}
		else if (a_index = 5)
		{
			if varcano in 0x000000,0xFFFFFF
				var5 := varcano
			else
			{
				reason = 4
				goto callerror
			}
		}
		else if (a_index = 6)
		{
			stringleft, checkprefix, varcano, 2
			if (checkprefix != "0x")
			{
				reason = 5
				goto callerror
			}
			if varcano is not xdigit
			{
				reason = 6
				goto callerror
			}
			lenth := strlen(varcano)
			if (lenth != 8)
			{
				reason = 7
				goto callerror
			}
			var6 := varcano
			firstpos := substr(var6, 3, 2)
			secondpos := substr(var6, 5, 2)
			thirdpos := substr(var6, 7, 2)
			caller = 0x%thirdpos%%secondpos%%firstpos%
			msgbox %var6% %caller%
			colorgetfunc("checkdef", var3, caller)
			if (checkdef != var2)
			{
				reason = 8
				goto callerror
			}
		}
	}
	if (wadt != 1)
	{
		lv_delete()
		whichcolumn = 0
	}
	LV_Add("", a_index, var2, var3, var4)
	LV_ColorChange(a_index, var5, var6)
	envadd, whichcolumn, 1
	if (wadt != 1)
	{
		if (whichcolumn > 0)
		{
			gosub, filemenuworker1
			wadt = 1 ; wadt is an acronym for "we already did this"
			fileopened = 1
		}
	}
	if (a_index > 99999)
		break
}
return

callerror:
gui, +owndialogs
msgbox, 0x10, Error, The %colorcolour% list is corrupted or unreadable.`n`n[%reason%]
return

; SET AS DEFAULT UI ROUTINE - CONTINUES TO WINDELL
setasdef:
if (curryui = uidef)
{
	uidef = 1
	menu, OptionsMenu, uncheck, Set as Default Window
}
else
{
	uidef := curryui
	menu, OptionsMenu, check, Set as Default Window
	if (curryui = 1)
		menu, OptionsMenu, Disable, Set as Default Window
}
return

compactUIenable:
curryui = 1
goto windell

colorprevenable:
curryui = 2
goto windell

magenable:
curryui = 3
goto windell

theworksenable:
curryui = 4
goto windell

tooltipenable:
curryui = 5
goto windell

windell:
menu, WindowsListMenu, uncheck, Everything (Compact Mode)
menu, WindowsListMenu, uncheck, %colortitle% Preview
menu, WindowsListMenu, uncheck, Magnifier
menu, WindowsListMenu, uncheck, The Works
menu, WindowsListMenu, uncheck, Tooltip
menu, filemenu, deleteall
menu, magnifiermenu, deleteall
menu, optionsmenu, deleteall
menu, menubar, deleteall
gui, 1:destroy
gui, 2:destroy
gui, 3:destroy
gui, 4:destroy
gui, 5:destroy
gui, 6:destroy
gui, 7:destroy
gui, 8:destroy
gui, 9:destroy
goto enter

; BELOW ARE THE REST OF THE MENU BUTTONS
anti:
menu, MagnifierMenu, togglecheck, Antialize
if (antialize = 1)
	antialize = 0
else
	antialize = 1
return

showcrs:
menu, MagnifierMenu, togglecheck, Show Cross Lines
if (showcross = 1)
	showcross = 0
else
	showcross = 1
return

pauser:
Menu, OptionsMenu, togglecheck, Pause on Self-Hover
if (pausehuv = 1)
{
	pausehuv = 0
	Menu, TooltipMenu, enable, Hide on Self-Hover
}
else
{
	pausehuv = 1
	Menu, TooltipMenu, check, Hide on Self-Hover
	Menu, TooltipMenu, disable, Hide on Self-Hover
	hoverblock = 1
}
return

hoverhide:
Menu, TooltipMenu, togglecheck, Hide on Self-Hover
if (hoverblock = 1)
	hoverblock = 0
else
	hoverblock = 1
return

autotltiphandl:
Menu, TooltipMenu, togglecheck, Auto Tooltip
if (autotool = 1)
	autotool = 0
else
{
	autotool = 1
	if (alwystooltip = 1)
	{
		alwystooltip = 0
		Menu, TooltipMenu, togglecheck, Always Show
	}
}
return

alwahandler:
Menu, TooltipMenu, togglecheck, Always Show
if (alwystooltip = 1)
	alwystooltip = 0
else
{
	alwystooltip = 1
	if (autotool = 1)
	{
		autotool = 0
		menu, TooltipMenu, togglecheck, Auto Tooltip
	}
}
return

autotrayic:
Menu, TraytipMenu, togglecheck, Auto Tray Icon
if (autotray = 1)
	autotray = 0
else
{
	autotray = 1
	if (alwystray = 1)
	{
		alwystray = 0
		Menu, TraytipMenu, togglecheck, Always Show
	}
}
return

alwaytray:
Menu, TrayTipMenu, togglecheck, Always Show
if (alwystray = 1)
	alwystray = 0
else
{
	alwystray = 1
	if (autotray = 1)
	{
		autotray = 0
		menu, TrayTipMenu, togglecheck, Auto Tray Icon
	}
}
return

traymaker:
if (autotray = 1)
{
	if (stayon = 1)
	{
		WinGet, ismined, MinMax, ahk_id %compactUI%
		if (ismined != -1)
		{
			menu, tray, noicon
			return
		}
	}
	IfWinActive, ahk_pid %pid%
		menu, tray, noicon
	else
		menu, tray, icon
}
else
{
	if (alwystray = 1)
		menu, tray, icon
	else
		menu, tray, noicon
}
return

copycc:
Menu, CopyMenu, togglecheck, Auto Copy Current %colortitle%
if (copycurcolor = 1)
	copycurcolor = 0
else
{
	copycurcolor = 1
	if (copytool = 1)
	{
		copytool = 0
		menu, CopyMenu, togglecheck, Auto Copy Tooltip
	}
}
return

copyt:
Menu, CopyMenu, togglecheck, Auto Copy Tooltip
if (copytool = 1)
	copytool = 0
else
{
	copytool = 1
	if (copycurcolor = 1)
	{
		copycurcolor = 0
		menu, CopyMenu, togglecheck, Auto Copy Current %colortitle%
	}
}
return

formatinc:
Menu, CopyMenu, togglecheck, Include Format
if (formatuse = 1)
	formatuse = 0
else
	formatuse = 1
return

nameswap:
gui +owndialogs
msgbox, 0x34, Warning, In order to do this, PixelWorks needs to restart.`n`nAre you sure that you want to continue? (If you didn't save the %colorcolour% list, all values will be lost!)
ifmsgbox Yes
	reload
else
	return

animae:
if (animate = 1)
{
	menu, OptionsMenu, rename, Disable Animation, Enable Animation
	animate = 0
}
else
{
	menu, OptionsMenu, rename, Enable Animation, Disable Animation
	animate = 1
}
return

stayer:
menu, OptionsMenu, Togglecheck, Stay on Top
if (stayon = 1)
{
	stayon = 0
	gui, 1:-alwaysontop
	gui, 2:-alwaysontop
	gui, 3:-alwaysontop
	gui, 4:-alwaysontop
	gui, 5:-alwaysontop
	gui, 6:-alwaysontop
	gui, 7:-alwaysontop
	gui, 8:-alwaysontop
}
else
{
	stayon = 1
	gui, 1:+alwaysontop
	gui, 2:+alwaysontop
	gui, 3:+alwaysontop
	gui, 4:+alwaysontop
	gui, 5:+alwaysontop
	gui, 6:+alwaysontop
	gui, 7:+alwaysontop
	gui, 8:+alwaysontop
}
return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; HOTKEYS

; PERMANENT HOTKEY FOR DELETE KEY
deleteselected:
GuiControlGet, FocusedControl, FocusV
if (FocusedControl != "LV_Sample")
	return
else
	goto deletah
return

; FIRST HOTKEY - THE REST OF THE LABELS WILL BE THE REST OF THE HOTKEYS, WHICH SOME ADDITIONAL ROUTINES IN PLACE
; PAUSE
hotzone1:
pause, toggle
return

; THE "INSERT HARMONY" BUTTON ROUTINE - IT'S LOCATED HERE SINCE IT UTILIZES FUNCTIONS FROM HOTZONE2 BELOW
insertharmony:
if (insertoriginalh = "None")
	return
else
	harminsert := flipper(insertoriginalh)
guicontrol, 1:disable, inserter
guicontrol, 1:disable, copyhan
guicontrol,, selectedhar, None
goto insertbridge

insertgradient:
if (insertoriginalg = "None")
	return
else
	harminsert := flipper(insertoriginalg)
guicontrol, 1:disable, insertgrad
guicontrol, 1:disable, copygrad
guicontrol,, selectedgrad, None
	
insertbridge:
insertingproperty = 1

; CAPTURE
hotzone2:
if (a_ispaused = 1)
	return
if picking in 1,2,3
	return
if (colordef = "Null")
	return
envadd, whichcolumn, 1
if (whichcolumn > 100000)
{
	gui +owndialogs
	msgbox, 0x10, Error, The maximum amount of captures (100000) has been reached.`n`nPlease delete some captures in order to take new ones.
	gui -owndialogs
	return
}
if (waint != 1) ; waint means We Already INitiated This
{
	lastsavedxpos := start_x
	lastsavedypos := start_y
	waint = 1
}
else
{
	deltaxvar := abs(lastsavedxpos-start_x)
	deltayvar := abs(lastsavedypos-start_y)
	lastsavedxpos := start_x
	lastsavedypos := start_y
}
backgroundColor := contrastFinder()
;msgbox backgroundcolor is %backgroundColor%
if (insertingproperty != 1) ; We don't want to switch the focus when inserting a grad or har
{
	LV_Add( "", whichcolumn, colordef, combos, "" )
	LV_ModifyCol(2, 70)
	LV_ColorChange(whichcolumn, backgroundColor, colordefbackground)
	gosub, filemenuworker1
	if (lastselected != "")
		LV_Modify(lastselected, "-Select -Focus")
	LV_Modify(whichcolumn, "+Select +Focus +Vis")
	lastselected := whichcolumn
	hotkeyed = 1
	gosub single
	if (copycurcolor = 1)
		gosub, hotzone3
	if (copytool = 1)
		gosub, hotzone9
}
else
{
	LV_Add( "", whichcolumn, textins, typeselected, "" )
	LV_ModifyCol(2, 70)
	LV_ColorChange(whichcolumn, backgroundColor, harminsert)
	insertingproperty = 0
}
return

; INITIATE CHANGE FOR COLOR OF LISTBOX ENTRY
LV_ColorInitiate() ; Initiate listview color change procedure
{
	global hw_LV_ColorChange, compactUI
	Control = SysListView321
	ControlGet, hw_LV_ColorChange, HWND,, %Control%, ahk_id %compactUI%
	SendMessage, 0x1036, 0x010000, 0x010000, , % "ahk_id " . hw_LV_ColorChange ; LVM_SETEXTENDEDLISTVIEWSTYLE
	OnMessage( 0x4E, "WM_NOTIFY" )
}

; CHANGE COLOR
LV_ColorChange(Index="", TextColor="", BackColor="") ; Change specific line's color or reset all lines
{
	global
	if Index =
		Loop, % LV_GetCount()
	LV_ColorChange(A_Index)
	else
	{
		Line_Color_%Index%_Text := TextColor
		Line_Color_%Index%_Back := BackColor
		WinSet, Redraw,, ahk_id %hw_LV_ColorChange%
	}
}

; PART OF COLOR CHANGE ROUTINE
WM_NOTIFY( p_w, p_l, p_m )
{
	local draw_stage, Current_Line, Index
	critical
	if (DecodeInteger("uint4", p_l, 0) = hw_LV_ColorChange)
	{
		if (DecodeInteger("int4", p_l, 8) = -12)
		{	; NM_CUSTOMDRAW
			draw_stage := DecodeInteger("uint4", p_l, 12)
			if (draw_stage = 1)	; CDDS_PREPAINT
				return, 0x20	; CDRF_NOTIFYITEMDRAW
			else if (draw_stage = 0x10000|1)
			{	; CDDS_ITEM
				Current_Line := DecodeInteger("uint4", p_l, 36) + 1
				LV_GetText(Index, Current_Line)
				if (Line_Color_%Index%_Text != "")
				{
					EncodeInteger(Line_Color_%Index%_Text, 4, p_l, 48) ; foreground
					EncodeInteger(Line_Color_%Index%_Back, 4, p_l, 52) ; background
				}
			}
		}
	}
}

; PART OF COLOR CHANGE ROUTINE
DecodeInteger(p_type, p_address, p_offset, p_hex = true)
{
	old_FormatInteger := A_FormatInteger
	if (p_hex = 1)
		SetFormat, Integer, hex
	else
		SetFormat, Integer, dec
	StringRight, size, p_type, 1
	loop, %size%
		value += *((p_address + p_offset) + (A_Index - 1)) << (8 * (A_Index - 1))
	if ((size <= 4) && (InStr(p_type, "u") != 1) && (*(p_address + p_offset + (size - 1)) &0x80))
		value := -((~value + 1) & ((2 ** (8 * size)) -1))
	SetFormat, Integer, %old_FormatInteger%
	return, value
}

; PART OF COLOR CHANGE ROUTINE
EncodeInteger( p_value, p_size, p_address, p_offset )
{
	loop, %p_size%
		DllCall( "RtlFillMemory", "uint", p_address + p_offset + A_Index - 1, "uint", 1, "uchar", p_value >> ( 8*(A_Index - 1) ) )
}

; COPY CURRENT COLOR
hotzone3:
if (formatuse = 1)
	clipboard := colordef . " (" . combos . ")"
else
	clipboard := colordef
return

; COPY ALL COLORS
hotzone4:
gosub, allcolors
if (formatuse = 1)
	clipboard := tipvarall
else
	clipboard := tipwithoall
return

; RETRIVES VALUES FOR ALL THE COLORS
allcolors:
tipvarall =
tipwithoall =
loop, 33
{
	all := combosName[a_index]
	colorgetfunc("alldef", all, colordefstage1)
	tipvarall := tipvarall . combosName[a_index] . ": " . alldef . "`n"
	tipwithoall := tipwithoall . alldef . "`n"
}
return

; COPY MOUSE POSITION
hotzone5:
if (formatuse = 1)
	clipboard := "Mouse Position: [" . start_x . ", " start_y . "]"
else
	clipboard := "[" . start_X . ", " . start_y . "]"
return

; COPY DELTA MOUSE POSITION
hotzone6:
if (formatuse = 1)
	clipboard := "Delta Mouse Position: [" . deltaxvar . ", " deltayvar . "]"
else
	clipboard := "[" . deltaxvar . ", " . deltayvar . "]"
return

; COPY MOUSE POSITION IN ADDITION TO DELTA POSITION
hotzone7:
if (formatuse = 1)
{
	clpboardpre1 := "Mouse Position: [" . start_x . ", " start_y . "]"
	clpboardpre2 := "Delta Mouse Position: [" . deltaxvar . ", " deltayvar . "]"
	clipboard := clpboardpre1 . "`n" . clpboardpre2
}
else
{
	clpboardpre1 := "[" . start_X . ", " . start_y . "]"
	clpboardpre2 := "[" . deltaxvar . ", " . deltayvar . "]"
	clipboard := clpboardpre1 . "`n" . clpboardpre2
}
return

; COPY EVERYTHING
hotzone8:
gosub, allcolors
if (formatuse = 1)
{
	clpboardpre1 := "Mouse Position: [" . start_x . ", " start_y . "]"
	clpboardpre2 := "Delta Mouse Position: [" . deltaxvar . ", " deltayvar . "]"
	clipboard := tipvarall . clpboardpre1 . "`n" . clpboardpre2
}
else
{
	clpboardpre1 := "[" . start_X . ", " . start_y . "]"
	clpboardpre2 := "[" . deltaxvar . ", " . deltayvar . "]"
	clipboard := tipwithoall . clpboardpre1 . "`n" . clpboardpre2
}
return

; COPY TOOLTIP
hotzone9:
if (formatuse = 1)
	clipboard := finishedtipvar
else
	clipboard := finishtipwitho
return

; ACTIVATE WINDOW
hotzone10:
winactivate ahk_id %compactUI%
return

; CYCLE COLOR FORMAT
hotzone11:
indexcombos := % ObjIndexOf(combosName, combos)
newdex := indexcombos + 1
if (newdex = 34)
	newdex = 1
combos := combosName[newdex]
guicontrol, choose, %combox%, %newdex%
return

; REVERSE COLOR CYCLE
hotzone12:
indexcombosrev := % ObjIndexOf(combosName, combos)
newdexrev := indexcombosrev - 1
if (newdexrev = 0)
	newdexrev = 33
combos := combosName[newdexrev]
guicontrol, choose, %combox%, %newdexrev%
return

; FIGURES OUT THE INDEX OF THE ITEM
ObjIndexOf(obj, item, case_sensitive:=false)
{
	for i, val in obj
	{
		if (case_sensitive ? (val == item) : (val = item))
			return i
	}
}

; TOGGLE TOOLTIP
hotzone13:
if ((autotool = 1) || (alwystooltip = 1))
{
	if (autotool = 1)
	{
		autotool = 0
		Menu, TooltipMenu, togglecheck, Auto Tooltip
	}
	if (alwystooltip = 1)
	{
		alwystooltip = 0
		Menu, TooltipMenu, togglecheck, Always Show
	}
}
else
{
	whattodo := idontknowfunc("1")
	if (whattodo = "auto")
	{
		autotool = 1
		Menu, TooltipMenu, togglecheck, Auto Tooltip
	}
	if (whattodo = "always")
	{
		alwystooltip = 1
		Menu, TooltipMenu, togglecheck, Always Show
	}
	if (whattodo = 0)
		return
}
return

; TOGGLE TRAY ICON
hotzone14:
if ((autotray = 1 ) || (alwystray = 1))
{
	if (autotray = 1)
	{
		autotray = 0
		Menu, TrayTipMenu, togglecheck, Auto Tray Icon
	}
	if (alwystray = 1)
	{
		alwystray = 0
		Menu, TrayTipMenu, togglecheck, Always Show
	}
}
else
{
	whattodo := idontknowfunc("2")
	if (whattodo = "auto")
	{
		autotray = 1
		Menu, TrayTipMenu, togglecheck, Auto Tray Icon
	}
	if (whattodo = "always")
	{
		alwystray = 1
		Menu, TrayTipMenu, togglecheck, Always Show
	}
	if (whattodo = 0)
		return
}
return

; DIALOG FOR WHEN WE DON'T KNOW WHAT TO DO
idontknowfunc(type) ; Type tool = 1, type tray = 2
{
	global checkedidk,compactUI
	if (type = 1)
	{
		Instruction := "Which of the following tooltip options would you like to enable?"
		Content := "You have pressed the hotkey to toggle the tooltip. All of the options are currently disabled. PixelWorks doesn't know which option you would like to enable now."
	}
	else
	{
		Instruction := "Which of the following tray icon options would you like to enable?"
		Content := "You have pressed the hotkey to toggle the tray icon. All of the options are currently disabled. PixelWorks doesn't know which option you would like to enable now."
	}
	Title := "Question"
	MainIcon := 99
	Flags := 0x110
	Buttons := 0x8
	CustomButtons := []
	if (type = 1)
	{
		CustomButtons.Push([101, "Auto Tooltip"])
		CustomButtons.Push([102, "Always Show"])
	}
	else
	{
		CustomButtons.Push([101, "Auto Tray Icon"])
		CustomButtons.Push([102, "Always Show"])
	}
	cButtons := CustomButtons.Length()
	VarSetCapacity(pButtons, 4 * cButtons + A_PtrSize * cButtons, 0)
	Loop %cButtons%
	{
		iButtonID := CustomButtons[A_Index][1]
		iButtonText := &(b%A_Index% := CustomButtons[A_Index][2])
		NumPut(iButtonID,   pButtons, (4 + A_PtrSize) * (A_Index - 1), "Int")
		NumPut(iButtonText, pButtons, (4 + A_PtrSize) * A_Index - A_PtrSize, "Ptr")
	}
	CheckText := "Remember my choice for next time"
	Parent := compactUI

	; TASKDIALOGCONFIG structure
	x64 := A_PtrSize == 8
	NumPut(VarSetCapacity(TDC, x64 ? 160 : 96, 0), TDC, 0, "UInt") ; cbSize
	NumPut(Parent, TDC, 4, "Ptr") ; hwndParent
	NumPut(Flags, TDC, x64 ? 20 : 12, "Int") ; dwFlags
	NumPut(Buttons, TDC, x64 ? 24 : 16, "Int") ; dwCommonButtons
	NumPut(&Title, TDC, x64 ? 28 : 20, "Ptr") ; pszWindowTitle
	NumPut(MainIcon, TDC, x64 ? 36 : 24, "Ptr") ; pszMainIcon
	NumPut(&Instruction, TDC, x64 ? 44 : 28, "Ptr") ; pszMainInstruction
	NumPut(&Content, TDC, x64 ? 52 : 32, "Ptr") ; pszContent
	NumPut(cButtons, TDC, x64 ? 60 : 36, "UInt") ; cButtons
	NumPut(&pButtons, TDC, x64 ? 64 : 40, "Ptr") ; pButtons
	NumPut(&CheckText, TDC, x64 ? 92 : 60, "Ptr") ; pszVerificationText

	soundplay *48
	DllCall("Comctl32.dll\TaskDialogIndirect", "Ptr", &TDC, "Int*", Button := 0, "Int*", Radio := 0, "Int*", Checked := 0)

	if (Button = 101)
	{
		; Auto Tooltip / Auto tray icon
		var = auto
	}
	else if (Button = 102)
	{
		; Always Show
		var = always
	}
	else if (Button = 2)
	{
		; Cancel
		var = 0
		goto skip
	}
	if (Checked)
		checkedidk = 1
	else
		checkedidk = 0
	skip:
	return var
}

; CHANGE ZOOM LEVEL +
hotzone15:
zoomlevel := zoom
envadd, zoomlevel, 1
if (curryui = 1)
	maxvalue = 51
else
	maxvalue = 513
if (zoomlevel = maxvalue)
	zoom = 1
else
	zoom := zoomlevel
return

; CHANGE ZOOM LEVEL -
hotzone16:
zoomlevel := zoom
envsub, zoomlevel, 1
if (curryui = 1)
	looparound = 50
else
	looparound = 512
if (zoomlevel = 0)
	zoom := looparound
else
	zoom := zoomlevel
return

; CUSTOM HOTKEY ROUTINES
hotzone17:
if (whichcolumn > 0)
	goto clearer
return

hotzone18:
looper := arraycounta
letter = a
goto custcopyer

hotzone19:
looper := arraycountb
letter = b
goto custcopyer

hotzone20:
looper := arraycountc
letter = c

custcopyer:
copycust =
copycustwo =
loop, %looper%
{
	varx := array%letter%[a_index]
	if varx not in Mouse Position,Delta Mouse Position
	{
		colorgetfunc("custdef", varx, colordefstage1)
		copycust := copycust . varx . ": " . custdef . "`n"
		copycustwo:= copycustwo . custdef . "`n"
	}
	else
	{
		if varx in Mouse Position
		{
			clpboardpre1 := "Mouse Position: [" . start_x . ", " start_y . "]"
			clpboardpre2 := "[" . start_x . ", " start_y . "]"
			copycust := copycust . clpboardpre1 . "`n"
			copycustwo := copycustwo . clpboardpre2 . "`n"
		}
		if varx in Delta Mouse Position
		{
			clpboardpre1 := "Delta Mouse Position: [" . start_x . ", " start_y . "]"
			clpboardpre2 := "[" . start_x . ", " start_y . "]"
			copycust := copycust . clpboardpre1 . "`n"
			copycustwo := copycustwo . clpboardpre2 . "`n"
		}
	}
}
if (formatuse = 1)
	clipboard := copycust
else
	clipboard := copycustwo
return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; REDRAW ROUTINES

; REDRAW UI FOR COLOR PREVIEW WINDOW
redraw4colorprev:
MouseGetPos X, Y 
PixelGetColor, Colorplane, %X%, %Y%, RGB
gui, color, %Colorplane%
if (curryui = 2)
	settimer, redraw4colorprev, %delay%
else
{
	settimer, redraw4colorprev, OFF
	gui, color, Default
}
return

; REDRAW UI FOR MAGNIFIER WINDOW
redraw4magnif:
MouseGetPos, start_x, start_y
WinGetPos, wx, wy, ww, wh, ahk_id %compactUI%
DllCall( "gdi32.dll\SetStretchBltMode", "uint", hdc_frame, "int", 4 * antialize )
DllCall("gdi32.dll\StretchBlt", UInt, hdc_frame, Int, 0, Int, 0, Int, ww, Int, wh, UInt, hdd_frame, Int, start_x - (ww / 2 / zoom), Int, start_y-(wh/2/zoom), Int, ww/zoom, Int, wh/zoom, UInt, 0xCC0020)
if (curryui = 3)
	settimer, redraw4magnif, %delay%
else
	settimer, redraw4magnif, OFF
return

; REDRAW UI FOR COMPACT UI MODE
Redraw4compact:
if (curryui = 1) ; Determining if we are in the compact ui mode - if so, we want to set the timer to make this continue
	SetTimer, redraw4compact, %delay%
else
	settimer, redraw4compact, OFF
MouseGetPos, start_x, start_y, mousehwnd ; Get mouse position and hwnd
WinGet, OutputVariable, PID, ahk_id %mousehwnd%
init = 0
if (outputvariable = PID) ; Check to see if hovering over program's own gui's
{
	init = 1
	if (pausehuv = 0) ; If we turned off the option to pause on hover, skip this section
		goto skippause
	if (hoverblock = 1) ; If we enabled the feature to hide on hover, clear the tooltip
		tooltip
	if ((autotray = 0) && (alwystray = 0)) ; If the tray option is turned off entirely, remove tray icon
		menu, tray, noicon
	if (alwystray = 1) ; If tray option is set to always appear, turn on
		menu, tray, icon
	else
	{
		ifwinactive, ahk_pid %PID% ; Determine if the window is active and if so, turn off tray icon
			menu, tray, noicon
	}
	return
}
skippause:
old_x := start_x
old_y := start_y
Rz := R/zoom
xz := In(start_x-Rz+1,0,A_ScreenWidth-2*Rz) ; Keep the frame on screen
yz := In(start_y-Rz+1,0,A_ScreenHeight-2*Rz)
PixelGetColor, Colordefstage1, %start_x%, %start_y%, RGB
Gui, Submit, NoHide 
colorgetfunc("colordef", combos, colordefstage1)
compactUIVars = [%start_x%, %start_y%]`n|%deltaxvar%, %deltayvar%|  
guicontrol, +Background%colordefstage1%, Prog
guicontrol,, texty, %compactUIVars%
guicontrol,, colory, %colordef%
DllCall("gdi32.dll\SetStretchBltMode", "uint", hdc_frame, "int", 4 * antialize) ; Halftone better quality with stretch
DllCall("gdi32.dll\StretchBlt", UInt, hdc_frame, Int, 111, Int, 5, Int, 2*R, Int, 2*R, UInt, hdd_frame, UInt, xz, UInt, yz, Int, 2*Rz, Int, 2*Rz, UInt, 0xCC0020) ; SRCCOPY
if (showcross = 1)
	DrawCross("161", "5", "161", "105", "111", "55", "211", "55", hdc_frame)
if ((hoverblock = 1) && (init = 1))
	tooltip
else
	gosub, tooltipmaker
gosub, traymaker
Return

; MAKES THE TOOLTIP
tooltipmaker:
if (autotool = 1)
{
	IfWinActive, ahk_pid %PID%
	{
		tooltip
		return
	}
	if (stayon = 1)
	{
		WinGet, ismined, MinMax, ahk_id %compactUI%
		if (ismined != -1)
		{
			tooltip
			return
		}
	}
}
else
{
	if (alwystooltip = 0)
	{
		tooltip
		return
	}
}
if (eegglaunch = 1)
{
	tooltip
	return
}
tipvar =
tipwitho =
loop, 33
{
	ifequal, gen%a_index%, 1
	{
		toolbox := combosName[a_index]
		colorgetfunc("tooltipdef", toolbox, colordefstage1)
		tipvar := tipvar . combosName[a_index] . ": " . tooltipdef . "`n"
		tipwitho := tipwitho . tooltipdef . "`n"
	}
}
if (gen34 = 1)
{
	tipvar := tipvar . "Mouse Position: [" . start_x . ", " start_y . "]`n"
	tipwitho := tipwitho . "[" . start_X . ", " . start_y . "]`n"
}
if (gen35 = 1)
{
	tipvar := tipvar . "Delta Mouse Position: [" . deltaxvar . ", " deltayvar . "]"
	tipwitho := tipwitho . "[" . deltaxvar . ", " . deltayvar . "]`n"
}	
finishedtipvar := tipvar
finishtipwitho := tipwitho
tooltip %tipvar%
return

; CREATES THE LAYOUT FOR THE HARMONY BOXES
layoutconfig:
if (donecreating = 1)
{
	gui, 1:submit, nohide
	critical
}
loop, 45
{
	GuiControl, Hide, har%a_index%
	GuiControl, Hide, textr%a_index%
}
if (whichharmony = 1)
{
	firsthar = har1
	loop, 12
	{
		guicontrol, show, har%a_index%
		guicontrol show, textr%a_index%
	}
}
else if (whichharmony = 2)
{
	firsthar = har13
	guicontrol, show, har13
	guicontrol, show, har14
	guicontrol, show, textr13
	guicontrol, show, textr14
}
else if (whichharmony = 3)
{
	firsthar = har15
	guicontrol, show, har15
	guicontrol, show, har16
	guicontrol, show, har17
	guicontrol, show, textr15
	guicontrol, show, textr16
	guicontrol, show, textr17
}
else if (whichharmony = 4)
{
	firsthar = har18
	guicontrol, show, har18
	guicontrol, show, har19
	guicontrol, show, har20
	guicontrol, show, textr18
	guicontrol, show, textr19
	guicontrol, show, textr20
}
else if (whichharmony = 5)
{
	firsthar = har21
	guicontrol, show, har21
	guicontrol, show, har22
	guicontrol, show, har23
	guicontrol, show, har24
	guicontrol, show, textr21
	guicontrol, show, textr22
	guicontrol, show, textr23
	guicontrol, show, textr24
}
else if (whichharmony = 6)
{
	firsthar = har25
	guicontrol, show, har25
	guicontrol, show, har26
	guicontrol, show, har27
	guicontrol, show, har28
	guicontrol, show, textr25
	guicontrol, show, textr26
	guicontrol, show, textr27
	guicontrol, show, textr28
}
else if (whichharmony = 7)
{
	firsthar = har29
	guicontrol, show, har29
	guicontrol, show, har30
	guicontrol, show, har31
	guicontrol, show, har32
	guicontrol, show, textr29
	guicontrol, show, textr30
	guicontrol, show, textr31
	guicontrol, show, textr32
}
else if (whichharmony = 8)
{
	firsthar = har33
	guicontrol, show, har33
	guicontrol, show, har34
	guicontrol, show, har35
	guicontrol, show, textr33
	guicontrol, show, textr34
	guicontrol, show, textr35
}
else if (whichharmony = 9)
{
	firsthar = har36
	guicontrol, show, har36
	guicontrol, show, har37
	guicontrol, show, har38
	guicontrol, show, har39
	guicontrol, show, textr36
	guicontrol, show, textr37
	guicontrol, show, textr38
	guicontrol, show, textr39
}
else if (whichharmony = 10)
{
	firsthar = har40
	guicontrol, show, har40
	guicontrol, show, har41
	guicontrol, show, har42
	guicontrol, show, har43
	guicontrol, show, har44
	guicontrol, show, har45
	guicontrol, show, textr40
	guicontrol, show, textr41
	guicontrol, show, textr42
	guicontrol, show, textr43
	guicontrol, show, textr44
	guicontrol, show, textr45
}
return

; GETS THE VALUES FOR THE COLORS OF ALL THE HARMONY BOXES
configharmony:
gui, submit, nohide
if (1click != 1)
{
	colorgetfunc("hsbvar", "HSBSPLIT", colordefstage1)
	varwhich := colordefstage1
}
else
{
	colorgetfunc("hsbvar", "HSBSPLIT", insert2harmon)
	varwhich := insert2harmon
}
storedhu := hu2
storedinisat := saturat2
storedinilight := lightn2

loop, 11
{
	amountdeg := a_index + 1
	envadd, hu2, 30
	if (hu2 > 360)
		hu2 := hu2 - 360
	deg%amountdeg% := hu2
	degga := % deg%amountdeg%
	lessthan1a := (defharmode = 1) ? (hsbCorrection(degga / 360)) : (degga / 360) ; to convert hsL back to hex, the function requires we make all values less than 1 - this case, we divide by 360 to get a decimal less than 1
	lessthan1b := saturat2 / 100 ; divide by 100 to get a decimal less than 1
	lessthan1c := lightn2 / 100 ; same as above
	hexer%amountdeg% := HSVB_Convert2RGB(lessthan1a,lessthan1b,lessthan1c) ; the function that converts the hsL back to hex
}

guicontrol, 1:disable, inserter
guicontrol, 1:disable, copyhan
guicontrol,, selectedhar, None
guicontrol, +Background%varwhich%, har1
guicontrol, +Background%hexer2%, har2
guicontrol, +Background%hexer3%, har3
guicontrol, +Background%hexer4%, har4
guicontrol, +Background%hexer5%, har5
guicontrol, +Background%hexer6%, har6
guicontrol, +Background%hexer7%, har7
guicontrol, +Background%hexer8%, har8
guicontrol, +Background%hexer9%, har9
guicontrol, +Background%hexer10%, har10
guicontrol, +Background%hexer11%, har11
guicontrol, +Background%hexer12%, har12
guicontrol, +Background%varwhich%, har13
guicontrol, +Background%hexer7%, har14
guicontrol, +Background%varwhich%, har15
guicontrol, +Background%hexer6%, har16
guicontrol, +Background%hexer8%, har17
guicontrol, +Background%varwhich%, har18
guicontrol, +Background%hexer5%, har19
guicontrol, +Background%hexer9%, har20
guicontrol, +Background%varwhich%, har21
guicontrol, +Background%hexer4%, har22
guicontrol, +Background%hexer7%, har23
guicontrol, +Background%hexer10%, har24
guicontrol, +Background%varwhich%, har25
guicontrol, +Background%hexer3%, har26
guicontrol, +Background%hexer7%, har27
guicontrol, +Background%hexer9%, har28
guicontrol, +Background%varwhich%, har29
guicontrol, +Background%hexer5%, har30
guicontrol, +Background%hexer7%, har31
guicontrol, +Background%hexer11%, har32
guicontrol, +Background%varwhich%, har33
guicontrol, +Background%hexer2%, har34
guicontrol, +Background%hexer12%, har35
guicontrol, +Background%varwhich%, har36
guicontrol, +Background%hexer2%, har37
guicontrol, +Background%hexer7%, har38
guicontrol, +Background%hexer12%, har39
guicontrol, +Background%varwhich%, har40
guicontrol, +Background%hexer3%, har41
guicontrol, +Background%hexer5%, har42
guicontrol, +Background%hexer7%, har43
guicontrol, +Background%hexer9%, har44
guicontrol, +Background%hexer11%, har45
guicontrol,, textr1, `n`n`n`n`n%varwhich%
guicontrol,, textr2, `n`n`n`n`n%hexer2%
guicontrol,, textr3, `n`n`n`n`n%hexer3%
guicontrol,, textr4, `n`n`n`n`n%hexer4%
guicontrol,, textr5, `n`n`n`n`n%hexer5%
guicontrol,, textr6, `n`n`n`n`n%hexer6%
guicontrol,, textr7, `n`n`n`n`n%hexer7%
guicontrol,, textr8, `n`n`n`n`n%hexer8%
guicontrol,, textr9, `n`n`n`n`n%hexer9%
guicontrol,, textr10, `n`n`n`n`n%hexer10%
guicontrol,, textr11, `n`n`n`n`n%hexer11%
guicontrol,, textr12, `n`n`n`n`n%hexer12%
guicontrol,, textr13, `n`n`n`n`n%varwhich%
guicontrol,, textr14, `n`n`n`n`n%hexer7%
guicontrol,, textr15, `n`n`n`n`n%varwhich%
guicontrol,, textr16, `n`n`n`n`n%hexer6%
guicontrol,, textr17, `n`n`n`n`n%hexer8%
guicontrol,, textr18, `n`n`n`n`n%varwhich%
guicontrol,, textr19, `n`n`n`n`n%hexer5%
guicontrol,, textr20, `n`n`n`n`n%hexer9%
guicontrol,, textr21, `n`n`n`n`n%varwhich%
guicontrol,, textr22, `n`n`n`n`n%hexer4%
guicontrol,, textr23, `n`n`n`n`n%hexer7%
guicontrol,, textr24, `n`n`n`n`n%hexer10%
guicontrol,, textr25, `n`n`n`n`n%varwhich%
guicontrol,, textr26, `n`n`n`n`n%hexer3%
guicontrol,, textr27, `n`n`n`n`n%hexer7%
guicontrol,, textr28, `n`n`n`n`n%hexer9%
guicontrol,, textr29, `n`n`n`n`n%varwhich%
guicontrol,, textr30, `n`n`n`n`n%hexer5%
guicontrol,, textr31, `n`n`n`n`n%hexer7%
guicontrol,, textr32, `n`n`n`n`n%hexer11%
guicontrol,, textr33, `n`n`n`n`n%varwhich%
guicontrol,, textr34, `n`n`n`n`n%hexer2%
guicontrol,, textr35, `n`n`n`n`n%hexer12%
guicontrol,, textr36, `n`n`n`n`n%varwhich%
guicontrol,, textr37, `n`n`n`n`n%hexer2%
guicontrol,, textr38, `n`n`n`n`n%hexer7%
guicontrol,, textr39, `n`n`n`n`n%hexer12%
guicontrol,, textr40, `n`n`n`n`n%varwhich%
guicontrol,, textr41, `n`n`n`n`n%hexer3%
guicontrol,, textr42, `n`n`n`n`n%hexer5%
guicontrol,, textr43, `n`n`n`n`n%hexer7%
guicontrol,, textr44, `n`n`n`n`n%hexer9%
guicontrol,, textr45, `n`n`n`n`n%hexer11%
1click = 0

; GETS THE GRADIENTS
configrad:
if (a23 != 0)
	goto ysisfig
critical
gui, 1:submit, nohide
if (whichgrad != 4)
{
	GuiControl, Disable, choosegrad
	GuiControl, Disable, progchoose
	GuiControl, Disable, resetchos
}
else
{
	GuiControl, Enable, choosegrad
	GuiControl, Enable, progchoose
	GuiControl, Enable, resetchos
}
if ((storedinisat = "") || (storedinilight = ""))
	return
if (whichgrad = 1)
{
	simpleArray1 := gradientMachine(storedhu, storedinisat, storedinilight, 12, 4, 0, 0, 0, 0, 0, 0, 1)
	simpleArray2 := gradientMachine(storedhu, storedinisat, storedinilight, 12, 5, 0, 0, 0, 0, 0, 0, 1)
}
else if (whichgrad = 2)
{
	simpleArray1 := gradientMachine(storedhu, storedinisat, storedinilight, 12, 2, 0, 0, 0, 0, 0, 0, 1)
	simpleArray2 := gradientMachine(storedhu, storedinisat, storedinilight, 12, 1, 0, 0, 0, 0, 0, 0, 1)
}
else if (whichgrad = 3)
{
	simpleArray1 := gradientMachine(storedhu, storedinisat, storedinilight, 12, 7, 0, 0, 0, 0, 0, 0, 1)
	simpleArray2 := gradientMachine(storedhu, storedinisat, storedinilight, 12, 9, 0, 0, 0, 0, 0, 0, 1)
}
else
{
	simpleArray1 := gradientMachine(storedhu, storedinisat, storedinilight, 12, 14, hu3, saturat3, lightn3, 0, 0, 0, 1)
	simpleArray2 := gradientMachine(storedhu, storedinisat, storedinilight, 12, 14, hu3, saturat3, lightn3, 1, 0, 0, 1)
}
/* msgboxvar := " "
Loop % simpleArray1.Length()
	msgboxvar := msgboxvar .  simpleArray1[A_Index] . " " . simpleArray2[A_Index] . "`n`n"
msgbox %msgboxvar%
*/
loop, 12
{
	currVar1 := simpleArray1[a_index]
	subArr1 := StrSplit(currVar1, "|")
	varH := subArr1[1] / 360
	varS := subArr1[2] / 100
	varL := subArr1[3] / 100
	currVar1 := HSVB_Convert2RGB(varH, varS, varL)
	guicontrol, +Background%currVar1%, grad%a_index%
	guicontrol,, textgrad%a_index%, `n`n`n`n`n%currVar1%

	shiftIndex := 12 + a_index
	currVar2 := simpleArray2[a_index]
	subArr2 := StrSplit(currVar2, "|")
	varH := subArr2[1] / 360
	varS := subArr2[2] / 100
	varL := subArr2[3] / 100
	currVar2 := HSVB_Convert2RGB(varH, varS, varL)
	guicontrol, +Background%currVar2%, grad%shiftIndex%
	guicontrol,, textgrad%shiftIndex%, `n`n`n`n`n%currVar2%
}

ysisfig:
gui, 1:submit, nohide
critical
; red = ff0000, green = 008000, blue = 0000ff, cyan = 00ffff, magenta = ff00ff, yellow = ffff00
gosub, barappear
if (analyziz = 1)
{
	colorgetfunc("mycolornew", "RGBPercent", insert2harmon)
	bayl1 = FF0000
	bayl2 = 008000
	bayl3 = 0000FF
	txayl1 = Red
	txayl2 = Green
	txayl3 = Blue
	perce1 := rpercent
	perce2 := gpercent
	perce3 := bpercent
}
else if (analyziz = 2)
{
	colorgetfunc("mycolornew", "RYBPercent", insert2harmon)
	bayl1 = FF0000
	bayl2 = FFFF00
	bayl3 = 0000FF
	txayl1 = Red
	txayl2 = Yellow
	txayl3 = Blue
	perce1 := rpercent
	perce2 := ypercent
	perce3 := bpercent
}
else if (analyziz = 3)
{
	colorgetfunc("mycolornew", "CMYPercent", insert2harmon)
	bayl1 = 00FFFF
	bayl2 = FF00FF
	bayl3 = FFFF00
	txayl1 = Cyan
	txayl2 = Magenta
	txayl3 = Yellow
	perce1 := cpercent
	perce2 := mpercent
	perce3 := ypercent
}
else if (analyziz = 4)
	colorgetfunc("mycolornew", "CMYKPercent", insert2harmon)
if ((whichcolumn = 0) || (insert2harmon = ""))
{
	perce1 = 0
	perce2 = 0
	perce3 = 0
	cpercent = 0
	mpercent = 0
	ypercent = 0
	kpercent = 0
}
if (analyziz != 4)
{
	guicontrol, 1:+c%bayl1%, anprog1
	guicontrol, 1:+c%bayl2%, anprog2
	guicontrol, 1:+c%bayl3%, anprog3
	guicontrol, 1:, anprog1, %perce1%
	guicontrol, 1:, anprog2, %perce2%
	guicontrol, 1:, anprog3, %perce3%
	guicontrol, 1:, antext1, %perce1%`%
	guicontrol, 1:, antext2, %perce2%`%
	guicontrol, 1:, antext3, %perce3%`%
	guicontrol, 1:, ptext1, %txayl1%
	guicontrol, 1:, ptext2, %txayl2%
	guicontrol, 1:, ptext3, %txayl3%
	guicontrol, 1:movedraw, anprog1
	guicontrol, 1:movedraw, anprog2
	guicontrol, 1:movedraw, anprog3
	guicontrol, 1:movedraw, antext1
	guicontrol, 1:movedraw, antext2
	guicontrol, 1:movedraw, antext3
	guicontrol, 1:movedraw, ptext1
	guicontrol, 1:movedraw, ptext2
	guicontrol, 1:movedraw, ptext3
}
else
{
	guicontrol, 1:, 2anprog1, %cpercent%
	guicontrol, 1:, 2anprog2, %mpercent%
	guicontrol, 1:, 2anprog3, %ypercent%
	guicontrol, 1:, 2anprog4, %kpercent%
	guicontrol, 1:, 2antext1, %cpercent%`%
	guicontrol, 1:, 2antext2, %mpercent%`%
	guicontrol, 1:, 2antext3, %ypercent%`%
	guicontrol, 1:, 2antext4, %kpercent%`%
	guicontrol, 1:movedraw, 2anprog1
	guicontrol, 1:movedraw, 2anprog2
	guicontrol, 1:movedraw, 2anprog3
	guicontrol, 1:movedraw, 2anprog4
	guicontrol, 1:movedraw, 2antext1
	guicontrol, 1:movedraw, 2antext2
	guicontrol, 1:movedraw, 2antext3
	guicontrol, 1:movedraw, 2antext4
	guicontrol, 1:movedraw, 2ptext1
	guicontrol, 1:movedraw, 2ptext2
	guicontrol, 1:movedraw, 2ptext3
	guicontrol, 1:movedraw, 2ptext4
}
return

; CREATES THE LAYOUT FOR THE ANALYSIS TAB
barappear:
if analyziz in 1,2,3
{
	action1 = show
	action2 = hide
}
else
{
	action1 = hide
	action2 = show
}
GuiControl, 1:%action2%, 2anprog1
GuiControl, 1:%action2%, 2anprog2
GuiControl, 1:%action2%, 2anprog3
GuiControl, 1:%action2%, 2anprog4
GuiControl, 1:%action2%, 2antext1
GuiControl, 1:%action2%, 2antext2
GuiControl, 1:%action2%, 2antext3
GuiControl, 1:%action2%, 2antext4
GuiControl, 1:%action2%, 2ptext1
GuiControl, 1:%action2%, 2ptext2
GuiControl, 1:%action2%, 2ptext3
GuiControl, 1:%action2%, 2ptext4
GuiControl, 1:%action1%, anprog1
GuiControl, 1:%action1%, anprog2
GuiControl, 1:%action1%, anprog3
GuiControl, 1:%action1%, antext1
GuiControl, 1:%action1%, antext2
GuiControl, 1:%action1%, antext3
GuiControl, 1:%action1%, ptext1
GuiControl, 1:%action1%, ptext2
GuiControl, 1:%action1%, ptext3
return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; MISC ROUTINES

; CREATES THE MAGNIFIER COMPONENT
magnificent:
WinGet PrintScreenID, id, ahk_id %compactUI%
WinSet, Transparent , 254, ahk_id %compactUI%
WinGet, PrintSourceID, id 
hdd_frame := DllCall("GetDC", UInt, PrintSourceID)
hdc_frame := DllCall("GetDC", UInt, PrintScreenID)
hdc_buffer := DllCall("gdi32.dll\CreateCompatibleDC", UInt,  hdc_frame)
hbm_buffer := DllCall("gdi32.dll\CreateCompatibleBitmap", UInt, hdc_frame, Int, A_ScreenWidth, Int, A_ScreenHeight)
; Specify the style, thickness and color of the cross lines
h_pen := DllCall("gdi32.dll\CreatePen", "int", 0, "int", 1, "uint", 0x0000FF)
; Select the correct pen into DC
DllCall("gdi32.dll\SelectObject", "uint", hdc_frame, "uint", h_pen)
return

; DRAWS THE CROSS LINES
DrawCross( vert_x_start, vert_y_start, vert_x_end, vert_y_end, horiz_x_start, horiz_y_start, horiz_x_end, horiz_y_end, dc )
{
	; Vertical start point
	DllCall("gdi32.dll\MoveToEx", "uint", dc, "int", vert_x_start, "int", vert_y_start, "uint", 0) 
	; Draw a line from the starting point to the end point
	DllCall("gdi32.dll\LineTo", "uint", dc, "int", vert_x_end, "int", vert_y_end) 
	; Horizontal start point
	DllCall("gdi32.dll\MoveToEx", "uint", dc, "int", horiz_x_start, "int", horiz_y_start, "uint", 0)
	; Draw a line from start point to end point
	DllCall("gdi32.dll\LineTo", "uint", dc, "int", horiz_x_end, "int", horiz_y_end)
	return
}

MenuHandler:
Return

; DETERMINES WHAT ITEM THE USER LAST SELECTED FOR THE "RESET SELECTED" BUTTON
which()
{
	global currentfocus
	guicontrolget, currentfocus2, 3:focusv
	if currentfocus2 in resetall,cust1,cust2,cust3,okhot,cank
	{
		guicontrol, 3:disable, thebutton
		return
	}
	else
	{
		if currentfocus2 in thebutton
			return
		else
		{
			currentfocus := currentfocus2
			guicontrol, 3:enable, thebutton
		}
	}
	return
}

; CHANGES TEXT ON SLIDE
sliderglide:
gui, 6:submit, nohide
GuiControl, 6:, slideredit, %slidervar%
return

; CHANGES SLIDER ON TEXT EDIT
sliderhand:
gui, 6:submit, nohide
if (slideredit > range)
{
	slideredit = %range%
	guicontrol, 6:, slideredit, %slideredit%
}
guicontrol, 6:, slidervar, %slideredit%
return

; FUNCTION TO TRIM STRING
stringtrimmer(var)
{
	stringtrimleft, firstpart, var, 1
	stringtrimright, output, firstpart, 1
	return output
}

; FLIPS RGB TO BGR
flipper(input)
{
	firstpos := substr(input, 3, 2)
	secondpos := substr(input, 5, 2)
	thirdpos := substr(input, 7, 2)
	output = 0x%thirdpos%%secondpos%%firstpos%
	return output
}

; Color conversion function
; Parameter 1: The name of variable to return
; Parameter 2: The type of value we want
; Parameter 3: Initial color in hex RGB
colorgetfunc(byref varname, byref typename, stageOne)
{
	global colordefbackground, red, green, blue, r2, y2, b2, orr, og, ob, rpercent, gpercent, ypercent, bpercent

	SplitRGBColor(stageOne) ; It's ok to call this function every time since it will be used by all of the rest
	
	colordefbackground := flipper(stageOne)
	
	; You may wonder why we are returning each individual item instead of having 1 return at the end.
	; The reason for this is to save time. For example, if we finish the HTML statement below, we
	; don't want to check the 39 other conditions below it or that will take longer than necessary.
	; The else-if commands don't work in all places as there are other commands BETWEEN the elses and ifs.

	if (typename = "HTML")
	{
		%varname% := "#" . substr(stageOne, 3, 6)
		return
	}
	
	else if (typename = "HEX")
	{
		%varname% := stageOne
		return
	}

	else if (typename = "HEX (BGR)")
	{
		%varname% := colordefbackground
		return
	}
	
	else if (typename = "Delphi")
	{
		%varname% := "$" . substr(colordefbackground, 3, 6)
		return
	}
	
	if (typename = "RGB [0, 255]")
	{
		%varname% := "(" . Red . ", " Green . ", " Blue . ")"
		return
	}

	else if (typename = "RGB [0, 1]")
	{
		gosub, rgbconfig
		%varname% := "(" . r01 . ", " g01 . ", " b01 . ")"
		return
	}
	
	else if (typename = "RGBPercent")
	{
		gosub, rgbconfig
		rpercent := round(r01 * 100)
		gpercent := round(g01 * 100)
		bpercent := round(b01 * 100)
		return
	}

	else if (typename = "RGB Integer")
	{
		%varname% := (Red<<16) + (Green<<8) + Blue
		return
	}

	else if (typename = "BGR [0, 255]")
	{
		%varname% := "(" . blue . ", " . green . ", " red . ")"
		return
	}

	else if (typename = "BGR [0, 1]")
	{
		gosub, rgbconfig
		%varname% := "(" . b01 . ", " g01 . ", " r01 . ")"
		return
	}

	else if (typename = "BGR Integer")
	{
		%varname% := (Blue<<16) + (Green<<8) + Red
		return
	}
	
	else if (typename = "RYB [0, 255]")
	{
		ryb(Red, Green, Blue, r2, y2, b2)
		%varname% := "(" . r2 . ", " y2 . ", " b2 . ")"
		return
	}

	else if (typename = "RYB [0, 1]")
	{
		ryb(Red, Green, Blue, r2, y2, b2)
		gosub, rybconfig
		%varname% := "(" . r01 . ", " y01 . ", " b01 . ")"
		return
	}
	
	else if (typename = "RYBPercent")
	{
		ryb(Red, Green, Blue, r2, y2, b2)
		gosub, rybconfig
		rpercent := round(r01 * 100)
		ypercent := round(y01 * 100)
		bpercent := round(b01 * 100)
		return
	}
	
	else if (typename = "RYB Integer")
	{
		ryb(Red, Green, Blue, r2, y2, b2)
		%varname% := (r2<<16) + (y2<<8) + b2
		return
	}

	else if (typename = "HSB/HSV")
	{
		%varname% := hslhsvb(Red, Green, Blue, "HSVB", 0)
		return
	}

	else if (typename = "HSL")
	{
		%varname% := hslhsvb(Red, Green, Blue, "HSL", 0)
		return
	}

	else if (typename = "HSL (255)")
	{
		%varname% := hslhsvb(Red, Green, Blue, "255", 0)
		return
	}

	else if (typename = "HSL (240)")
	{
		%varname% := hslhsvb(Red, Green, Blue, "240", 0)
		return
	}

	else if (typename = "HWB")
	{
		%varname% := hslhsvb(Red, Green, Blue, "HWB", 0)
		return
	}

	else if (typename = "HSBSPLIT")
	{
		hslhsvb(Red, Green, Blue, "HSVB", 1)
		return
	}
	
	else if (typename = "HSBSPLITSep")
	{
		hslhsvb(Red, Green, Blue, "HSVB", 2)
		return		
	}
	
	else if (typename = "HSBRYB")
	{
		gosub, rgbconfig
		ryb2rgb(r01, g01, b01, orr, og, ob)
		hslhsvb(round(orr), round(og), round(ob), "HSVB", 1)
		return
	}
	
	else if (typename = "RYB2RGB")
	{
		gosub, rgbconfig
		ryb2rgb(r01, g01, b01, orr, og, ob)
		%varname% := "0x" . format("{1:02X}{2:02X}{3:02X}", orr, og, ob)
		return
	}

	else if (typename = "XYZ")
	{
		%varname% := xyzdef(red, green, blue, "norm")
		return
	}

	else if (typename = "Yxy")
	{
		%varname% := xyzdef(red, green, blue, "yyy")
		return
	}

	else if (typename = "CIELab")
	{
		%varname% := cie(red, green, blue, "lab")
		return
	}

	else if (typename = "CIELCh(ab)")
	{
		%varname% := cie(red, green, blue, "lchab")
		return
	}

	else if (typename = "CIELSh(ab)")
	{
		%varname% := cie(red, green, blue, "shba")
		return
	}

	else if (typename = "CIELuv")
	{
		%varname% := cie(red, green, blue, "luv")
		return
	}

	else if (typename = "CIELCh(uv)")
	{
		%varname% := cie(red, green, blue, "lchuv")
		return
	}

	else if (typename = "CIELSh(uv)")
	{
		%varname% := cie(red, green, blue, "shuv")
		return
	}

	else if (typename = "Hunter-Lab")
	{
		%varname% := cie(red, green, blue, "hunter")
		return
	}

	else if (typename = "YUV")
	{
		%varname% := yuvv(red, green, blue, "YUV")
		return
	}

	else if (typename = "YCbCr")
	{
		%varname% := yuvv(red, green, blue, "YCbCr")
		return
	}

	cmykmaker(red, green, blue, cyank, magentak, yellowk, blackk) ; It's ok to call this every time as the commands below all use this

	if (typename = "CMYK [0, 100]")
	{
		cyan := round((cyank * 100))
		magenta := round((magentak * 100))
		yellow := round((yellowk * 100))
		black := round((blackk * 100))
		%varname% := "(" . cyan . ", " magenta . ", " yellow . ", " black ")"
		return
	}

	else if (typename = "CMYK [0, 1]")
	{
		gosub, cmykconfig
		%varname% := "(" . cyan . ", " magenta . ", " yellow . ", " black ")"
		return
	}
	
	else if (typename = "CMYKPercent")
	{
		gosub, cmykconfig
		global cpercent := round(cyan * 100)
		global mpercent := round(magenta * 100)
		global ypercent := round(yellow * 100)
		global kpercent := round(black * 100)
		return
	}

	else if (typename = "CMY [0, 100]")
	{
		Cm := round(100 * (cyank * (1 - blackk) + blackk))
		Mm := round(100 * (magentak * (1 - blackk) + blackk))
		Ym := round(100 * (yellowk * (1 - blackk) + blackk))
		%varname% := "(" . cm . ", " mm . ", " ym . ")"
		return
	}

	else if (typename = "CMY [0, 1]")
	{
		gosub, cmyconfig
		%varname% := "(" . cm . ", " mm . ", " ym . ")"
		return
	}
	
	else if (typename = "CMYPercent")
	{
		gosub, cmyconfig
		global cpercent := round(cm * 100)
		global mpercent := round(mm * 100)
		global ypercent := round(ym * 100)
	}
	return
	
	cmyconfig:
	Cm := round((cyank * (1 - blackk) + blackk), 2)
	Mm := round((magentak * (1 - blackk) + blackk), 2)
	Ym := round((yellowk * (1 - blackk) + blackk), 2)
	if (cm = 0.00)
		cm = 0
	else if (cm = 1.00)
		cm = 1
	if (mm = 0.00)
		mm = 0
	else if (mm = 1.00)
		mm = 1
	if (ym = 0.00)
		ym = 0
	else if (ym = 1.00)
		ym = 1
	return
	
	cmykconfig:
	cyan := round(cyank, 2)
	magenta := round(magentak, 2)
	yellow := round(yellowk, 2)
	black := round(blackk, 2)
	if (cyan = 0.00)
		cyan = 0
	else if (cyan = 1.00)
		cyan = 1
	if (magenta = 0.00)
		magenta = 0
	else if (magenta = 1.00)
		magenta = 1
	if (yellow = 0.00)
		yellow = 0
	else if (yellow = 1.00)
		yellow = 1
	if (black = 0.00)
		black = 0
	else if (black = 1.00)
		black = 1
	return

	rgbconfig:
	r01 := round((Red / 255), 2)
	g01 := round((Green / 255), 2)
	b01 := round((Blue / 255), 2)
	if (r01 = 1.00)
		r01 = 1
	else if (r01 = 0.00)
		r01 = 0
	if (g01 = 1.00)
		g01 = 1
	else if (g01 = 0.00)
		g01 = 0
	if (b01 = 1.00)
		b01 = 1
	else if (b01 = 0.00)
		b01 = 0
	return
	
	rybconfig:
	r01 := round((r2 / 255), 2)
	y01 := round((y2 / 255), 2)
	b01 := round((b2 / 255), 2)
	if (r01 = 1.00)
		r01 = 1
	else if (r01 = 0.00)
		r01 = 0
	if (y01 = 1.00)
		y01 = 1
	else if (y01 = 0.00)
		y01 = 0
	if (b01 = 1.00)
		b01 = 1
	else if (b01 = 0.00)
		b01 = 0
	return
}

In(x, a, b) ; Closest number to x in [a,b]
{
	if (x < a)
		Return a
	if (b < x)
		Return b
	Return x
}

; Color MUST be in RGB form
; This function splits the color into its Red, Green, and Blue parts
SplitRGBColor(RGBColor)
{
	global red, green, blue
    Red := RGBColor >> 16 & 0xFF
    Green := RGBColor >> 8 & 0xFF
    Blue := RGBColor & 0xFF
	return
}

cmykmaker(red, green, blue, byref cyank, byref magentak, byref yellowk, byref blackk)
{
	r01 := round((Red / 255), 2)
	g01 := round((Green / 255), 2)
	b01 := round((Blue / 255), 2)
	blackk := 1 - max(r01, g01, b01)
	cyank := (1 - r01 - blackk) / (1 - blackk)
	magentak := (1 - g01 - blackk) / (1 - blackk)
	yellowk := (1 - b01 - blackk) / (1 - blackk)
	return
}

; SplitFlag determines if we are going to return multiple variables or just one
; If splitFlag = 0, return 1 var
; If splitFlag = 1, return 3 variables
; If splitFlag = 2, return 3 variables with different names to prevent conflicts
; The types can be HSL, 255, 240, HSVB, or HWB
hslhsvb(red, green, blue, type, splitFlag)
{
	global hu2, saturat2, lightn2 ; For splitFlag = 1
	global hu3, saturat3, lightn3 ; For splitFlag = 2
	redprime := red / 255
	greenprime := green / 255
	blueprime := blue / 255
	
	max := max(redprime, greenprime, blueprime)
	min := min(redprime, greenprime, blueprime)
	
	deltacolor := max - min
	
	if type in HSL,255,240
	{
		lightness := (max + min) / 2
		saturation := (deltacolor / (1 - (abs(2 * lightness - 1))))
	}
	
	if type in HSVB,HWB
	{
		lightness := max
		saturation := (deltacolor / max)
	}
	
	if (deletacolor = 0)
		hue = 0
	else
	{
		if (max = redprime)
		{
			x := ((greenprime - blueprime) / deltacolor)
			y = 6
			modvar := x - (y * (floor(x / y)))
			hue := 60 * modvar
		}
		else if (max = greenprime)
			hue :=  60 * (2 + ((blueprime - redprime) / deltacolor))
		else if (max = blueprime)
			hue :=  60 * (4 + ((redprime - greenprime) / deltacolor))
	}

	if type in 255,240
	{
		saturat := round(type * saturation)
		lightn := round(type * lightness)
		if (type = 255)
			hue := hue / (360 / 255)
		else if (type = 240)
			hue := hue / (360 / 240)
	}
	else
	{
		saturat := round(100 * saturation)
		lightn := round(100 * lightness)
	}

	hu := round(hue)
	if (type != "HWB")
	{
		if splitFlag not in 1,2
			var2sendback = (%hu%°, %saturat%`%, %lightn%`%)
		else
		{
			if (splitFlag = 1)
				hu2 := hu, saturat2 := saturat, lightn2 := lightn
			else
				hu3 := hu, saturat3 := saturat, lightn3 := lightn
			; msgbox %hu3% %saturat3% %lightn3%
			
			Return
		}
	}
	else
	{
		w := round(100 * ((1 - saturation) * lightness))
		b := round(100 * (1 - lightness))
		var2sendback = (%hu%°, %w%`%, %b%`%)
	}

	return var2sendback
}

ryb(r, g, b, byref r2, byref y2, byref b2)
{
	w := min(r, g, b)
	r := r - w
	g := g - w	 ; Remove whiteness from colors
	b := b - w
	mg := max(r, g, b)
	y := min(r, g)
	r := r - y	; Get yellow out of the red+green
	g := g - y

	if ((b && g) != 0)	; If the conversion combines blue and green, cut in half to preserve value's maximum range
	{
		b := b / 2
		g := g / 2
	}

	y := y + g	; Redistribute remaining green
	b := b + g

	my := max(r, y, b)	; Normalize to values
	if (my != 0)
	{
		n := mg / my
		r := r * n
		y := y * n
		b := b * n
	}

	r2 := round(r + w)
	y2 := round(y + w)	; Add white back in
	b2 := round(b + w)
	return
}

cubicint(t, a, b)
{
	weight := t * t * (3 - (2 * t))
	weight := a + weight * (b - a)
	return weight
}

ryb2rgb(ir, iy, ib, byref orr, byref og, byref ob)
{
	; red
	x0 := cubicInt(iB, 1.0, 0.163)
	x1 := cubicInt(iB, 1.0, 0.0)
	x2 := cubicInt(iB, 1.0, 0.5)
	x3 := cubicInt(iB, 1.0, 0.2)
	y0 := cubicInt(iY, x0, x1)
	y1 := cubicInt(iY, x2, x3)
	oRr := 255 * cubicInt(iR, y0, y1)

	; green
	x0 := cubicInt(iB, 1.0, 0.373)
	x1 := cubicInt(iB, 1.0, 0.66)
	x2 := cubicInt(iB, 0.0, 0.0)
	x3 := cubicInt(iB, 0.5, 0.094)
	y0 := cubicInt(iY, x0, x1)
	y1 := cubicInt(iY, x2, x3)
	oG := 255 * cubicInt(iR, y0, y1)

	; blue
	x0 := cubicInt(iB, 1.0, 0.6)
	x1 := cubicInt(iB, 0.0, 0.2)
	x2 := cubicInt(iB, 0.0, 0.5)
	x3 := cubicInt(iB, 0.0, 0.0)
	y0 := cubicInt(iY, x0, x1)
	y1 := cubicInt(iY, x2, x3)
	oB := 255 * cubicInt(iR, y0, y1)
	return
}

xyzdef(red, green, blue, type)
{
	redsm := red / 255
	greensm := green / 255
	bluesm := blue / 255
	if (redsm > 0.04045)
		redsm := ((redsm + 0.055) / 1.055) ** 2.4
	else
		redsm := redsm / 12.92

	if (greensm > 0.04045) 
		greensm := ((greensm + 0.055) / 1.055) ** 2.4
	else
		greensm := greensm / 12.92

	if (bluesm > 0.04045)
		bluesm := ((bluesm + 0.055) / 1.055) ** 2.4
	else
		bluesm := bluesm / 12.92

	redsm := redsm * 100
	bluesm := bluesm * 100
	greensm := greensm * 100
	X := redsm * 0.4124564 + greensm * 0.3575761 + bluesm * 0.1804375
	Y := redsm * 0.2126729 + greensm * 0.7151522 + bluesm * 0.0721750
	Z := redsm * 0.0193339 + greensm * 0.1191920 + bluesm * 0.9503041
	if (type = "norm")
	{
		x := round(x, 2)
		y := round(y, 2)
		z := round(z, 2)
		if (x = 100.00)
			x = 100
		else if (x = 0.00)
			x = 0
		if (y = 100.00)
			y = 100
		else if (y = 0.00)
			y = 0
		if (z = 100.00)
			z = 100
		else if (z = 0.00)
			z = 0
		combinedvars := "(" . x . ", " . y . ", " z . ")"
	}
	else
	{
		if type in ciemodex,ciemodey,ciemodez
		{
			if (type = "ciemodex")
				return x
			if (type = "ciemodey")
				return y
			if (type = "ciemodez")
				return z
			return
		}
		else
		{
			lowerx := x / (x + y + z)
			lowery := y / (x + y + z)
			y := round(y, 2)
			lowerx := round(lowerx, 2)
			lowery := round(lowery, 2)
			if (lowerx = 100.00)
				lowerx = 100
			else if (lowerx = 0.00)
				lowerx = 0
			if (lowery = 100.00)
				lowery = 100
			else if (lowery = 0.00)
				lowery = 0
			if (y = 100.00)
				y = 100
			else if (y = 0.00)
				y = 0
			combinedvars := "(" . Y . ", " . lowerx . ", " lowery . ")"
		}
	}
	return combinedvars
}

cie(red, green, blue, type)
{
	X := round((xyzdef(red, green, blue, "ciemodex")), 3)
	Y := round((xyzdef(red, green, blue, "ciemodey")), 3)
	Z := round((xyzdef(red, green, blue, "ciemodez")), 3)
	if (type != "luv") ; SETS UP TYPE FOR THE REST
	{
		var_X := X / 95.047
		var_Y := Y / 100
		var_Z := Z / 108.883
		if (var_X > 0.008856) 
			var_X := var_X ** (1 / 3)
		else
			var_X := (7.787 * var_X) + (16 / 116)
		if (var_Y > 0.008856)
			var_Y := var_Y ** (1 / 3)
		else
			var_Y := (7.787 * var_Y) + (16 / 116)
		if (var_Z > 0.008856)
			var_Z := var_Z ** (1 / 3)
		else
			var_Z := (7.787 * var_Z) + (16 / 116)
		L := round(((116 * var_Y) - 16), 2)
	}
	else ; TYPE LUV
	{
		var_U := (4 * X) / (X + (15 * Y) + (3 * Z))
		var_V := (9 * Y) / (X + (15 * Y) + (3 * Z))
		var_Y := Y / 100
		if (var_y > 0.008856)
			var_Y := var_Y ** (1 / 3)
		else
			var_Y := (7.787 * var_Y) + (16 / 116)
		ref_U := (4 * 95.047) / (95.047 + (15 * 100) + (3 * 108.883))
		ref_V := (9 * 100) / (95.047 + (15 * 100) + (3 * 108.883))
		L := round(((116 * var_y) - 16), 2)
		U := round((13 * L * (var_U - ref_U)), 2)
		V := round((13 * L * (var_V - ref_V)), 2)
		combinedvars := "(" . L . ", " . U . ", " V . ")"
	}

	if (type = "lab")
	{
		a := round((500 * (var_X - var_Y)), 2)
		b := round((200 * (var_Y - var_Z)), 2)
		combinedvars := "(" . L . ", " . A . ", " B . ")"
	}

	if type in lchab,lchuv,shuv,shba
	{
		if type in lchab,shba
		{
			a := round((500 * (var_X - var_Y)), 1)
			b := round((200 * (var_Y - var_Z)), 2)
		}
		else
		{
			var_U := (4 * X) / (X + (15 * Y) + (3 * Z))
			var_V := (9 * Y) / (X + (15 * Y) + (3 * Z))
			var_Y := Y / 100
			if (var_y > 0.008856)
				var_Y := var_Y ** (1 / 3)
			else
				var_Y := (7.787 * var_Y) + (16 / 116)
			ref_U := (4 * 95.047) / (95.047 + (15 * 100) + (3 * 108.883))
			ref_V := (9 * 100) / (95.047 + (15 * 100) + (3 * 108.883))
			L := round(((116 * var_y) - 16), 2)
			a := round((13 * L * (var_U - ref_U)), 2)
			b := round((13 * L * (var_V - ref_V)), 2)
		}

		if ((a >= 0) && (b = 0))
		{
			var_H = 0
			goto skiptan
		}
		else if ((a < 0) && (b = 0))
		{
			var_H = 180
			goto skiptan
		}
		else if ((a = 0) && (b > 0))
		{
			var_H = 90
			goto skiptan
		}
		else if ((a = 0) && (b < 0))
		{
			var_H = 270
			goto skiptan
		}

		if ((a > 0) && (b > 0))
			xbias = 0

		if (a < 0)
			xbias = 180

		if ((a > 0) && (b < 0))
			xbias = 360

		var_H := atan((b / a))
		var_H := (var_H * 57.29578) + xbias

		skiptan:
		if (var_H < 0)
			var_H := 360 + var_H

		var_H := round(var_H, 2)
		C := round(sqrt((a**2) + (b**2)), 2)
		if (type = "shuv")
			c := round((C / L), 2)

		if (type = "shba")
			C := round((sqrt((a ** 2) + (b ** 2)) / L) , 2)
		combinedvars := "(" . L . ", " . C . ", " var_H . ")"
	}
	
	if (type = "hunter")
	{
		var_Ka := (175 / 198.04) * (100 + 95.047)
		var_Kb := (70 / 218.11) * (100 + 108.883)
		L := round((100 * sqrt(Y / 100)), 2)
		A := round((var_Ka * (((X / 95.047) - (Y / 100)) / sqrt(Y / 100))), 2)
		B := round((var_Kb * (((Y / 100) - (Z / 108.883)) / sqrt(Y / 100))), 2)
		combinedvars := "(" . L . ", " . A . ", " B . ")"
	}
	return combinedvars
}

yuvv(red, green, blue, type)
{
	if (type = "YUV")
	{
		y := ((66 * (Red) + 129 * (Green) + 25 * (Blue) + 128) >> 8) + 16
		u := ((-38 * (Red) - 74 * (Green) + 112 * (Blue) + 128) >> 8) + 128
		v := ((112 * (Red) - 94 * (Green) - 18 * (Blue) + 128) >> 8) + 128
	}
	else if (type = "YCbCr")
	{
		y := (19595 * Red + 38470 * Green + 7471 * Blue) >> 16
		u := (36962 * (Blue - ((19595 * Red + 38470 * Green + 7471 * Blue) >> 16)) >> 16) + 128
		v := (46727 * (Red - ((19595 * Red + 38470 * Green + 7471 * Blue) >> 16)) >> 16) + 128
	}
	combinedvars := "(" . y . ", " u . ", " v . ")"
	return combinedvars
}

; CONVERT HSL TO RGB
HSL_Convert2RGB(H, S, L)
{
	if (s = 0)
		r := g := b := L ; -- Achromatic
	else
	{
		q := (L < 0.5) ? (L * (1 + s)) : (L + s - (L * s))
		p := (2 * l) - q
		r := HSL_Hue2RGB(p, q, h + (1 / 3))
		g := HSL_Hue2RGB(p, q, h)
		b := HSL_Hue2RGB(p, q, h - (1 / 3))
	}
	r := round(255 * r)
	g := round(255 * g)
	b := round(255 * b)
	hexer := format("{1:02x}{2:02x}{3:02x}", r, g, b)
	stringupper, hexer, hexer
	hexer := "0x" . hexer
	return hexer
}

; SUB-COMPONENT OF PREVIOUS FUNCTION
HSL_Hue2RGB(p, q, t)
{
	if (t < 0)
		t += 1
	if (t > 1)
		t -= 1
	if (t < (1 / 6))
		return p + (q - p) * 6 * t
	if (t < (1 / 2))
		return q
	if (t < (2 / 3))
		return p + (q - p) * ((2 / 3) - t) * 6
	return p
}

; CONVERT HSB/V TO RGB
HSVB_Convert2RGB(H, S, V)
{
	H := H * 360

	if (H = 360)
		H := 0

	c := v * s

	x := c * (1 - abs(mod((h / 60), 2) - 1))
	m := v - c

	if ((0 <= H) && (H < 60))
	{
		rprime := c
		gprime := x
		bprime := 0
	}
	else if ((60 <= H) && (H < 120))
	{
		rprime := x
		gprime := c
		bprime := 0
	}
	else if ((120 <= H) && (H < 180))
	{
		rprime := 0
		gprime := c
		bprime := x
	}
	else if ((180 <= H) && (H < 240))
	{
		rprime := 0
		gprime := x
		bprime := c
	}
	else if ((240 <= H) && (H < 300))
	{
		rprime := x
		gprime := 0
		bprime := c
	}
	else if ((300 <= H) && (H < 360))
	{
		rprime := c
		gprime := 0
		bprime := x
	}

	r := round((rprime + m) * 255)
	g := round((gprime + m) * 255)
	b := round((bprime + m) * 255)

	hexer := format("{1:02x}{2:02x}{3:02x}", r, g, b)
	stringupper, hexer, hexer
	hexer := "0x" . hexer
	return hexer
}

; FILESELECTFILE ROUTINE
SelectFile(hGUI, Title := "", Filter := "", DefaultFilter := "", Root := "", DefaultExt := "", Flags := "")
{
    static OFN_S := 0
    , OFN_OVERWRITEPROMPT := 0x2
	, OFN_CREATEPROMPT := 0x2000

    If (Filter = "") ; default string for filter
        Filter := "All Files (*.*)"

    SplitPath, Root, rootFN, rootDir

    hFlags := 0x80000 ; always set OFN_ENABLEXPLORER
    Loop, Parse, Flags, %A_TAB%%A_SPACE%, %A_TAB%%A_SPACE%
        If (A_LoopField != "")
            hFlags |= OFN_%A_LoopField%
    VarSetCapacity(FN, 0XFFFF)
    VarSetCapacity(lpstrFilter, 4 * StrLen(Filter), 0)

    If (rootFN != "")
        DllCall("RtlMoveMemory", "Str", FN, "Str", rootFN
            , "UInt", (StrLen(rootFN) + 1) * (A_IsUnicode ? 2 : 1))

    ; contruct FilterText separated by zero
    delta := 0 ; used by Loop as offset
    Loop, Parse, Filter, |
    {
        desc := A_LoopField
        ext  := SubStr(A_LoopField, InStr(A_LoopField, "(") + 1, -1)
        LenD := StrLen(A_LoopField) + 1
        LenE := StrLen(ext) + 1 ; including zero

        If A_IsUnicode
            LenD *= 2, LenE *= 2

        DllCall("RtlMoveMemory", "Uint", &lpstrFilter + delta, "Str", desc, "Uint", LenD)
        DllCall("RtlMoveMemory", "Uint", &lpstrFilter + delta + LenD, "Str", ext, "int", LenE)
        delta += LenD + LenE
    }

    ; OPENFILENAME structure
    VarSetCapacity(OFN, 90, 0)
    NumPut(76,            OFN,  0, "UInt")  ; Length of Structure
    NumPut(hGui,          OFN,  4, "UInt")  ; HWND
    NumPut(&lpstrFilter,  OFN, 12, "UInt")  ; Pointer to FilterStruc
    NumPut(DefaultFilter, OFN, 24, "UInt")  ; DefaultFilter Pair
    NumPut(&FN,           OFN, 28, "UInt")  ; lpstrFile / InitialisationFileName
    NumPut(0xffff,        OFN, 32, "UInt")  ; MaxFile / lpstrFile length
    NumPut(&rootDir,      OFN, 44, "UInt")  ; StartDir
    NumPut(&Title,        OFN, 48, "UInt")  ; DlgTitle
    NumPut(hFlags,        OFN, 52, "UInt")  ; Flags
    NumPut(&DefaultExt,   OFN, 60, "UInt")  ; DefaultExt

    Result := SubStr(Flags, 1, 1) = "S"
        ? DllCall("comdlg32\GetSaveFileName" (A_IsUnicode ? "W" : "A"), "UInt", &OFN)
        : DllCall("comdlg32\GetOpenFileName" (A_IsUnicode ? "W" : "A"), "UInt", &OFN)

    If (Result = 0)
        Return

    Adr := &FN
    f := d := DllCall("MulDiv", "Int", Adr, "Int",1, "Int",1, "str")
    Result := ""

    If StrLen(d) != 3 ; windows adds "\" when in rootdir, doesn't do that otherwise
        d .= "\"

    If MultiSelect := InStr(Flags, "ALLOWMULTISELECT")
        Loop
            If f := DllCall("MulDiv", "Int", Adr += (StrLen(f)+1)*(A_IsUnicode ? 2 : 1), "Int",1, "Int",1, "str")
                Result .= d f "`n"
            Else
			{
                 If (A_Index = 1)
					SetEnv, Result, %d% ; if user selects only 1 file with multiselect flag, windows ignores this flag
                 Break
            }

    Return, MultiSelect ? SubStr(Result, 1, -1) : SubStr(d, 1, -1)
}

; CONTRAST ROUTINE
; Credit to https://stackoverflow.com/questions/3942878/how-to-decide-font-color-in-white-or-black-depending-on-background-color
contrastFinder()
{
	global red, green, blue

	;msgbox %red% %green% %blue%

	rc := red / 255
	if (rc <= 0.03928)
		rc := rc / 12.92
	else
		rc := ((rc + 0.055) / 1.055) ** 2.4

	gc := green / 255
	if (gc <= 0.03928)
		gc := gc / 12.92
	else
		gc := ((gc + 0.055) / 1.055) ** 2.4

	bc := blue / 255
	if (bc <= 0.03928)
		bc := bc / 12.92
	else
		bc := ((bc + 0.055) / 1.055) ** 2.4

	l := 0.2126 * rc + 0.7152 * gc + 0.0722 * bc

	if (l > 0.179)
		return 0x000000
	else
		return 0xFFFFFF
}

map3(value, start1, stop1, start2, stop2, v, when)
{
    b := start2
    c := stop2 - start2
    t := value - start1
    d := stop1 - start1
    p := v
    out := 0
    EASE_IN := 0
    EASE_OUT := 1
    EASE_IN_OUT := 2
    
    if (when = EASE_IN)
    {
        t := t / d
        out := c * (t**p) + b
    }
    else if (when = EASE_OUT)
    {
        t := t / d
        out := c * (1 - (1 - t)**p) + b
    }
    else if (when = EASE_IN_OUT)
    {
        t := t / (d/2)
        if (t < 1)
            return c/2*(t**p) + b
        out := c/2 * (2 - ((2 - t) ** p)) + b
    }
    return out
}

hsbCorrection(hue)
{
	hue *= 360
	var := map3(mod(hue, 360), 0, 360, 0, 360, 1.6, 0)
	var := var / 360
	;msgbox hue %hue%`nmap3 %var%
	return var
}

^D::listvars

; INCLUDES

#include Lib/SVGLib.ahk
#include Lib/Fnt.ahk
#include Lib/Fnt_ChooseFontDlg.ahk
#include Lib/AddTooltip.ahk
#include Lib/MoveChildWindow.ahk
#include Lib/WinGetPosEx.ahk
#include Lib/Class_CtlColors.ahk
#include Lib/Gdip_All.ahk
#include Lib/ColorProc.ahk
