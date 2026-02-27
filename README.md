# Vencord Custom Plugins (marcmy)

Custom Vencord plugins maintained outside upstream.

## What this repo is

This is a plugin pack for Vencord source builds.

It does **not** include Vencord itself and cannot build Discord on its own.

You must already have:
1. A local Vencord source checkout
2. Dependencies installed in that checkout (`pnpm install`)
3. A working build/reinject setup

## Included plugins

- `onePingPerChannel`
- `splitLongMessages` (upstream-safe version, no DOM UI polish)
- `splitLongMessagesPlus` (local polished version with composer UI cleanup)
- `hideChannelListShortcuts` (local-only UI-hiding plugin)

## Important

- Enable only one of these at a time:
  - `SplitLongMessages`
  - `SplitLongMessagesPlus`
- `hideChannelListShortcuts` is likely not suitable for upstream Vencord PRs (UI-hiding / DOM approach).

## Install into an existing Vencord source repo (Windows / PowerShell)

From this repo folder, target your existing Vencord checkout:

```powershell
.\install.ps1 -VencordPath "C:\path\to\Vencord"
```

By default, this installs:
- `onePingPerChannel`
- `hideChannelListShortcuts`
- `splitLongMessagesPlus` (polished variant)

Use the upstream-safe split plugin instead:

```powershell
.\install.ps1 -VencordPath "C:\path\to\Vencord" -SplitVariant upstream
```

Install and build:

```powershell
.\install.ps1 -VencordPath "C:\path\to\Vencord" -Build
```

Install, build, and run Vencord installer/reinject script:

```powershell
.\install.ps1 -VencordPath "C:\path\to\Vencord" -Build -Reinject
```

## Update after editing plugins here

```powershell
.\update.ps1 -VencordPath "C:\path\to\Vencord" -Build
```

## Notes

- This does not bypass Vencord's build step; it automates copying plugins into a Vencord source tree.
- Target Vencord repo should already have dependencies installed (`pnpm install`).
