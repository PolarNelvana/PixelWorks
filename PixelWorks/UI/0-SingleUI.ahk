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
Gui, Add, DropDownList, x6 y112 w98 r5 choose%whichcalc% hwndcombox vcombos, HTML|Hex (RGB)|RGB (255)|RGB (100)|RGB (1)|Integer (RGB)|Hex (BGR)|BGR (255)|BGR (100)|BGR (1)|Integer (BGR)|Hex (RYB)|RYB (255)|RYB (100)|RYB (1)|Integer (RYB)|Hex (Android RGB)|Integer (Android RGB)|Adobe RGB (255)|Adobe RGB (100)|Adobe RGB (1)|HSL (360, 100, 100)|HSL (360, 1, 1)|HSL (255)|HSL (240)|HSL (1)|HSV/B (360, 100, 100)|HSV/B (360, 1, 1)|HSV/B (1)|HWB (360, 100, 100)|HWB (360, 1, 1)|HWB (1)|HSI (360, 100, 255)|HSI (360, 1, 255)|HSI (360, 1, 1)|HSI (1)|CMYK (100)|CMYK (1)|CMY (100)|CMY (1)|Delphi|XYZ|Yxy|CIELab|CIELChab|CIELShab|CIELuv|CIELChuv|CIELShuv|Hunter Lab|YUV (255)|YUV (1)|YCbCr (HD)|YCbCr (FD)|YCbCr (SD)|YPbPr (HD)|YPbPr (SD)|YCxCz|YCoCg
CB_SETDROPPEDWIDTH := 0x0160
PostMessage, CB_SETDROPPEDWIDTH, 145,,, ahk_id %combox%Gui, Add, Edit, x111 y112 w100 h21 vcolory, %colordef%
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
Gui, Add, Progress, x345 y175 w22 h22 Background%chosenColor1% +border vProgChoose
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
	CtlColors.Attach(hEdit, chosenColor2, "Black")
if ((f1 != 1) && (b1 = 1)) ; if font is stationary but background is automatic
	CtlColors.Attach(hEdit, "White", chosenColor3)
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
Gui, 1:+hwndmainUIHWND
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

Gosub, MAGNIFICENT
R = 50
IfExist, %1%
{
	opener = %1%
	Gosub, SKIPFILESELECT
}