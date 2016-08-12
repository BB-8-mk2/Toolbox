'Option Explicit

' Ultimate Install Font VBS
'   http://www.visualbasicscript.com/Ultimate-Install-Font-VBS-m72168.aspx

Const FONTS = &H14&
Const ForAppending = 8

Dim fso, 

doexist = 0
dontexist = 0

Set objShell = CreateObject("Shell.Application")
Set objFolder = objShell.Namespace(FONTS)
set oShell = CreateObject("WScript.Shell") 
strSystemRootDir = oshell.ExpandEnvironmentStrings("%systemroot%")
strFontDir = strSystemRootDir & "\fonts\"
strTempDir = oshell.ExpandEnvironmentStrings("C:\SccmDvlog")
Set fso = CreateObject("Scripting.FileSystemObject")
Set objDictionary = CreateObject("Scripting.Dictionary")
objDictionary.CompareMode = TextMode
Set f1 = FSO.createTextFile(strTempDir & "\m16019-1-NotoFont_Bold.txt", ForAppending)

CollectFonts
InstallFonts "."          ' insert path here to font folder

wscript.echo doexist & " fonts already installed." & vbcrlf & dontexist & " new fonts installed."

'===================================================================
Public Sub CollectFonts
'===================================================================
set colItems = objfolder.Items
For each ObjItem in ColItems
   If LCase(Right(objItem.Name, 3)) = "ttf" or _
      LCase(Right(objItem.Name, 3)) = "otf" or _
      LCase(Right(objItem.Name, 3)) = "pfm" or _
      LCase(Right(objItem.Name, 3)) = "fon" Then
       If Not objDictionary.Exists(LCase(ObjItem.Name)) Then
           objDictionary.Add LCase(ObjItem.Name), LCase(ObjItem.Name)
       End If
   End If
Next
For each ObjItem in ObjDictionary
   f1.writeline ObjDictionary.Item(objItem)
Next
End Sub

'===================================================================
Public Sub InstallFonts(Folder)
'===================================================================
Set FontFolder = fso.getfolder(Folder)
       For Each File in FontFolder.Files
            If LCase(fso.GetExtensionName(File))="ttf" or _
               LCase(fso.GetExtensionName(File))="otf" or _
               LCase(fso.GetExtensionName(File))="pfm" or _
               LCase(fso.GetExtensionName(File))="fon" Then
'check if Font is Already installed. If not, Install
               If objDictionary.Exists(lcase(fso.GetFileName(File))) then
'                    wscript.echo fso.GetFileName(File) & " already exists in " & strFontDir
                   doexist = doexist + 1
               Else
'                    wscript.echo fso.GetAbsolutePathName(File) & " doesn't exists in " & strFontDir
                   objFolder.CopyHere FontFolder & "\" & fso.GetFileName(File)
                   dontexist = dontexist + 1
               end If
           End If
       Next
       For Each SubFolder in FontFolder.subFolders
           InstallFonts SubFolder
       Next
End Sub
