#!/bin/bash

# Set the expected configuration file path
CONFIG_FILE="google-sheets/config.yaml"

# Ensure an argument is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <csv_filename>"
    exit 1
fi

CSV_FILE="$1"
OUTPUT_DIR="google-sheets"

# Ensure the configuration file exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: Configuration file $CONFIG_FILE not found!"
    exit 1
fi

# Extract Google Sheet ID from YAML
SHEET_ID=$(grep "^sheet_id:" "$CONFIG_FILE" | awk '{print $2}')

# Extract mappings from YAML (associative array)
declare -A SHEETS
while IFS=":" read -r key value; do
    key=$(echo "$key" | xargs)    # Trim whitespace
    value=$(echo "$value" | xargs) # Trim whitespace
    SHEETS["$key"]="$value"
done < <(awk '/sheets:/ {flag=1; next} flag' "$CONFIG_FILE")

# Ensure requested file exists in the mappings
NAME="${CSV_FILE%.csv}"  # Remove `.csv` extension
GID="${SHEETS[$NAME]}"

if [ -z "$GID" ]; then
    echo "Error: No matching entry for $CSV_FILE in $CONFIG_FILE"
    exit 1
fi

# Ensure the output directory exists
mkdir -p "$OUTPUT_DIR"

# Download the specific CSV file
OUTPUT_PATH="$OUTPUT_DIR/$CSV_FILE"
echo "... Downloading $CSV_FILE to $OUTPUT_PATH..."

curl -L "https://docs.google.com/spreadsheets/d/${SHEET_ID}/export?format=csv&gid=${GID}" -o "$OUTPUT_PATH"

if [ $? -eq 0 ]; then
    echo "... Downloaded $CSV_FILE successfully."
else
    echo "FAILED to download $CSV_FILE."
    exit 1
fi