#!/bin/bash

DB_PATH="$1"
BIN_DIR=$(dirname "$0")

if [ -z "$(ls -A "$DB_PATH")" ]; then
    echo "No tables found in database."
    read -p "Press Enter..."
    exit
fi

echo "=== List of Tables ==="
ls "$DB_PATH"
echo "======================"

read -p "Do you want to view a table from the list? (y/n): " choice

if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
    # Call the existing select.sh script
    # We pass the DB_PATH, and select.sh will ask for the table name
    "$BIN_DIR/select.sh" "$DB_PATH"
else
    read -p "Press Enter to return..."
fi