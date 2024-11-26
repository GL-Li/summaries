#!/bin/bash

data_dir="$1"

echo "Print all .txt and .csv files in $data_dir and its subdirectories"

# list $data_dir and all its subdirectories recursively and then find
# .txt and .csv files in each directory. Typically use dir in place of aaa
# and fname in place of bbb.
find "$data_dir" -type d | while read aaa; do

  find "$aaa" -type f \( -name "*.csv" -or -name "*.txt" \) | while read bbb; do

    echo -e "\n$bbb =============="  # -e to enable \n
    cat "$bbb"

  done

done

echo "finished printing"
