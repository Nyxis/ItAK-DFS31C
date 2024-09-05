#!/bin/bash
# Commande pour rechercher uniquement les fichiers contenant "log" dans leur nom et les compter
echo "Résultat de 'find -type f -name \"*log*\" | wc -l':"
find . -type f -name "*log*" | wc -l
