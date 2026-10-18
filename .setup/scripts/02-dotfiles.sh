#!/bin/bash
set -e

echo "=== Setting up Dotfiles ==="

# Helper function for yes/no prompts
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

# Derived, not assumed: a clone outside $HOME made `cd ~/.dotfiles` fail and
# set -e took the whole run with it.
DOTFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$DOTFILES_ROOT"

# --no-folding: never collapse a directory into one symlink — tools that
# write runtime state beside their stowed config would land it in this repo.
# --target: stow otherwise infers the package's parent, which is only $HOME
# when the repo sits directly beneath it.
STOW_FLAGS=(--no-folding --target="$HOME")

# stow --adopt absorbs a conflicting regular file, but a symlink stow did not
# create is a hard conflict it refuses, so forcing has to clear those itself.
clear_foreign_links() {
    stow . -n "${STOW_FLAGS[@]}" 2>&1 \
        | sed -n 's/^ *\* existing target is not owned by stow: //p' \
        | while IFS= read -r target; do
            [ -L "$HOME/$target" ] || continue
            echo "- Replacing foreign symlink: ~/$target"
            rm "$HOME/$target"
        done
}

# A link is ours only when it resolves into the repo. For a directory, one
# such link anywhere inside means an earlier run already took it over, and
# re-running must not move it into a new backup over the first original.
repo_owned() {
    local path=$1 root=$2 link
    if [ -L "$path" ]; then
        [[ $(realpath -m "$path") == "$root"/* ]]
        return
    fi
    [ -d "$path" ] || return 1
    while IFS= read -r -d '' link; do
        if [[ $(realpath -m "$link") == "$root"/* ]]; then
            return 0
        fi
    done < <(find "$path" -type l -print0)
    return 1
}

# Omarchy ships its own copies of configs this repo stows, and both answers
# to the macOS prompt lose them: adopt absorbs them into the repo, force
# deletes the originals. Move each listed one into a dated backup first.
stow_with_takeover() {
    local list="$DOTFILES_ROOT/.setup/takeover-targets.txt"
    local backup_root="$HOME/.dotfiles-backup"
    # Canonical, so link targets compare equal even behind a symlinked $HOME.
    local repo_real
    repo_real=$(realpath -m "$DOTFILES_ROOT")

    local moves=() rel backup_dir
    while IFS= read -r rel; do
        [[ $rel =~ ^[[:space:]]*(#|$) ]] && continue
        if [ -e "$HOME/$rel" ] || [ -L "$HOME/$rel" ]; then
            repo_owned "$HOME/$rel" "$repo_real" || moves+=("$rel")
        fi
    done < "$list"

    if [ ${#moves[@]} -gt 0 ]; then
        backup_dir="$backup_root/$(date +%Y%m%d-%H%M%S)"
        mkdir -p "$backup_dir"
        for rel in "${moves[@]}"; do
            mkdir -p "$backup_dir/$(dirname "$rel")"
            mv "$HOME/$rel" "$backup_dir/$rel"
            echo "- Backed up ~/$rel"
        done
        printf '%s\n' "${moves[@]}" > "$backup_dir/targets"
        sed "s|__DOTFILES_ROOT__|$repo_real|" \
            "$DOTFILES_ROOT/.setup/scripts/lib/takeover-restore.sh" \
            > "$backup_dir/restore.sh"
        chmod +x "$backup_dir/restore.sh"
        echo "Omarchy originals are in $backup_dir"
        echo "Put any of them back with: $backup_dir/restore.sh [path ...]"
    else
        echo "Takeover: listed configs are already stowed or absent; no backup needed."
    fi

    # ghostty stays Omarchy's on Linux (stow end-anchors --ignore patterns,
    # unlike .stow-local-ignore). Stow plans every link before making one:
    # an unlisted conflict stops the stage with the backup untouched.
    if ! stow . --restow "${STOW_FLAGS[@]}" --ignore='\.config/ghostty'; then
        echo "Stow refused paths outside the takeover list (see above)." >&2
        echo "Add each to .setup/takeover-targets.txt or remove it, then re-run this stage." >&2
        exit 1
    fi
}

if [[ "$OSTYPE" == "darwin"* ]]; then
    # Ask user how to handle existing configs
    if confirm "Would you like to force repo versions of all dotfiles? (This will overwrite your current configs)"; then
        echo "Force installing dotfiles from repo..."
        clear_foreign_links
        stow . --adopt "${STOW_FLAGS[@]}"  # First adopt to handle any new files
        git restore .    # Discard any adopted changes
        stow . --restow "${STOW_FLAGS[@]}" # Reinstall all symlinks
    else
        echo "Adopting existing files..."
        stow . --adopt "${STOW_FLAGS[@]}"

        # Show what changes were adopted
        echo -e "\nChanges adopted from existing files:"
        echo -e "\nFile changes summary:"
        git diff --stat

        echo -e "\nDetailed changes (side by side):"
        if command -v delta &> /dev/null; then
            git -c core.pager='' diff --color=always | delta --side-by-side
        else
            git -c core.pager='' diff
        fi

        echo -e "\nNOTE: Review the changes above and decide what to keep:"
        echo "1. Keep adopted changes: git add . && git commit -m 'feat: adopt existing configs'"
        echo "2. Stash adopted changes: git stash save 'adopted configs'"
        echo "3. Discard adopted changes: git restore ."
        echo -e "   Then use 'stow . --restow --no-folding' to use repo versions\n"
    fi
else
    stow_with_takeover
fi

echo "Dotfiles setup complete!"
