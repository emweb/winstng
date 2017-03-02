' j_unzip.vbs
' '
' UnZip a file script
'
' By Justin Godden 2010
' Modified for winstng
'
' It's a mess, I know!!!
'
Set ArgObj = WScript.Arguments

If (Wscript.Arguments.Count > 0) Then
 strZipFile = ArgObj(0)
Else
 WScript.Echo ( "No argument." )
 WScript.Quit
End if

'The location of the zip file.
Dim sCurPath
sCurPath = CreateObject("Scripting.FileSystemObject").GetAbsolutePathName(".")
'The folder the contents should be extracted to.
outFolder = sCurPath & "\"

WScript.Echo ( "Extracting file " & strFileZIP)

Set objShell = CreateObject( "Shell.Application" )
Set objSource = objShell.NameSpace(strZipFile).Items()
Set objTarget = objShell.NameSpace(outFolder)
intOptions = 4
objTarget.CopyHere objSource, intOptions

WScript.Echo ( "Extracted." )

