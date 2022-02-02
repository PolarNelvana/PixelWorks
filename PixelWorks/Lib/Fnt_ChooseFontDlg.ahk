;------------------------------
;
; Function: Fnt_ChooseFontDlg
;
; Description:
;
;   An alternative to the <Fnt_ChooseFont> function.
;
; Type:
;
;   Add-on function.  Preview/Experimental.
;
; Parameters:
;
;   p_Owner - Owner GUI.  Set to 0 for no owner.  See the *Owner* section for
;       more information.
;
;   r_Name - Typeface name. [Input/Output] On input, this variable can contain
;       the default typeface name.  On output, this variable will contain the
;       selected typeface name.
;
;   r_Options - Font options. [Input/Output] See the *Options* section for the
;       details.
;
;   p_Effects - Flags to determine what GUI controls are shown.  See the
;       *Effects* section for more information.
;
;   p_Flags - [Advanced Feature] Additional ChooseFont bit flags. [Optional]
;       The default is 0 (no additional flags).  See the *ChooseFont Flags*
;       section for more information.
;
;   p_HelpHandler - Name of a developer-created function that is called when the
;       the user presses the Help button on the dialog. [Optional] See the *Help
;       Handler* section for the details.  Note: The CF_SHOWHELP flag is
;       automatically added if this parameter contains a valid function name.
;
; Returns:
;
;   TRUE if a font was selected, otherwise FALSE is returned if the dialog was
;   canceled or if an error occurred.
;
; Calls To Other Functions:
;
; * AddTooltip
; * <Fnt_Color2ColorName>
; * <Fnt_Color2RGB>
; * <Fnt_ColorName2RGB>
; * <Fnt_CreateFont>
; * <Fnt_CreateMessageFont>
; * <Fnt_DeleteFont>
; * <Fnt_FORemoveWeight>
; * <Fnt_FOSetWeight>
; * <Fnt_GetDefaultGUIMargins>
; * <Fnt_GetFontAvgCharWidth>
; * <Fnt_GetFontHeight>
; * <Fnt_GetFontWeight>
; * <Fnt_GetFontSize>
; * <Fnt_GetListOfFonts>
; * <Fnt_GetMessageFontName>
; * <Fnt_GetMessageFontOptions>
; * <Fnt_GetStatusFontName>
; * <Fnt_GetStatusFontOptions>
; * <Fnt_GetStringWidth>
; * <Fnt_GetSysColor>
; * <Fnt_GetWindowTextColor>
; * <Fnt_RGB2ColorName>
; * <Fnt_SetFont>
; * <Fnt_TruncateStringToFit>
; * MoveChildWindow
; * WinGetPosEx (called from MoveChildWindow)
;
; ChooseFont Flags:
;
;   This function and associated dialog is designed to emulate the ChooseFont
;   dialog when possible.  Much of the flexibility this dialog is available via
;   a large number of ChooseFont flags.  For this function, the flags are
;   determined by fixed values, options in the r_Options parameter, and the
;   value of the p_Effects parameter.  Although the flags set by these
;   conditions will handle the needs of the majority of developers, there are
;   additional ChooseFont flags that could provide additional value.
;
;   The p_Flags parameter is used to _add_ additional ChooseFont flags to
;   control the operation of the FntCFDlg window.  Note carefully that some of
;   the ChooseFont flags are not supported by this function.  In addition, there
;   are a few custom ChooseFont flags that are only available to functions in
;   the Fnt library.  See the function's static variables for a list of possible
;   flag values.
;
;   Warning: This is an advanced feature.  Including invalid or conflicting
;   flags may produce unexpected results.  In addition, some of the ChooseFont
;   flags may conflict with some of the flags set in the p_Effects parameter.
;   Be sure to test throroughly.
;
; Compatibility:
;   
;   At this writing, this function is mostly backwards compatible to the
;   features and syntax of the functions that use the ChooseFont API in the
;   Fnt library (<Fnt_ChooseFont>) and in the Dlg2 library (Dlg_ChooseFont).
;   There many possible exceptions but often just the function name needs to be
;   changed in order to use this add-on function.  For example, the following
;   call to <Fnt_ChooseFont> function can easily changed.
;
;       (start code)
;       From:
;       Fnt_ChooseFont(hMyGUI,$FontName,$FontOptions)
;
;       To:
;       Fnt_ChooseFontDlg(hMyGUI,$FontName,$FontOptions)
;       (end)
;
; Effects:
;
;   The p_Effects parameter is used to determine what GUI controls are shown.
;   The following are the primary values for this parameter:
;
;   TRUE (1) or CFD_ALL (0x1) - Show all GUI controls except the status bar.
;       This is the default value.  The controls shown are similar to what is
;       shown when the CF_EFFECTS flags is included when calling the ChooseFont
;       API function.
;
;   2 or CFD_ALLXCOLOR (0x2) - Show all GUI controls except the Color combo box
;       and the status bar.  The controls shown are similar to what is shown
;       when the CF_EFFECTS flag in not included when calling the ChooseFont API
;       function.
;
;   FALSE (0) - This will produce the same results as CFD_ALLXCOLOR (0x2) except
;       that it cannot be combined with any other value.  To combine with other
;       values, use CFD_ALLXCOLOR (0x2) instead.
;
;   Alternatively, any combination of following values can be used.  These
;   values can be used independently or they can be combined with the
;   previous values except where noted.
;
;   CFD_TYPEFACE (0x10) - Show the Font Name combo box.
;
;   CFD_SIZE (0x20) - Show the Size combo box.
;
;   CFD_STYLE (0x40) - Show the Style group.
;
;   CFD_QUALITY (0x80) - Show the Quality drop down list.
;
;   CFD_COLOR (0x100) - Show the Color combo box.
;
;   CFD_SAMPLETEXT (0x200) - Show the Sample Text group.
;
;   CFD_STATUSBAR (0x400) - Show the status bar.
;
;   CFD_DISABLETYPEFACE (0x1000) - Disable the Font Name combo box.  This flag
;       is only used if the Font Name combo box is showing.
;
;   CFD_DISABLESIZE (0x2000) - Disable the Size combo box.  This flag is only
;       used if the Size combo box is showing.
;
;   CFD_DISABLESTYLE (0x4000) - Disable the controls in the Style group.  This
;       flag is only used if the Style group is showing.
;
;   CFD_DISABLEQUALITY (0x8000) - Disable the Quality drop down list.  This flag
;       is only used if the Quality drop down list is showing.
;
;   CFD_DISABLECOLOR (0x10000) - Disable the Color combo box.  This flag is only
;       used if the Color combo box is showing.
;
;   Additional...
;
;   Not showing a GUI control is much different that just disabling it.  If a
;   control or group of controls are not shown, the associated value(s) are not
;   returned.  For example, if the Color combo box is not shown, the color
;   option (Ex: "cBlue") is not returned.  However, if a control is disabled,
;   the initial value of the control cannot be modified by the user and is
;   returned as is.  For example if the initial value of the Size combo box is
;   12 and the control is disabled, the user will see the Size combo box, the
;   size 12 will be selected, but user will not be able to modify the size.
;   When the function returns, the size option will return with the selected
;   value (Ex: "s12").  If hiding or disabling any of the controls that affect
;   the value of the font name or options, be sure to test thoroughly.
;
; Height:
;
;   The "h{HeightInPixels}" option (r_Options parameter) allows the developer to
;   specify a font size based on height instead of point size.  This option has
;   the same precedence as the "s"ize option.  If both the "h" and "s" options
;   are specified, the last one specified is used.
;
;   If the height value is positive (Ex: "h30"), the font mapper matches it
;   against the cell height (ascent + descent) of the available fonts and will
;   set/select the closest point size value.
;
;   If the height value is negative (Ex: "h-25"), the font mapper matches the
;   absolute value against the em height (cell height less internal leading) of
;   the available fonts and will set/select the closest point size value.
;
;   Note: This is an "input only" option.  The "h"eight option is not returned.
;   Instead, the function returns the point size selected.  Ex: "s16".
;
; Help Handler:
;
;   The Help Handler is an optional developer-created function that is called
;   when the user presses the Help button on the dialog.
;
;   The function must have one parameter -- an event object.  For lack of a
;   better name, we'll call it EO.  The following Event Object properties are
;   available:
;
;   Effects - Effects flags.  This contains all of the active Effects flags.
;       They are not necessarily the same flags set in the p_Effects parameter.
;       Flags that are implicitly set because a flag covers multiple controls
;       (Ex: CFD_ALL), are explicitly set in this property.  This keeps the
;       developer from having to test for all possible conditions (Ex: CFD_ALL
;       or CFD_ALLXCOLOR or CFD_SIZE).  Instead, only the specific condition
;       (Ex: CFD_SIXE) needs to be tested.
;
;   Event - The name of the event.  For the help handler, the event is "Help".
;
;   Flags - ChooseFont flags.  This contains all of the ChooseFont flags that
;       that have been set.  They are not necessarily the same as the flags set
;       in the p_Flags parameter.  They also contain flags that are
;       automatically added by this function.
;
;   FontName - The current font name.  This is not necessarily the final font
;       name that the Fnt_ChooseFontDlg function will return.
;
;   FontOptions - The current font options.  This not necessarily the final
;       version of the font options that the Fnt_ChooseFontDlg function will
;       return.
;
;   GUI - The GUI name.  Ex: "FntCFDlg".
;
;   hDlg - The handle to the FntCFDlg window.
;
;   hSB - The handle to the status bar.  This value is zero (0) if the status
;       bar is not showing.
;
;   Hint: The EO properties are rarely used in a help handler function but they
;   are available if needed.
;
;   A few notes...
;
;   It's up to the developer to determine what commands are performed in this
;   function but displaying some sort of help message/document is what is
;   expected.
;
;   While the help handler is running, the default GUI is the GUI name of the
;   FntCFDlg window.  This allows the developer to use commands such as "gui
;   +OwnDialogs" (to make standard dialogs (Ex: MsgBox) modal) and SB_SetText
;   without having to change the default GUI.  If needed, the Fnt_ChooseFontDlg
;   function will restore the default GUI to whatever it was after the add-on
;   function returns.  This will ensure that the Fnt_ChooseFontDlg function or
;   any add-on will not interfere with the parent script.
;
;   Note: The main FntCFDlg window will not operate correctly until the handler
;   has completed processing so the the handler should either 1) finish quickly
;   or 2) any dialogs displayed via the handler should be modal.  See the
;   example scripts included with this project for an example.
;
; Options:
;
;   On input, the r_Options parameter contains the default font options.  On
;   output, r_Options will contain the selected font options.  The following
;   space-delimited options (in alphabetical order) are available:
;
;   bold - See the *Weight* section for more information.
;
;   c{color} - Text color.  "{color}" is one of 16 supported color names (Ex:
;       Blue.  See the AutoHotkey documentation for a list of possible color
;       names), a 6-digit RGB hexadecimal color value (Ex: FF00FA), or a 6-digit
;       hexadecimal number (Ex: 0x808080).  On input, this option will attempt
;       to pre-select the color name.  On output, this option is returned with
;       the selected color.  Notes and exceptions:  1) The system default text
;       color is the default color.  On input, the default text color is
;       pre-selected if this option is not defined.  2) If p_Effects is FALSE or
;       does not contain the CFD_COLOR flag, this option is ignored on input
;       and is not returned.
;
;   h{HeightInPixels} - [Input Only]  Font height in pixels.  Ex: h20.  See the
;       *Height* section for more information.
;
;   italic - On input, this option will check the Italic option.  On output,
;       this option will be returned if the Italic option was checked.
;
;   s{SizeInPoints} -  Font size in points.  For example: s12.  On input, this
;       option will load the font size and if on the font size list, will
;       pre-select the font size.  On output, the font size that was
;       entered/selected is returned.
;
;   SizeMax{MaxPointSize} - [Input only] Sets the maximum point size the user
;       can enter/select.  See the *Size Limits* section for more information.
;
;   SizeMin{MinPointSize} - [Input only] Sets the minimum point size the user
;       can enter/select.  See the *Size Limits* section for more information.
;
;   strike -  On input, this option will check the Strikeout option.  On output,
;       this option will be returned if the Strikeout option was checked.
;
;   underline -  On input, this option will check the Underline option.  On
;       output, this option will be returned if the Underline option was
;       checked.
;
;   w{FontWeight} - Font weight (thickness or boldness), which is an integer
;       between 1 and 1000.  Ex: w200.  See the *Weight* section for more
;       information.
;
;   To specify more than one option, include a space between each option.  For
;   example: s12 cFF0000 bold.  On output, the font options selected/set in the
;   dialog are defined in the same format.
;
; Owner:
;
;   The p_Owner parameter is used to specify the owner of the FntCFDlg window.
;   Set to 0 for no owner.
;
;   For an AutoHotkey owner window, specify a valid GUI number (1-99), GUI name,
;   or handle to the window.  When the FntCFDlg window is created, the owner
;   window is disabled and ownership of the FntCFDlg window is assigned to the
;   owner window.  This makes makes the FntCFDlg window modal which prevents
;   the user from interacting with the owner window until the FntCFDlg window
;   is closed.
;
;   For a non-AutoHotkey owner window, specify the handle to the window.
;   Ownership is not assigned but the window's position and size is use to
;   position the FntCFDlg window.
;
;   If p_Owner is not specified or is set to the handle of a non-AutoHotkey
;   window, the AlwaysOnTop attribute is added to the FntCFDlg window to ensure
;   that the dialog is not lost.
;
;   For all owner windows, the FntCFDlg window is positioned in the center of
;   the owner window by default.
;
; Size Limits:
;
;   By default, the font size is not tested.  The user can enter whatever they
;   want in most cases.  The SizeMin and SizeMax options (r_Options parameter)
;   change that by ensuring the size is between a certain range of values.  In
;   addition, they also limit the sizes that are shown in the Size list box.
;
;   The SizeMin{MinimumPointSize} option sets the minimum point size the user
;   can enter/select.  Ex: SizeMin10.  If this option is specified without also
;   specifying the SizeMax option, the SizeMax value is automatically set to
;   the maximum point size - 0xBFFF (49151).
;
;   The SizeMax{MaximumPointSize} option sets the the maximum point size the
;   user can enter/select.  Ex: SizeMax72.  If this option is specified without
;   also specifying the SizeMin option, the SizeMin value is automatically set
;   to 0.
;
;   If the user enters a font size that is outside the boundaries set by the
;   SizeMin and SizeMax options, a MsgBox dialog is shown and the user is not
;   allowed to continue until a valid font size is entered/selected.  
;
;   Note: If the SizeMin value is greater than the SizeMax value, both size
;   limits are invalidated and no size limits are enforced.
;
; Status Bar:
;
;   The status bar is only shown if the p_Effects parameter contains the
;   CFD_STATUSBAR flag.  If the status bar is showing, the program will show the
;   current font name and font options in status bar and will update it when
;   changes are made.  The status bar is also available to the help handler.
;   See the example script for an example.
;
; Weight:
;
;   Weight is a font attribute that determines the thickness of the font
;   characters.  Internally it is defined as an integer from 1 to 1000.
;
;   Most fonts support two unique weights. The primary weight represents what
;   the font looks like by default (i.e normal).  For most fonts, the
;   normal/default font weight is 400.  The secondary weight represents what the
;   font looks like when the characters are emphasized (i.e. bold).  For most
;   fonts, the bold/heavy font weight is 700.
;
;   On input, the "bold" or "w"eight (Ex: "w600") options defined in the
;   r_Options variable (if any) determine if the Bold checkbox in the Style
;   group is automatically checked or not.  If the "bold" option or a weight of
;   700 or more is defined (Ex: "w800"), the Bold checkbox will be checked
;   when the dialog is shown.
;
;   On output, the actual weight of the font determines what weight options (if
;   any) are set in the r_Options variable.  If the font weight is exactly 400,
;   no weight options are added to the r_Options variable.  If the weight is
;   exactly 700, "bold" is added to the r_Options variable.  If the weight is
;   something other than 400 or 700, the "w"eight option is added to the
;   r_Options variable with the exact weight value.  Ex: "w200".
;
; Programming Notes:
;
;   When executed in an independent thread (Ex: Button, Click, Menu, etc.), the
;   GUIControl commands (Hide, Show, Focus, Font, etc.) don't work if the
;   control's variable name (Ex: FntCFDlg_MyEdit) is specified but they do work
;   if the control's handle (Ex: FntCFDlg_hMyEdit) is used.  Also note that
;   specifying the GUI name (Ex: GUIControl FntCFDlg:Font) for these commands is
;   superfluous when the control's handle is specified but the GUI name remains
;   for consistency.
;
;-------------------------------------------------------------------------------
Fnt_ChooseFontDlg(p_Owner:="",ByRef r_Name:="",ByRef r_Options:="",p_Effects:=True,p_Flags:=0,p_HelpHandler:="")
    {
    Static Dummy75458195
          ,s_MaximumSize:=0xBFFF

          ;-- Misc. constants
          ,SS_NOPREFIX   :=0x80
          ,SS_CENTERIMAGE:=0x200

          ;-- Effects flags
          ,CFD_ALL            :=0x1     ;-- Show all controls except the status bar
          ,CFD_ALLXCOLOR      :=0x2     ;-- Show all controls except Color and the status bar
          ,CFD_FUTURE1        :=0x4
          ,CFD_FUTURE2        :=0x8
          ,CFD_TYPEFACE       :=0x10    ;-- Show the Font Name combo box
          ,CFD_SIZE           :=0x20    ;-- Show the Size combo box
          ,CFD_STYLE          :=0x40    ;-- Show the Style group
          ,CFD_QUALITY        :=0x80    ;-- Show the Quality drop down list
          ,CFD_COLOR          :=0x100   ;-- Show the Color combo box
          ,CFD_SAMPLETEXT     :=0x200   ;-- Show the Sample Text group
          ,CFD_STATUSBAR      :=0x400   ;-- Show the status bar (debugging or help)
          ,CFD_FUTURE3        :=0x800
          ,CFD_DISABLETYPEFACE:=0x1000  ;-- Disable the Font Name combo box
          ,CFD_DISABLESIZE    :=0x2000  ;-- Disable the Size combo box
          ,CFD_DISABLESTYLE   :=0x4000  ;-- Disable the controls in the Style group
          ,CFD_DISABLEQUALITY :=0x8000  ;-- Disable the Quality drop down list
          ,CFD_DISABLECOLOR   :=0x10000 ;-- Disable the Color combo box

          ;-- ChooseFont flags
          ,CF_SCREENFONTS:=0x1
                ;-- List only the screen fonts supported by the system.  This
                ;   flag is not used by this function.

          ,CF_PRINTERFONTS:=0x2
                ;-- List only printer fonts.  Not supported by this libary.  Do
                ;   not use.

          ,CF_SHOWHELP:=0x4
                ;-- Causes the dialog box to display a Help button.

          ,CF_ENABLEHOOK:=0x8
                ;-- Enables the hook procedure specified in the lpfnHook member
                ;   of this structure.  Not supported by this library.  Do not
                ;   use.

          ,CF_ENABLETEMPLATE:=0x10
                ;-- Indicates that the hInstance and lpTemplateName members
                ;   specify a dialog box template to use in place of the default
                ;   template.  Not supported by this library.  Do not use.

          ,CF_ENABLETEMPLATEHANDLE:=0x20
                ;-- Indicates that the hInstance member identifies a data block
                ;   that contains a preloaded dialog box template.  The system
                ;   ignores the lpTemplateName member if this flag is specified.
                ;   Not supported by this library.  Do not use.

          ,CF_INITTOLOGFONTSTRUCT:=0x40
                ;-- Use the structure pointed to by the lpLogFont member to
                ;   initialize the dialog box controls.  This flag is not used
                ;   by this function.

          ,CF_USESTYLE:=0x80
                ;-- Not supported by this library.  Do not use.

          ,CF_EFFECTS:=0x100
                ;-- Causes the dialog box to display the controls that allow
                ;   the user to specify strikeout, underline, and text color
                ;   options.  This flag is not supported by this function but
                ;   much of the functionally that the flag supports in the
                ;   ChooseFont dialog is supported by the p_Effects parameter.
                ;   See the *Effects* section of the documentation for more
                ;   information.

          ,CF_APPLY:=0x200
                ;-- Causes the dialog box to display the Apply button.  Not
                ;   supported by this library.  Do not use.

          ,CF_SCRIPTSONLY:=0x400
                ;-- Prevent the dialog box from displaying or selecting OEM or
                ;   Symbol fonts.

          ,CF_NOOEMFONTS:=0x800
                ;-- Prevent the dialog box from displaying or selecting OEM
                ;   fonts.  Note: The CF_NOVECTORFONTS constant (not used here)
                ;   is set to the same value as this constant.

          ,CF_NOSIMULATIONS:=0x1000
                ;-- Prevent the dialog box from displaying or selecting font
                ;   simulations.  This flag is not supported by this function.
                ;   Do not use.

          ,CF_LIMITSIZE:=0x2000
                ;-- Select only font sizes within the range specified by the
                ;   nSizeMin and nSizeMax members.  This flag is automatically
                ;   added if the SizeMin and/or the SizeMax options (r_Options
                ;   parameter) are used.

          ,CF_FIXEDPITCHONLY:=0x4000
                ;-- Show and allow selection of only fixed-pitch fonts.

          ,CF_WYSIWYG:=0x8000
                ;-- Obsolete.  ChooseFont ignores this flag.  Not used by this
                ;   function.

          ,CF_FORCEFONTEXIST:=0x10000
                ;-- Display an error message if the user attempts to select a
                ;   font that is not listed in the dialog box.  Note: This 
                ;   restriction is only enforced if the font name combo box is
                ;   showing.

          ,CF_SCALABLEONLY:=0x20000
                ;-- Show and allow selection of only scalable fonts.  Scalable
                ;   fonts include vector fonts, scalable printer fonts, TrueType
                ;   fonts, and fonts scaled by other technologies.

          ,CF_TTONLY:=0x40000
                ;-- Show and allow the selection of only TrueType fonts.

          ,CF_NOFACESEL:=0x80000
                ;-- Prevent the dialog box from displaying an initial selection
                ;   for the font name combo box.

          ,CF_NOSTYLESEL:=0x100000
                ;   Prevents the dialog from displaying an initial selection of
                ;   of any options in the Style group (Bold, Italic, Underline,
                ;   and Strike).

          ,CF_NOSIZESEL:=0x200000
                ;-- Prevent the dialog box from displaying an initial selection
                ;   for the Font Size combo box.

          ,CF_SELECTSCRIPT:=0x400000
                ;-- When specified on input, only fonts with the character set
                ;   identified in the lfCharSet member of the LOGFONT structure
                ;   are displayed.  The user will not be allowed to change the
                ;   character set specified in the Scripts combo box.  Not
                ;   supported by this library.  Do not use.

          ,CF_NOSCRIPTSEL:=0x800000
                ;-- Disables the Script combo box.  This flag is not supported
                ;   by this function.  Do not use.

          ,CF_NOVERTFONTS:=0x1000000
                ;-- Display only horizontally oriented fonts.

          ,CF_INACTIVEFONTS:=0x2000000
                ;-- ChooseFont should additionally display fonts that are set to
                ;   Hide in Fonts Control Panel.  Windows 7+.  This flag is not
                ;   suppported by this function.  Do not use.

          ,CF_NOSYMBOLFONTS:=0x10000000
                ;-- [Custom Flag]  Exclude symbol fonts.

          ,CF_VARIABLEPITCHONLY:=0x20000000
                ;-- [Custom Flag]  Show variable pitch fonts only.

          ,CF_FUTURE01:=0x40000000
                ;-- [Custom Flag]  Future.

          ;-- ComboBox messages
          ,CB_GETCURSEL :=0x147
          ,CB_GETEDITSEL:=0x140
          ,CB_SETEDITSEL:=0x142
          ,CB_ERR:=-1

          ;-- Font weight
          ,FW_DONTCARE:=0
          ,FW_NORMAL  :=400
          ,FW_BOLD    :=700

          ;-- Device constants
          ,LOGPIXELSY:=90

    ;**************************
    ;*                        *
    ;*    Already showing?    *
    ;*                        *
    ;**************************
    ;-- Bounce (with prejudice) if an FntCFDlg window already showing
    gui FntCFDlg:+LastFoundExist
    IfWinExist
        {
        ;-- Bounce with prejudice
        outputdebug,
           (ltrim join`s
            Function: %A_ThisFunc% - A %A_ThisFunc% window already exists.
            This request has been aborted.
           )

        SoundPlay *-1  ;-- System default beep
        Return False
        }

    ;********************
    ;*                  *
    ;*    Initialize    *
    ;*                  *
    ;********************
    l_GUI:="FntCFDlg"   ;-- Static (for now)
    l_LastSelectedName:=""
	l_SampleText = Jackdaws love my big sphinx of quartz. 1234567890
    ;l_SampleText      :="AaBbYyZz 1234567890 !#$`%^&()*"  ;-=[]\;',./_+{}|:<>?~"
    l_WindowTextColor :=Fnt_GetWindowTextColor()
        ;-- The default window text color

    ;-- System information
    SysGet CXVSCROLL,2
        ;-- Width of a vertical scroll bar, in pixels

    ;************************
    ;*                      *
    ;*      Parameters      *
    ;*    (Set defaults)    *
    ;*                      *
    ;************************
    ;[=========]
    ;[  Owner  ]
    ;[=========]
    if p_Owner  ;-- Not null/zero
        {
        ;-- Assign to hOwner if p_Owner is a valid window handle
        hOwner:=WinExist("ahk_id " . p_Owner)

        ;-- Determine if p_Owner is a valid AutoHotkey window and if so,
        ;   identify the window handle.  Note: The Try command is used because
        ;   AutoHotkey will generate a run-time error if p_Owner is not a valid
        ;   GUI number (1 thru 99), a valid GUI name, or a window handle that is
        ;   not an AutoHotkey GUI.
        Try
            {
            gui %p_Owner%:+LastFoundExist
            IfWinExist
                {
                gui %p_Owner%:+LastFound
                hOwner:=WinExist()
                }
             else  ;-- GUI not found
                p_Owner:=0
            }
         Catch  ;-- Not an AutoHotkey GUI
            p_Owner:=0
        }

    ;[========]
    ;[  Name  ]
    ;[========]
    r_Name:=Trim(r_Name," `f`n`r`t`v")
        ;-- Remove all leading/trailing white space

    ;[=========]
    ;[  Flags  ]
    ;[=========]
    ;-- p_Effects
    if p_Effects is not Integer
        p_Effects:=True  ;-- Equivalent to CFD_ALL

    ;-- If the CFD_ALL (0x1) or CFD_ALLXCOLOR (0x2) flags are set, all flags
    ;   except CFD_STATUSBAR (and Color for CFD_ALLXCOLOR) are manually set
    ;   here.   This allows the program to only check for a specific flag
    ;   without also checking for the CFD_ALL (0x1) and CFD_ALLXCOLOR (0x2)
    ;   flags.
    if p_Effects & CFD_ALL
        p_Effects|=CFD_TYPEFACE|CFD_SIZE|CFD_STYLE|CFD_QUALITY|CFD_COLOR|CFD_SAMPLETEXT
            ;-- All "show" flags except CFD_STATUSBAR
    else if (p_Effects=0 or p_Effects & CFD_ALLXCOLOR)
        p_Effects|=CFD_TYPEFACE|CFD_SIZE|CFD_STYLE|CFD_QUALITY|CFD_SAMPLETEXT
            ;-- All "show" flags except CFD_COLOR and CFD_STATUSBAR

    ;-- p_Flags
    if p_Flags is not Integer
        p_Flags:=0x0

    p_Flags&=~CF_LIMITSIZE
        ;-- In case the developer manually set it for some reason

    if IsFunc(p_HelpHandler)
        p_Flags|=CF_SHOWHELP

    ;[===================]
    ;[  Options, Part 1  ]
    ;[  Extract/Process  ]
    ;[===================]
    ;-- Initialize
    o_Color    :=l_WindowTextColor
    o_Height   :=""             ;-- Undefined
    o_Italic   :=False
    o_Quality  :=2              ;-- AutoHotkey default
    o_Size     :=""             ;-- Undefined
    o_SizeMin  :=""             ;-- Undefined
    o_SizeMax  :=""             ;-- Undefined
    o_Strikeout:=False
    o_Underline:=False
    o_Weight   :=FW_DONTCARE

    ;-- Extract options from r_Options
    ;   Note: Options are processed in the order they are defined, i.e. from
    ;   left to right.  If an option is defined more than once, the last
    ;   occurrence of the option takes precedence.
    Loop Parse,r_Options,%A_Space%
        {
        if A_LoopField is Space
            Continue

        if (SubStr(A_LoopField,1,4)="bold")
            o_Weight:=1000  ;-- FW_BOLD
        else if (SubStr(A_LoopField,1,6)="italic")
            o_Italic:=True
        else if (SubStr(A_LoopField,1,7)="sizemin")
            o_SizeMin:=SubStr(A_LoopField,8)
        else if (SubStr(A_LoopField,1,7)="sizemax")
            o_SizeMax:=SubStr(A_LoopField,8)
        else if (SubStr(A_LoopField,1,6)="strike")
            o_Strikeout:=True
        else if (SubStr(A_LoopField,1,9)="underline")
            o_Underline:=True
        else if (SubStr(A_LoopField,1,1)="c")
            o_Color:=SubStr(A_LoopField,2)
        else if (SubStr(A_LoopField,1,1)="h")
            {
            o_Height:=SubStr(A_LoopField,2)
            o_Size  :=""  ;-- Undefined
            }
        else if (SubStr(A_LoopField,1,1)="q")
            o_Quality:=SubStr(A_LoopField,2)
        else if (SubStr(A_LoopField,1,1)="s")
            {
            o_Size  :=SubStr(A_LoopField,2)
            o_Height:=""  ;-- Undefined
            }
        else if (SubStr(A_LoopField,1,1)="w")
            o_Weight:=SubStr(A_LoopField,2)
        }

    ;[===========================]
    ;[      Options, Part 2      ]
    ;[  Post-Extract Processing  ]
    ;[===========================]
    ;-- If needed, set/reset parameters/options based on flag instructions
    if p_Flags & CF_NOFACESEL
        r_Name:=""

    if p_Flags & CF_NOSIZESEL
        o_Size:=""

    if p_Flags & CF_NOSTYLESEL
        {
        o_Weight   :=FW_DONTCARE
        o_Italic   :=False
        o_Strikeout:=False
        o_Underline:=False
        }

    ;--------------------------
    ;-- Convert or fix invalid
    ;-- or unspecified options
    ;--------------------------
    if o_Color is Space
        o_Color:=l_WindowTextColor

    if o_Height is not Integer
        o_Height:="" ;-- Undefined

    ;-- If needed, convert height to point size
    if o_Height is Integer
        {
        if (o_Height=0)
            o_Size:=0
         else if (o_Height>0)
            {
            ;-- Create a temporary font using the specified height.  Collect the
            ;   font size from the temporary font.
            ;
            ;   Note: This value is only accurate for the default typeface, i.e.
            ;   the value in r_Name.  Since it only the initial value for the
            ;   point size, it should suffice.
            hTempFont:=Fnt_CreateFont(r_Name,"h" . o_Height)
            o_Size   :=Fnt_GetFontSize(hTempFont)
            Fnt_DeleteFont(hTempFont)
            }
         else  ;-- Less than 0 (absolute value is em height)
            {
            ;-- Get the number of pixels per logical inch along the screen height
            hDC:=DllCall("CreateDC","Str","DISPLAY","Ptr",0,"Ptr",0,"Ptr",0)
            l_LogPixelsY:=DllCall("GetDeviceCaps","Ptr",hDC,"Int",LOGPIXELSY)
            DllCall("DeleteDC","Ptr",hDC)

            ;-- Convert em height to point size
            o_Size:=Round((Abs(o_Height)*72)/l_LogPixelsY)
            }
        }

    if o_Size is not Integer
        o_Size:=""   ;-- Undefined
     else
        if (o_Size<0)
            o_Size:=Abs(o_Size)

    if o_SizeMin is not Integer
        o_SizeMin:=""  ;-- Undefined

    if o_SizeMax is not Integer
        o_SizeMax:=""  ;-- Undefined

    if o_SizeMin is Integer
        if o_SizeMax is not Integer
            o_SizeMax:=s_MaximumSize+0

    if o_SizeMax is Integer
        {
        if (o_SizeMax>s_MaximumSize)
            o_SizeMax:=s_MaximumSize+0

        if o_SizeMin is not Integer
            o_SizeMin:=0
        }

    if o_SizeMin is Integer
        if (o_SizeMin>o_SizeMax)
            {
            o_SizeMin:=""  ;-- Undefined
            o_SizeMax:=""  ;-- Undefined
            outputdebug Function: %A_ThisFunc% - SizeMin>SizeMax. No size limit set.
            }

    if o_Weight is not Integer
        o_Weight:=FW_DONTCARE

    ;[================]
    ;[  Update flags  ]
    ;[================]
    if o_SizeMin is Integer
        p_Flags|=CF_LIMITSIZE

    ;***********************
    ;*                     *
    ;*    Pre-Build GUI    *
    ;*                     *
    ;***********************
    hMessageFont  :=Fnt_CreateMessageFont()
    l_MessageFontH:=FntCFDlg_StyleH:=Fnt_GetFontHeight(hMessageFont)

    ;-- Set default margins (needed for many calculations)
    Fnt_GetDefaultGUIMargins(hMessageFont,l_MarginX,l_MarginY,False)
    l_MarginY:=l_MarginX

    ;-- Calulate commonly-used values
    l_QualityPosW:=Fnt_GetStringWidth(hMessageFont,"Non-Antialiasedxi")+CXVSCROLL
    l_ButtonW    :=Fnt_GetStringWidth(hMessageFont,"Cancelxxxxx")
    l_ButtonGapW :=9

    ;-- Initialize tooltip
    AddTooltip("AutoPopDelay",32)

    ;[===============]
    ;[  Build lists  ]
    ;[===============]
    l_ListOfFontNames:=Fnt_GetListOfFonts("","",p_Flags&0xFFFFFFF0)  ;-- All but the first 4 bits
    if l_ListOfFontNames is Space
        l_NumberOfFonts:=0
      else
        {
        StringReplace l_ListOfFontNames,l_ListOfFontNames,`n,|,UseErrorLevel
        l_NumberOfFonts:=ErrorLevel+1
        }

    l_ListOfFontSizes:="6|7|8|9|10|11|12|14|16|18|20|22|24|26|36|48|72"

    if p_Flags & CF_LIMITSIZE
        {
        ;-- Rebuild the list of font sizes to only include sizes within the
        ;   SizeMin and SizeMax limits
        l_TempList:=l_ListOfFontSizes
        l_ListOfFontSizes:=""
        Loop Parse,l_TempList,|
            if (A_LoopField>=o_SizeMin and A_LoopField<=o_SizeMax)
                l_ListOfFontSizes.=(StrLen(l_ListOfFontSizes) ? "|":"") . A_LoopField
        }

    l_ListOfFontQualities=
       (ltrim join|
        Default
        Draft
        Proof
        Non-Antialiased
        Antialiased
        ClearType
       )

    l_ListOfColorNames=
       (ltrim join|
        Aqua
        Black
        Blue
        Fuchsia
        Gray
        Green
        Lime
        Maroon
        Navy
        Olive
        Purple
        Red
        Silver
        Teal
        White
        Yellow
       )

    ;*******************
    ;*                 *
    ;*    Build GUI    *
    ;*                 *
    ;*******************
    ;-- Assign ownership
    ;   Note: Ownership commands must be performed before any other GUI commands
    if p_Owner
        {
        gui %p_Owner%:+Disabled       ;-- Disable Owner window
        gui FntCFDlg:+Owner%p_Owner%  ;-- Set ownership
        }
     else
        gui FntCFDlg:+Owner           ;-- Give ownership to the script window

    ;[===============]
    ;[  GUI options  ]
    ;[===============]
    gui FntCFDlg:-DPIScale +hWndhFntCFDlg +LabelFntCFDlg_ -MinimizeBox
    gui FntCFDlg:Margin,%l_MarginX%,%l_MarginY%
    if not p_Owner
        gui FntCFDlg:+AlwaysOnTop

    gui FntCFDlg:Font,% Fnt_GetMessageFontOptions(),% Fnt_GetMessageFontName()

    ;[===============]
    ;[  GUI objects  ]
    ;[===============]
    ;-------------
    ;-- Font Name
    ;-------------
    if p_Effects & CFD_TYPEFACE
        {
        gui FntCFDlg:Add,Text,xm,Font:

        Static FntCFDlg_FontName
        gui FntCFDlg:Add
           ,Combobox
           ,% ""
                . "xm y+2 r8 "
                . "w" . Fnt_GetFontAvgCharWidth(hMessageFont)*26 . A_Space
                . "Simple "
                . "hWndFntCFDlg_hFontName "
                . "vFntCFDlg_FontName "
                . "gFntCFDlg_FontNameAction"
           ,%l_ListOfFontNames%

        ;-- Select name
        if r_Name is not Space
            if InStr("|" . l_ListOfFontNames . "|","|" . r_Name . "|")
                {
                GUIControl FntCFDlg:ChooseString,FntCFDlg_FontName,%r_Name%
                l_LastSelectedName:=r_Name
                }

        ;-- Get the current position and size of the control
        GUIControlGet FntCFDlg_FontNamePos,FntCFDlg:Pos,FntCFDlg_FontName

        ;-- Disable?
        if p_Effects & CFD_DISABLETYPEFACE
            GUIControl FntCFDlg:Disable,FntCFDlg_FontName
        }
     else  ;-- No FontName combo box
        {
        ;-- Set FntCFDlg_FontName
        ;   Note: The FntCFDlg_FontName variable is used internally to represent
        ;   the current font name.  If the FontName combo box is not shown, then
        ;   the value provided by the developer (r_Name parameter) will be used
        ;   when needed.
        FntCFDlg_FontName:=r_Name
        }

    ;--------
    ;-- Size
    ;--------
    if p_Effects & CFD_SIZE
        {
        gui FntCFDlg:Add,Text,ym,Size:

        Static FntCFDlg_Size
        gui FntCFDlg:Add
           ,Combobox
           ,% ""
                . "xp y+2 "
                . "w" . Fnt_GetStringWidth(hMessageFont,"888xxi")+CXVSCROLL . A_Space
                . "r8 "
                . "Simple "
                . "hWndFntCFDlg_hSize "
                . "vFntCFDlg_Size "
                . "gFntCFDlg_SizeAction"
           ,%l_ListOfFontSizes%

        if o_Size is not Space
            if InStr("|" . l_ListOfFontSizes . "|","|" . o_Size . "|")
                GUIControl FntCFDlg:ChooseString,FntCFDlg_Size,%o_Size%
             else
                GUIControl FntCFDlg:Text,FntCFDlg_Size,%o_Size%

        ;-- Get the current position and size of the control
        GUIControlGet FntCFDlg_SizePos,FntCFDlg:Pos,FntCFDlg_Size

        ;-- Disable?
        if p_Effects & CFD_DISABLESIZE
            GUIControl FntCFDlg:Disable,FntCFDlg_Size
        }

    ;---------
    ;-- Style
    ;---------
    if p_Effects & CFD_STYLE
        {
        if p_Effects & CFD_QUALITY
            l_StyleGBPosW:=l_QualityPosW
         else
            {
            SysGet CXMENUCHECK,71
                ;-- Width of the default menu check-mark bitmap, in pixels

            l_StyleGBPosW:=CXMENUCHECK+Fnt_GetStringWidth(hMessageFont,"Underline")+(l_MarginX*2)+1
            }

        Static FntCFDlg_StyleGB
        gui FntCFDlg:Add
           ,GroupBox
           ,% ""
                . "x237 y12 "
                . "w" . l_StyleGBPosW . A_Space
                . "h" . FntCFDlg_StyleH . A_Space
                . "Section "
                . "vFntCFDlg_StyleGB "
           ,Style:

        Static FntCFDlg_Bold
        gui FntCFDlg:Add
           ,CheckBox
           ,% ""
                . "xp+" . l_MarginX . A_Space
                . "yp+" . l_MessageFontH+5 . A_Space
                . "vFntCFDlg_Bold "
                . "gFntCFDlg_SetSampleTextFont "
            ,Bold

        if (o_Weight>=700)
            GUIControl,FntCFDlg:,FntCFDlg_Bold,1

        Static FntCFDlg_Italic
        gui FntCFDlg:Add
           ,CheckBox
           ,% ""
                . "xp y+10 "
                . "vFntCFDlg_Italic "
                . "gFntCFDlg_SetSampleTextFont "
           ,Italic

        if o_Italic
            GUIControl,FntCFDlg:,FntCFDlg_Italic,1

        Static FntCFDlg_Underline
        gui FntCFDlg:Add
           ,CheckBox
           ,% ""
                . "xp y+10 "
                . "vFntCFDlg_Underline "
                . "gFntCFDlg_SetSampleTextFont "
           ,Underline

        if o_Underline
            GUIControl,FntCFDlg:,FntCFDlg_Underline,1

        Static FntCFDlg_Strikeout
        gui FntCFDlg:Add
           ,CheckBox
           ,% ""
                . "xp y+10 "
                . "vFntCFDlg_Strikeout "
                . "gFntCFDlg_SetSampleTextFont "
           ,Strikeout

        if o_Strikeout
            GUIControl,FntCFDlg:,FntCFDlg_Strikeout,1

        ;-- Set the height of the Style group box
        GUIControlGet FntCFDlg_StyleGBPos,FntCFDlg:Pos,FntCFDlg_StyleGB
        GUIControlGet FntCFDlg_StrikeoutPos,FntCFDlg:Pos,FntCFDlg_Strikeout
        GUIControl
            ,FntCFDlg:Move
            ,FntCFDlg_StyleGB
            ,% "h" . (FntCFDlg_StrikeoutPosY-FntCFDlg_StyleGBPosY)+FntCFDlg_StrikeoutPosH+l_MarginY

        if not (p_Effects & CFD_QUALITY)
            {
            FntCFDlg_PrevCtrlPosH:=0
            if p_Effects & CFD_TYPEFACE
                FntCFDlg_PrevCtrlPosH:=FntCFDlg_FontNamePosH
             else if p_Effects & CFD_SIZE
                FntCFDlg_PrevCtrlPosH:=FntCFDlg_SizePosH

            if FntCFDlg_PrevCtrlPosH
                {
                FntCFDlg_PrevCtrlPosH+=l_MessageFontH+2
                GUIControl
                    ,FntCFDlg:Move
                    ,FntCFDlg_StyleGB
                    ,% "h" . FntCFDlg_PrevCtrlPosH
                }
            }

        ;-- Recollect the position and size of the Style group box
        GUIControlGet FntCFDlg_StyleGBPos,FntCFDlg:Pos,FntCFDlg_StyleGB

        ;-- Disable the controls in the group?
        if p_Effects & CFD_DISABLESTYLE
            {
            GUIControl FntCFDlg:Disable,FntCFDlg_Bold
            GUIControl FntCFDlg:Disable,FntCFDlg_Italic
            GUIControl FntCFDlg:Disable,FntCFDlg_Underline
            GUIControl FntCFDlg:Disable,FntCFDlg_Strikeout
            }
        }

    ;-----------
    ;-- Quality
    ;-----------
    if p_Effects & CFD_QUALITY
        {
        Static FntCFDlg_QualityPrompt
        gui FntCFDlg:Add
           ,Text
           ,% ""
                . (p_Effects & CFD_Style ? "xs":"") . A_Space
                . (p_Effects & CFD_Style ? "y" . FntCFDlg_StyleGBPosY+FntCFDlg_StyleGBPosH+l_MarginY:"ym") . A_Space
                . "vFntCFDlg_QualityPrompt "
           ,Quality:

        Static FntCFDlg_Quality
        gui FntCFDlg:Add
           ,% (p_Effects & CFD_STYLE ? "DDL":"ListBox")
           ,% ""
                . "xp y+2 "
                . "r6 "
                . "w" . l_QualityPosW . A_Space
                . "AltSubmit "
                . "vFntCFDlg_Quality "
                . "gFntCFDlg_QualityAction"
           ,%l_ListOfFontQualities%

        if o_Quality is Integer
            GUIControl FntCFDlg:Choose,FntCFDlg_Quality,% o_Quality+1
         else
            GUIControl FntCFDlg:Choose,FntCFDlg_Quality,3   ;-- 3=Quality 2 (Proof, the AutoHotkey default)

        ;-- Reposition Quality
         if (p_Effects & CFD_STYLE)
        and (p_Effects & CFD_TYPEFACE or p_Effects & CFD_SIZE)
            {
            GUIControlGet FntCFDlg_QualityPromptPos,FntCFDlg:Pos,FntCFDlg_QualityPrompt
            GUIControlGet FntCFDlg_QualityPos,FntCFDlg:Pos,FntCFDlg_Quality

            if p_Effects & CFD_SIZE
                GUIControlGet FntCFDlg_PrevCtrlPos,FntCFDlg:Pos,FntCFDlg_Size
             else
                GUIControlGet FntCFDlg_PrevCtrlPos,FntCFDlg:Pos,FntCFDlg_FontName

            YDiff:=(FntCFDlg_PrevCtrlPosY+FntCFDlg_PrevCtrlPosH)-(FntCFDlg_QualityPosY+FntCFDlg_QualityPosH)
            GUIControl FntCFDlg:Move,FntCFDlg_QualityPrompt,% "y" . FntCFDlg_QualityPromptPosY+YDiff
            GUIControl FntCFDlg:Move,FntCFDlg_Quality,% "y" . FntCFDlg_QualityPosY+YDiff
            }

        ;-- Collect the current position and size of the control
        GUIControlGet FntCFDlg_QualityPos,FntCFDlg:Pos,FntCFDlg_Quality

        ;-- Disable?
        if p_Effects & CFD_DISABLEQUALITY
            GUIControl FntCFDlg:Disable,FntCFDlg_Quality
        }

    ;---------
    ;-- Color
    ;---------
    if p_Effects & CFD_COLOR
        {
        gui FntCFDlg:Add,Text,ym,Color:

        Static FntCFDlg_Color
        gui FntCFDlg:Add
           ,Combobox
           ,% ""
                . "xp y+2 "
                . "w" . Fnt_GetStringWidth(hMessageFont,"Maroonxxx")+CXVSCROLL . A_Space
                . "r7 "
                . "Simple "
                . "hWndFntCFDlg_hColor "
                . "vFntCFDlg_Color "
                . "gFntCFDlg_ColorAction "
           ,%l_ListOfColorNames%

        ;-- Convert to a color name if a match is found
        o_Color:=Fnt_Color2ColorName(o_Color,True)

        ;-- Select color name or set color value
        if InStr("|" . l_ListOfColorNames . "|","|" . o_Color . "|")
            GUIControl FntCFDlg:ChooseString,FntCFDlg_Color,%o_Color%
         else
            {
            /*
                Note: At this point, the color value is not modified.  It is
                only modified later if a color is selected from the list or if
                a custom color is selected.
            */
            GUIControl FntCFDlg:Text,FntCFDlg_Color,%o_Color%
            }

        ;-- Get the current position and size of the control
        GUIControlGet FntCFDlg_ColorPos,FntCFDlg:Pos,FntCFDlg_Color

        ;-- Determine the height of the ColorLV control
        FntCFDlg_PrevCtrlPosH:=0
        if p_Effects & CFD_TYPEFACE
            FntCFDlg_PrevCtrlPosH:=FntCFDlg_FontNamePosH
         else if p_Effects & CFD_SIZE
            FntCFDlg_PrevCtrlPosH:=FntCFDlg_SizePosH

        if FntCFDlg_PrevCtrlPosH
            l_ColorLVPosH:=FntCFDlg_PrevCtrlPosH-FntCFDlg_ColorPosH
         else
            l_ColorLVPosH:=l_MessageFontH

        Static FntCFDlg_ColorLV
        gui FntCFDlg:Add
           ,ListView
           ,% ""
                . "xp y+0 wp "
                . "h" . l_ColorLVPosH . A_Space
                . "+AltSubmit "
                . "-Hdr "
                . "+Background" . Fnt_GetSysColor(20) . A_Space
                        ; -- 20=COLOR_3DHIGHLIGHT
                . "-Tabstop "
                . "hWndFntCFDlg_hColorLV "
                . "vFntCFDlg_ColorLV "
                . "gFntCFDlg_ColorLVAction "

        ;-- Disable?
        ;   Note: The Color ComboBox is disabled if requested but the associated
        ;   Color ListView control is not disabled because when disabled, the
        ;   color is muted.
        if p_Effects & CFD_DISABLECOLOR
            GUIControl FntCFDlg:Disable,FntCFDlg_Color
         else
            AddTooltip(FntCFDlg_hColorLV,"Click here to choose a custom color")
        }

    ;-- Calculate the total width of all GUI controls that are showing at this
    ;   point, including the gap in between each control.
    ;
    ;   Note: This could also be accomplished by rendering the window at this
    ;   point, i.e. "gui Show" and then calculating the value based on the width
    ;   of the window's client but since all of the information is avaiable, it
    ;   is calculated here.
    ;
    l_TotalW:=0
    if p_Effects & CFD_TYPEFACE
        l_TotalW+=FntCFDlg_FontNamePosW

    if p_Effects & CFD_SIZE
        {
        if l_TotalW
            l_TotalW+=l_MarginX

        l_TotalW+=FntCFDlg_SizePosW
        }

    if p_Effects & CFD_STYLE
        {
        if l_TotalW
            l_TotalW+=l_MarginX

        l_TotalW+=FntCFDlg_StyleGBPosW
        }
    else if p_Effects & CFD_QUALITY
        {
        if l_TotalW
            l_TotalW+=l_MarginX

        l_TotalW+=FntCFDlg_QualityPosW
        }

    if p_Effects & CFD_COLOR
        {
        if l_TotalW
            l_TotalW+=l_MarginX

        l_TotalW+=FntCFDlg_ColorPosW
        }

    l_MinimumW:=(l_ButtonW*2)+l_ButtonGapW
    if p_Flags & CF_SHOWHELP
        l_MinimumW+=l_ButtonW+(l_ButtonGapW*4)

    if (l_TotalW<l_MinimumW)
        l_TotalW:=l_MinimumW

    ;---------------
    ;-- Sample Text
    ;---------------
    if p_Effects & CFD_SAMPLETEXT
        {
        gui FntCFDlg:Add
           ,GroupBox
           ,% ""
                . "xm "
                . "w" . l_TotalW . A_Space
                . "h100 "  ;-- Arbitrary height (for now)
           ,Sample

        Static FntCFDlg_SampleText
        gui FntCFDlg:Add
           ,Text
           ,% ""
                . "xp+1 "
                . "yp+" . l_MessageFontH . A_Space
                . "w" . l_TotalW-2 . A_Space
                . "hp-" . l_MessageFontH+2 . A_Space
                . "+Center "
                . SS_NOPREFIX . A_Space
                . SS_CENTERIMAGE . A_Space
                . "hWndFntCFDlg_hSampleText "
                . "vFntCFDlg_SampleText "

        ;-- Get the current position and size of the control
        GUIControlGet FntCFDlg_SampleTextPos,FntCFDlg:Pos,FntCFDlg_SampleText
        }

    ;[===========]
    ;[  Buttons  ]
    ;[===========]
    if p_Flags & CF_SHOWHELP
        {
        l_ButtonX:=(l_TotalW+l_MarginX)-((l_ButtonW*3)+(l_ButtonGapW*5))
        gui FntCFDlg:Add
           ,Button
           ,% ""
                . "xm "
                . "x" . l_ButtonX . A_Space
                . "w" . l_ButtonW . A_Space
                . "gFntCFDlg_Help "
           ,Help
        }

    l_ButtonX:=(l_TotalW+l_MarginX)-((l_ButtonW*2)+l_ButtonGapW)
    gui FntCFDlg:Add
       ,Button
       ,% ""
            . ((p_Flags & CF_SHOWHELP) ? "x+" . l_ButtonGapW*4:"xm x" . l_ButtonX) . A_Space
            . "w" . l_ButtonW . A_Space
            . "Default "
            . "gFntCFDlg_Accept "
       ,OK

    gui FntCFDlg:Add
       ,Button
       ,% ""
            . "x+" . l_ButtonGapW . A_Space
            . "wp "
            . "gFntCFDlg_Cancel "
       ,Cancel

    ;-- Set the font to the AutoHotkey default
    gui FntCFDlg:Font

    ;[==============]
    ;[  Status bar  ]
    ;[==============]
    hSB:=0
    if p_Effects & CFD_STATUSBAR
        {
        Static FntCFDlg_StatusBar
        gui FntCFDlg:Font,% Fnt_GetStatusFontOptions(),% Fnt_GetStatusFontName()
        gui FntCFDlg:Add,StatusBar,hWndhSB
        gui FntCFDlg:Font
        }

    ;-- Set the initial sample text font and color
    ;   Note: These steps are performed before the window is shown to reduce
    ;   flicker.  The color on the ListView control is set after the window is
    ;   shown for other reasons.
    gosub FntCFDlg_SetSampleTextFont
    if p_Effects & CFD_Color
        gosub FntCFDlg_SetSampleTextColor

    ;**************
    ;*            *
    ;*    Show    *
    ;*            *
    ;**************
    ;-- Render but do not show
    gui FntCFDlg:Show,Hide,Font Configuration

    ;-- Position and show
    if hOwner
        {
        ;-- Position window
        ;   Note: By default, the window is positioned in the middle of the
        ;   owner window.
        MoveChildWindow(hOwner,hFntCFDlg,"Show")
        }
     else
        gui FntCFDlg:Show

    ;-- Set the color
    ;   Note: This is performed after the window is shown because of an odd
    ;   characteristic of the ListView control.  The inner border color of the
    ;   control is permanently set to whatever color it was last set to before
    ;   the window is shown.  Setting the control's color to the font color
    ;   after the window is shown will ensure that the inner border color of
    ;   the control will remain the same color it was set to when the control
    ;   was created.
    if p_Effects & CFD_COLOR
        gosub FntCFDlg_SetColor

    ;[=====================]
    ;[  Loop until window  ]
    ;[      is closed      ]
    ;[=====================]
    WinWaitClose ahk_id %hFntCFDlg%
    Return l_RC  ;-- End of function


    ;*****************************
    ;*                           *
    ;*                           *
    ;*        Subroutines        *
    ;*         (FntCFDlg)        *
    ;*                           *
    ;*                           *
    ;*****************************
    FntCFDlg_Accept:
    gui FntCFDlg:Submit,NoHide

    ;-- Trim
    gosub FntCFDlg_TrimFields

    ;-- Integrity tests
    if p_Effects & CFD_TYPEFACE
        if p_Flags & CF_FORCEFONTEXIST
            {
            SendMessage CB_GETCURSEL,0,0,,ahk_id %FntCFDlg_hFontName%
            if (ErrorLevel<<32>>32=CB_ERR)  ;-- No item on list selected
                {
                gui +OwnDialogs
                MsgBox
                    ,0x30
                    ,Invalid Font Name,
                       (ltrim join`s
                        There is no font with that name. Choose a font from the
                        list of fonts.
                       )

                return
                }
            }

    if p_Effects & CFD_SIZE
        {
        if StrLen(FntCFDlg_Size)
            {
            if FntCFDlg_Size is not Integer
                {
                gui +OwnDialogs
                MsgBox 0x30,Invalid Size,Size must be a number.
                return
                }
            }

        if p_Flags & CF_LIMITSIZE
            if FntCFDlg_Size not Between %o_SizeMin% and %o_SizeMax%
                {
                gui +OwnDialogs
                MsgBox
                    ,0x30
                    ,Invalid Size
                    ,Size must be between %o_SizeMin% and %o_SizeMax% points.
                return
                }
        }

    ;-- Build options
    gosub FntCFDlg_BuildOptions

    ;-- Update output variables
    if p_Effects & CFD_TYPEFACE
        r_Name:=l_LastSelectedName

    r_Options:=l_FontOptions

    ;-- We're done.  Shut it down
    l_RC:=True
    gosub FntCFDlg_Exit
    return


    FntCFDlg_BuildOptions:   ;-- Assume gui Submit,NoHide has been performed
    l_FontOptions:=""

    ;-- Size
    if p_Effects & CFD_SIZE
        {
        if FntCFDlg_Size is Integer
            l_FontOptions.="s" . FntCFDlg_Size
         else
            {
            ;-- Build a temporary font to collect/set the default font size
            ;   Note: This matches the behavior of the ChooseFont API function
            ;   when no font size is specified in the dialog.  It does not match the
            ;   behavior of the <Fnt_CreateFont> function when no "s"ize option
            ;   is specified.  Since this dialog is designed to emulate the
            ;   ChooseFont dialog, this behavior was selected.
            hTempFont:=Fnt_CreateFont(FntCFDlg_FontName,"s0")
            l_FontOptions.="s" . Fnt_GetFontSize(hTempFont)
            Fnt_DeleteFont(hTempFont)
            }
        }

    ;-- Color
    if p_Effects & CFD_COLOR
        {
        if FntCFDlg_Color is Space
            l_FontOptions.=A_Space . "cDefault"
         else
            {
            if FntCFDlg_Color is not xDigit
                {
                if (Fnt_ColorName2RGB(FntCFDlg_Color)=l_WindowTextColor)
                    FntCFDlg_Color:="Default"

                ;-- Note: This step will convert the color to "Default" if
                ;   the color is equal to the default text color.  This is
                ;   only done if the color is a color name (Ex: "Blue").  It not done when
                ;   the color is a hexadecimal value (Ex: "0000FF" or
                ;   "0xFF")
                }

            l_FontOptions.=A_Space . "c" . FntCFDlg_Color
            }
        }

    ;-- Styles
    if p_Effects & CFD_STYLE
        {
        if FntCFDlg_Bold
            l_FontOptions.=A_Space . "bold"
        else
            l_FontOptions.=A_Space . "w0"  ;-- just a place holder (for now)

        if FntCFDlg_Italic
            l_FontOptions.=A_Space . "italic"

        if FntCFDlg_Underline
            l_FontOptions.=A_Space . "underline"

        if FntCFDlg_Strikeout
            l_FontOptions.=A_Space . "strike"

        ;-- Build a temporary font to collect/set the font weight
        ;   Note: The quality is not set at this point but it does not affect
        ;   the font weight
        hTempFont:=Fnt_CreateFont(FntCFDlg_FontName,l_FontOptions)
        l_Weight :=Fnt_GetFontWeight(hTempFont)
        Fnt_DeleteFont(hTempFont)
        if (l_Weight=400)
            Fnt_FORemoveWeight(l_FontOptions)
         else
            if (l_Weight=700)
                {
                if (Fnt_FOGetWeight(l_FontOptions)<>700)
                    Fnt_FOSetWeight(l_FontOptions,700)
                }
             else
                Fnt_FOSetWeight(l_FontOptions,l_Weight)
        }

    ;-- Quality
    if p_Effects & CFD_QUALITY
        if (FntCFDlg_Quality-1<>2)
            l_FontOptions.=A_Space . "q" . FntCFDlg_Quality-1

    l_FontOptions:=Trim(l_FontOptions)
    return


    FntCFDlg_ColorAction:
    gui FntCFDlg:Submit,NoHide

    ;-- Note: Although leading and trailing spaces are not appropriate, the
    ;   Color field is not trimmed here because it can generate confusing
    ;   results because trimming may cause the color to be reselected.  Don't
    ;   worry, the Color field is trimmed before the font is created and before
    ;   the color is returned to the calling function.

    SendMessage CB_GETCURSEL,0,0,,ahk_id %FntCFDlg_hColor%
    if (ErrorLevel<<32>>32=CB_ERR)  ;-- No item on list selected
        {
        if InStr("|" . l_ListOfColorNames . "|","|" . FntCFDlg_Color . "|")  ;-- Color name in the list
            {
            ;-- Get current select positions
            SendMessage CB_GETEDITSEL,0,0,,ahk_id %FntCFDlg_hColor%
            l_SelPos:=ErrorLevel

            ;-- Select the color from the list
            GUIControl FntCFDlg:ChooseString,%FntCFDlg_hColor%,%FntCFDlg_Color%

            ;-- Reset select positions
            SendMessage CB_SETEDITSEL,0,l_SelPos,,ahk_id %FntCFDlg_hColor%
            }
        }

    gosub FntCFDlg_SetColor
    return


    FntCFDlg_ColorLVAction:

    ;-- Bounce if anything other than a single click
    if (A_GUIEvent<>"Normal")
        return

    ;-- Bounce if the Color combo box is disabled
    if p_Effects & CFD_DISABLECOLOR
        return

    gui FntCFDlg:Submit,NoHide

    ;-- Convert to RGB integer if needed
    FntCFDlg_Color:=Fnt_Color2RGB(FntCFDlg_Color)

    ;-- Prompt for color.  Bounce if canceled
    if not Fnt_ChooseFontDlg_ChooseColor(hFntCFDlg,FntCFDlg_Color)
        return

    FntCFDlg_Color:=Fnt_RGB2ColorName(FntCFDlg_Color)
    if InStr("|" . l_ListOfColorNames . "|","|" . FntCFDlg_Color . "|")
        GUIControl FntCFDlg:ChooseString,%FntCFDlg_hColor%,%FntCFDlg_Color%
     else
        {
        GUIControl FntCFDlg:Choose,%FntCFDlg_hColor%,0  ;-- Unselect if anything was selected
        FntCFDlg_Color:=SubStr(FntCFDlg_Color,3)
        GUIControl FntCFDlg:Text,%FntCFDlg_hColor%,%FntCFDlg_Color%
        }

    gosub FntCFDlg_SetColor
    return


    FntCFDlg_Help:
    if IsFunc(p_HelpHandler)
        {
        EO:=Object()

        ;-- Update form and build options
        gui FntCFDlg:Submit,NoHide
        gosub FntCFDlg_TrimFields
        gosub FntCFDlg_BuildOptions

        ;-- General properties
        EO.Effects    :=p_Effects
        EO.Event      :="Help"
        EO.Flags      :=p_Flags
        EO.FontName   :=FntCFDlg_FontName
        EO.FontOptions:=l_FontOptions
        EO.GUI        :=l_GUI
        EO.hDlg       :=hFntCFDlg
        EO.hSB        :=hSB

        ;-- Call add-on function.  Note: Return value is ignored.
        %p_HelpHandler%(EO)

        ;-- Release event object
        EO:=""
        }

    return


    FntCFDlg_FontNameAction:
    gui FntCFDlg:Submit,NoHide

    ;-- Note: The font name is not trimmed here because it can cause confusion
    ;   (and inappropriate action) if the user is adding a space to the end of
    ;   the name.  Ex: 'Arial" changed to "Arial Black".

    SendMessage CB_GETCURSEL,0,0,,ahk_id %FntCFDlg_hFontName%
    if (ErrorLevel<<32>>32=CB_ERR)  ;-- No item on list selected
        {
        if InStr("|" . l_ListOfFontNames . "|","|" . FntCFDlg_FontName . "|")  ;-- Found name
            {
            ;-- Get current select positions
            SendMessage CB_GETEDITSEL,0,0,,ahk_id %FntCFDlg_hFontName%
            l_SelPos:=ErrorLevel

            ;-- Select the name from the list
            GUIControl FntCFDlg:ChooseString,%FntCFDlg_hFontName%,%FntCFDlg_FontName%
            l_LastSelectedName:=FntCFDlg_FontName

            ;-- Reset select positions
            SendMessage CB_SETEDITSEL,0,l_SelPos,,ahk_id %FntCFDlg_hFontName%

            ;-- Update sample text
            gosub FntCFDlg_SetSampleTextFont
            }
        }
     else  ;-- Name is selected
        {
        l_LastSelectedName:=FntCFDlg_FontName
        gosub FntCFDlg_SetSampleTextFont
        }

    return


    FntCFDlg_QualityAction:
    gosub FntCFDlg_SetSampleTextFont
    return


    FntCFDlg_SetColor:

    ;-- Build options
    gui FntCFDlg:Submit,NoHide
    gosub FntCFDlg_TrimFields
    gosub FntCFDlg_BuildOptions

    ;-- Update FntCFDlg_ColorLV
    ;   Note: This subroutine is only run if the Color combo box is showing so
    ;   checking for the CFD_COLOR flag is redundant.
    GUIControl % "FntCFDlg:+Background" . Fnt_Color2RGB(FntCFDlg_Color),%FntCFDlg_hColorLV%

    ;-- Update the sample text color
    if p_Effects & CFD_SAMPLETEXT
        gosub FntCFDlg_SetSampleTextColor

    ;-- Update the status bar
    if p_Effects & CFD_STATUSBAR
        Fnt_ChooseFontDlg_SBSetText(hSB,FntCFDlg_FontName . (l_FontOptions ? ", " . l_FontOptions:""))

    return


    FntCFDlg_SetSampleTextColor:
    ;-- Note: This subroutine uses the color defined in FntCFDlg_Color
    if FntCFDlg_Color is Space
        FntCFDlg_Color:="Default"

    GUIControl +c%FntCFDlg_Color%,%FntCFDlg_hSampleText%
    GUIControl +Redraw,%FntCFDlg_hSampleText%
    return


    FntCFDlg_SetSampleTextFont:

    ;-- Bounce if neither the sample text group or status bar is showing
    if not (p_Effects & CFD_SAMPLETEXT or p_Effects & CFD_STATUSBAR)
        return

    ;-- Build options
    gui FntCFDlg:Submit,NoHide
    gosub FntCFDlg_TrimFields
    gosub FntCFDlg_BuildOptions

    ;-- Set/Update the sample text
    if p_Effects & CFD_SAMPLETEXT
        {
        hFont_old:=hFont
        hFont:=Fnt_CreateFont(FntCFDlg_FontName,l_FontOptions)
        GUIControl
            ,FntCFDlg:
            ,%FntCFDlg_hSampleText%
            ,% Fnt_TruncateStringToFit(hFont,l_SampleText,FntCFDlg_SampleTextPosW)

        Fnt_SetFont(FntCFDlg_hSampleText,hFont,True)
        Fnt_DeleteFont(hFont_old)
        }

    ;-- Update the status bar
    if p_Effects & CFD_STATUSBAR
        Fnt_ChooseFontDlg_SBSetText(hSB,FntCFDlg_FontName . (l_FontOptions ? ", " . l_FontOptions:""))

    return


    FntCFDlg_SizeAction:
    gui FntCFDlg:Submit,NoHide
    SendMessage CB_GETCURSEL,0,0,,ahk_id %FntCFDlg_hSize%
    if (ErrorLevel<<32>>32=CB_ERR)  ;-- No item on list selected
        {
        if InStr("|" . l_ListOfFontSizes . "|","|" . FntCFDlg_Size . "|")  ;-- Size in the list
            {
            ;-- Get current select positions
            SendMessage CB_GETEDITSEL,0,0,,ahk_id %FntCFDlg_hSize%
            l_SelPos:=ErrorLevel

            ;-- Select the size from the list
            GUIControl FntCFDlg:ChooseString,%FntCFDlg_hSize%,%FntCFDlg_Size%

            ;-- Reset select positions
            SendMessage CB_SETEDITSEL,0,l_SelPos,,ahk_id %FntCFDlg_hSize%
            }
        }

    gosub FntCFDlg_SetSampleTextFont
    return


    FntCFDlg_TrimFields:  ;-- Assume gui Submit,NoHide has been performed
    FntCFDlg_FontName:=Trim(FntCFDlg_FontName," `f`n`r`t`v")
    FntCFDlg_Size    :=Trim(FntCFDlg_Size," `f`n`r`t`v")
    FntCFDlg_Color   :=Trim(FntCFDlg_Color," `f`n`r`t`v")
    return


    FntCFDlg_Cancel:
    FntCFDlg_Close:
    FntCFDlg_Escape:
    l_RC:=False

    ;-- Fall through...

    FntCFDlg_Exit:

    ;-- Enable Owner window
    if p_Owner
        gui %p_Owner%:-Disabled

    ;-- Destroy the FntCFDlg window so that the GUI window can be reused
    gui FntCFDlg:Destroy
    return  ;-- End of subroutines
    }

;------------------------------
;
; Function: Fnt_ChooseFontDlg_ChooseColor
;
; Description:
;
;   Creates a Color dialog box that enables the user to select a color.
;
; Type:
;
;   Used by the <Fnt_ChooseFontDlg> add-on.  Subject to change.  Do not call
;   directly.
;
; Parameters:
;
;   hOwner - A handle to the window that owns the dialog box.  This parameter
;       can be any valid window handle or it can be set to 0 or null if the
;       dialog box has no owner.
;
;   r_Color - Color in RGB format. [Input/Output] On input, this variable should
;       contain the default color, i.e. the color that is initially selected
;       when the Color dialog is displayed.  On output, this variable contains
;       the color selected in a 6-digit hexadecimal RGB format.  Ex: 0x00FF80.
;       If the function returns FALSE, i.e. the Color dialog was cancelled, the
;       value is not modified.
;
;   p_Flags - Flags used to initialize the Color dialog.  See the *Flags*
;       section for the details.
;
; Flags:
;
;   The p_Flags parameter contains flags that are used to initialize and/or
;   determine the behavior of the dialog.  If set to zero (the default) or null,
;   the CC_FULLOPEN and CC_ANYCOLOR flags are used.  If p_Flags contains an
;   interger value, the parameter is assumed to contain bit flags.  See the
;   function's static variables for a list a valid bit flags.  Otherwise, the
;   following space-delimited text flags can be used.
;
;   AnyColor - Causes the dialog box to display all available colors in the set
;       of basic colors.
;
;   FullOpen - Causes the dialog box to display the additional controls that
;       allow the user to create custom colors.  If this flag is not set, the
;       user must click the Define Custom Colors button to display the custom
;       color controls.
;
;   PreventFullOpen - Disables the Define Custom Colors button.
;
; Returns:
;
;   TRUE if a color was selected, otherwise FALSE which indicates that the
;   dialog was canceled.
;
;-------------------------------------------------------------------------------
Fnt_ChooseFontDlg_ChooseColor(hOwner,ByRef r_Color,p_Flags:=0)
    {
    Static Dummy98026343
          ,s_CustomColors
                ;-- Custom color array

          ;-- ChooseColor flags
          ,CC_ANYCOLOR:=0x100
                ;-- Causes the dialog box to display all available colors in the
                ;   set of basic colors.

          ,CC_RGBINIT:=0x1
                ;-- Causes the dialog box to use the color specified in the
                ;   rgbResult member as the initial color selection.  This flag
                ;   is included by default.

          ,CC_FULLOPEN:=0x2
                ;-- Causes the dialog box to display the additional controls
                ;   that allow the user to create custom colors.  If this flag
                ;   is not set, the user must click the Define Custom Color
                ;   button to display the custom color controls.

          ,CC_PREVENTFULLOPEN:=0x4
                ;-- Disables the Define Custom Colors button.

          ,CC_SHOWHELP:=0x8
                ;-- Causes the dialog box to display the Help button.  Not
                ;   supported by this function.  Do not use.

          ,CC_SOLIDCOLOR:=0x80
                ;-- Causes the dialog box to display only solid colors in the
                ;   set of basic colors.  Observation: This flags doesn't
                ;   appear to do anything.

    ;[==============]
    ;[  Initialize  ]
    ;[==============]
    ;-- If needed, initialize the custom colors array
    if not VarSetCapacity(s_CustomColors)
        VarSetCapacity(s_CustomColors,64,0)
            ;-- All values are set to Black (0x0)

    ;[==============]
    ;[  Parameters  ]
    ;[==============]
    ;-- Color
    l_Color:=r_Color  ;-- Working copy of r_Color
    if l_Color is not Integer
        l_Color:=0x0  ;-- Black
     else
        ;-- Convert color to BGR
        l_Color:=((l_Color&0xFF)<<16)+(l_Color&0xFF00)+((l_Color>>16)&0xFF)

    ;-- Flags
    l_Flags:=CC_RGBINIT
    if not p_Flags  ;-- Zero, blank, or null
        l_Flags|=CC_FULLOPEN|CC_ANYCOLOR
     else
        ;-- Bit flags
        if p_Flags is Integer
            l_Flags|=p_Flags
         else
            ;-- Convert text flags into bit flags
            Loop Parse,p_Flags,%A_Tab%%A_Space%,%A_Tab%%A_Space%
                if A_LoopField is not Space
                    if CC_%A_LoopField% is Integer
                        l_Flags|=CC_%A_LoopField%

    ;[==================]
    ;[  Pre-Processing  ]
    ;[==================]
    ;-- Create and populate CHOOSECOLOR structure
    lStructSize:=VarSetCapacity(CHOOSECOLOR,(A_PtrSize=8) ? 72:36,0)
    NumPut(lStructSize,CHOOSECOLOR,0,"UInt")            ;-- lStructSize
    NumPut(hOwner,CHOOSECOLOR,(A_PtrSize=8) ? 8:4,"Ptr")
        ;-- hwndOwner
    NumPut(l_Color,CHOOSECOLOR,(A_PtrSize=8) ? 24:12,"UInt")
        ;-- rgbResult
    NumPut(&s_CustomColors,CHOOSECOLOR,(A_PtrSize=8) ? 32:16,"Ptr")
        ;-- lpCustColors
    NumPut(l_Flags,CHOOSECOLOR,(A_PtrSize=8) ? 40:20,"UInt")
        ;-- Flags

    ;[===============]
    ;[  Show dialog  ]
    ;[===============]
    ;-- Show the Color dialog.  Returns TRUE if a color is selected, otherwise
    ;   FALSE.
    if not DllCall("comdlg32\ChooseColor" . (A_IsUnicode ? "W":"A"),"Ptr",&CHOOSECOLOR)
        Return False

    ;[===================]
    ;[  Post-Processing  ]
    ;[===================]
    ;-- Collect the selected color
    l_Color:=NumGet(CHOOSECOLOR,(A_PtrSize=8) ? 24:12,"UInt")
        ;-- rgbResult

    ;-- Convert to RGB
    l_Color:=((l_Color&0xFF)<<16)+(l_Color&0xFF00)+((l_Color>>16)&0xFF)

    ;-- Update r_Color with the selected color
    r_Color:=Format("0x{:06X}",l_Color)
    Return True
    }

;------------------------------
;
; Function: Fnt_ChooseFontDlg_SBSetText
;
; Description:
;
;   Set the text in the specified part of a status bar.
;
; Type:
;
;   Used by the <Fnt_ChooseFontDlg> add-on.  Subject to change.  Do not call
;   directly.
;
; Parameters:
;
;   hSB - The handle to the status bar control.
;
;   p_Text - The text to set.
;
;   p_PartNumber - 1-based index of the part to set. [Optional]  The default is
;       1.
;
;   p_Style - The type of the drawing operation. [Optional]  The default is 0.
;       See the function's static variables for a list of possible values.
;
;-------------------------------------------------------------------------------
Fnt_ChooseFontDlg_SBSetText(hSB,p_Text,p_PartNumber:=1,p_Style:=0)
    {
    Static Dummy58624566

          ;-- Drawing operation types
          ,SBT_DEFAULT:=0x0
                ;-- The text is drawn with a border to appear lower than the
                ;   plane of the window.  This is the default.

          ,SBT_NOBORDERS:=0x100
                ;-- The text is drawn without borders.

          ,SBT_POPOUT:=0x200
                ;-- The text is drawn with a border to appear higher than the
                ;   plane of the window.

          ,SBT_RTLREADING:=0x400
                ;-- The text will be displayed in the opposite direction to the
                ;   text in the parent window

          ,SBT_NOTABPARSING:=0x800
                ;-- Tab characters are ignored.

          ,SBT_OWNERDRAW:=0x1000
                ;-- The text is drawn by the parent window.

          ;-- Messages
          ,SB_SETTEXTA:=0x401                           ;-- WM_USER+1
          ,SB_SETTEXTW:=0x40B                           ;-- WM+USER+11

    ;-- Set status bar text
    SendMessage
        ,A_IsUnicode ? SB_SETTEXTW:SB_SETTEXTA
        ,p_Style|p_PartNumber-1                         ;-- wParam (Style|Part)
        ,&p_Text                                        ;-- lParam (&Text)
        ,,ahk_id %hSB%
    }
