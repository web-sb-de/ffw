# TODO-Liste: Domain-Registrierung und Hugo-Deployment auf Cloudflare Pages

## 1. Namecheap / Porkbun

- Domain registrieren
- DNS auf Cloudflare umstellen

```
brenna.ns.cloudflare.com
yahir.ns.cloudflare.com
```

## Github / Terminal

- Neues Git Repo erstellen

cd ~/Documents/software/
NAME=test-repo;
gh repo create $NAME --private && 
git clone https://github.com/sbbrnnr123/web-sb-demo.git $NAME && 
cd $NAME && 
git remote set-url origin https://github.com/sbbrnnr123/$NAME.git &&
git push -u origin main

## Cloudflare

- Domain umziehen
- DNS
- robots.txt
- Pages (Git verlinken)
- Custom domains

## 3. Hugo Projekt

- hugo.json
- wrangler.toml
- footer.html
- impressum.html
- /content befüllen
- /content Bilder komprimieren
- ./build.sh

## 7. Tests und Monitoring

- Website testen
- Monitoring aktivieren
