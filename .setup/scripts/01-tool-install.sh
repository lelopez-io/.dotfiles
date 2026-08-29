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

# Sections (## headers) drive the prompts: [REQUIRED] installs unasked,
# [OPTIONAL] is opt-in. @account-required and @license-required entries sort
# last and are asked individually, keeping the section answer about the topic.
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

    local selection entries display pkgs acct i
    selection="$(mktemp)"

    for i in "${!names[@]}"; do
        pkgs="$(printf '%s' "${bodies[$i]}")"
        entries=$(printf '%s' "$pkgs" | count_entries)
        [[ "$entries" -eq 0 ]] && continue
        acct=$(printf '%s' "$pkgs" | grep -E '@(account|license)-required' | count_entries)
        display="${names[$i]#\[REQUIRED\] }"
        display="${display#\[OPTIONAL\] }"

        if [[ "${names[$i]}" == "[REQUIRED]"* ]]; then
            echo "Including \"${display:-$category}\" ($entries packages)"
            printf '%s\n' "$pkgs" >> "$selection"
            continue
        fi

        echo ""
        printf '%s\n' "$pkgs" | grep -v '^$' | sed 's/^/  /'
        if confirm "Include \"${display:-$category}\"?"; then
            # An all-account section was already decided by the prompt above.
            if [[ "$acct" -gt 0 && "$acct" -lt "$entries" ]]; then
                # fd 3, not stdin: a here-string on `done` feeds the loop body
                # too, so confirm would read packages instead of the answer.
                while IFS= read -r line <&3; do
                    if [[ "$line" =~ @(account|license)-required && "$line" =~ ^(tap|brew|cask|mas)\  ]]; then
                        if confirm "  Include $(printf '%s' "$line" | sed 's/#.*//; s/[[:space:]]*$//')?"; then
                            printf '%s\n' "$line" >> "$selection"
                        fi
                    else
                        printf '%s\n' "$line" >> "$selection"
                    fi
                done 3<<< "$pkgs"
            else
                printf '%s\n' "$pkgs" >> "$selection"
            fi
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
