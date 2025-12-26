#!/bin/bash

## Welcome to Team 9's Bash Shell Script Database Management System (DBMS)
###########################################################################
    ################ By Mohammed Ali & Ziad Khattab ################
###########################################################################

DB_DIR="./Databases"
CORE="./core" ## Helper Scripts location
mkdir -p "$DB_DIR" #Main storage creation
chmod +x "$CORE"/*.sh 2>dev/null

currentDB="" # Variable that tracks the currently connected DB

while true
do
    echo "#################################"
    echo "########### MAIN MENU ###########"
    echo "#################################"
    echo ""
    echo "1) Create DB"
    echo "2) List DataBases"
    echo "3) Connect To Database"
    echo "4) Drop Database" 
    echo "5) exit"
    

        read -p "Choose option from [1 to 5] " ch

    case $ch in 
    1)
        read -p "DB Name: " db
        mkdir "$DB_DIR/$db" 2>/dev/null && echo "DB Created" || echo "DB Already Exists!!"
        ;;
    2)
        ls "$DB_DIR"
        ;;
    3)
        read -p "Enter DB Name to connect to it: " db
        if [[ -d "$DB_DIR/$db" ]]; then
            cd "$DB_DIR/$db" || exit
            source ../../Table_Menu.sh
            cd - >/dev/null
        else
            echo "Database Not Found !!!"
        fi
        ;;
    4)
        read -p "Enter Database Name to Drop: " db
        if [[ -d "$DB_DIR/$db" ]]; then
            read -p "Do you really want to delete '$db'? (y/n) " confirm
            if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
                rm -rf "$DB_DIR/$db"
                echo "Database '$db' Deleted Successfully!!"
            else
                echo "Deletion Cancelled !"
            fi
        else
            echo "Error: Database '$db' Not Found. "
        fi
        ;;
    5)
        exit
        ;;
    *)
        echo "Invalid Choice !!!"
        ;;
    esac
done