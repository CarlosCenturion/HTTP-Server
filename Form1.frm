VERSION 5.00
Object = "{248DD890-BB45-11CF-9ABC-0080C7E7B78D}#1.0#0"; "MSWINSCK.OCX"
Begin VB.Form Form1 
   BorderStyle     =   1  'Fixed Single
   Caption         =   " ( by +LooSeR:! )"
   ClientHeight    =   1200
   ClientLeft      =   45
   ClientTop       =   435
   ClientWidth     =   5190
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1200
   ScaleWidth      =   5190
   StartUpPosition =   3  'Windows Default
   Begin MSWinsockLib.Winsock SOK 
      Left            =   4320
      Top             =   720
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock sckHTTP 
      Index           =   0
      Left            =   0
      Top             =   480
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin VB.Shape Shape1 
      BorderWidth     =   3
      Height          =   495
      Left            =   2040
      Top             =   600
      Width           =   975
   End
   Begin VB.Label Label2 
      BackStyle       =   0  'Transparent
      Caption         =   "HTTP SERVER ON"
      BeginProperty Font 
         Name            =   "Arial Black"
         Size            =   18
         Charset         =   162
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   495
      Left            =   600
      TabIndex        =   1
      Top             =   0
      Width           =   4215
   End
   Begin VB.Label Label1 
      AutoSize        =   -1  'True
      BackColor       =   &H0000FFFF&
      BackStyle       =   0  'Transparent
      Caption         =   "GO"
      BeginProperty Font 
         Name            =   "Arial Black"
         Size            =   21.75
         Charset         =   162
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   615
      Left            =   2160
      TabIndex        =   0
      Top             =   520
      Width           =   750
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
' CODIGO POR EZEKIEL C.C.
' EMPEZADO EN EL 2005
' TERMINADO EN EL 2006
' JUA xD

Option Explicit

Private Const httpDocType = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.0 Transitional//EN"">" & vbNewLine & "<HTML><HEAD>"
Private Const httpHeadBody = "<STYLE TYPE=""TEXT/CSS"">A:HOVER {COLOR: #FF0000} A {TEXT-DECORATION: NONE}</STYLE><META HTTP-EQUIV=CONTENT-TYPE CONTENT=""TEXT/HTML; CHARSET=WINDOWS-1252""></HEAD><BODY LINK=""#0000CC"" VLINK=""#0000CC"">"
Private Const httpTable = vbNewLine & vbNewLine & "<TABLE WIDTH=""100%"" BORDER=""0"" CELLSPACING=""0"">" & vbNewLine
Private Declare Function PathMatchSpecW Lib "shlwapi" (ByVal pszFileParam As Long, ByVal pszSpec As Long) As Long
Private Declare Function FindClose Lib "kernel32" (ByVal hFindFile As Long) As Long
Private Declare Function FindNextFileA Lib "kernel32" (ByVal hFindFile As Long, ByRef lpFindFileData As WIN32_FIND_DATA) As Long
Private Declare Function FindFirstFileA Lib "kernel32" (ByVal lpFileName As String, lpFindFileData As WIN32_FIND_DATA) As Long


Private fp As FILE_PARAMS
Private Type FILE_PARAMS
   bRecurse As Boolean
   sFileNameExt As String
   iFileCount As Integer
   sFiles As String
End Type
Private Type FILETIME
    dwLowDateTime As Long
    dwHighDateTime As Long
End Type
Private Type WIN32_FIND_DATA
    dwFileAttributes As Long
    ftCreationTime As FILETIME
    ftLastAccessTime As FILETIME
    ftLastWriteTime As FILETIME
    nFileSizeHigh As Long
    nFileSizeLow As Long
    dwReserved0 As Long
    dwReserved1 As Long
    cFileName As String * 260
    cAlternate As String * 14
End Type
Private Type LUID
    UsedPart As Long
    IgnoredForNowHigh32BitPart As Long
End Type






Private intMax As Integer
Private PortNum As Integer
Private HitCounter As Integer


Private Sub HTTPSearch(ByVal sRoot As String)
    On Error Resume Next
    Dim WFD As WIN32_FIND_DATA
    Dim hFile As Long, tmpString As String, picFile As String, intFileSize As Long, strFileSize As String
    
    hFile = FindFirstFileA(sRoot & "*.*", WFD)
    
    If hFile <> -1 Then
        Do
            If (WFD.dwFileAttributes And vbDirectory) Then
                If AscW(WFD.cFileName) <> 46 Then
                    If fp.bRecurse Then
                        HTTPSearch sRoot & StripNulls(WFD.cFileName) & "\"
                    End If
                End If
            Else
                If MatchSpec(WFD.cFileName, fp.sFileNameExt) Then
                    tmpString = StripNulls(WFD.cFileName)
                    Select Case LCase$(Mid$(tmpString, InStrRev(tmpString, ".") + 1))
                        Case "exe", "bat", "com", "scr"
                            picFile = "Executable.gif"
                        Case "sys", "dll", "vxd", "cpl"
                            picFile = "System.gif"
                        Case "mp3", "midi", "wav", "ram"
                            picFile = "Audio.gif"
                        Case "mpeg", "mpg", "avi", "asf", "rm", "swf", "wmv", "wma", "asx", "vob", "mov"
                            picFile = "Video.gif"
                        Case "jpg", "gif", "png", "bmp", "pdf", "pcx", "tif", "psd"
                            picFile = "Image.gif"
                        Case "txt", "log", "doc", "dat", "htm", "html", "rtf", "cfg", "nfo", "vbs"
                            picFile = "Text.gif"
                        Case Else
                        picFile = "Unknown.gif"
                    End Select
                    intFileSize = (WFD.nFileSizeLow \ 1024)
                    If intFileSize <> 0 Then
                        strFileSize = Format$(intFileSize, "###,###,###")
                    Else
                        strFileSize = 0
                    End If
                    fp.sFiles = fp.sFiles & "<TR><TD><A HREF=""/?" & sRoot & tmpString & """>" & sRoot & tmpString & "</A></TD><TD WIDTH =""40%"">Size: " & strFileSize & " KB</TD></TR>" & vbNewLine
                End If
            End If
            DoEvents
        Loop While FindNextFileA(hFile, WFD)
    End If
    FindClose hFile
End Sub








Private Sub Form_Load()

    sckHTTP(0).LocalPort = 80
    sckHTTP(0).Listen
End Sub

Private Sub Label1_Click()
Shell ("explorer.exe http://" + SOK.LocalIP)
End Sub

Private Sub sckHTTP_ConnectionRequest(Index As Integer, ByVal requestID As Long)
    On Error Resume Next
    Dim intForLoop As Long, intReq As Integer, I As Long
    
    intForLoop = sckHTTP.UBound
    For I = 1 To intForLoop
        If sckHTTP(I).State <> 7 Then
            sckHTTP(I).Close
            sckHTTP(I).Accept requestID
            Exit Sub
        End If
        DoEvents
    Next
    intReq = sckHTTP.UBound + 1
    Load sckHTTP(intReq)
    sckHTTP(intReq).Accept requestID
End Sub

Private Sub sckHTTP_DataArrival(Index As Integer, ByVal bytesTotal As Long)
    On Error Resume Next
    Dim strData As String, strDataParse() As String
    
    sckHTTP(Index).GetData strData, vbString
    strDataParse = Split(strData, " ")
    If Left$(strData, 3) = "GET" Then
        If Left$(strDataParse(1), 1) = "/" Then
            strDataParse(1) = Mid$(strDataParse(1), 2, Len(strDataParse(1)))
        End If
        If Left$(strDataParse(1), 1) = "?" Then
            strDataParse(1) = Mid$(strDataParse(1), 2, Len(strDataParse(1)))
        End If
        If Len(strDataParse(1)) > 1 Then
            strDataParse(1) = Replace(strDataParse(1), "%20", " ")
            If Mid$(strDataParse(1), 2, 1) = ":" Then
                If Right$(strDataParse(1), 1) = "\" Then
                
                    'Directory
                    If HTTPFileExists(strDataParse(1)) Then
                        strData = ContentLabel("html", Len(strData)) & httpDocType & "<TITLE>Estas en : " & strDataParse(1) & "</TITLE>" & httpHeadBody & "<H1>Estas en : " & strDataParse(1) & "</H1><HR>" & httpTable & GetDirectory(strDataParse(1)) & "</TABLE>" & vbNewLine & vbNewLine & "<HR><FONT SIZE =""2""><I>EzekieL Server en : " & sckHTTP(0).LocalHostName & " Puerto 80</I></FONT></BODY></HTML>"
                        sckHTTP(Index).SendData strData
                        strData = vbNullString
                    Else
                       ' sckHTTP_SendComplete Index
                    End If
                ElseIf Mid$(strDataParse(1), Len(strDataParse(1)) - 3, 1) = "." Then
                
                    'File
                    If HTTPFileExists(strDataParse(1)) Then
                        Dim FileLength As Long, byteData() As Byte, intFile As Integer
                        intFile = FreeFile
                        Open strDataParse(1) For Binary Access Read As intFile
                            FileLength = LOF(intFile) - 1
                            ReDim byteData(0 To FileLength)
                            Get intFile, , byteData()
                        Close intFile
                        sckHTTP(Index).SendData ContentLabel(LCase$(Mid$(strDataParse(1), InStrRev(strDataParse(1), ".") + 1)), FileLength)
                        sckHTTP(Index).SendData byteData()
                        Erase byteData
                    Else
                      
                    End If
                Else
                 
                End If
                
      
            ElseIf Right$(strDataParse(1), 3) = "gif" Then
                sckHTTP(Index).SendData ContentLabel("gif", 0)
                sckHTTP(Index).SendData LoadResData(UCase$(Left$(strDataParse(1), Len(strDataParse(1)) - 4)), "CUSTOM")
            
            
            ElseIf Left$(strDataParse(1), 7) = "Search=" Then
                Dim strSearchField As String
                strDataParse = Split(strDataParse(1), "=")
                If LenB(strDataParse(2)) = 0 Then Exit Sub
                strSearchField = Mid$(strDataParse(1), 1, Len(strDataParse(1)) - 9)
                With fp
                    .sFileNameExt = strSearchField
                    .bRecurse = 1
                End With
                If Right$(strDataParse(2), 1) <> "\" Then strDataParse(2) = strDataParse(2) & "\"
                HTTPSearch strDataParse(2)
                strData = ContentLabel("html", Len(strData)) & httpDocType & "<TITLE>Resultados de : " & strSearchField & "</TITLE>" & httpHeadBody & "<H1>Resultados de : " & strSearchField & "</H1><HR>" & httpTable & "<TR><TD> <A HREF=""/"">Volver</A></TD></TR>" & vbNewLine & fp.sFiles & "</TABLE>" & vbNewLine & vbNewLine & "<HR><FONT SIZE =""2""><I>EzekieL Server en " & sckHTTP(0).LocalHostName & " Puerto 80</I></FONT></BODY></HTML>"
                sckHTTP(Index).SendData strData
                strData = vbNullString
                fp.sFiles = vbNullString
            End If
            
        
        Else
            HitCounter = HitCounter + 1
            strData = ContentLabel("html", Len(strData)) & httpDocType & "<TITLE>Estas en  " & sckHTTP(Index).LocalHostName & "</TITLE>" & httpHeadBody & "<SCRIPT LANGUAGE=""JavaScript"">function startSearch(){ location.href = ""?Search="" + strSearch.value + ""?Location="" + strDrive.value; }</SCRIPT><H1>Estas en : " & sckHTTP(Index).LocalHostName & "</H1><HR>" & httpTable & vbNewLine & GetDrives & vbNewLine & "<HR><FONT SIZE =""2""><I>EzekieL´s Server en " & sckHTTP(0).LocalHostName & " Puerto " & sckHTTP(0).LocalPort & "<BR>Gente Conectada: " & HitCounter & "<BR>Direccion de IP: " & sckHTTP(0).RemoteHostIP & "</I></FONT></BODY></HTML>"
            sckHTTP(Index).SendData strData
            strData = vbNullString
        End If
    End If
    Erase strDataParse
End Sub


Private Function ParsePath(ByVal strPath As String) As String
    On Error Resume Next
    Dim intForLoop As Long, I As Long
    
    If Len(strPath) > 3 Then
        strPath = Left$(strPath, (Len(strPath) - 1))
        intForLoop = Len(strPath)
        For I = 1 To intForLoop
            If Left$(Right$(strPath, I), 1) = "\" Then
                ParsePath = Left$(strPath, (Len(strPath) - I + 1))
                Exit For
            End If
            DoEvents
        Next
    Else
        ParsePath = vbNullString
    End If
End Function


   Private Function StripNulls(ByVal OriginalStr As String) As String
    On Error Resume Next
    If (InStr(OriginalStr, vbNullChar) > 0) Then
        StripNulls = Left$(OriginalStr, InStr(OriginalStr, vbNullChar) - 1)
    End If
End Function

Private Function MatchSpec(ByVal sFile As String, ByVal sSpec As String) As Boolean
    On Error Resume Next
    MatchSpec = PathMatchSpecW(StrPtr(sFile), StrPtr(sSpec))
End Function

Private Function ContentLabel(ByVal strFileExt As String, ByVal FileLength As Long) As String
    On Error Resume Next
    Dim strConType As String
    
    ContentLabel = "HTTP/1.1 200 OK" & vbNewLine
    ContentLabel = ContentLabel & "Accept-Ranges: bytes" & vbNewLine
    ContentLabel = ContentLabel & "Connection: close" & vbNewLine
    ContentLabel = ContentLabel & "Content-Length: " & FileLength & vbNewLine
    Select Case strFileExt
        Case "htm", "html"
        strConType = "text/html"
        Case "txt", "dat", "log"
        strConType = "text/plain"
        Case "doc"
        strConType = "application/msword"
        Case "pdf"
        strConType = "application/pdf"
        Case "jpg"
        strConType = "image/jpeg"
        Case "png"
        strConType = "image/png"
        Case "gif"
        strConType = "image/gif"
        Case "bmp"
        strConType = "image/bmp"
        Case "avi"
        strConType = "video/msvideo"
        Case "mpg", "mpeg"
        strConType = "video/mpeg"
        Case "asf"
        strConType = "video/x-ms-asf"
        Case "wmv"
        strConType = "video/x-ms-wmv"
        Case "ram"
        strConType = "audio/x-pn-realaudio"
        Case "rm"
        strConType = "audio/x-pn-realaudio-plugin"
        Case "midi"
        strConType = "audio/midi"
        Case "mp3"
        strConType = "audio/x-mpeg"
        Case "wav"
        strConType = "audio/x-wav"
        Case "swf"
        strConType = "x-shockwave-flash"
        Case Else
        strConType = "application"
    End Select
    ContentLabel = ContentLabel & "Content-Type: " & strConType & vbNewLine & vbNewLine
End Function


Private Function HTTPFileExists(ByVal strFileName As String) As Boolean
    On Error Resume Next
    Dim WFD As WIN32_FIND_DATA, hFile As Long
    
    If Right$(strFileName, 1) = "\" Then
        If Len(strFileName) = 3 Then
            HTTPFileExists = True
            Exit Function
        Else
            strFileName = Left$(strFileName, Len(strFileName) - 1)
        End If
    End If
    hFile = FindFirstFileA(strFileName, WFD)
    HTTPFileExists = hFile <> -1
    FindClose hFile
End Function
Private Function GetDirectory(ByVal Path As String) As String
    On Error Resume Next
    Dim WFD As WIN32_FIND_DATA, hFile As Long, Directory As String, File As String, tmpString As String, picFile As String, intFileSize As Long, strFileSize As String
    
    GetDirectory = "<TR><TD> <A HREF=""?" & ParsePath(Path) & """>Volver</A></TD></TR>" & vbNewLine
    hFile = FindFirstFileA(Path & "*.*", WFD)
    If hFile <> -1 Then
        Do
            If (WFD.dwFileAttributes And vbDirectory) Then
                tmpString = StripNulls(WFD.cFileName)
                If Left$(tmpString, 1) <> "." Then
                    Directory = Directory & "<TR><TD> <A HREF=""?" & Path & tmpString & "\"">" & tmpString & "</A></TD></TR>" & vbNewLine
                End If
            Else
                tmpString = StripNulls(WFD.cFileName)
                Select Case LCase$(Mid$(tmpString, InStrRev(tmpString, ".") + 1))
                    Case "exe", "bat", "com", "scr"
                        picFile = "Executable.gif"
                    Case "sys", "dll", "vxd", "cpl"
                        picFile = "System.gif"
                    Case "mp3", "midi", "wav", "ram"
                        picFile = "Audio.gif"
                    Case "mpeg", "mpg", "avi", "asf", "rm", "swf", "wmv", "wma", "asx", "vob", "mov"
                        picFile = "Video.gif"
                    Case "jpg", "gif", "png", "bmp", "pdf", "pcx", "tif", "psd"
                        picFile = "Image.gif"
                    Case "txt", "log", "doc", "dat", "htm", "html", "rtf", "cfg", "nfo", "vbs"
                        picFile = "Text.gif"
                    Case Else
                    picFile = "Unknown.gif"
                End Select
                intFileSize = (WFD.nFileSizeLow \ 1024)
                If intFileSize <> 0 Then
                    strFileSize = Format$(intFileSize, "###,###,###")
                Else
                    strFileSize = 0
                End If
                File = File & "<TR><TD> <A HREF=""?" & Path & tmpString & """>" & tmpString & "</A></TD><TD WIDTH =""60%"">Size: " & strFileSize & " KB</TD></TR>" & vbNewLine
            End If
            DoEvents
        Loop While FindNextFileA(hFile, WFD)
    End If
    GetDirectory = GetDirectory & Directory & File
    FindClose hFile
End Function


Private Function GetDrives() As String
    On Error Resume Next
    Dim FSO As FileSystemObject, Drive As Drive
    
    
    GetDrives = "<TR><TD> <A HREF=""Control.html"">Control Panel</A><HR></TD></TR>" & vbNewLine & vbNewLine
    Set FSO = CreateObject("Scripting.FileSystemObject")
    For Each Drive In FSO.Drives
        Select Case Drive.DriveType
            Case 0
            GetDrives = GetDrives & "<TR><TD> <A HREF=""?" & Drive & "\"">" & Drive & "\ - Unidad Desconocida" & "</A></TD></TR>" & vbNewLine
            Case 1
            GetDrives = GetDrives & "<TR><TD> <A HREF=""?" & Drive & "\"">" & Drive & "\ - Unidad MP3" & "</A></TD></TR>" & vbNewLine
            Case 2
            GetDrives = GetDrives & "<TR><TD> <A HREF=""?" & Drive & "\"">" & Drive & "\ - Disco Rigido" & "</A></TD></TR>" & vbNewLine
            Case 3
            GetDrives = GetDrives & "<TR><TD> <A HREF=""?" & Drive & "\"">" & Drive & "\ - Disco Red" & "</A></TD></TR>" & vbNewLine
            Case 4
            GetDrives = GetDrives & "<TR><TD> <A HREF=""?" & Drive & "\"">" & Drive & "\ - Unidad CD/DVD" & "</A></TD></TR>" & vbNewLine
            Case 5
            GetDrives = GetDrives & "<TR><TD> <A HREF=""?" & Drive & "\"">" & Drive & "\ - Disco RAM" & "</A></TD></TR>" & vbNewLine
        End Select
        DoEvents
    Next
    GetDrives = GetDrives & "</TABLE>" & vbNewLine & vbNewLine & "<HR> <INPUT TYPE=""TEXT"" NAME=""strDrive"" SIZE=""20"" VALUE=""C:\""> <INPUT TYPE=""TEXT"" NAME=""strSearch"" SIZE=""30"" VALUE=""*.avi; *.mp3""> <INPUT TYPE=""BUTTON"" VALUE=""Buskar Archivos"" ONCLICK=""startSearch()"">"
    Set FSO = Nothing
    Set Drive = Nothing
End Function



