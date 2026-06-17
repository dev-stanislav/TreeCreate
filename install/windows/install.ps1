$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectDir = Split-Path -Parent (Split-Path -Parent $ScriptDir)
$SourceFile = Join-Path $ProjectDir "src\treecreate.py"
$BinDir = Join-Path $env:USERPROFILE ".local\bin"
$CmdPath = Join-Path $BinDir "treecreate.cmd"

New-Item -ItemType Directory -Force -Path $BinDir | Out-Null
Set-Content -Path $CmdPath -Value "@echo off`r`npython `"$SourceFile`" %*`r`n" -Encoding ASCII

$UserPath = [Environment]::GetEnvironmentVariable("Path", "User")
$PathParts = @()
if ($UserPath) {
    $PathParts = $UserPath -split ";"
}

if ($PathParts -notcontains $BinDir) {
    $NewPath = if ($UserPath) { "$UserPath;$BinDir" } else { $BinDir }
    [Environment]::SetEnvironmentVariable("Path", $NewPath, "User")
    $env:Path = "$env:Path;$BinDir"
}

Write-Host "Installed treecreate to $CmdPath"
Write-Host "Restart PowerShell if the command is not found in existing terminals."
