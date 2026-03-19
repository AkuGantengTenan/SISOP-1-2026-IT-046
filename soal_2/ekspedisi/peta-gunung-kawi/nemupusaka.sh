#!/bin/bash

INPUT="titik-penting.txt"
OUTPUT="posisipusaka.txt"

# Ambil koordinat diagonal (node_001 dan node_003)
lat1=$(awk -F',' 'NR==1 {print $3}' "$INPUT")
lon1=$(awk -F',' 'NR==1 {print $4}' "$INPUT")

lat3=$(awk -F',' 'NR==3 {print $3}' "$INPUT")
lon3=$(awk -F',' 'NR==3 {print $4}' "$INPUT")

# Hitung titik tengah diagonal
lat_pusat=$(echo "scale=10; ($lat1 + $lat3) / 2" | bc)
lon_pusat=$(echo "scale=10; ($lon1 + $lon3) / 2" | bc)

echo "Koordinat pusat: $lat_pusat,$lon_pusat"
echo "$lat_pusat,$lon_pusat" > "$OUTPUT"

echo "Hasil disimpan di $OUTPUT"
