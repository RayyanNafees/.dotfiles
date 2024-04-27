if ((Get-Location | Format-Wide -Property Path) -ne 'D:\.dotfiles'){
	Set-Location 'D:\.dotfiles'
}


'Exporting dotfiles...'
scoop export > scoop.json
'✅ Scoop exported'
cat $profile > '$profile.ps1'
'✅ Powershell $profile exported'
lsd C:\Users\nafee\scoop\apps\python\current\Scripts > pyscripts.txt
'✅ Python installed scripts exported'
lsd F:\packages\go\bin > goscripts.txt
'✅ Golang installed scripts exported'
gh extension list > gh-ext.txt
'✅ Github CLI extensions exported'
pnpm list -g > pnpm-global.txt
'✅ pnpm global scripts exported'
lsd C:/Tools > tools.txt
'✅ Global C:/Tools exe(s) exports'
cat "$nupath/config.nu" > nushell/config.nu
cat "$nupath/env.nu" > nushell/env.nu
'✅ NuShell config files exported'
cp $icons Custom-Icons
'✅ Custom-Icons exported'

'

		  Commiting Changes to Github 

'
git status
git add .
git commit -am "synced!"
git push
