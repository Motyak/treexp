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
        local nb_of_lines; nb_of_lines="$(wc -l < "$regular_file")"
        OUTPUT="${OUTPUT}./${regular_file#"$ROOT_DIR/"} $((nb_of_lines + 1))"$'\n'
        OUTPUT="${OUTPUT}$(< "$regular_file")"$'\n'
        # if file ends with trailing newline, add it before returning to line
        [ -z "$(tail -c1 "$regular_file")" ] && OUTPUT="$OUTPUT"$'\n'
    }

    return 0 # file shouldn't be handled
}

function process_dir {
    local dir="$1"

    for f in "$dir"/*; do
        process_file "$f"
    done
}

ROOT_DIR="${1:-.}"
ROOT_DIR="${ROOT_DIR%/}"

OUTPUT=""
process_dir "$ROOT_DIR"
echo "$OUTPUT" > "${ROOT_DIR}.txt"

##########################################################################################
# would cause a problem, what if two directories in different place have the same name ? #
##########################################################################################

# [ -d "root_dir" ] && {
#     process_dir "$root_dir"; exit $?
# }


# while read -r file_path; do
#     [ -z "$file_path" ] && continue
#     process_file "$file_path"
# done < "$root_dir"
