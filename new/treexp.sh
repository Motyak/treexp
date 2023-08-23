#!/bin/bash
# shellcheck disable=SC2317

# set -o xtrace

function process_file {
    local file="$1"

    [ -e "$file" ] || {
        >&2 echo "file \`$file\` is inaccessible"
        return 1
    }

    [ -d "$file" ] && {
        process_dir "$file"; return $?
    }

    [ -f "$file" ] && {
        process_regular_file "$file"; return $?
    }

    return 0 # file shouldn't be handled
}

function is_a_textual_file {
    local file="$1"

    [ -f "$file" ] && file --mime-encoding "$file" | grep -qv "binary"
}

function process_regular_file {
    local regular_file="$1"

    is_a_textual_file "$regular_file" && {
        local res=""
        local nb_of_lines="$(wc -l < "$regular_file")"
        echo "$regular_file $((nb_of_lines + 1))"
        cat "$regular_file"
        echo ""
        # if file ends with trailing newline, add it before returning to line
        [ "$(tail -c1 "$regular_file")" == $'\n' ] && echo ""
    }

    return 0 # file shouldn't be handled
}

function process_dir {
    local dir="$1"

    for f in "$dir"/*; do
        process_file "$f"
    done
}

root_dir="${1:-.}"
root_dir="${root_dir%/}"

[ -d "root_dir" ] && {
    process_dir "$root_dir"; exit $?
}

while read -r file_path; do
    [ -z "$file_path" ] && continue
    process_file "$file_path"
done < "$root_dir"

exit 123




# res=

# for f in "$dir"*; do
#     nb_of_lines=$(wc -l < "$f")
#     res="$res./${f#"$dir"} $((nb_of_lines + 1))\n$(cat "$f")\n"
#     # if file ends with trailing newline, add it before returning to line
#     [ -z "$(tail -c1 "$f")" ] && res="$res\n"
# done

# # we get rid of echo's \n
# echo "$res\c" > "${dir%/}".txt
