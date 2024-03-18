scoop export > scoop.json
cat $profile > '$profile.ps1'
lsd C:\Users\nafee\scoop\apps\python\current\Scripts > pyscripts.txt
lsd F:\packages\go\bin > goscripts.txt
gh extension list > gh-ext.txt
pnpm list -g > pnpm-global.txt


git add .
git commit -am "synced!"
git push
