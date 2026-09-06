#!/bin/bash
set -eE

SETUP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="$SETUP_DIR/scripts"

echo "=== Starting Development Environment Setup ==="

# Stages are sourced and each runs set -e, so one failure ends the whole run.
# Without this the later stages just never appear and nothing says why.
stage=""
trap 'echo "=== Setup stopped in ${stage:-startup}. Later stages did not run. ==="' ERR

run() {
    stage=$1
    echo "$2"
    # shellcheck disable=SC1090 # the stage name is the argument, by design.
    source "$SCRIPTS_DIR/$1"
}

run 00-core.sh "Installing core dependencies..."
run 01-tool-install.sh "Installing selected tools and applications..."
run 02-dotfiles.sh "Setting up dotfiles..."
run 03-languages.sh "Setting up language environments..."
run 04-shell.sh "Setting up shell environment..."
run 05-git.sh "Setting up Git configuration..."
run 06-forks.sh "Building patched forks..."
run 07-agents.sh "Setting up agents..."

echo "=== Setup Complete! ==="
echo "NOTE: You may need to restart your terminal for all changes to take effect."
