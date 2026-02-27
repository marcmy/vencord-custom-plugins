param(
    [Parameter(Mandatory = $true)]
    [string]$VencordPath,

    [ValidateSet("upstream", "plus")]
    [string]$SplitVariant = "plus",

    [switch]$Build,
    [switch]$Reinject
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$pluginsSrc = Join-Path $repoRoot "plugins"

if (!(Test-Path $pluginsSrc)) {
    throw "Plugins folder not found: $pluginsSrc"
}

$targetPlugins = Join-Path $VencordPath "src\plugins"
if (!(Test-Path $targetPlugins)) {
    throw "Target Vencord plugins folder not found: $targetPlugins"
}

Write-Host "Installing custom plugins into $targetPlugins" -ForegroundColor Cyan

$toInstall = @(
    "onePingPerChannel",
    "hideChannelListShortcuts"
)

if ($SplitVariant -eq "upstream") {
    $toInstall += "splitLongMessages"
    $toRemove = @("splitLongMessagesPlus")
} else {
    $toInstall += "splitLongMessagesPlus"
    $toRemove = @("splitLongMessages")
}

foreach ($name in $toRemove) {
    $dst = Join-Path $targetPlugins $name
    if (Test-Path $dst) {
        Write-Host "Removing conflicting plugin $name" -ForegroundColor Yellow
        Remove-Item -Recurse -Force $dst
    }
}

foreach ($name in $toInstall) {
    $src = Join-Path $pluginsSrc $name
    $dst = Join-Path $targetPlugins $name

    if (!(Test-Path $src)) {
        throw "Source plugin not found: $src"
    }

    if (Test-Path $dst) {
        Remove-Item -Recurse -Force $dst
    }

    Copy-Item -Recurse $src $dst
    Write-Host "Installed $name" -ForegroundColor Green
}

Write-Host ""
Write-Host "Done copying plugins." -ForegroundColor Green

if ($Build) {
    Write-Host "Running pnpm build..." -ForegroundColor Cyan
    Push-Location $VencordPath
    try {
        & pnpm build
        if ($LASTEXITCODE -ne 0) {
            throw "pnpm build failed with exit code $LASTEXITCODE"
        }

        if ($Reinject) {
            Write-Host "Running Vencord installer script..." -ForegroundColor Cyan
            & node scripts/runInstaller.mjs
            if ($LASTEXITCODE -ne 0) {
                throw "runInstaller.mjs failed with exit code $LASTEXITCODE"
            }
        }
    } finally {
        Pop-Location
    }
} elseif ($Reinject) {
    Write-Warning "-Reinject was requested without -Build. Running installer anyway."
    Push-Location $VencordPath
    try {
        & node scripts/runInstaller.mjs
        if ($LASTEXITCODE -ne 0) {
            throw "runInstaller.mjs failed with exit code $LASTEXITCODE"
        }
    } finally {
        Pop-Location
    }
}

Write-Host ""
Write-Host "Installed plugins:" -ForegroundColor Cyan
foreach ($name in $toInstall) { Write-Host " - $name" }
Write-Host ""
Write-Host "Enable in Vencord settings after restart/reinject." -ForegroundColor Cyan

