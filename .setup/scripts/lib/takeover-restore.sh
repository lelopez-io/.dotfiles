#!/bin/bash
# Restore the originals this backup holds, reversing 02-dotfiles.sh's
# takeover. 02 bakes the repo path in when it copies this script into the
# backup, so restore still works after the repo moves or is gone.
set -euo pipefail

DOTFILES_ROOT="__DOTFILES_ROOT__"
BACKUP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Only a link that resolves into the repo may be removed; anything else was
# made after the backup and restoring must not destroy it.
repo_link() {
    [ -L "$1" ] && [[ $(realpath -m "$1") == "$DOTFILES_ROOT"/* ]]
}

clear_current() {
    local cur=$1 entry
    [ -e "$cur" ] || [ -L "$cur" ] || return 0
    if repo_link "$cur"; then
        rm "$cur"
        return 0
    fi
    if [ -d "$cur" ]; then
        while IFS= read -r -d '' entry; do
            if ! repo_link "$entry"; then
                echo "skip: $cur contains $entry, not a repo link" >&2
                return 1
            fi
        done < <(find "$cur" -mindepth 1 ! -type d -print0)
        find "$cur" -type l -delete
        find "$cur" -depth -mindepth 1 -type d -empty -delete
        rmdir "$cur"
        return 0
    fi
    echo "skip: $cur is not a repo link; remove it yourself to restore" >&2
    return 1
}

backed_up=()
while IFS= read -r line; do
    backed_up+=("$line")
done < "$BACKUP_DIR/targets"

if [ $# -gt 0 ]; then
    targets=("$@")
else
    targets=("${backed_up[@]}")
fi

status=0
for rel in "${targets[@]}"; do
    if [ ! -e "$BACKUP_DIR/$rel" ] && [ ! -L "$BACKUP_DIR/$rel" ]; then
        echo "skip: $rel is not in this backup" >&2
        status=1
        continue
    fi
    if clear_current "$HOME/$rel"; then
        mkdir -p "$HOME/$(dirname "$rel")"
        mv "$BACKUP_DIR/$rel" "$HOME/$rel"
        echo "restored ~/$rel"
    else
        status=1
    fi
done
exit "$status"
