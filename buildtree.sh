#!/bin/sh

# file used for the tree building
file=$1
dir=${file%.txt}

mkdir -p $dir

cur_line_nb=1
line=$(sed -n "${cur_line_nb}p" < $file)

while [ "$line" != "" ]; do
    filename=$(echo "$line" | sed -E 's/^\.\/(.*) [0-9]+$/\1/gm')
    nb_of_lines_to_read=$(echo "$line" | sed -E 's/^\.\/.* ([0-9]+)$/\1/gm')

    to_copy=$(sed -n "$((cur_line_nb + 1)),$(($cur_line_nb + $nb_of_lines_to_read))p" < $file)
    [ $nb_of_lines_to_read != $(echo "$to_copy" | wc -l) ] && to_copy="$to_copy\n"

    echo -n "$to_copy" > $dir/$filename

    cur_line_nb=$(($cur_line_nb + $nb_of_lines_to_read + 1))
    line=$(sed -n "${cur_line_nb}p" < $file)
done
