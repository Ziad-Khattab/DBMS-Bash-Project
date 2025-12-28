#!/bin/bash

DB_PATH="$1"

read -p "Enter Table Name: " tName

if [[ -f "$DB_PATH/$tName" ]]; then
    echo "Error: Table already exists."
    read -p "Press Enter..."
    exit
fi

if [[ ! "$tName" =~ ^[a-zA-Z0-9_]+$ ]]; then
    echo "Invalid table name."
    read -p "Press Enter..."
    exit
fi

read -p "Enter Number of Columns: " colNum

if ! [[ "$colNum" =~ ^[0-9]+$ ]]; then
    echo "Error: Must be a number."
    read -p "Press Enter..."
    exit
fi

metaData=""
typeData=""
pkName=""
sep=":"

for (( i=1; i<=colNum; i++ )); do
    echo "--- Column $i ---"
    read -p "Column Name: " cName
    
    echo "Select Type:"
    select type in "int" "string"; do
        case $type in
            int|string) break ;;
            *) echo "Invalid choice";;
        esac
    done

    if [[ -z "$pkName" ]]; then
        read -p "Is '$cName' the Primary Key? (y/n): " isPk
        if [[ "$isPk" == "y" || "$isPk" == "Y" ]]; then
            pkName="$cName"
        fi
    fi

    if [[ $i -eq 1 ]]; then
        metaData="$cName"
        typeData="$type"
    else
        metaData="$metaData$sep$cName"
        typeData="$typeData$sep$type"
    fi
done

if [[ -z "$pkName" ]]; then
    echo "Warning: No PK selected. Defaulting to first column."
    pkName=$(echo "$metaData" | cut -d: -f1)
fi

echo "$metaData" > "$DB_PATH/$tName"
echo "$typeData" >> "$DB_PATH/$tName"
echo "$pkName" >> "$DB_PATH/$tName"

echo "Table '$tName' created."
read -p "Press Enter..."