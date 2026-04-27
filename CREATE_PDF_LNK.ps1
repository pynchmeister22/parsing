<# 
Creates a Windows .lnk shortcut that opens a PDF file.

This script is intentionally benign: no embedded scripts, no downloads,
no persistence, no MOTW manipulation.
#>

param(
  # Full path to the PDF you want the shortcut to open.
  # If omitted, the script will look for Resume.pdf (or any .pdf) next to this script.
  [string]$PdfPath = '',

  # Output shortcut name (without extension). Defaults to "Resume".
  [string]$ShortcutName = 'Resume',

  # Optional: set to a specific PDF reader exe (e.g. "$env:ProgramFiles\SumatraPDF\SumatraPDF.exe").
  # If omitted, the shortcut opens the PDF with the system default handler.
  [string]$PdfReaderExe = '',

  # Optional icon for the shortcut (e.g. "$env:SystemRoot\System32\shell32.dll,1" or "C:\Path\App.exe,0").
  [string]$IconLocation = "$env:SystemRoot\System32\shell32.dll,1",

  [string]$Description = 'Open PDF'
)

$ErrorActionPreference = 'Stop'

$scriptRoot = if (-not [string]::IsNullOrWhiteSpace($PSCommandPath)) {
  Split-Path -LiteralPath $PSCommandPath
} elseif ($MyInvocation.MyCommand.Path) {
  Split-Path -LiteralPath $MyInvocation.MyCommand.Path
} else {
  (Get-Location).Path
}

function Quote-Arg([string]$s) {
  if ($null -eq $s) { return '""' }
  return '"' + ($s -replace '"', '\"') + '"'
}

function Resolve-PdfPath([string]$candidate) {
  if ([string]::IsNullOrWhiteSpace($candidate)) {
    $candidate = 'Resume.pdf'
  }

  if (-not [string]::IsNullOrWhiteSpace($candidate) -and (Test-Path -LiteralPath $candidate -PathType Leaf)) {
    return (Resolve-Path -LiteralPath $candidate).Path
  }

  # If user passed a relative path (or default), try relative to script directory.
  $fromRoot = Join-Path $scriptRoot $candidate
  if (-not [string]::IsNullOrWhiteSpace($candidate) -and (Test-Path -LiteralPath $fromRoot -PathType Leaf)) {
    return (Resolve-Path -LiteralPath $fromRoot).Path
  }

  # As a convenience: if Resume.pdf doesn't exist, pick the first PDF found here.
  $firstPdf = Get-ChildItem -LiteralPath $scriptRoot -Filter '*.pdf' -File -ErrorAction SilentlyContinue |
    Select-Object -First 1
  if ($null -ne $firstPdf) {
    return $firstPdf.FullName
  }

  return $null
}

$resolvedPdfPath = Resolve-PdfPath $PdfPath
if ($null -eq $resolvedPdfPath) {
  Write-Host "No PDF found." -ForegroundColor Red
  Write-Host "Put a PDF (e.g. Resume.pdf) in: $scriptRoot" -ForegroundColor Yellow
  Write-Host "Or run: .\CREATE_PDF_LNK.ps1 -PdfPath `"C:\path\to\file.pdf`"" -ForegroundColor Yellow
  return
}

$lnkPath = Join-Path $scriptRoot ($ShortcutName + '.lnk')

$wsh = New-Object -ComObject WScript.Shell
$sc = $wsh.CreateShortcut($lnkPath)

$sc.Description = $Description
$sc.IconLocation = $IconLocation
$sc.WorkingDirectory = (Split-Path -LiteralPath $resolvedPdfPath)

if ([string]::IsNullOrWhiteSpace($PdfReaderExe)) {
  # Use default PDF app via ShellExecute by calling explorer.exe on the file
  $sc.TargetPath = "$env:WINDIR\explorer.exe"
  $sc.Arguments = Quote-Arg($resolvedPdfPath)
} else {
  if (-not (Test-Path -LiteralPath $PdfReaderExe -PathType Leaf)) {
    throw "PDF reader exe not found: $PdfReaderExe"
  }
  $sc.TargetPath = (Resolve-Path -LiteralPath $PdfReaderExe).Path
  # Common readers accept the PDF path as the first argument
  $sc.Arguments = Quote-Arg($resolvedPdfPath)
}

$sc.Save()

[System.Runtime.Interopservices.Marshal]::ReleaseComObject($sc) | Out-Null
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($wsh) | Out-Null
[GC]::Collect()
[GC]::WaitForPendingFinalizers()

Write-Host "Created shortcut: $lnkPath" -ForegroundColor Green
Write-Host "PDF: $resolvedPdfPath" -ForegroundColor Gray
if (-not [string]::IsNullOrWhiteSpace($PdfReaderExe)) {
  Write-Host "Reader: $PdfReaderExe" -ForegroundColor Gray
} else {
  Write-Host "Reader: (system default)" -ForegroundColor Gray
}
