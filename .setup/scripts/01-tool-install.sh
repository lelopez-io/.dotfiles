#!/bin/bash
set -e

SETUP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "=== Installing Applications ==="

confirm() {
    while true; do
        # EOF means no answers left; decline rather than loop on empty input.
        read -r -p "$1 (y/n) " yn || return 1
        case $yn in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Please answer yes (y) or no (n).";;
        esac
    done
}

count_entries() { grep -cE '^(tap|brew|cask|mas) ' || true; }
count_offerable() { grep -cE '^#?[[:space:]]*(tap|brew|cask|mas) ' || true; }

# [REQUIRED] installs unasked; [OPTIONAL] is asked per entry: only the user
# knows whether they hold a license, or an account to sign into here.
# Commented entries are dormant, not deleted, so they are offered too.
install_brewfile() {
    local brewfile=$1 category=$2
    local -a names=() bodies=()
    local name="" body="" line

    # The || guard keeps the last line when a Brewfile has no trailing newline;
    # without it that package is dropped silently.
    while IFS= read -r line || [[ -n "$line" ]]; do
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

    local selection entries display pkgs pkg note i
    selection="$(mktemp)"

    for i in "${!names[@]}"; do
        pkgs="$(printf '%s' "${bodies[$i]}")"
        display="${names[$i]#\[REQUIRED\] }"
        display="${display#\[OPTIONAL\] }"

        if [[ "${names[$i]}" == "[REQUIRED]"* ]]; then
            entries=$(printf '%s' "$pkgs" | count_entries)
            [[ "$entries" -eq 0 ]] && continue
            echo "Including \"${display:-$category}\" ($entries packages)"
            printf '%s\n' "$pkgs" >> "$selection"
            continue
        fi

        entries=$(printf '%s' "$pkgs" | count_offerable)
        [[ "$entries" -eq 0 ]] && continue

        echo ""
        echo "${display:-$category}"
        # fd 3, not stdin: a here-string on `done` feeds the loop body too, so
        # confirm would read packages instead of the answer.
        while IFS= read -r line <&3; do
            # Uncommented copy for the selection file; unchanged means active.
            entry=$(printf '%s' "$line" | sed 's/^#[[:space:]]*//')
            [[ "$entry" =~ ^(tap|brew|cask|mas)\  ]] || continue
            pkg=$(printf '%s' "$entry" | sed 's/^[a-z]*[[:space:]]*"//; s/".*//')
            note=""
            [[ "$entry" == *@account-required* ]] && note="account required"
            [[ "$entry" == *@license-required* ]] && note="${note:+$note, }license required"
            [[ "$line" == "$entry" ]] || note="${note:+$note, }dormant"
            [[ -n "$note" ]] && note=" ($note)"
            printf '  %s\n' "$line"
            if confirm "  Include $pkg$note?"; then
                printf '%s\n' "$entry" >> "$selection"
            fi
        done 3<<< "$pkgs"
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
