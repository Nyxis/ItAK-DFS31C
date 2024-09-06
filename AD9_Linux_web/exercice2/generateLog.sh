#!/bin/bash

# Script for generating a txt file with random entries
# Generated with the help of chatGTP

# Define the output log file with timestamp
timestamp=$(date +"%Y%m%d-%H%M%S")
output_file="access-${timestamp}.txt"

# Number of lines in the log file
lines=500

# Function to generate a random IP address
generate_ip() {
    echo "$((RANDOM % 256)).$((RANDOM % 256)).$((RANDOM % 256)).$((RANDOM % 256))"
}

# Function to generate a random HTTP status code
generate_status() {
    # Define an array with possible status codes, heavily weighted towards 200
    status_codes=(200 200 200 200 200 200 200 200 200 200 404 500 301 302 403)
    echo "${status_codes[$RANDOM % ${#status_codes[@]}]}"
}

# Generate the log file
for ((i=1; i<=lines; i++)); do
    # Generate a random IP, date, HTTP method, URL, and HTTP version
    ip=$(generate_ip)
    datetime="[$(date +'%d/%b/%Y:%H:%M:%S %z')]"
    method=$(echo "GET POST PUT DELETE" | tr ' ' '\n' | shuf | head -n1)
    url="/$(echo "index.html about.html contact.html products.html" | tr ' ' '\n' | shuf | head -n1)"
    version="HTTP/1.1"

    # Generate a random HTTP status code
    status=$(generate_status)
    
    # Generate a random response size
    size=$((RANDOM % 5000 + 100))

    # Write the log entry to the file
    echo "$ip - - $datetime \"$method $url $version\" $status $size" >> $output_file
done

echo "$lines lines of log entries have been written to $output_file."