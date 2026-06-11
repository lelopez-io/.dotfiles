#!/bin/bash
set -e

SETUP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "=== Installing Applications ==="

confirm() {
    while true; do
        read -p "$1 (y/n) " yn
        case $yn in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Please answer yes (y) or no (n).";;
        esac
    done
}

# Sections (## headers) are parsed from each Brewfile; [REQUIRED] sections
# install without prompting, [OPTIONAL] sections are opt-in.
install_brewfile() {
    local brewfile=$1 category=$2
    local -a names=() bodies=()
    local name="" body="" line

    while IFS= read -r line; do
        if [[ "$line" == "## "* ]]; then
            names+=("$name")
            bodies+=("$body")
            name="${line#\#\# }"
            body=""
        else
            body+="$line"$'\n'
        fi
    done < "$brewfile"
    names+=("$name")
    bodies+=("$body")

    local selection entries display i
    selection="$(mktemp)"

    for i in "${!names[@]}"; do
        entries=$(printf '%s' "${bodies[$i]}" | grep -cE '^(tap|brew|cask|mas) ' || true)
        [[ "$entries" -eq 0 ]] && continue

        if [[ "${names[$i]}" == "[REQUIRED]"* ]]; then
            echo "Including \"${names[$i]#\[REQUIRED\] }\" ($entries packages)"
            printf '%s' "${bodies[$i]}" >> "$selection"
            continue
        fi

        display="${names[$i]#\[OPTIONAL\] }"
        echo ""
        printf '%s' "${bodies[$i]}" | grep -v '^$' | sed 's/^/  /'
        if confirm "Include \"${display:-$category}\"?"; then
            printf '%s' "${bodies[$i]}" >> "$selection"
        fi
    done

    if grep -qE '^(tap|brew|cask|mas) ' "$selection"; then
        echo ""
        echo "Installing selected $category packages..."
        if ! brew bundle --file="$selection"; then
            echo "Warning: Some $category packages failed to install. Check the output above."
        fi
    else
        echo "Nothing selected from $category."
    fi
    rm -f "$selection"
}

for brewfile in "$SETUP_DIR"/Brewfile.*; do
    [[ "$brewfile" == *.lock.json ]] && continue
    category="${brewfile##*/Brewfile.}"
    echo ""
    echo "--- $category ---"
    install_brewfile "$brewfile" "$category"
done
