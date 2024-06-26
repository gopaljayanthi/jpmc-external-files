#!/bin/bash

# Function to ensure files end with a newline character
ensure_trailing_newline() {
    FILE=$1
    if [ -f "$FILE" ]; then
        # Check if the last character is a newline
        if [ "$(tail -c 1 "$FILE" | wc -l)" -eq 0 ]; then
            echo >> "$FILE"
        fi
    fi
}

# Function to create a ConfigMap YAML for a given directory
create_configmap() {
    DIRECTORY=$1
    CONFIGMAP_NAME=$(basename "$DIRECTORY")
    CONFIGMAP_DIR="$DIRECTORY/configmap"
    CONFIGMAP_FILE="$CONFIGMAP_DIR/$CONFIGMAP_NAME.yaml"

    # Create the configmap directory if it doesn't exist
    mkdir -p "$CONFIGMAP_DIR"

    # Start writing the ConfigMap YAML
    echo "apiVersion: v1
kind: ConfigMap
metadata:
  name: $CONFIGMAP_NAME
data:" > "$CONFIGMAP_FILE"

    # Append each file in the directory to the ConfigMap YAML
    for FILE in "$DIRECTORY"/*; do
        if [ -f "$FILE" ]; then
            ensure_trailing_newline "$FILE"
            FILENAME=$(basename "$FILE")
            echo "  $FILENAME: |" >> "$CONFIGMAP_FILE"
            sed 's/^/    /' "$FILE" >> "$CONFIGMAP_FILE"
        fi
    done

    echo "ConfigMap YAML has been created at $CONFIGMAP_FILE"
}

# Get the root directory of the GitHub repository
REPO_DIR=$1

# Check if the repository directory exists
if [ ! -d "$REPO_DIR" ]; then
    echo "Repository directory $REPO_DIR does not exist."
    exit 1
fi

# Iterate through each subdirectory in the repository directory
for DIR in "$REPO_DIR"/*; do
    if [ -d "$DIR" ]; then
        create_configmap "$DIR"
    fi
done
