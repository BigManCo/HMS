'********************************************************************
'**  Home Media Server Application - Main
'**  Copyright (c) 2010 Brian C. Lane All Rights Reserved.
'********************************************************************
Sub Main()
    'initialize theme attributes like titles, logos and overhang color
    initTheme()

    screen = PreShowPosterScreen()
    if screen = invalid then
        print "Error creating initial poster screen"
        return
    end if

    ' Get server url and make sure it is valid
    valid_dir = false
    force_edit = false
    while not valid_dir
        valid_dir = checkServerUrl(force_edit)
        dir = getDirectoryListing( "http://"+RegRead("ServerURL") )
        if dir = invalid then
            force_edit = true
            valid_dir = false
        end if
    end while

    path = []

    done = false
    while not done
        print "path: ";path
        pathString = joinString(path, "/", true, true)
        print "pathString: ";pathString
        ret = displayDirectory( "http://"+RegRead("ServerURL")+pathString )
        print "main: ";ret
        print "depth:";path.Count()
        if ret = invalid and path.Count() = 0 then
            done = true
        else if ret = invalid then
            path.Pop()
        else
            print "Adding to path: ";ret
            path.Push(ret)
        end if
    end while
End Sub


'*************************************************************
'** Set the configurable theme attributes for the application
'** 
'** Configure the custom overhang and Logo attributes
'** Theme attributes affect the branding of the application
'** and are artwork, colors and offsets specific to the app
'*************************************************************
Sub initTheme()

    app = CreateObject("roAppManager")
    theme = CreateObject("roAssociativeArray")

    theme.OverhangOffsetSD_X = "72"
    theme.OverhangOffsetSD_Y = "31"
    theme.OverhangSliceSD = "pkg:/images/Overhang_Background_SD.png"
    theme.OverhangLogoSD  = "pkg:/images/Overhang_Logo_SD.png"

    theme.OverhangOffsetHD_X = "125"
    theme.OverhangOffsetHD_Y = "35"
    theme.OverhangSliceHD = "pkg:/images/Overhang_Background_HD.png"
    theme.OverhangLogoHD  = "pkg:/images/Overhang_Logo_HD.png"

    app.SetTheme(theme)

End Sub

'*************************************************************
'** Setup something as a placeholder while we load
'*************************************************************
Function preShowPosterScreen() As Object
    port=CreateObject("roMessagePort")
    screen = CreateObject("roPosterScreen")
    screen.SetMessagePort(port)
    screen.SetListStyle("flat-category")
    screen.Show()
    return screen
End Function

