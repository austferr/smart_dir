#!/bin/bash

dir_utility () {
  directory_path="$1"

  if [ ! -d "$directory_path" ]; then
    read -p "Directory '$directory_path' does not exist. Create it? (y/n): " create_choice
    case "$create_choice" in
      y|yes)
        mkdir "$directory_path"
        echo "Directory '$directory_path' created."
        ;;
      *)
        echo "Directory creation skipped."
        return 1 # Exit with error if directory creation is skipped
        ;;
    esac
  fi

  file_count=$(find "$directory_path" -type f | wc -l)

  total_size_raw=$(find "$directory_path" -type f -print0 | xargs -0 du -shc 2>/dev/null | tail -n 1)
  total_size=$(echo "$total_size_raw" | awk '{print $1}')

  if [ $? -ne 0 ]; then
    echo "Error: Could not calculate total size (possible permission issues)."
    total_size="N/A"
  fi

  echo "Directory Information for: $directory_path"
  echo "========================================"
  echo "Total Number of Files: $file_count"
  echo "Total Size: $total_size"
  echo "========================================"

  if [ "$file_count" -gt 0 ]; then
    echo "Files and Directories:"
    ls -l "$directory_path"
  else
    echo "Directory is empty."
  fi
}


if [ -n "$1" ]; then
  dir_utility "$1"
else
  read -p "Enter the directory path: " user_input
  dir_utility "$user_input"
fi