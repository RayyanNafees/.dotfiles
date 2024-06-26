# Current Working Directory
$cwd = pwd

if ($cwd -ne 'D:\.dotfiles'){
	cd 'D:\.dotfiles'
}


'Exporting dotfiles...'
scoop export > scoop.json
'✅ Scoop exported'
winget export -o winget.json
'✅ Winget exported'
cat $profile > '$profile.ps1'
'✅ Powershell $profile exported'
lsd C:\Users\nafee\scoop\apps\python\current\Scripts > pyscripts.txt
'✅ Python installed scripts exported'
lsd F:\packages\go\bin > goscripts.txt
'✅ Golang installed scripts exported'
lsd C:\Eget > eget.txt
gh extension list > gh-ext.txt
'✅ Github CLI extensions exported'
pnpm list -g > pnpm-global.txt
'✅ pnpm global scripts exported'
lsd C:/Tools > tools.txt
'✅ Global C:/Eget exe(s) exports'
cat "$nupath/config.nu" > nushell/config.nu
cat "$nupath/env.nu" > nushell/env.nu
'✅ NuShell config files exported'
cp $icons Custom-Icons
'✅ Custom-Icons exported'
cp ~\AppData\Roaming\aichat\config.yaml aichat
'✅ AIchat config exported'
lsd "$env:LocalAppData\Microsoft\PowerToys\PowerToys Run\Plugins" > tools.txt
'✅ PowerToys Run plugins exported'
'

		  Commiting Changes to Github 

'
git status
git add .
git commit -am @args
git push

cd $cwd
'✨ Changes Pushed ✨'
