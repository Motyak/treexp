#!/bin/sh

set -o nounset

# file used for the tree building
file=$1
dir=${file%.txt}

mkdir -p "$dir"

cur_line_nb=1
line=$(sed -n "${cur_line_nb}p" < "$file")

while [ -n "$line" ]; do
    filename=$(echo "$line" | awk '{print $1}')
    nb_of_lines_to_read=$(echo "$line" | awk '{print $2}')

    to_copy=$(sed -n "$((cur_line_nb + 1)),$((cur_line_nb + nb_of_lines_to_read))p" < "$file")

    # for files with trailing newline, we add an extra newline to be consumed later on
    [ $nb_of_lines_to_read != $(echo "$to_copy" | wc -l) ] && to_copy="$to_copy\n"

    # print file by removing trailing newline
    echo "$to_copy\c" > "$dir/$filename"

    cur_line_nb=$((cur_line_nb + nb_of_lines_to_read + 1))
    line=$(sed -n "${cur_line_nb}p" < "$file")
done
