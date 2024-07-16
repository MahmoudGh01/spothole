#!/bin/bash

# Function to convert file name to lowercase
to_lowercase() {
  echo "$1" | tr '[:upper:]' '[:lower:]'
}

# Find all Dart files
find . -type f -name '*.dart' | while read -r file; do
  # Convert file name to lowercase
  lower_file=$(to_lowercase "$file")

  # If the lowercase file does not exist, rename it
  if [[ "$file" != "$lower_file" && ! -e "$lower_file" ]]; then
    mv "$file" "$lower_file"
  fi
done

# Replace import statements to match the new file names
find . -type f -name '*.dart' | while read -r file; do
  sed -i 's/import "\(.*\)"/import "\L\1"/g' "$file"
done
