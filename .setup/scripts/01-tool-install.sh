#!/bin/bash
set -e

SETUP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "=== Installing Applications ==="

# Pacman systems offer Packages.arch and install each accepted entry on its
# own; everywhere else the Brewfiles and brew bundle serve. The prompt loop
# is shared, only the entry keywords and the install step differ.
if [[ "$OSTYPE" != "darwin"* ]] && command -v pacman &>/dev/null; then
    on_arch=1
    entry_kinds='pacman|yay'
    lists=("$SETUP_DIR"/Packages.arch)
else
    on_arch=0
    entry_kinds='tap|brew|cask|mas'
    lists=("$SETUP_DIR"/Brewfile.*)
fi

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

count_entries() { grep -cE "^($entry_kinds) " || true; }
count_offerable() { grep -cE "^#?[[:space:]]*($entry_kinds) " || true; }

# Whether you hold a license, or have an account to sign into on this
# machine, is context the repo does not have, so no section-wide answer
# stands in for it. Commented entries are opt-outs, not deletions.
install_list() {
    local list=$1 category=$2
    local -a names=() bodies=()
    local name="" body="" line

    # The || guard keeps the last line when a list has no trailing newline;
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
    done < "$list"
    names+=("$name")
    bodies+=("$body")

    local selection entries display pkgs pkg note i entry
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
            # brew bundle ignores a commented line, so an accepted entry has
            # to reach the selection uncommented.
            entry=$(printf '%s' "$line" | sed 's/^#[[:space:]]*//')
            [[ "$entry" =~ ^($entry_kinds)\  ]] || continue
            pkg=$(printf '%s' "$entry" | sed 's/^[a-z]*[[:space:]]*"//; s/".*//')
            note=""
            [[ "$entry" == *@account-required* ]] && note="account required"
            [[ "$entry" == *@license-required* ]] && note="${note:+$note, }license required"
            [[ "$line" == "$entry" ]] || note="${note:+$note, }parked"
            [[ -n "$note" ]] && note=" ($note)"
            printf '  %s\n' "$line"
            if confirm "  Include $pkg$note?"; then
                printf '%s\n' "$entry" >> "$selection"
            fi
        done 3<<< "$pkgs"
    done

    if grep -qE "^($entry_kinds) " "$selection"; then
        echo ""
        echo "Installing selected $category packages..."
        if [[ "$on_arch" == 1 ]]; then
            # Entry by entry, so one failed package warns and the rest still
            # install, the contract brew bundle gives the Brewfile path.
            # --needed leaves what the machine already ships in place.
            # REQUIRED sections carry their comment lines into the selection;
            # brew bundle ignores those, this loop has to skip them itself.
            while IFS= read -r entry; do
                [[ "$entry" =~ ^($entry_kinds)\  ]] || continue
                pkg=$(printf '%s' "$entry" | sed 's/^[a-z]*[[:space:]]*"//; s/".*//')
                if [[ "$entry" == yay\ * ]]; then
                    yay -S --needed --noconfirm "$pkg" \
                        || echo "Warning: $pkg failed to install. Continuing..."
                else
                    sudo pacman -S --needed --noconfirm "$pkg" \
                        || echo "Warning: $pkg failed to install. Continuing..."
                fi
            done < "$selection"
        elif ! brew bundle --file="$selection"; then
            echo "Warning: Some $category packages failed to install. Check the output above."
        fi
    else
        echo "Nothing selected from $category."
    fi
    rm -f "$selection"
}

# Homebrew 6 will not load a non-official tap formula until it is trusted, and
# a REQUIRED one then fails the run. Read from the Brewfiles so a new tapped
# entry needs no second edit here.
if brew trust --help &> /dev/null; then
    grep -hoE '^#?[[:space:]]*brew "[^"]+/[^"]+/[^"]+"' "$SETUP_DIR"/Brewfile.* \
        | sed 's/.*"\(.*\)"/\1/' | sort -u | while read -r formula; do
        brew trust --formula "$formula" \
            || echo "Warning: brew trust $formula failed. Continuing..."
    done
fi

for list in "${lists[@]}"; do
    [[ "$list" == *.lock.json ]] && continue
    category="${list##*/}"
    category="${category#*.}"
    echo ""
    echo "--- $category ---"
    install_list "$list" "$category"
done

# brew ships compose and buildx as docker CLI plugins, in a directory the
# docker binary does not search, so `docker compose` silently does not exist
# until it is registered. Only brew's docker needs this; distro packages land
# the plugins where the CLI already looks. Merge: this file also holds
# registry credentials.
plugin_dir=""
if command -v brew &>/dev/null; then
    plugin_dir="$(brew --prefix)/lib/docker/cli-plugins"
fi
if [ -n "$plugin_dir" ] && [ -d "$plugin_dir" ]; then
    python3 - "$plugin_dir" <<'PY'
import json, os, sys

path = os.path.expanduser("~/.docker/config.json")
plugin_dir = sys.argv[1]

if os.path.exists(path):
    try:
        with open(path) as fh:
            cfg = json.load(fh)
    except ValueError:
        print(f"Warning: {path} is not valid JSON, leaving it alone.", file=sys.stderr)
        sys.exit(0)
else:
    cfg = {}

dirs = cfg.setdefault("cliPluginsExtraDirs", [])
if plugin_dir in dirs:
    sys.exit(0)

dirs.append(plugin_dir)
os.makedirs(os.path.dirname(path), exist_ok=True)
tmp = f"{path}.tmp"
with open(tmp, "w") as fh:
    json.dump(cfg, fh, indent=2)
os.replace(tmp, path)
print(f"docker: registered {plugin_dir} for CLI plugins")
PY
fi
