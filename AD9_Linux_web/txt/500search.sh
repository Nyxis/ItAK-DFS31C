#!/bin/bash

# Commande pour chercher les lignes contenant "500" dans tous les fichiers .txt et les consigner dans resultats.log
grep "500" *.txt > resultats.log

# Afficher un message de confirmation
echo "Les lignes contenant '500' ont été extraites et enregistrées dans resultats.log."
