#!/bin/bash

INPUT="gsxtrack.json"
OUTPUT="titik-penting.txt"

> "$OUTPUT"

ids=$(grep -oP '"id":\s*"\K[^"]+' "$INPUT")
names=$(grep -oP '"site_name":\s*"\K[^"]+' "$INPUT")
lats=$(grep -oP '"latitude":\s*\K[-0-9.]+' "$INPUT")
lons=$(grep -oP '"longitude":\s*\K[-0-9.]+' "$INPUT")

IFS=$'\n' read -r -d '' -a arr_ids   <<< "$ids"
IFS=$'\n' read -r -d '' -a arr_names <<< "$names"
IFS=$'\n' read -r -d '' -a arr_lats  <<< "$lats"
IFS=$'\n' read -r -d '' -a arr_lons  <<< "$lons"

for i in "${!arr_ids[@]}"; do
    echo "${arr_ids[$i]},${arr_names[$i]},${arr_lats[$i]},${arr_lons[$i]}" >> "$OUTPUT"
done

echo "Parsing selesai. Hasil disimpan di $OUTPUT"
cat "$OUTPUT"
