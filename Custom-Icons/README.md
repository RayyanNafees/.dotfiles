# Custom Icons
Custom files & folder icons defined to be used with [terminal-icons](https://github.com/devblackops/Terminal-Icons)
for `MonoLisa` font within Windows 11 Terminal

## Setup

```sh
scoop install terminal-icons
```

Move the files into `~/OneDrive/Documents/PowerShell/Modules/Custom-Icons/Custom-Icons.psm1` folder
and do the following changes to `$profile`

```pwsh
Import-Module Terminal-Icons
Import-Module Custom-Icons # Must import AFTER "Terminal-Icons"

# VARIABLES
$icons = '~/OneDrive/Documents/PowerShell/Modules/Custom-Icons/Custom-Icons.psm1'
```

## Usage

Head-over to nerd-fonts' icons cheatsheet to find more fonts: https://www.nerdfonts.com/cheat-sheet

Currently the following iconsets are supported for `MonoLisa NF Mono` font:
- ✅ nf-dev
- ✅ nf-seti
- ✅ nf-md
- ✅ nf-fae

And the following iconsets dont seem to work with `MonoLisa NF Mono`: 
- ❌ nf-fa
- ❌ nf-mdi
> Test them out on a different font, namely `CaskaydiaCove Nerd Font` in this [gist](https://gist.github.com/markwragg/6301bfcd56ce86c3de2bd7e2f09a8839)

Now edit the Custom-Icons file for defining nf icons for folders/files `micro $icons`:

```pwsh
Set-TerminalIconsIcon -Directory Workers -Glyph nf-md-cloud

# Usage
Set-TerminalIconsIcon -FileExtension <string> -Glyph <string>

Set-TerminalIconsIcon -FileName <string> -Glyph <string>

Set-TerminalIconsIcon -Directory <string> -Glyph <string>
```

For seeing the changes rerun the shell with `pwsh`, `zsh`, `sh`, `nu` etc commands
doesn't seem to work when doing `. $profile`


## Todo:

- [ ] Figure out what `Set-TerminalIconsIcon -NewGlyph <string> -Glyph <string>` does
- [ ] Checkout & experiment with the working of `Set-TerminalIconsTheme` functionality and see if that turns out to be a better use case

