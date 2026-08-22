#!/bin/bash
set -e

echo "=== Installing Core Dependencies ==="

# Check for Homebrew
if ! command -v brew &>/dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH and other environment variables for the current session
    if [[ "$OSTYPE" == "darwin"* ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi
fi

# Pin the kernel hostname. With HostName unset, macOS negotiates
# kern.hostname from Bonjour/network state at boot, so long-running tools
# that cache it once (herdr's window title) can show a transient name like
# "Mac" for the server's whole lifetime. LocalHostName (mDNS) is untouched.
if ! scutil --get HostName &>/dev/null; then
    read -p "No HostName set — pin one? [name, blank = $(scutil --get LocalHostName)] " hn
    hn=${hn:-$(scutil --get LocalHostName)}
    [ -n "$hn" ] && sudo scutil --set HostName "$hn" && echo "HostName pinned to: $hn"
fi
