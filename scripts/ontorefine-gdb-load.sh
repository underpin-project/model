#!/bin/bash

# Ensure correct usage
if [ $# -ne 2 ]; then
    echo "Usage: $0 <csv_file> <transform_query>"
    exit 1
fi

CSV_FILE="$1"
TRANSFORM_QUERY="$2"
CONFIG_FILE="ontorefine-gdb-load/config.yaml"
OUTPUT_DIR="ontorefine-gdb-load/initial-data"
LOADED_FILE="$OUTPUT_DIR/$(basename "$CSV_FILE" .csv).loaded"

# Load configurations manually
ONTOREFINE_URL=$(grep '^ontorefine_url:' "$CONFIG_FILE" | awk '{print $2}')
GDB_URL=$(grep '^graphdb_url:' "$CONFIG_FILE" | awk '{print $2}')
ONTOREFINE_CLI=$(grep '^ontorefine_cli:' "$CONFIG_FILE" | awk '{print $2}')

# Prelimiary cleanup OntoRefine Project
$ONTOREFINE_CLI delete -u "$ONTOREFINE_URL" "data" >/dev/null 2>&1 || :

# Load CSV into OntoRefine
$ONTOREFINE_CLI create -a data -u "$ONTOREFINE_URL" -n "$(basename "$CSV_FILE")" "$CSV_FILE"
if [ $? -ne 0 ]; then
    echo "Failed to load CSV into OntoRefine"
    exit 1
fi

echo "CSV loaded into OntoRefine"

# Execute transformation query on GraphDB
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" -X POST -H "Content-Type: application/sparql-update" --data-binary "@$TRANSFORM_QUERY" "$GDB_URL")
if [ "$HTTP_CODE" -ne 204 ]; then
    echo "Failed to execute transformation query on GraphDB. HTTP Code: $HTTP_CODE"
    exit 1
fi

echo "Transformation query executed successfully on GraphDB"

# Cleanup OntoRefine Project
$ONTOREFINE_CLI delete -u "$ONTOREFINE_URL" "data"
if [ $? -ne 0 ]; then
    echo "Failed to delete OntoRefine project"
    exit 1
fi

echo "OntoRefine project cleaned up"

# Create loaded marker file
touch "$LOADED_FILE"
echo "Created marker file: $LOADED_FILE"