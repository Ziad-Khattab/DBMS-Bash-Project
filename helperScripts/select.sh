#!/bin/bash

DB_PATH="$1"
read -p "Enter Table Name: " tName
FILE="$DB_PATH/$tName"

if [[ ! -f "$FILE" ]]; then
    echo "Table not found."
    read -p "Press Enter..."
    exit
fi

echo "======================================"
# Prints Header (Line 1) and Data (Lines 4+) formatted nicely
awk -F: '
    NR==1 { print "Columns: " $0; print "----------------------"; }
    NR>3  { print $0 }
' "$FILE" | column -t -s ':'

echo "======================================"
read -p "Press Enter..."