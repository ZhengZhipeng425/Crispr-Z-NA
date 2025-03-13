#!/bin/bash

# This script is used to split each gene's good sgrnas and corresponding lfc to rows, just fitting to CRISPR-Cas9 screening sequences experiment, and data is analyzed by MAGeCk.

# Check if the input file is provided
if [ -z "$1" ]; then
    echo "Please provide the input file name (e.g., ./split-sgrna.sh input.csv output.csv)"
    exit 1
fi

# Check if the input file exists
if [ ! -f "$1" ]; then
    echo "Input file $1 does not exist!"
    exit 1
fi

# Check if the output file is provided
if [ -z "$2" ]; then
    echo "Please provide the output file name (e.g., ./split-sgrna.sh input.csv output.csv)"
    exit 1
fi

# Input file and output file
INPUT_FILE="$1"
OUTPUT_FILE="$2"

# Run awk to split the columns
awk -F',' '
BEGIN { OFS="," }
NR==1 { print "Gene_ID", "sgrna_ID", "sgrna_lfc"; next } 
{
    split($8, sgrna_ids, ";")   # Split sgrna IDs (column 8)
    split($9, sgrna_lfcs, ";")  # Split sgrna lfc (column 9)

    for (i=1; i<length(sgrna_ids); i++) {
        print $1, sgrna_ids[i], (i in sgrna_lfcs ? sgrna_lfcs[i] : "NA")
    }
}' "$INPUT_FILE" > "$OUTPUT_FILE"

echo "Processing complete, results saved to $OUTPUT_FILE"

