# Specify the path to the .exe file you want to read
$exeFilePath = "D:\deploy.exe"

# Specify the path to the output .txt file
$outputFilePath = "D:\output.txt"

# Read the .exe file as raw bytes
$exeBytes = [System.IO.File]::ReadAllBytes($exeFilePath)

# Convert the byte array to a string of hexadecimal values
$hexString = [BitConverter]::ToString($exeBytes) -replace '-'

# Write the hexadecimal string to the .txt file
Set-Content -Path $outputFilePath -Value $hexString

# Optionally, print out the output for verification
Write-Host "The raw bytes from the .exe file have been written to $outputFilePath"
