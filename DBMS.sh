#!/bin/bash

## Welcome to Team Nine Telecom Application Development
#   _______  _______  _______  __   __    __    _  ___   __    _  _______ 
#  |       ||       ||       ||  |_|  |  |  |  | ||   | |  |  | ||       |
#  |_     _||    ___||   _   ||       |  |   |_| ||   | |   |_| ||    ___|
#    |   |  |   |___ |  |_|  ||       |  |       ||   | |       ||   |___ 
#    |   |  |    ___||       ||       |  |  _    ||   | |  _    ||    ___|
#    |   |  |   |___ |   _   || ||_|| |  | | |   ||   | | | |   ||   |___ 
#    |___|  |_______||__| |__||_|   |_|  |_|  |__||___| |_|  |__||_______|

#Bash Shell Script Database Management System (DBMS)

###########################################################################

    ################ By Mohammed Ali & Ziad Khattab ################

###########################################################################

# Configuration
DB_DIR="./DBMS"
helperScripts="./helperScripts"
mkdir -p "$DB_DIR"

# Check if helperScripts folder exists
if [[ ! -d "$helperScripts" ]]; then
    echo "Error: Directory '$helperScripts' not found."
    exit 1
fi

# Ensure executable permissions
chmod +x "$helperScripts"/*.sh 2>/dev/null

while true; do
    clear
    echo "#################################"
    echo "########### MAIN MENU ###########"
    echo "#################################"
    echo ""
    echo "1. Create Database"
    echo "2. List Databases"
    echo "3. Connect To Database"
    echo "4. Drop Database"
    echo "5. Exit"
    echo ""
    echo "#################################"
    echo ""
    read -p "Enter Choice: " choice

    case $choice in
        1) 
            clear
            echo "=== Create Database ==="
            read -p "Enter Database Name: " dbName
            # Validation: Alphanumeric only
            if [[ "$dbName" =~ ^[a-zA-Z0-9_]+$ ]]; then #if name matches this pattern of 1 or more char condition
                if [[ -d "$DB_DIR/$dbName" ]]; then
                    echo "Error: Database '$dbName' already exists."
                else
                    mkdir "$DB_DIR/$dbName"
                    echo "Database '$dbName' created successfully."
                fi
            else
                echo "Error: Invalid name. Use letters, numbers, and underscores only."
            fi
            read -p "Press Enter to return to menu..."
            ;;
        2) 
            clear
            echo "=== List of Databases ==="
            ls -F "$DB_DIR" | grep "/" | tr -d '/'
            echo "-------------------------"
            read -p "Press Enter to return to menu..."
            ;; 
        3) 
            clear
            echo "=== Connect To Database ==="
            read -p "Enter Database Name: " dbName
            
            # Check if DB exists
            if [[ -d "$DB_DIR/$dbName" ]]; then
                
                # Check if the script exists before calling it
                if [[ -f "$helperScripts/table_menu.sh" ]]; then
                    # Call the script
                    "$helperScripts/table_menu.sh" "$DB_DIR/$dbName"
                else
                    echo "Error: Script '$helperScripts/table_menu.sh' not found."
                    echo "Please check your folder structure."
                fi
                
            else
                echo "Error: Database '$dbName' not found."
            fi
            #This pause lets you see errors if the script fails to load
            read -p "Press Enter to return to menu..."
            ;;
        4) 
            clear
            echo "=== Drop Database ==="
            read -p "Enter Database Name to Drop: " dbName
            if [[ -d "$DB_DIR/$dbName" ]]; then
                read -p "Are you sure you want to delete '$dbName'? (y/n): " confirm
                if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
                    rm -r "$DB_DIR/$dbName"
                    echo "Database Deleted."
                else
                    echo "Deletion Cancelled."
                fi
            else
                echo "Error: Database not found."
            fi
            read -p "Press Enter to return to menu..."
            ;;
        5) 
            echo "Exiting..."
            exit 0 
            ;;
        *) 
            echo "Invalid Choice"
            read -p "Press Enter to return to menu..."
            ;;
    esac
done