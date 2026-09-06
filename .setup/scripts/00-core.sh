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

# 06-forks needs an SDK zig can link against. The fork builds override
# DEVELOPER_DIR per build, so this offers only the machine-wide fixes, which
# need sudo. Repo path: nothing is stowed until 02-dotfiles.
toolchain_check="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)/.local/bin/toolchain-check"
rc=0
"$toolchain_check" || rc=$?

if [ "$rc" -eq 1 ]; then
    if dd=$("$toolchain_check" --developer-dir 2>/dev/null); then
        read -p "Switch xcode-select to $dd? (needs sudo) [y/N] " ans
        if [[ "$ans" =~ ^[Yy]$ ]]; then
            sudo xcode-select -s "$dd" && echo "Now using: $(xcode-select -p)"
        fi
    elif sdk=$("$toolchain_check" --usable-sdk 2>/dev/null); then
        # Nothing is missing here, only the default symlink points at the
        # arm64e-only SDK. A CLT update can point it back.
        sdks=$(dirname "$sdk")
        if [ ! -L "$sdks/MacOSX.sdk" ]; then
            # ln -sfn would land inside a real directory rather than replace it.
            echo "Default SDK is not a symlink; leaving $sdks/MacOSX.sdk alone."
        else
            # Name the current target: it is what restores this.
            echo "Default SDK is $(readlink "$sdks/MacOSX.sdk"), which zig cannot link."
            read -p "Point it at $(basename "$sdk")? (needs sudo) [y/N] " ans
            if [[ "$ans" =~ ^[Yy]$ ]]; then
                sudo ln -sfn "$(basename "$sdk")" "$sdks/MacOSX.sdk" \
                    && echo "Default SDK now: $(readlink "$sdks/MacOSX.sdk")"
            fi
        fi
    fi
fi
