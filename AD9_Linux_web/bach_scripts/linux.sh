
# Exercice 1 : Filtrer et compter les lignes
echo "Exercice 1 :"
ls -a | grep "log" | wc -l # tous les fichiers et dossiers
find . -type f -name "*log*" | wc -l # seulement les fichiers

# "screenshot1.png" 

# Exercice 2 : Rechercher un motif
echo "Exercice 2 :"
find . -type f -name "*.txt" -print0 | xargs -0 grep "500" > resultats.log
cat resultats.log

# "screenshot2.png" 2

# Exercice 3 : Déplacer des fichiers
echo "Exercice 3 :"
mkdir -p images
find . -type f -name "*.jpeg" -print0 2>/dev/null | xargs -0 -I {} mv -v {} images/ 2>/dev/null

# "screenshot3.png" 3

echo "Toutes les commandes ont été exécutées. Vérifiez les résultats dans le fichier linux.sh."
