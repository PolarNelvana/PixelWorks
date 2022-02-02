; Written by Lucas Jaramillo. Started this project on 11/15/18. A work still in progress...
; Thank you Lord for giving me the brain capacity to do this!
; Please don't steal or modify this source code. I worked really hard on it!
; If you find this source, shoot me an email at cpumood@gmail.com!

; DIRECTIVES
#NoEnv
#NoTrayIcon
#SingleInstance Force
#Maxthreads 255
#InstallKeybdHook

; CONDITIONS
FileEncoding, UTF-8
SetWinDelay, 0
SetBatchLines, -1
SetControlDelay, 0
DetectHiddenWindows, On
CoordMode, Pixel, Screen 
CoordMode, Mouse, Screen

; CREATE IMPORTANT VARIABLES
PID := DllCall("GetCurrentProcessId")
workingDir = %A_AppData%\PixelWorks
global workingDirSVG := A_Temp . "\PixelWorks"
currentHue = 0
currentSaturation = 0
currentLightness = 94
$FontName := "Arial"
$FontOptions := "s20 cD59453"
columnCount = 0 ; Keeps track of how many colors we have captured
pickingFlag = 0 ; Keeps track of what the current color selection applies to (background, foreground, harmonies, etc.)

; READ CUSTOM SETTINGS
IniRead, zoom, %workingDir%\Settings.ini, Magnifier, 1
if zoom is not integer
	zoom = 18
else if ((zoom < 0) || (zoom > 512))
	zoom = 18
IniRead, antialize, %workingDir%\Settings.ini, Magnifier, 2
if antialize not in 0,1
	antialize = 1
IniRead, showCross, %workingDir%\Settings.ini, Magnifier, 3
if showCross not in 0,1
	showCross = 1

IniRead, autoTool, %workingDir%\Settings.ini, Tooltip, 1
if autoTool not in 0,1
	autoTool = 1
IniRead, alwaysShowTooltip, %workingDir%\Settings.ini, Tooltip, 2
if alwaysShowTooltip not in 0,1
	alwaysShowTooltip = 0
if ((autoTool = 1) && (alwaysShowTooltip = 1))
{
	autoTool = 1
	alwaysShowTooltip = 0
}
IniRead, hoverBlock, %workingDir%\Settings.ini, Tooltip, 3
if hoverBlock not in 0,1
	hoverBlock = 1
Loop, 35
{
	IniRead, gen%A_Index%, %workingDir%\Settings.ini, TooltipMod, %A_Index%
	if gen%A_Index% not in 0,1
		gen%A_Index% = 0
	else
		EnvAdd, counter, 1
}
if (counter = "")
{
	; These are the pre-defined enabled Tooltip values
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
counter := "" ; Reset this variable (we will use the counter variable in the future for other things)

IniRead, autoTray, %workingDir%\Settings.ini, TrayTip, 1
if autoTray not in 0,1
	autoTray = 1
IniRead, alwaysShowTray, %workingDir%\Settings.ini, TrayTip, 2
if alwaysShowTray not in 0,1
	alwaysShowTray = 0
if ((autoTray = 1) && (alwaysShowTray = 1))
{
	autoTray = 1
	alwaysShowTray = 0
}

IniRead, copyCurrentColor, %workingDir%\Settings.ini, AutoCopy, 1
if copyCurrentColor not in 0,1
	copyCurrentColor = 1
IniRead, copyTool, %workingDir%\Settings.ini, AutoCopy, 2
if copyTool not in 0,1
	copyTool = 1
if ((copyCurrentColor = 1) && (copyTool = 1))
{
	copyCurrentColor = 1
	copyTool = 0
}
IniRead, formatUse, %workingDir%\Settings.ini, AutoCopy, 3
if formatUse not in 0,1
	formatUse = 1

IniRead, delay, %workingDir%\Settings.ini, Options, 1
if delay is not integer
	delay = 0
else if ((delay < 0) || (delay > 500))
	delay = 0
IniRead, colorMode, %workingDir%\Settings.ini, Options, 2
if colorMode not in 0,1
	colorMode = 0
if (colorMode = 1)
{
	colorLowercase := "color"
	colorUppercase := "Color"
}
else
{
	colorLowercase := "colour"
	colorUppercase := "Colour"
}
IniRead, animate, %workingDir%\Settings.ini, Options, 3
if animate not in 0,1
	animate = 1
IniRead, stayOn, %workingDir%\Settings.ini, Options, 4
if stayOn not in 0,1
	stayOn = 1
IniRead, pauseHover, %workingDir%\Settings.ini, Options, 5
if pauseHover not in 0,1
	pauseHover = 1

Loop, 20
{
	IniRead, hot%A_Index%, %workingDir%\Settings.ini, Hotkeys, %A_Index%, %A_Space%
	IfNotEqual, hot%A_Index%, ; If not blank, add #1
		EnvAdd, counter, 1
}
if (counter = "")
{
	; Set default hotkeys
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
	; Rest of the hotkeys are disabled by default
	Loop, 10
	{
		var := % hot%A_Index% . " Up"
		Hotkey, %var%, HOTZONE%A_Index%
	}
}
else
{
	Loop, 20
	{
		var := % hot%A_Index% . " Up"
		Hotkey, %var%, HOTZONE%A_Index%
	}
}
counter := ""

IniRead, whichCalc, %workingDir%\Settings.ini, Recaller, 1
if whichCalc is not integer
	whichCalc = 1
else if ((whichCalc < 1) || (whichCalc > 33))
	whichCalc = 1
IniRead, upDownPosition, %workingDir%\Settings.ini, Recaller, 2
if upDownPosition not in 0,1
	upDownPosition = 1
IniRead, whichHarmony, %workingir%\Settings.ini, Recaller, 3
if whichHarmony not in 1,2,3,4,5,6,7,8,9,10
	whichHarmony = 1
IniRead, defaultHarmony, %workingDir%\Settings.ini, Recaller, 4
if defaultHarmony not in 1,2
	defaultHarmony = 1
IniRead, defaultGradient, %workingDir%\Settings.ini, Recaller, 5
if defaultGradient not in 1,2,3,4
	defaultGradient = 4
IniRead, defaultPattern, %workingDir%\Settings.ini, Recaller, 6
if defaultPattern is not integer
	defaultPattern = 1
else if ((defaultPattern < 1) || (defaultPattern > 45))
	defaultPattern = 1
IniRead, defaultAnalysis, %workingDir%\Settings.ini, Recaller, 7
if defaultAnalysis not in 1,2,3,4
	defaultAnalysis = 3

; The prefix "a" followed by the number (e.g. a23) refers to the variable of the GUI component on the advanced dialog
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

IniRead, forwardBackH, %workingDir%\Settings.ini, Direction, 1
if forwardBackH not in 1,2,3
	forwardBackH = 3
IniRead, forwardBackS, %workingDir%\Settings.ini, Direction, 2
if forwardBackS not in 1,2,3
	forwardBackS = 3
IniRead, forwardBackL, %workingDir%\Settings.ini, Direction, 3
if forwardBackL not in 1,2,3
	forwardBackL = 3

IniRead, fontConfig, %workingDir%\Settings.ini, ColorWorks, 1
if fontConfig not in 1,2,3
	fontConfig = 2
IniRead, backgroundConfig, %workingDir%\Settings.ini, ColorWorks, 2
if backgroundConfig not in 1,2,3
	backgroundConfig = 1
if ((fontConfig = 1) && (backgroundConfig = 1))
{
	fontConfig = 1
	backgroundConfig = 3
}
IniRead, chosenColor1, %workingDir%\Settings.ini, ColorWorks, 3
if chosenColor1 is not xdigit
	chosenColor1 = 0xEFEFEF
counter := StrLen(chosenColor1)
if (counter != 8)
	chosenColor1 = 0xEFEFEF
IniRead, chosenColor2, %workingDir%\Settings.ini, ColorWorks, 4
if chosenColor2 is not xdigit
	chosenColor2 = 0xFFFFFF
counter := StrLen(chosenColor2)
if (counter != 8)
	chosenColor2 = 0xFFFFFF
IniRead, chosenColor3, %workingDir%\Settings.ini, ColorWorks, 5
if chosenColor3 is not xdigit
	chosenColor3 = 0x000000
counter := StrLen(chosenColor3)
if (counter != 8)
	chosenColor3 = 0x000000
counter := ""

if (fontConfig = 1)
{
	f1 = 1
	f2 = 0
	f3 = 0
}
else if (fontConfig = 2)
{
	f1 = 0
	f2 = 1
	f3 = 0
}
else if (fontConfig = 3)
{
	f1 = 0
	f2 = 0
	f3 = 1
}
if (backgroundConfig = 1)
{
	b1 = 1
	b2 = 0
	b3 = 0
}
else if (backgroundConfig = 2)
{
	b1 = 0
	b2 = 1
	b3 = 0
}
else if (backgroundConfig = 3)
{
	b1 = 0
	b2 = 0
	b3 = 1
}

temp := hex2HSVB(chosenColor1, 1, "x")
currentHue := temp[1]
currentSaturation := temp[2]
currentLightness := temp[3]
temp := ""

chosenColor2 := SubStr(chosenColor2, -5)
chosenColor3 := SubStr(chosenColor3, -5)
chosenColor2Temp := chosenColor2
chosenColor3Temp := chosenColor3

IniRead, singleWindowMode, %workingDir%\Settings.ini, WindowSettings, 1
if singleWindowMode not in 0,1
	singleWindowMode = 1

IniRead, colorPreviewWindowEnabled, %workingDir%\Settings.ini, WindowSettings, 2
if colorPreviewWindowEnabled not in 0, 1
	colorPreviewWindowEnabled = 0

IniRead, magnifierWindowEnabled, %workingDir%\Settings.ini, WindowSettings, 3
if magnifierWindowEnabled not in 0, 1
	magnifierWindowEnabled = 0

IniRead, theWorksWindowEnabled, %workingDir%\Settings.ini, WindowSettings, 4
if theWorksWindowEnabled not in 0, 1
	theWorksWindowEnabled = 0

IniRead, tooltipEnabled, %workingDir%\Settings.ini, WindowSettings, 5
if tooltipEnabled not in 0, 1
	tooltipEnabled = 0

if (singleWindowMode = 0)
{
	; If everything is disabled, we need to enable at least something
	if (colorPreviewWindowEnabled != 1) && (magnifierWindowEnabled != 1) && (colorPreviewWindowEnabled != 1) && (theWorksWindowEnabled != 1) && (tooltipEnabled != 1))
		tooltipEnabled = 1; ; Enable the bare-minimum UI
}

Gosub, MENUMAKER ; Create the menu items

; SET THE CURRENT UI
ENTER:
if (singleWindowMode != 1)
	Goto, MULTIWINDOWUI
; Otherwise, we just continue with the code below that has the label SINGLEUI

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; UIS

; UI FOR SINGLE WINDOW MODE
SINGLEUI:
#Include UI/0-SingleUI.ahk
Gosub, REDRAWSINGLE
Return

; CREATES MULTIPLE UIS
MULTIWINDOWUI:
; Create all UIs and keep them hidden
#Include UI/1-ColorUI.ahk
#Include UI/2-MagnifierUI.ahk
#Include UI/3-WorksUI.ahk
Gosub, REDRAWMULTI
Return

; ABOUT UI
ABOUTUI:
#Include UI/4-AboutUI.ahk
Return

; HOTKEY CONFIGURATION UI
CONFIGHOTKEY:
Suspend, On
#Include UI/5-HotkeySettingsUI.ahk
currentFocus = hkey1
OnMessage(0x202, "which") ; Left mouse click release
OnMessage(0x101, "which") ; Keyboard release
Return

; TOOLTIP CONFIGURATION UI
CONFIGTOOLTIP:
#Include UI/6-TooltipSettingsUI.ahk
Return

; CUSTOM HOTKEY CONFIGURATION UI
CUSTHOTKEYCONFIG:
#Include UI/7-CustomHotkeySettingsUI.ahk
Return

NOTESUI:
#Include UI/8-NotesUI.ahk
Return

; SETS UP CREATION OF ZOOM CHANGE UI
ZOOMUI:
sliderMode = Zoom
slider := zoom
if (currentUI = 1)
	range = 50
else
	range = 512
rangeMin = 1
unit = `%
defaultSlide = 18
Goto, SLIDERUI

; SETS UP CREATION OF DELAY CHANGE UI
DELAYGUI:
sliderMode = Delay
slider := delay
range = 500
rangeMin = 0
unit = ms
defaultSlide = 0

; MINI SLIDER UI
SLIDERUI:
#Include UI/9-SliderUI.ahk
Return

; GRADIENT DIRECTION CONFIGURATION UI
DIRECTIONUI:
#Include UI/10-DirectionUI.ahk
Return

; COLOR CONFIGURATION UI
COLORCONFUI:
#Include UI/11-ColorConfUI.ahk
Return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; MENU ROUTINES

; CREATE MENU ON GUI
MENUMAKER:
Menu, Tray, NoStandard
Menu, Tray, DeleteAll

Menu, FileMenu, Add, Open..., OPENFILE
Menu, FileMenu, Add, Save List, SAVEFILE
Menu, FileMenu, Add, Save List As..., SAVEFILEAS
Menu, FileMenu, Add, Clear All, CLEARLIST
Menu, FileMenu, Add, Exit, GUICLOSE
Menu, FileMenu, Disable, Save List
Menu, FileMenu, Disable, Save List As...
Menu, FileMenu, Disable, Clear All
disabledFileMenu = 1

Menu, MagnifierMenu, Add, Zoom, ZOOMUI
Menu, MagnifierMenu, Add, Antialize, ANTIALIZEUI
if (antialize = 1)
	Menu, MagnifierMenu, Check, Antialize
else
	Menu, MagnifierMenu, Uncheck, Antialize
Menu, MagnifierMenu, Add, Show Cross Lines, CROSSLABEL
if (showCross = 1)
	Menu, MagnifierMenu, Check, Show Cross Lines
else
	Menu, MagnifierMenu, Uncheck, Show Cross Lines

Menu, TooltipMenu, Add, Configure, CONFIGTOOLTIP
Menu, TooltipMenu, Add, Auto Tooltip, AUTOTOOLTIP, +radio
if (autoTool = 1)
	Menu, TooltipMenu, Check, Auto Tooltip
else
	Menu, TooltipMenu, Uncheck, Auto Tooltip
Menu, TooltipMenu, Add, Always Show, ALWAYSTOOLTIP, +radio
if (alwaysShowTooltip = 1)
{
	Menu, TooltipMenu, Check, Always Show
	Menu, TooltipMenu, Uncheck, Auto Tooltip
}
else
	Menu, TooltipMenu, Uncheck, Always Show
Menu, TooltipMenu, Add, Hide on Self-Hover, HOVERHIDE
if (hoverBlock = 1)
	Menu, TooltipMenu, Check, Hide on Self-Hover
else
	Menu, TooltipMenu, Uncheck, Hide on Self-Hover
if (pauseHover = 1)
	Menu, TooltipMenu, Disable, Hide on Self-Hover

Menu, TrayTipMenu, Add, Auto Tray Icon, AUTOTRAYICON, +radio
if (autoTray = 1)
	Menu, TrayTipMenu, Check, Auto Tray Icon
else
	Menu, TrayTipMenu, Uncheck, Auto Tray Icon
Menu, TrayTipMenu, Add, Always Show, ALWAYSTRAY, +radio
if (alwaysShowTray = 1)
{
	Menu, TrayTipMenu, Check, Always Show
	Menu, TrayTipMenu, Uncheck, Auto Tray Icon
}
else
	Menu, TrayTipMenu, Uncheck, Always Show

Menu, CopyMenu, Add, Auto Copy Current %colorUppercase%, COPYCURRCOLOR, +radio
if (copyCurrentColor = 1)
	Menu, CopyMenu, Check, Auto Copy Current %colorUppercase%
else
	Menu, CopyMenu, Uncheck, Auto Copy Current %colorUppercase%
Menu, CopyMenu, Add, Auto Copy Tooltip, COPYTOOLTIP, +radio
if (copyTool = 1)
	Menu, CopyMenu, Check, Auto Copy Tooltip
else
	Menu, CopyMenu, Uncheck, Auto Copy Tooltip
Menu, CopyMenu, Add, Include Format, INCLUDEFORMAT
if (formatUse = 1)
	Menu, CopyMenu, Check, Include Format
else
	Menu, CopyMenu, Uncheck, Include Format

Menu, OptionsMenu, Add, Magnifier, :MagnifierMenu
Menu, OptionsMenu, Add, Tooltip, :TooltipMenu
Menu, OptionsMenu, Add, Tray Icon, :TrayTipMenu
Menu, OptionsMenu, Add, Copying, :CopyMenu
Menu, OptionsMenu, Add, Delay, DELAYGUI
Menu, OptionsMenu, Add, Hotkeys, CONFIGHOTKEY

; For UIs that don't have Zoom menu item (Color Preview, The Works)
Menu, OptionsMenuNoZoom, Add, Tooltip, :TooltipMenu
Menu, OptionsMenuNoZoom, Add, Tray Icon, :TrayTipMenu
Menu, OptionsMenuNoZoom, Add, Copying, :CopyMenu
Menu, OptionsMenuNoZoom, Add, Delay, DELAYGUI
Menu, OptionsMenuNoZoom, Add, Hotkeys, CONFIGHOTKEY

if (colorMode = 1)
{
	Menu, OptionsMenu, Add, Replace "Color" with "Colour", NAMESWAP
	Menu, OptionsMenuNoZoom, Add, Replace "Color" with "Colour", NAMESWAP
}
else
{
	Menu, OptionsMenu, Add, Replace "Colour" with "Color", NAMESWAP
	Menu, OptionsMenuNoZoom, Add, Replace "Colour" with "Color", NAMESWAP
}

if (animate = 1)
	Menu, OptionsMenu, Add, Disable Animation, ANIMATE
else
	Menu, OptionsMenu, Add, Enable Animation, ANIMATE

Menu, OptionsMenu, Add, Stay on Top, STAYONTOP
Menu, OptionsMenuNoZoom, Add, Stay on Top, STAYONTOP
if (stayOn = 1)
{
	Menu, OptionsMenu, Check, Stay on Top
	Menu, OptionsMenuNoZoom, Check, Stay on Top
}
else
{
	Menu, OptionsMenu, Uncheck, Stay on Top
	Menu, OptionsMenuNoZoom, Uncheck, Stay on Top
}

Menu, OptionsMenu, Add, Pause on Self-Hover, PAUSESELF
Menu, OptionsMenuNoZoom, Add, Pause on Self-Hover, PAUSESELF
if (pauseHover = 1)
{
	Menu, OptionsMenu, Check, Pause on Self-Hover
	Menu, OptionsMenuNoZoom, Check, Pause on Self-Hover
}
else
{
	Menu, OptionsMenu, Uncheck, Pause on Self-Hover
	Menu, OptionsMenuNoZoom, Uncheck, Pause on Self-Hover
}

Menu, OptionsMenu, Add, Set as Default Window, SETASDEFAULT
Menu, OptionsMenuNoZoom, Add, Set as Default Window, SETASDEFAULT
if (singleWindowMode = currentUI)
{
	Menu, OptionsMenu, Check, Set as Default Window
	Menu, OptionsMenuNoZoom, Check, Set as Default Window
	if (singleWindowMode = 1)
	{
		Menu, OptionsMenu, Disable, Set as Default Window
		Menu, OptionsMenuNoZoom, Disable, Set as Default Window
	}
}
else
{
	Menu, OptionsMenu, Uncheck, Set as Default Window
	Menu, OptionsMenuNoZoom, Uncheck, Set as Default Window
	if (singleWindowMode = 1)
	{
		Menu, OptionsMenu, Enable, Set as Default Window
		Menu, OptionsMenuNoZoom, Enable, Set as Default Window
	}
}

Menu, SystemDiags, Add, %colorUppercase% Dialog, MENUHANDLER
Menu, SystemDiags, Add, Font Dialog, MENUHANDLER
Menu, ToolsMenu, Add, System Dialogs, :SystemDiags
Menu, ToolsMenu, Add, %colorUppercase% Recorder, MENUHANDLER
Menu, ToolsMenu, Add, PixelSearch, MENUHANDLER
Menu, ToolsMenu, Add, Random %colorUppercase% Generator, MENUHANDLER
Menu, ToolsMenu, Add, Converter, MENUHANDLER

Menu, WindowsListMenu, Add, Everything (Compact Mode), SINGLEUIENABLE
if (currentUI = 1)
	Menu, WindowsListMenu, Check, Everything (Compact Mode)

Menu, WindowsListMenu, Add, %colorUppercase% Preview, COLORPREVIEWENABLE
if (currentUI = 2)
	Menu, WindowsListMenu, Check, %colorUppercase% Preview

Menu, WindowsListMenu, Add, Magnifier, MAGNIFYENABLE
if (currentUI = 3)
	Menu, WindowsListMenu, Check, Magnifier

Menu, WindowsListMenu, Add, The Works, THEWORKSENABLE
if (currentUI = 4)
	Menu, WindowsListMenu, Check, The Works

Menu, WindowsListMenu, Add, Tooltip, TOOLTIPUIENABLE
if (currentUI = 5)
	Menu, WindowsListMenu, Check, Tooltip

Menu, MenuBar, Add, File, :FileMenu
Menu, MenuBar, Add, Options, :OptionsMenu
Menu, MenuBar, Add, Tools, :ToolsMenu
Menu, MenuBar, Add, Windows, :WindowsListMenu
Menu, MenuBar, Add, About, ABOUTUI

Menu, Tray, Add, File, :FileMenu
Menu, Tray, Add, Options, :OptionsMenu
Menu, Tray, Add, Tools, :ToolsMenu
Menu, Tray, Add, Windows, :WindowsListMenu
Menu, Tray, Add, About, ABOUTUI

; We need a separate menu bar for Magnifier UI (has no File menu item)
Menu, MenuBarZoom, Add, Options, :OptionsMenu
Menu, MenuBarZoom, Add, Tools, :ToolsMenu
Menu, MenuBarZoom, Add, Windows, :WindowsListMenu
Menu, MenuBarZoom, Add, About, ABOUTUI

; We need a separate menu bar for Color Preview UI (has no File menu item and no Zoom menu item under Options)
Menu, MenuBarColorPreview, Add, Options, :OptionsMenuNoZoom
Menu, MenuBarColorPreview, Add, Tools, :ToolsMenu
Menu, MenuBarColorPreview, Add, Windows, :WindowsListMenu
Menu, MenuBarColorPreview, Add, About, ABOUTUI

; We need a separate menu bar for The Works UI (has no Zoom menu item under Options)
Menu, MenuBarTheWorks, Add, File, :FileMenu
Menu, MenuBarTheWorks, Add, Options, :OptionsMenuNoZoom
Menu, MenuBarTheWorks, Add, Tools, :ToolsMenu
Menu, MenuBarTheWorks, Add, Windows, :WindowsListMenu
Menu, MenuBarTheWorks, Add, About, ABOUTUI
Return

; OPEN LIST ROUTINE
OPENFILE:
if (columnCount != 0)
{
	Gui, 1: +OwnDialogs
	MsgBox, 0x34, Warning, Opening a new file will clear all of the entries in the list.`n`nAre you sure that you want to continue?
	IfMsgBox, No
		Return
}
Gui, 1:+OwnDialogs
FileSelectFile, opener, 1,, Open, (*.txt; *.pwf)
; File should be composed of lines of text, in which each line should be separated into 6 sections by pipes ( | ) - A_Index refers to each respective section
SKIPFILESELECT:
counter = 0 ; Since we have nested loops, this keeps track of the A_Index in the outer loop
weAlreadyDidThis = 0 ; Keeps track if we already opened a file previously
Loop, Read, %opener%
{
	EnvAdd, counter, 1
	if (A_LoopReadLine = "")
		Break
	Loop, Parse, A_LoopReadLine, |
	{
		if (A_Index != 6)
			currentString := stringTrimmer(A_LoopField)
		else
			StringTrimLeft, currentString, A_LoopField, 1

		if (A_Index = 1)
		{
			if (currentString != counter)
			{
				; If number is not at the correct index
				; For example, will throw this error if number of 15 is found at position 20
				reason = 1
				Goto, CALLREADERROR
			}
		}
		else if (A_Index = 2)
			convertedColor := currentString
		else if (A_Index = 3)
		{
			For key, value in listFormats ; listFormats is from Lib/ColorLib.ahk
			{
				if (currentString := value)
				{
					temp = 1
					keyPosition := key
					Break
				}
			}

			if (temp != 1)
			{
				; If color format is not valid
				reason = 2
				Goto, CALLREADERROR
			}

			temp := ""
		}
		else if (A_Index = 4)
		{
			length := StrLen(currentString)
			if (length <= 500)
				currentNote := currentString
			else
			{
				; If note is too long
				reason = 3
				Goto, CALLREADERROR
			}
		}
		else if (A_Index = 5)
		{
			if currentString in 0x000000,0xFFFFFF
				fontContrastColor := currentString
			else
			{
				; If contrast color is not black or white
				reason = 4
				Goto, CALLREADERROR
			}
		}
		else if (A_Index = 6)
		{
			StringLeft, checkPrefix, currentString, 2
			if (checkPrefix != "0x")
			{
				; If value does not contain hexadecimal prefix
				reason = 5
				Goto, CALLREADERROR
			}

			if currentString is not xdigit
			{
				; If value is not valid hexadecimal number
				reason = 6
				Goto, CALLREADERROR
			}

			length := StrLen(currentString)
			if (length != 8)
			{
				; If hexadecimal value is greater than 8 characters
				reason = 7
				Goto, CALLREADERROR
			}

			hexBGR := currentString
			firstPosition := SubStr(hexBGR, 3, 2)
			secondPosition := SubStr(hexBGR, 5, 2)
			thirdPosition := SubStr(hexBGR, 7, 2)
			testHex = 0x%thirdPosition%%secondPosition%%firstPosition%

			testConversion := arrayToText(number2Hex(testHex, keyPosition))
			if (testConversion != convertedColor)
			{
				; If hexadecimal value does not successfully convert into the value present on the list
				; The last item in the row is essentially a "checksum" of the color, represented as hex (BGR)
				; For example, let's say we have CIELCh (67.07, 45.89, 256.39). The last element in the row should be hex (BGR) 0xF3AD24.
				; Now imagine the list is corrupted. Instead, we have CIELCh (81, 20.78, 259.87) in the list instead at the same position.
				; We attempt to convert the checksum  of 0xF3AD24 to CIELCh and don't get a match - thus the list is corrupted. 
				reason = 8
				Goto, CALLREADERROR
			}
		}
	}

	if (weAlreadyDidThis != 1)
	{
		LV_Delete()
		columnCount = 0
	}
	LV_Add("", A_Index, convertedColor, colorFormat, currentNote)
	LV_ColorChange(A_Index, fontContrastColor, hexBGR)
	EnvAdd, columnCount, 1
	if (weAlreadyDidThis != 1)
	{
		if (columnCount > 0)
		{
			Gosub, FILEMENUWORKER1
			weAlreadyDidThis = 1
		}
	}
	if (A_Index > 99999)
		Break
}
counter := ""
Return

CALLREADERROR:
Gui, 1:+OwnDialogs
MsgBox, 0x10, Error, The %colorLowercase% list is corrupted or unreadable.`n`n[%reason%]
Return

; ENABLE CONTEXT MENU ENTRIES FOR RIGHT CLICK OF COLOR LIST
FILEMENUWORKER1:
if (disabledFileMenu = 1)
{
	Menu, FileMenu, Enable, Save List
	Menu, FileMenu, Enable, Save List As...
	Menu, FileMenu, Enable, Clear All
	disabledFileMenu = 0
}
Return

; OPPOSITE OF ABOVE
FILEMENUWORKER2:
if (disabledFileMenu = 0)
{
	Menu, FileMenu, Disable, Save List
	Menu, FileMenu, Disable, Save List As...
	Menu, FileMenu, Disable, Clear All
	disabledFileMenu = 1
}
Return

; SAVE LIST ROUTINE
SAVEFILEAS:
differentFileFlag = 1 ; Keeps track if we creating a new file to distinGuish between Save/Save As
SAVEFILE:
if (columnCount = 0)
{
	MsgBox, 0x20, Error, IT'S BLANK!!!`n`nThere is nothing to save.`n`nAnyway, this button should be disabled. How did you even obtain access to this button?!
	Return
}

Gui 1:+OwnDialogs
if ((fileAlreadyOpened = 1) && (differentFileFlag = 0))
	fileLocation := opener
else
{
	fileTypes = %colorUppercase% List (*.pwf; *.txt)|All Files (*.*)
	Gui, 1:+OwnDialogs
	fileLocation := SelectFile(mainUIHWND, "Save As", fileTypes, "1", fileName, ".pwf", "S CREATEPROMPT OVERWRITEPROMPT")
	if (fileLocation = "")
	{
		differentFileFlag = 0
		Return
	}
}

IfExist, %fileLocation%
{
	try
		FileDelete, %fileLocation%
	catch
		Goto, CALLWRITEERROR
}

dataToWrite := ""
Loop, %columnCount%
{
	LV_GetText(convertedColor, A_Index, 2)
	LV_GetText(colorFormat, A_Index, 3)
	LV_GetText(currentNote, A_Index, 4)
	fontContrastColor := % Line_Color_%A_Index%_Text
	hexBGR := % Line_Color_%A_Index%_Back
	dataToWrite := "#" . A_Index . " | " . convertedColor . " | " . colorFormat . " | "  . currentNote . " | " . fontContrastColor . " | " . hexBGR

	if (A_Index != columnCount) ; Prevent last line of list from containing blank new line
		dataToWrite .= "`n"

	try
		FileAppend, %dataToWrite%, %fileLocation%
	catch
		Goto, CALLWRITEERROR
}

differentFileFlag = 0
fileAlreadyOpened = 1
Return

CALLWRITEERROR:
Gui, 1:+OwnDialogs
MsgBox, 0x10, Error, Failed to save the %colorLowercase% list!`n`nMake sure that you have appropriate privileges to save to this location and that no other programs are locking the file.
Return

; CLEAR ALL ITEMS IN COLOR LIST
CLEARLIST:
Gui, 1:+OwnDialogs
MsgBox, 0x34, Warning, Are you sure that you want to clear all of the entries in the %colorLowercase% list?
IfMsgBox, No
	Return
LV_Delete()
Gosub, RESETHARMONY
REFRESHVARIABLES:
columnCount = 0 ; Reset count of items in color list
firstMousePosFlag = 0 ; When calculating delta mouse position, during the first iteration there is no previous mouse position so we need to keep track of this
deltaXVar = 0
deltaYVar = 0
colorPreviewSquare = 000000
lastSelected =
storedinilight =
storedinisat =
varwhich =
insert2harmon =
Gosub, RESETCOLORS
Gosub, FILEMENUWORKER2
Return

ANTIALIZEUI:
Menu, MagnifierMenu, ToggleCheck, Antialize
if (antialize = 1)
	antialize = 0
else
	antialize = 1
Return

CROSSLABEL:
Menu, MagnifierMenu, ToggleCheck, Show Cross Lines
if (showCross = 1)
	showCross = 0
else
	showCross = 1
Return

PAUSESELF:
Menu, OptionsMenu, ToggleCheck, Pause on Self-Hover
if (pauseHover = 1)
{
	pauseHover = 0
	Menu, TooltipMenu, Enable, Hide on Self-Hover
}
else
{
	pauseHover = 1
	Menu, TooltipMenu, Check, Hide on Self-Hover
	Menu, TooltipMenu, Disable, Hide on Self-Hover
	hoverBlock = 1
}
Return

HOVERHIDE:
Menu, TooltipMenu, ToggleCheck, Hide on Self-Hover
if (hoverBlock = 1)
	hoverBlock = 0
else
	hoverBlock = 1
Return

AUTOTOOLTIP:
Menu, TooltipMenu, ToggleCheck, Auto Tooltip
if (autoTool = 1)
	autoTool = 0
else
{
	autoTool = 1
	if (alwaysShowTooltip = 1)
	{
		alwaysShowTooltip = 0
		Menu, TooltipMenu, ToggleCheck, Always Show
	}
}
Return

ALWAYSTOOLTIP:
Menu, TooltipMenu, ToggleCheck, Always Show
if (alwaysShowTooltip = 1)
	alwaysShowTooltip = 0
else
{
	alwaysShowTooltip = 1
	if (autoTool = 1)
	{
		autoTool = 0
		Menu, TooltipMenu, ToggleCheck, Auto Tooltip
	}
}
Return

AUTOTRAYICON:
Menu, TraytipMenu, ToggleCheck, Auto Tray Icon
if (autoTray = 1)
	autoTray = 0
else
{
	autoTray = 1
	if (alwaysShowTray = 1)
	{
		alwaysShowTray = 0
		Menu, TraytipMenu, ToggleCheck, Always Show
	}
}
Return

ALWAYSTRAY:
Menu, TrayTipMenu, ToggleCheck, Always Show
if (alwaysShowTray = 1)
	alwaysShowTray = 0
else
{
	alwaysShowTray = 1
	if (autoTray = 1)
	{
		autoTray = 0
		Menu, TrayTipMenu, ToggleCheck, Auto Tray Icon
	}
}
Return

COPYCURRCOLOR:
Menu, CopyMenu, ToggleCheck, Auto Copy Current %colorUppercase%
if (copyCurrentColor = 1)
	copyCurrentColor = 0
else
{
	copyCurrentColor = 1
	if (copyTool = 1)
	{
		copyTool = 0
		Menu, CopyMenu, ToggleCheck, Auto Copy Tooltip
	}
}
Return

COPYTOOLTIP:
Menu, CopyMenu, ToggleCheck, Auto Copy Tooltip
if (copyTool = 1)
	copyTool = 0
else
{
	copyTool = 1
	if (copyCurrentColor = 1)
	{
		copyCurrentColor = 0
		Menu, CopyMenu, ToggleCheck, Auto Copy Current %colorUppercase%
	}
}
Return

INCLUDEFORMAT:
Menu, CopyMenu, ToggleCheck, Include Format
if (formatUse = 1)
	formatUse = 0
else
	formatUse = 1
Return

NAMESWAP:
Gui, 1:+OwnDialogs
MsgBox, 0x34, Warning, In order to do this, PixelWorks needs to restart.`n`nAre you sure that you want to continue? (If you didn't save the %colorLowercase% list, all values will be lost!)
IfMsgBox, Yes
	Reload
else
	Return

ANIMATE:
if (animate = 1)
{
	Menu, OptionsMenu, Rename, Disable Animation, Enable Animation
	animate = 0
}
else
{
	Menu, OptionsMenu, Rename, Enable Animation, Disable Animation
	animate = 1
}
Return

STAYONTOP:
Menu, OptionsMenu, ToggleCheck, Stay on Top
if (stayOn = 1)
{
	stayOn = 0
	Gui, 1:-AlwaysOnTop
	Gui, 2:-AlwaysOnTop
	Gui, 3:-AlwaysOnTop
	Gui, 4:-AlwaysOnTop
	Gui, 5:-AlwaysOnTop
	Gui, 6:-AlwaysOnTop
	Gui, 7:-AlwaysOnTop
	Gui, 8:-AlwaysOnTop
}
else
{
	stayOn = 1
	Gui, 1:+AlwaysOnTop
	Gui, 2:+AlwaysOnTop
	Gui, 3:+AlwaysOnTop
	Gui, 4:+AlwaysOnTop
	Gui, 5:+AlwaysOnTop
	Gui, 6:+AlwaysOnTop
	Gui, 7:+AlwaysOnTop
	Gui, 8:+AlwaysOnTop
}
Return

; SET AS DEFAULT UI ROUTINE - CONTINUES TO DELETEWINDOWS
SETASDEFAULT:
if (currentUI = singleWindowMode)
{
	singleWindowMode = 1
	Menu, OptionsMenu, Uncheck, Set as Default Window
}
else
{
	singleWindowMode := currentUI
	Menu, OptionsMenu, Check, Set as Default Window
	if (currentUI = 1)
		Menu, OptionsMenu, Disable, Set as Default Window
}
Return

SINGLEUIENABLE:
currentUI = 1
Goto, DELETEWINDOWS

COLORPREVIEWENABLE:
currentUI = 2
Goto, DELETEWINDOWS

MAGNIFYENABLE:
currentUI = 3
Goto, DELETEWINDOWS

THEWORKSENABLE:
currentUI = 4
Goto, DELETEWINDOWS

TOOLTIPUIENABLE:
currentUI = 5
Goto, DELETEWINDOWS

DELETEWINDOWS:
Menu, WindowsListMenu, Uncheck, Everything (Compact Mode)
Menu, WindowsListMenu, Uncheck, %colorUppercase% Preview
Menu, WindowsListMenu, Uncheck, Magnifier
Menu, WindowsListMenu, Uncheck, The Works
Menu, WindowsListMenu, Uncheck, Tooltip
Menu, FileMenu, DeleteAll
Menu, MagnifierMenu, DeleteAll
Menu, OptionsMenu, DeleteAll
Menu, MenuBar, DeleteAll
Gui, 1:Destroy
Gui, 2:Destroy
Gui, 3:Destroy
Gui, 4:Destroy
Gui, 5:Destroy
Gui, 6:Destroy
Gui, 7:Destroy
Gui, 8:Destroy
Gui, 9:Destroy
Goto, ENTER