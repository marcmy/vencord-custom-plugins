param(
    [Parameter(Mandatory = $true)]
    [string]$VencordPath,

    [ValidateSet("upstream", "plus")]
    [string]$SplitVariant = "plus",

    [switch]$Build,
    [switch]$Reinject
)

$ErrorActionPreference = "Stop"
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

& (Join-Path $scriptDir "install.ps1") `
    -VencordPath $VencordPath `
    -SplitVariant $SplitVariant `
    -Build:$Build `
    -Reinject:$Reinject

