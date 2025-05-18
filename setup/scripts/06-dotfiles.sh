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

# Navigate to dotfiles directory
cd "$HOME/.dotfiles"

# Ask user how to handle existing configs
if confirm "Would you like to force repo versions of all dotfiles? (This will overwrite your current configs)"; then
    echo "Force installing dotfiles from repo..."
    stow . --adopt  # First adopt to handle any new files
    git restore .    # Discard any adopted changes
    stow . --restow # Reinstall all symlinks
else
    echo "Adopting existing files..."
    stow . --adopt

    # Show what changes were adopted
    echo -e "\nChanges adopted from existing files:"
    echo -e "\nFile changes summary:"
    git diff --stat

    echo -e "\nDetailed changes (side by side):"
    git -c core.pager='' diff --color=always | delta --side-by-side

    echo -e "\nNOTE: Review the changes above and decide what to keep:"
    echo "1. Keep adopted changes: git add . && git commit -m 'feat: adopt existing configs'"
    echo "2. Stash adopted changes: git stash save 'adopted configs'"
    echo "3. Discard adopted changes: git restore ."
    echo -e "   Then use 'stow . --restow' to use repo versions\n"
fi

echo "Setting up additional symlinks..."
ln -sf "$HOME/.dotfiles/.gitignore" "$HOME/.gitignore"
ln -sf "$HOME/.dotfiles/.env.aider" "$HOME/.env.aider"

echo "Dotfiles setup complete!"