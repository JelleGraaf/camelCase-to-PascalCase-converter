<#
    .SYNOPSIS
        This script converts all variables in a target script from camelCase to PascalCase
    .DESCRIPTION
        This script converts all variables in a target script from camelCase to PascalCase, the best style
    .PARAMETER Script
        Enter the full path and filename of the script to be converted
    .PARAMETER Verbose
        Gives feedback on screen on the operations performed
    .EXAMPLE
        PS> .\Invoke-CaseConverter.ps1 -Script C:\Temp\SuckyCamelCaseScript.ps1
#>

param (
    [Parameter(Mandatory = $true)]
    $Script
)

if ($Script.Split('.')[-1] -ne 'ps1') {
    Write-Host "File entered is not a PowerShell script. Exiting." -ForegroundColor Red
    Exit
}

# Initialize
$ScriptPath = $Script | Split-Path
$ScriptName = $Script | Split-Path -Leaf
[regex]$Regex = '[a-z]'
$File = Get-Content $Script

# Check to see if a corrected script file already exists. If it does, remove it
if (Test-Path ($ScriptPath + "\Improved-$ScriptName")) {
    Remove-Item ($ScriptPath + "\Improved-$ScriptName")
}
# Create a corrected script file
$NewFile = New-Item ($ScriptPath + "\Improved-$ScriptName")

foreach ($Line in $File) {
    # Read position of dollar sign in line
    $Line2 = $Line.ToCharArray()
    $CharsToUpperCase = @()
    for ($i = 0; $i -lt $Line2.Count; $i++) {
        if ($Line2[$i] -eq '$') {
            $CharsToUpperCase += $i + 1
        }
    }

    # Change all [a-z] characters behind a dollar to uppercase
    [string]$LineCorrected = $null
    for ($i = 0; $i -lt $Line2.Count; $i++) {
        if ($i -in $CharsToUpperCase -and $Line2[$i] -match $Regex) {
            [string]$CharAsString = $Line2[$i]
            $LineCorrected += $CharAsString.ToUpper()
        } 
        else {
            [string]$CharAsString = $Line2[$i]
            $LineCorrected += $CharAsString
        }
    }

    # Write the line to a new script file
    Add-Content $NewFile -Value $LineCorrected
}
