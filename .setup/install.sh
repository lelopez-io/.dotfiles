#!/bin/bash
set -eE

SETUP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="$SETUP_DIR/scripts"

usage() {
    cat <<'USAGE'
install.sh — run the setup stages.

Usage: install.sh [--from NN] [--only NN[,NN...]]

  --from NN   resume at stage NN and run everything after it
  --only NN   run just these stages, comma separated

Stages:
  00 core        01 tools       02 dotfiles    03 languages
  04 shell       05 git         06 forks       07 agents

Later stages assume earlier ones ran: 03 needs the mise config 02 stows, and
06 and 07 need the toolchains 03 installs. Skipping is for resuming a run that
already got past them, not for a fresh machine.
USAGE
}

FROM=""
ONLY=""
while [ $# -gt 0 ]; do
    case $1 in
        --from) FROM=${2:?--from needs a stage number}; shift 2 ;;
        --only) ONLY=${2:?--only needs stage numbers}; shift 2 ;;
        -h|--help) usage; exit 0 ;;
        *) echo "install.sh: unknown option '$1'" >&2; usage >&2; exit 1 ;;
    esac
done

echo "=== Starting Development Environment Setup ==="

# Stages are sourced and each runs set -e, so one failure ends the whole run.
# Without this the later stages just never appear and nothing says why.
stage=""
trap 'echo "=== Setup stopped in ${stage:-startup}. Later stages did not run. ==="' ERR

resuming=0
run() {
    local script=$1 label=$2 num=${1%%-*}

    if [ -n "$ONLY" ]; then
        case ",$ONLY," in *",$num,"*) ;; *) echo "Skipping $script"; return 0 ;; esac
    elif [ -n "$FROM" ]; then
        [ "$num" = "$FROM" ] && resuming=1
        [ "$resuming" = 1 ] || { echo "Skipping $script"; return 0; }
    fi

    stage=$script
    echo "$label"
    # shellcheck disable=SC1090 # the stage name is the argument, by design.
    source "$SCRIPTS_DIR/$script"
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
