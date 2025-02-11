#!/bin/bash

# Set the Google Sheet ID (Replace with your actual Sheet ID)
SHEET_ID="1wnnq20RinFOLhFjg-QiOcYo9XsisZ3ZaPwzq2G5_ogU"
ONTOREFINE_URL="http://localhost:7333"  # Replace with your OntoRefine instance URL if different
ONTOREFINE_CLI="ontorefine-cli"
GDB_URL="http://localhost:7200/repositories/underpin/statements"
RIOT=riot

# Declare an associative array with sheet names and their GIDs
declare -A SHEETS
SHEETS=(
    ["schema-refinery"]="870089929"
    ["schema-refinery-result-anomaly"]="699616734"
    ["schema-windfarm"]="1189930306"
    ["schema-windfarm-ait"]="769197706"
    ["schema-windfarm-generator2"]="2142433981"
    ["schema-windfarm-result"]="1862782183"
    ["dataset"]="1341812003"
)

# Create a folder for downloaded sheets (optional)
OUTPUT_DIR="csv"
mkdir -p "$OUTPUT_DIR"

# Loop through the sheets and download each as a CSV file

$ONTOREFINE_CLI delete -u "$ONTOREFINE_URL" "data"
curl -X POST -H "Content-Type: application/sparql-update" --data "CLEAR ALL" "$GDB_URL"

for SHEET_NAME in "${!SHEETS[@]}"; do
    GID="${SHEETS[$SHEET_NAME]}"
    OUTPUT_FILE="$OUTPUT_DIR/${SHEET_NAME}.csv"

    echo "... Downloading $SHEET_NAME to $OUTPUT_FILE..."

    curl -L "https://docs.google.com/spreadsheets/d/${SHEET_ID}/export?format=csv&gid=${GID}" -o "$OUTPUT_FILE"

    if [ $? -eq 0 ]; then
        echo "... Downloaded $SHEET_NAME successfully."
         # Load the CSV into OntoRefine
                echo "... Loading $SHEET_NAME into OntoRefine..."

                $ONTOREFINE_CLI create -u "$ONTOREFINE_URL" -n "$SHEET_NAME" -a "data" "$OUTPUT_FILE"
                if [ $? -eq 0 ]; then
                    echo "... $SHEET_NAME loaded into OntoRefine successfully."
         # Send query to GraphDB
                    QUERY_NAME="${SHEET_NAME}.ru"
                    echo "... Sending query to GraphDB with name $QUERY_NAME..."

                    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" -X POST -H "Content-Type: application/sparql-update" \
                                    --data-binary "@$QUERY_NAME" \
                                    "$GDB_URL")
                    if [ "$HTTP_CODE" -eq 204 ]; then
                            echo "... Query $QUERY_NAME executed successfully."

                            # Delete the OntoRefine project
                            echo "... Deleting OntoRefine project $SHEET_NAME..."
                            $ONTOREFINE_CLI delete -u "$ONTOREFINE_URL" "data"

                            if [ $? -eq 0 ]; then
                                echo "... OR project deleted successfully."
                            else
                                echo "FAILED to delete OR project"
                                break
                            fi
                        else
                            echo "FAILED to execute query $QUERY_NAME on GraphDB. CODE $HTTP_CODE"
                            break
                        fi
                else
                    echo "FAILED to load $SHEET_NAME into OntoRefine."
                    break
                fi
    else
        echo "FAILED to download $SHEET_NAME."
        break
    fi
done

# Execute queries in updates.ru
QUERY_FILE=updates.ru
if [ -f "$QUERY_FILE" ]; then
    echo "... Executing query $QUERY_FILE on GraphDB..."
    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" -X POST -H "Content-Type: application/sparql-update" \
                    --data-binary "@$QUERY_FILE" \
                    "$GDB_URL")
    if [ "$HTTP_CODE" -eq 204 ]; then
        echo "... Query $QUERY_FILE executed successfully."
    else
        echo "FAILED to execute query $QUERY_FILE on GraphDB. HTTP CODE $HTTP_CODE"
        break
    fi
fi



curl -X GET -H "Accept:application/x-trig" "$GDB_URL" > tmp.trig
if [ $? -eq 0 ]; then
  sed '/###/q' prefixes.ttl | cat - tmp.trig | $RIOT --base https://dataspace.underpinproject.eu/ --syntax trig --formatted trig > out/schema-dataset.trig
  cat  ./out/*.trig | $RIOT --base https://dataspace.underpinproject.eu/ --syntax trig --formatted trig > out/dataspace.trig
  zip -j "out/dataspace.zip" "out/dataspace.trig"
  rm out/dataspace.trig

  echo "... Done! Exporting GDB repository!"
else
  echo "FAILED to download data!"
fi

echo "DONE ALL"