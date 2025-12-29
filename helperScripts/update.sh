#!/bin/bash

DB_PATH="$1"
read -p "Enter Table Name: " tName
FILE="$DB_PATH/$tName"

if [[ ! -f "$FILE" ]]; then
    echo "Table not found."
    read -p "Press Enter..."
    exit
fi

pkName=$(sed -n '3p' "$FILE")
read -p "Enter Value for PK ($pkName) to update: " pkVal

cols=$(sed -n '1p' "$FILE")
IFS=':' read -r -a colArray <<< "$cols"
pkIndex=-1
for i in "${!colArray[@]}"; do
    if [[ "${colArray[$i]}" == "$pkName" ]]; then
        pkIndex=$i
    fi
done
awkIndex=$((pkIndex+1))

if ! tail -n +4 "$FILE" | cut -d: -f$awkIndex | grep -w -q "$pkVal"; then
    echo "Error: Record with PK $pkVal not found."
    read -p "Press Enter..."
    exit
fi

types=$(sed -n '2p' "$FILE")
IFS=':' read -r -a typeArray <<< "$types"

newRow=""
sep=":"
echo "Enter new values:"

for i in "${!colArray[@]}"; do
    cName="${colArray[$i]}"
    cType="${typeArray[$i]}"

    if [[ $i -eq $pkIndex ]]; then
        echo "$cName ($cType): $pkVal (Cannot change PK)"
        val="$pkVal"
    else
        while true; do
            read -p "New value for $cName ($cType): " val
            if [[ "$cType" == "int" ]]; then
                if ! [[ "$val" =~ ^[0-9]+$ ]]; then
                    echo "Error: Invalid Integer."
                    continue
                fi
            fi
            break
        done
    fi

    if [[ -z "$newRow" ]]; then
        newRow="$val"
    else
        newRow="$newRow$sep$val"
    fi
done

awk -F: -v idx="$awkIndex" -v search="$pkVal" -v new="$newRow" '
    NR<=3 {print $0}
    NR>3  {
        if ($idx == search) print new;
        else print $0;
    }
' "$FILE" > "$FILE.tmp" && mv "$FILE.tmp" "$FILE"

echo "Row Updated."
read -p "Press Enter..."