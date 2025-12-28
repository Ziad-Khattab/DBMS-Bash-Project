#!/bin/bash

DB_PATH="$1"
read -p "Enter Table Name: " tName
FILE="$DB_PATH/$tName"

if [[ ! -f "$FILE" ]]; then
    echo "Table not found."
    read -p "Press Enter..."
    exit
fi

cols=$(sed -n '1p' "$FILE")
types=$(sed -n '2p' "$FILE")
pkName=$(sed -n '3p' "$FILE")

IFS=':' read -r -a colArray <<< "$cols"
IFS=':' read -r -a typeArray <<< "$types"

pkIndex=-1
for i in "${!colArray[@]}"; do
    if [[ "${colArray[$i]}" == "$pkName" ]]; then
        pkIndex=$i
    fi
done

row=""
sep=":"

for i in "${!colArray[@]}"; do
    cName="${colArray[$i]}"
    cType="${typeArray[$i]}"

    while true; do
        read -p "Enter value for $cName ($cType): " val

        if [[ "$cType" == "int" ]]; then
            if ! [[ "$val" =~ ^[0-9]+$ ]]; then
                echo "Error: Invalid Integer."
                continue
            fi
        fi

        if [[ $i -eq $pkIndex ]]; then
            if tail -n +4 "$FILE" | cut -d: -f$((pkIndex+1)) | grep -w -q "$val"; then
                echo "Error: Primary Key '$val' already exists."
                continue
            fi
        fi
        
        break
    done

    if [[ -z "$row" ]]; then
        row="$val"
    else
        row="$row$sep$val"
    fi
done

echo "$row" >> "$FILE"
echo "Row Inserted."
read -p "Press Enter..."