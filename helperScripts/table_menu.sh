#!/bin/bash

# $1 is passed from dbms.sh
CURRENT_DB="$1"
helperScripts="./helperScripts"
DB_NAME=$(basename "$CURRENT_DB")

while true; do
    clear
    echo "=============================="
    echo "   DATABASE: $DB_NAME"
    echo "=============================="
    echo "1. Create Table"
    echo "2. List Tables"
    echo "3. Drop Table"
    echo "4. Insert Into Table"
    echo "5. Select From Table"
    echo "6. Delete From Table"
    echo "7. Update Table"
    echo "8. Back To Main Menu"
    echo "=============================="
    read -p "Enter Choice: " choice

    case $choice in
        1) 
            clear
            echo "=== Create Table ==="
            "$helperScripts/create_table.sh" "$CURRENT_DB" 
            ;;
        2) 
            clear
            # Now calls the new list_tables.sh script
            "$helperScripts/list_tables.sh" "$CURRENT_DB"
            ;;
        3) 
            clear
            echo "=== Drop Table ==="
            read -p "Enter Table Name to Drop: " tName
            if [[ -f "$CURRENT_DB/$tName" ]]; then
                rm "$CURRENT_DB/$tName"
                echo "Table Dropped."
            else
                echo "Table not found."
            fi
            read -p "Press Enter..."
            ;;
        4) 
            clear
            echo "=== Insert Data ==="
            "$helperScripts/insert.sh" "$CURRENT_DB" 
            ;;
        5) 
            clear
            "$helperScripts/select.sh" "$CURRENT_DB" 
            ;;
        6) 
            clear
            echo "=== Delete Data ==="
            "$helperScripts/delete.sh" "$CURRENT_DB" 
            ;;
        7) 
            clear
            echo "=== Update Data ==="
            "$helperScripts/update.sh" "$CURRENT_DB" 
            ;;
        8) exit 0 ;; # Returns control to dbms.sh
        *) echo "Invalid Option"; read -p "Press Enter..." ;;
    esac
done