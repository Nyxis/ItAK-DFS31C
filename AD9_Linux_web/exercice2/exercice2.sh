#!/bin/bash

# Define timestamp and output file name
timestamp=$(date +"%Y%m%d-%H%M%S")
output_file="500-${timestamp}.log"

# Find all .txt files in the current directory and its subdirectories
listTxt=$(find . -name "*.txt")

# Loop through each file and search for "500", append results to the output file
for file in $listTxt
do
    grep "500" "$file" >> "$output_file"
done
