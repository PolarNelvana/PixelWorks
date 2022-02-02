;-----------------------------
;
; Function: MoveChildWindow v0.3 (Preview)
;
; Description:
;
;   Moves a child or pop-up window relative to the parent window.  If needed,
;   the coordinates are adjusted so that the window will fit within the primary
;   monitor work area.
;
; Parameters:
;
;   p_Parent - Parent window.  This parameter can contain a GUI window number
;       (1 thru 99), a GUI name (Ex: "MyGUI") or a window handle (hWnd).
;       Exception: If the "Mouse", "x", "y", or "x,y" options are used, this
;       parameter is ignored.
;
;   p_Child - Child window.  This parameter can contain a GUI window number
;       (1 thru 99), a GUI name (Ex: "MyChilGUI") or a window handle (hWnd).
;
;   p_Options - Options that determine the position of the child window
;       relative to the parent.  See the *Options* section for the details.
;
; Options:
;
;   The p_Options parameter contains a combination of options that determine
;   how the child window is positioned and/or modified.  The following
;   position options are available.
;
;   Attach - If included, the child window is positioned outside of the parent
;       window as though it were "attached" to one of the borders. The order of
;       the positional parameters ("Left", "Top", etc.) becomes important if
;       selected.  For example, if "Attach Right Top" is specified, the child
;       window is positioned on the right border of the parent at the top of the
;       window.  However, if "Attach Top Right" is specified, the child window
;       is positioned immediately above the parent window on the right side of
;       the window.
;
;   Bottom - Positions the child window relative to the bottom of the parent
;       window.  Often used with the "Left", "Center", or "Right options.
;
;   Center - Positions the child window relative to the center of the parent
;       window.  Often used with the "Top", "Bottom", "Left", or "Right"
;       options.  This option is the default positioning option and it has the
;       lowest precedence of all the positioning options.  If no positioning (or
;       competing) options are specified, "Center" is assumed.
;
;   Left - Positions the child window relative to the left side of the parent
;       window.  Often used with the "Top", "Center", or "Bottom" options.
;
;   Mouse - Positions the child window relative to the current cursor (i.e.
;       mouse) position.  This option has the highest precedence.  If specified,
;       all other positioning options are ignored.
;
;   Right - Positions the child window relative to the right side of the parent
;       windows.  Often used with the "Top", "Center", or "Bottom" options.
;
;   Top - Positions the child window relative to the top of the parent window.
;       Often used with the "Left" , "Center", or "Right" options. This option
;       takes precedence over the "Bottom" option.
;
;   x,y - [Deprecated] Position the child window to specific X and/or Y
;       coordinates.  For example, "10,10" will position the dialog in the top
;       left corner of the monitor, 10 pixels in.  If either coordinate is
;       omitted, the dialog will be centered in that dimension.  However, the
;       "," (comma) character must always be specified.  Ex: "120," (X
;       coordinate only) or ",90" (Y coordinate only).  If this option is
;       included, all other positional options are ignored.  Note: This option
;       is deprecated.  Use the x and y options instead.
;
;   x{x-coordinate} - X coordinate of the child window.  Ex: x25.  If the y
;       option is not specified, the dialog will be centered along the Y
;       axis.  If the x and/or the y options are used, all other positional
;       options are ignored.
;
;   y{y-coordinate} - Y coordinate of the child window.  Ex: y100.  If the x
;       option is not specified, the dialog will be centered along the X
;       axis.  If the x and/or the y options are used, all other positional
;       options are ignored.
;
;   In addition, the following miscellaneous options are available.
;
;   NoMove - Calculates the new position but the child window is not moved.  The
;       coordinates of the child window can be collected via the function's
;       return value.  Note: Since the ShowNA option was added, this option is
;       rarely needed.
;
;   Show - Shows (unhides) the child window after it has been moved.  Note: This
;       option should only be specified if the child/pop-up window is hidden
;       _and_ the script doesn't already show (unhide) the window.
;
;   ShowNA - Same as the "Show" option except that the window is not activated
;       after it shown.  This option takes precedence over the "Show" option.
;
;   If more than one option is specified, it should be delimited by a space.
;   For example: "Attach Left Top".
;
; Returns:
;
;   If successful, the address to a <POINT at http://tinyurl.com/mfv6fpz>
;   structure which contains the new coordinates of the child window, otherwise
;   FALSE.
;
; Calls To Other Functions:
;
; * WinGetPosEx
;
; Remarks:
;
;   At this writing, the function only supports the primary monitor.  Support
;   for multiple monitors may be included in future versions.
;
;-------------------------------------------------------------------------------
MoveChildWindow(p_Parent,p_Child,p_Options="")
    {
    Static Dummy52026183
          ,POINT
          ,SW_SHOWNA:=8

    ;[==============]
    ;[  Initialize  ]
    ;[==============]
    VarSetCapacity(POINT,8,0)

    ;-- Environment
    l_DetectHiddenWindows:=A_DetectHiddenWindows
    DetectHiddenWindows On
    SysGet l_MonitorWorkArea,MonitorWorkArea
    StringUpper p_Options,p_Options,T   ;-- Just in case StringCaseSense is On

    ;[==============]
    ;[  Parameters  ]
    ;[==============]
    ;------------
    ;-- p_Parent
    ;------------
    ;-- Ignore the parent, i.e. allow invalid or no parent, if "Mouse" or 
    ;   coordinates options (Ex: "100,400" or "x100" and/or "y100") are
    ;   specified.
    if (InStr(p_Options,"Mouse")
    or  InStr(p_Options,",")                ;-- X and/or Y coordinates (deprecated)
    or  InStr(A_Space . p_Options," x")     ;-- X coordinates
    or  InStr(A_Space . p_Options," y"))    ;-- Y coordinates
        hParent:=0
     else
        {
        ;-- Not already a window handle?
        if not hParent:=WinExist("ahk_id " . p_Parent)
            {
            Try
                {
                ;-- Determine if p_Parent is a valid AutoHotkey window and if
                ;   so, identify the window handle.  Note: The Try command is
                ;   used because AutoHotkey may generate a run-time error if
                ;   p_Owner is not a valid GUI number (1 thru 99), a valid GUI
                ;   name, or a window handle that is not an AutoHotkey GUI.
                gui %p_Parent%:+LastFoundExist
                IfWinExist
                    {
                    gui %p_Parent%:+LastFound
                    hParent:=WinExist()
                    }
                 else  ;-- GUI not found
                    p_Parent:=0
                }
             Catch  ;-- Not an AutoHotkey GUI
                p_Parent:=0
            }

        ;-- Bounce if the parent window is not found
        if not hParent
            {
            outputdebug,
               (ltrim join`s
                Function: %A_ThisFunc% -
                Unable to find the parent window. Request aborted.
                p_Parent=%p_Parent%
               )

            ;-- Reset environment
            DetectHiddenWindows %l_DetectHiddenWindows%
            Return False
            }

        ;-- Collect window position/size
        WinGetPosEx(hParent,l_ParentX,l_ParentY,l_ParentW,l_ParentH)
        }

    ;-----------
    ;-- p_Child
    ;-----------
    ;-- Not already a window handle?
    if not hChild:=WinExist("ahk_id " . p_Child)
        {
        Try
            {
            ;-- Determine if p_Child is a valid AutoHotkey window and if so,
            ;   identify the window handle.  Note: The Try command is used
            ;   because AutoHotkey may generate a run-time error if p_Owner is
            ;   not a valid GUI number (1 thru 99), a valid GUI name, or a
            ;   window handle that is not an AutoHotkey GUI.
            gui %p_Child%:+LastFoundExist
            IfWinExist
                {
                gui %p_Child%:+LastFound
                hChild:=WinExist()
                }
             else  ;-- GUI not found
                p_Child:=0
            }
         Catch  ;-- Not a AutoHotkey GUI
            p_Child:=0

        }

    ;-- Bounce if the child window is not found
    if not hChild
        {
        outputdebug,
           (ltrim join`s
            Function: %A_ThisFunc% - 
            Unable to find the child window. Request aborted.
            p_Child=%p_Child%
           )

        ;-- Reset environment
        DetectHiddenWindows %l_DetectHiddenWindows%
        Return False
        }

    ;-- Collect window position/size
    WinGetPosEx(hChild,l_ChildX,l_ChildY,l_ChildW,l_ChildH,l_ChildOffset_X,l_ChildOffset_Y)

    ;[=========================]
    ;[  Determine coordinates  ]
    ;[=========================]
    ;-- Mouse
    if p_Options Contains Mouse
        {
        DllCall("GetCursorPos","Ptr",&POINT)
        l_ChildX:=NumGet(POINT,0,"Int")+l_ChildOffset_X
        l_ChildY:=NumGet(POINT,4,"Int")+l_ChildOffset_Y
        }
     else
        {
        ;-- Extract X and/or Y coordinates if any
        if (InStr(A_Space . p_Options," x") or InStr(A_Space . p_Options," y"))
            {
            ;-- Set default coordinates
            l_ChildX:=Round(((l_MonitorWorkAreaRight-l_MonitorWorkAreaLeft)/2)-(l_ChildW/2))+l_ChildOffset_X
            l_ChildY:=Round(((l_MonitorWorkAreaBottom-l_MonitorWorkAreaTop)/2)-(l_ChildH/2))+l_ChildOffset_Y

            ;-- Parse for the coordinate options
            Loop Parse,p_Options,%A_Space%
                {
                if (SubStr(A_LoopField,1,1)="x")
                    {
                    l_XPos:=SubStr(A_LoopField,2)
                    if l_XPos is Integer
                        l_ChildX:=l_XPos+l_ChildOffset_X
                    }

                if (SubStr(A_LoopField,1,1)="y")
                    {
                    l_YPos:=SubStr(A_LoopField,2)
                    if l_YPos is Integer
                        l_ChildY:=l_YPos+l_ChildOffset_Y
                    }
                }

            }

        ;-- Extract X and/or Y coordinates (Note: deprecated format)
        else if p_Options Contains ,,
            {
            ;-- Parse until the coordinates option is found
            l_Coords:=""
            Loop Parse,p_Options,%A_Space%
                if A_LoopField Contains ,,
                    {
                    l_Coords:=A_LoopField
                    Break
                    }

            ;-- Set defaults
            l_ChildX:=Round(((l_MonitorWorkAreaRight-l_MonitorWorkAreaLeft)/2)-(l_ChildW/2))+l_ChildOffset_X
            l_ChildY:=Round(((l_MonitorWorkAreaBottom-l_MonitorWorkAreaTop)/2)-(l_ChildH/2))+l_ChildOffset_Y

            ;-- Extract coordinates
            Loop Parse,l_Coords,`,
                {
                if (A_Index=1)
                    if A_LoopField is Integer
                        l_ChildX:=A_LoopField+l_ChildOffset_X

                if (A_Index=2)
                    if A_LoopField is Integer
                        l_ChildY:=A_LoopField+l_ChildOffset_Y
                }
            }
         else
            {
            ;-- Default if none of the associated positional options are included
            l_ChildX:=Round(l_ParentX+((l_ParentW-l_ChildW)/2))+l_ChildOffset_X
            l_ChildY:=Round(l_ParentY+((l_ParentH-l_ChildH)/2))+l_ChildOffset_Y

            ;-- Attach
            if p_Options Contains Attach
                {
                ;-- Initialize
                l_PosParmCount:=0

                ;-- Extract options from left to right
                Loop Parse,p_Options,%A_Space%
                    {
                    if A_LoopField not in Left,Top,Right,Bottom
                        Continue

                    l_PosParmCount++
                    if (l_PosParmCount=1)
                        {
                        if (A_LoopField="Left")
                            l_ChildX:=l_ParentX-l_ChildW+l_ChildOffset_X
                         else if (A_LoopField="Top")
                            l_ChildY:=l_ParentY-l_ChildH+l_ChildOffset_Y
                         else if (A_LoopField="Right")
                            l_ChildX:=l_ParentX+l_ParentW+l_ChildOffset_X
                         else if (A_LoopField="Bottom")
                            l_ChildY:=l_ParentY+l_ParentH+l_ChildOffset_Y
                        }
                     else  ;-- l_PosParmCount>1
                        {
                        if (A_LoopField="Left")
                            l_ChildX:=l_ParentX+l_ChildOffset_X
                         else if (A_LoopField="Top")
                            l_ChildY:=l_ParentY+l_ChildOffset_Y
                         else if (A_LoopField="Right")
                            l_ChildX:=l_ParentX+l_ParentW-l_ChildW+l_ChildOffset_X
                         else if (A_LoopField="Bottom")
                            l_ChildY:=l_ParentY+l_ParentH-l_ChildH+l_ChildOffset_Y
                        }
                    }
                }
             else
                {
                ;-- X
                if p_Options Contains Left
                    l_ChildX:=l_ParentX+l_ChildOffset_X
                 else
                    if p_Options Contains Right
                        l_ChildX:=l_ParentX+l_ParentW-l_ChildW+l_ChildOffset_X

                ;-- Y
                if p_Options Contains Top
                    l_ChildY:=l_ParentY+l_ChildOffset_Y
                 else
                    if p_Options Contains Bottom
                        l_ChildY:=l_ParentY+l_ParentH-l_ChildH+l_ChildOffset_Y
                }
            }
        }

    ;-- If needed, adjust so that the window fits within the monitor work area
    if (l_ChildX<l_MonitorWorkAreaLeft+l_ChildOffset_X)
        l_ChildX:=l_MonitorWorkAreaLeft+l_ChildOffset_X

    if (l_ChildY<l_MonitorWorkAreaTop+l_ChildOffset_Y)
        l_ChildY:=l_MonitorWorkAreaTop+l_ChildOffset_Y

    l_MaximumX:=l_MonitorWorkAreaRight-l_ChildW+l_ChildOffset_X
    if (l_ChildX>l_MaximumX)
        l_ChildX:=l_MaximumX

    l_MaximumY:=l_MonitorWorkAreaBottom-l_ChildH+l_ChildOffset_Y
    if (l_ChildY>l_MaximumY)
        l_ChildY:=l_MaximumY

    ;[========]
    ;[  Move  ]
    ;[========]
    if p_Options not Contains Nomove
        {
        ;-- Move to new position using the window's current width and height
        WinGetPos,,,l_Width,l_Height,ahk_id %hChild%
        if !DllCall("MoveWindow"
                ,"Ptr",hChild
                ,"Int",l_ChildX
                ,"Int",l_ChildY
                ,"Int",l_Width
                ,"Int",l_Height
                ,"Int",True)
            {
            outputdebug,
               (ltrim join`s
                Function: %A_ThisFunc% - 
                Unable to move the child window. Request aborted.
               )
    
            ;-- Reset environment
            DetectHiddenWindows %l_DetectHiddenWindows%
            Return False
            }

        ;-- Yield the remainder of the script's timeslice to other processes
        ;   that need it, if any
        Sleep 0
        }

    ;[========]
    ;[  Show  ]
    ;[========]
    if p_Options Contains Showna
        DllCall("ShowWindow","Ptr",hChild,"Int",SW_SHOWNA)
     else
        if p_Options Contains Show
            WinShow ahk_id %hChild%

    ;[=======================]
    ;[  Housekeeping/Return  ]
    ;[=======================]
    ;-- Reset environment 
    DetectHiddenWindows %l_DetectHiddenWindows%

    ;-- Populate POINT structure
    NumPut(l_ChildX,POINT,0,"Int")
    NumPut(l_ChildY,Point,4,"Int")

    ;-- Return address of POINT structure
    Return &POINT
    }
