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

# The SDK a compiler sees comes from the selected developer directory, and
# installing Xcode does not select it. 06-forks needs an SDK zig can link
# against, so settle it before anything consumes it.
if [ -d /Applications/Xcode.app ] &&
   [ "$(xcode-select -p 2>/dev/null)" = /Library/Developer/CommandLineTools ]; then
    echo "Xcode is installed but Command Line Tools are selected."
    read -p "Switch xcode-select to Xcode? (needs sudo) [y/N] " ans
    if [[ "$ans" =~ ^[Yy]$ ]]; then
        sudo xcode-select -s /Applications/Xcode.app/Contents/Developer \
            && echo "Now using: $(xcode-select -p)"
    fi
fi
