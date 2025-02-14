#!/usr/bin/env bash
# Usage: ./run_ask_queries.sh /path/to/queries [--debug]

# GraphDB endpoint URL
GDB_URL="http://localhost:7200/repositories/underpin"

# Directory containing SPARQL ASK queries
QUERY_DIR="test"
OUT_DIR="ontorefine-gdb-load"
echo "RUNNING tests..."
# Check if the --debug flag is set
DEBUG=false
if [[ "$1" == "--debug" ]]; then
    DEBUG=true
    echo "DEBUG mode, failed test will not stop process!"
fi

# Ensure the query directory is provided and exists
if [[ -z "$QUERY_DIR" || ! -d "$QUERY_DIR" ]]; then
    echo "Error: Query directory not specified or does not exist."
    exit 1
fi

# Iterate over all .rq files in the specified directory
for query_file in "$QUERY_DIR"/*.rq; do
    # Extract the query filename
    query_name=$(basename "$query_file")

    # Execute the SPARQL ASK query
    response=$(curl -s -X POST -H "Content-Type: application/sparql-query" --data-binary "@$query_file" "$GDB_URL")

    # Check if the response contains "true" or "false"
    if echo "$response" | grep -q "true"; then
        echo "OK: $query_name"
    else
        echo "ERROR: $query_name"
        # Exit if not in debug mode
        if [ "$DEBUG" = false ]; then
            exit 1
        fi
    fi
done

touch "$OUT_DIR/tests.ok"