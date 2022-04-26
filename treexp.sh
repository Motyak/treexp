#!/bin/sh

set -o nounset

# directory name with one trailing '/'
dir=$1
res=

for f in "$dir"*; do
    nb_of_lines=$(wc -l < "$f")
    res="$res./${f#"$dir"} $((nb_of_lines + 1))\n$(cat "$f")\n"
    # if file ends with trailing newline, add it before returning to line
    [ -z "$(tail -c1 "$f")" ] && res="$res\n"
done

# we get rid of the last '\n' written in $res
echo "$res\c" > "${dir%/}".txt
