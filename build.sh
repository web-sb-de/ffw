#!/bin/bash

# Deploy Script für  Hugo Website
# Dieses Skript führt die folgenden Schritte aus:
# 1. Bilder in WebP konvertieren (falls nicht vorhanden)
# 2. Überprüfen, ob WebP-Bilder > 150KB sind (abbruch bei Überschreitung)
# 3. Nicht-WebP-Bilder löschen
# 4. Public-Ordner löschen
# 5. Hugo Mod tidy ausführen
# 6. Hugo Build ausführen

set -e  # Skript bei Fehlern abbrechen

echo "Starte Deploy-Prozess..."

# Schritt 1: Bilder komprimieren (überschreibe WebP)
echo "Konvertiere Bilder zu WebP..."
find content -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) -exec sh -c 'output="${1%.*}.webp"; cwebp -q 80 "$1" -o "$output";' _ {} \;

# Schritt 2: Überprüfe Größe der WebP-Bilder
echo "Überprüfe WebP-Bildgrößen..."
for file in $(find content -name "*.webp"); do
    # Größe in Bytes ermitteln (macOS: stat -f%z, Linux: stat -c%s)
    size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null || echo "0")
    if [ "$size" -gt 1536000 ]; then  # 150KB = 153600 Bytes
        echo "FEHLER: Bild $file ist größer als 150KB ($size Bytes). Abbruch."
        exit 1
    fi
done
echo "Alle WebP-Bilder sind ≤ 150KB."

# Schritt 3: Nicht-WebP-Bilder löschen
echo "Lösche nicht-WebP-Bilder..."
find . -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.bmp" \) -delete

# Schritt 4: Public-Ordner löschen
echo "Lösche public-Ordner..."
rm -rf public

# Schritt 5: Hugo Mod tidy
echo "Führe hugo mod tidy aus..."
hugo mod tidy

# Schritt 6: Hugo Build
echo "Führe Hugo Build aus..."
hugo  --minify

echo "Deploy erfolgreich abgeschlossen!"

# Schritt 7: Git add, commit und push
echo "Führe git add . aus..."
git add .

echo "Führe git commit aus..."
git commit -m "Deploy update"

echo "Führe git push aus..."
git push

echo "Git-Operationen abgeschlossen!"

# Zusätzliche Hugo-Befehle (nicht Teil des Deploy-Skripts, nur als Referenz):
# Lokaler Server:
# hugo server --bind 0.0.0.0 --baseURL http://$(hostname -I | awk '{print $1}'):1313