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

'

		Commiting Changes to Github

'

git add .
git commit -am "synced!"
git push
