#!/bin/bash

# Make the script executable
chmod +x "$0"

# Create a directory for our demo files and results
DEMO_DIR="$HOME/script_demo"

# Function to create a new section in the output file
create_section() {
    echo -e "\n\n=== $1 ===" >> "$DEMO_DIR/output.txt"
    echo "$2" >> "$DEMO_DIR/output.txt"
}

# Clean up any existing demo directory and create a fresh one
rm -rf "$DEMO_DIR"
mkdir -p "$DEMO_DIR"

# Initialize the output file
echo "Script Demo Results" > "$DEMO_DIR/output.txt"
echo "===================" >> "$DEMO_DIR/output.txt"

# Part 1: Filtering and counting lines
create_section "Part 1: Filtering and counting lines" "This section demonstrates listing files, filtering for 'log', and counting the results."

mkdir -p "$DEMO_DIR/part1"
touch "$DEMO_DIR/part1/access.log" "$DEMO_DIR/part1/error.log" "$DEMO_DIR/part1/system.log" "$DEMO_DIR/part1/random.txt"

echo "Listing all files:" >> "$DEMO_DIR/output.txt"
ls "$DEMO_DIR/part1" >> "$DEMO_DIR/output.txt"

echo -e "\nFiles containing 'log':" >> "$DEMO_DIR/output.txt"
ls "$DEMO_DIR/part1" | grep "log" >> "$DEMO_DIR/output.txt"

echo -e "\nCount of files containing 'log':" >> "$DEMO_DIR/output.txt"
ls "$DEMO_DIR/part1" | grep "log" | wc -l >> "$DEMO_DIR/output.txt"

# Part 2: Searching for a pattern
create_section "Part 2: Searching for a pattern" "This section demonstrates searching for '500' in .txt files and logging the results."

mkdir -p "$DEMO_DIR/part2"
echo "Error 500: Internal Server Error" > "$DEMO_DIR/part2/errors.txt"
echo "Everything is fine" > "$DEMO_DIR/part2/status.txt"
echo "Another 500 error occurred" >> "$DEMO_DIR/part2/errors.txt"

echo "Searching for '500' in .txt files:" >> "$DEMO_DIR/output.txt"
grep -n "500" "$DEMO_DIR/part2"/*.txt >> "$DEMO_DIR/part2/results.log"
cat "$DEMO_DIR/part2/results.log" >> "$DEMO_DIR/output.txt"

# Part 3: Moving files
create_section "Part 3: Moving files" "This section demonstrates finding .jpeg files and moving them to an 'images' folder."

mkdir -p "$DEMO_DIR/part3/subdir"
touch "$DEMO_DIR/part3/photo1.jpeg" "$DEMO_DIR/part3/document.txt" "$DEMO_DIR/part3/subdir/photo2.jpeg"

echo "Initial directory structure:" >> "$DEMO_DIR/output.txt"
find "$DEMO_DIR/part3" -type f >> "$DEMO_DIR/output.txt"

mkdir -p "$DEMO_DIR/part3/images"
find "$DEMO_DIR/part3" -name "*.jpeg" -exec mv {} "$DEMO_DIR/part3/images" \;

echo -e "\nDirectory structure after moving .jpeg files:" >> "$DEMO_DIR/output.txt"
find "$DEMO_DIR/part3" -type f >> "$DEMO_DIR/output.txt"

echo -e "\nScript execution complete. Results are available in $DEMO_DIR/output.txt"