#!/bin/bash
for i in {1..20}; do
  if [ $i -le 10 ]; then
    echo "Contenu du fichier log $i" > "log_file_$i.txt"
  else
    echo "Contenu du fichier $i" > "file_$i.txt"
  fi
done

