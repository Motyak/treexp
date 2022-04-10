#!/bin/sh

# directory name with a trailing '/'
dir=$1
res=''

for f in $dir*; do
    nb_of_lines=$(wc -l < $f)
    res="${res}./${f#$dir} $((nb_of_lines + 1))\n$(cat $f)\n"
    [ "$(tail -c1 $f)" = "" ] && res="$res\n"
done

echo "$res" > ${dir%/}.txt
