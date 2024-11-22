#!/usr/bin/env bash

# Colors for better readability
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Config directory
CONFIG_DIR="$HOME/.dotfiles/setup"
BREWFILE="$CONFIG_DIR/Brewfile"

# Store selections
declare -A editors
declare -A browsers
declare -A productivity_apps
declare -A dev_tools
declare -A utility_apps

# Initialize default selections (all optional set to 0)
editors=(
    ["VSCode"]=0
    ["GitKraken"]=0
    ["Hyper"]=0
)

browsers=(
    ["Firefox"]=0
    ["Chrome"]=0
)

productivity_apps=(
    ["Obsidian"]=0
    ["Spark"]=0
    ["Grammarly"]=0
    ["MeetingBar"]=0
)

dev_tools=(
    ["Rancher"]=0
    ["kubectx"]=0
    ["kube-ps1"]=0
)

utility_apps=(
    ["OnePassword"]=0
    ["Swish"]=0
    ["Discord"]=0
    ["Raycast"]=0
    ["AnyDesk"]=0
)

# Helper Functions
print_header() {
    echo -e "\n${BLUE}=== $1 ===${NC}\n"
}

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

print_current_selection() {
    local array_name=$1
    local key=$2
    if [ "${!array_name[$key]}" = "1" ]; then
        echo -e "[${GREEN}✓${NC}] $key"
    else
        echo -e "[${RED}✗${NC}] $key"
    fi
}

backup_file() {
    local file=$1
    if [ -f "$file" ]; then
        local backup="${file}.$(date +%Y%m%d_%H%M%S).bak"
        cp "$file" "$backup"
        echo "Backed up $file to $backup"
    fi
}

# Load existing configuration
load_existing_config() {
    mkdir -p "$CONFIG_DIR"
    
    if [ -f "$BREWFILE" ]; then
        while IFS= read -r line; do
            case "$line" in
                *"visual-studio-code"*) editors["VSCode"]=1 ;;
                *"gitkraken"*) editors["GitKraken"]=1 ;;
                *"hyper"*) editors["Hyper"]=1 ;;
                *"firefox"*) browsers["Firefox"]=1 ;;
                *"google-chrome"*) browsers["Chrome"]=1 ;;
                *"obsidian"*) productivity_apps["Obsidian"]=1 ;;
                *"1password"*) productivity_apps["1Password"]=1 ;;
                *"spark"*) productivity_apps["Spark"]=1 ;;
                *"grammarly"*) productivity_apps["Grammarly"]=1 ;;
                *"meetingbar"*) productivity_apps["MeetingBar"]=1 ;;
                *"rancher"*) dev_tools["Rancher"]=1 ;;
                *"kubectx"*) dev_tools["kubectx"]=1 ;;
                *"kube-ps1"*) dev_tools["kube-ps1"]=1 ;;
            esac
        done < "$BREWFILE"
    fi
}

generate_config() {
    # Backup existing files
    backup_file "$BREWFILE"

    # Create Brewfile based on selections
    echo "# Generated Brewfile - $(date)" > "$BREWFILE"
    echo "tap \"homebrew/bundle\"" >> "$BREWFILE"
    echo "tap \"homebrew/cask\"" >> "$BREWFILE"
    echo "tap \"homebrew/core\"" >> "$BREWFILE"
    echo "" >> "$BREWFILE"
    
    # Essential tools (always included)
    echo "# Essential Tools" >> "$BREWFILE"
    echo "brew \"stow\"" >> "$BREWFILE"
    echo "brew \"mise\"" >> "$BREWFILE"
    echo "brew \"tree\"" >> "$BREWFILE"
    echo "brew \"tmux\"" >> "$BREWFILE"
    echo "brew \"neovim\"" >> "$BREWFILE"
    echo "brew \"prettierd\"" >> "$BREWFILE"
    echo "brew \"yt-dlp\"" >> "$BREWFILE"
    echo "brew \"ffmpeg\"" >> "$BREWFILE"
    echo "brew \"the_silver_searcher\"" >> "$BREWFILE"
    echo "brew \"stylua\"" >> "$BREWFILE"
    echo "brew \"wget\"" >> "$BREWFILE"
    echo "brew \"ripgrep\"" >> "$BREWFILE"
    echo "brew \"jq\"" >> "$BREWFILE"
    echo "cask \"hiddenbar\"" >> "$BREWFILE"
    echo "" >> "$BREWFILE"
    
    # Optional Editors
    if [ -n "$(printf '%s\n' "${editors[@]}" | grep -w "1")" ]; then
        echo "# Editors" >> "$BREWFILE"
        for editor in "${!editors[@]}"; do
            if [ "${editors[$editor]}" -eq 1 ]; then
                case $editor in
                    "VSCode")
                        echo "cask \"visual-studio-code\"" >> "$BREWFILE"
                        ;;
                    "GitKraken")
                        echo "cask \"gitkraken\"" >> "$BREWFILE"
                        ;;
                    "Hyper")
                        echo "cask \"hyper\"" >> "$BREWFILE"
                        ;;
                esac
            fi
        done
        echo "" >> "$BREWFILE"
    fi
    
    # Optional Browsers
    if [ -n "$(printf '%s\n' "${browsers[@]}" | grep -w "1")" ]; then
        echo "# Browsers" >> "$BREWFILE"
        for browser in "${!browsers[@]}"; do
            if [ "${browsers[$browser]}" -eq 1 ]; then
                case $browser in
                    "Firefox")
                        echo "cask \"firefox\"" >> "$BREWFILE"
                        ;;
                    "Chrome")
                        echo "cask \"google-chrome\"" >> "$BREWFILE"
                        ;;
                esac
            fi
        done
        echo "" >> "$BREWFILE"
    fi
    
    # Optional Productivity Apps
    if [ -n "$(printf '%s\n' "${productivity_apps[@]}" | grep -w "1")" ]; then
        echo "# Productivity" >> "$BREWFILE"
        for app in "${!productivity_apps[@]}"; do
            if [ "${productivity_apps[$app]}" -eq 1 ]; then
                case $app in
                    "Obsidian")
                        echo "cask \"obsidian\"" >> "$BREWFILE"
                        ;;
                    "OnePassword")
                        echo "cask \"1password\"" >> "$BREWFILE"
                        ;;
                    "Spark")
                        echo "cask \"spark\"" >> "$BREWFILE"
                        ;;
                    "Grammarly")
                        echo "cask \"grammarly\"" >> "$BREWFILE"
                        ;;
                    "MeetingBar")
                        echo "cask \"meetingbar\"" >> "$BREWFILE"
                        ;;
                esac
            fi
        done
        echo "" >> "$BREWFILE"
    fi
    
    # Optional Development Tools
    if [ -n "$(printf '%s\n' "${dev_tools[@]}" | grep -w "1")" ]; then
        echo "# Development Tools" >> "$BREWFILE"
        for tool in "${!dev_tools[@]}"; do
            if [ "${dev_tools[$tool]}" -eq 1 ]; then
                case $tool in
                    "Rancher")
                        echo "cask \"rancher\"" >> "$BREWFILE"
                        ;;
                    "kubectx")
                        echo "brew \"kubectx\"" >> "$BREWFILE"
                        ;;
                    "kube-ps1")
                        echo "brew \"kube-ps1\"" >> "$BREWFILE"
                        ;;
                esac
            fi
        done
    fi

    # Optional Utility Apps
    if [ -n "$(printf '%s\n' "${utility_apps[@]}" | grep -w "1")" ]; then
        echo "# Utility Apps" >> "$BREWFILE"
        for app in "${!utility_apps[@]}"; do
            if [ "${utility_apps[$app]}" -eq 1 ]; then
                case $app in
                    "Swish")
                        echo "cask \"swish\"" >> "$BREWFILE"
                        ;;
                    "Discord")
                        echo "cask \"discord\"" >> "$BREWFILE"
                        ;;
                    "Raycast")
                        echo "cask \"raycast\"" >> "$BREWFILE"
                        ;;
                    "AnyDesk")
                        echo "cask \"anydesk\"" >> "$BREWFILE"
                        ;;
                esac
            fi
        done
    fi

    echo -e "${GREEN}Configuration files generated successfully!${NC}"
    echo "Generated files:"
    echo "- $BREWFILE"
    echo -e "\nBackups of previous configurations (if any) were created"
}

setup_config() {
    clear
    print_header "Development Environment Setup"
    
    # Load existing configuration
    load_existing_config
    
    echo "The following essential tools will be installed automatically:"
    echo ""
    echo "Development Tools:"
    echo "  - stow (dotfile management)"
    echo "  - mise (version management)"
    echo "  - tree (directory visualization)"
    echo "  - tmux (terminal multiplexer)"
    echo "  - neovim (text editor)"
    echo "  - prettierd (code formatting)"
    echo ""
    echo "Media & Download Tools:"
    echo "  - yt-dlp (video download)"
    echo "  - ffmpeg (media processing)"
    echo ""
    echo "Search & Processing Tools:"
    echo "  - the_silver_searcher (code search)"
    echo "  - ripgrep (fast search)"
    echo "  - wget (file download)"
    echo "  - jq (JSON processing)"
    echo ""
    echo "UI Tools:"
    echo "  - hiddenbar (menu bar management)"
    echo "  - stylua (lua formatting)"
    echo ""
    echo "You can now choose additional optional tools to install."
    echo "Press Enter to continue..."
    read

    # Editors Selection
    print_header "Additional Code Editors and IDEs"
    echo "Available editors to install:"
    echo "  - VSCode (Visual Studio Code - popular IDE)"
    echo "  - GitKraken (Git GUI Client)"
    echo "  - Hyper (Terminal Emulator)"
    echo ""
    if confirm "Would you like to install any of these additional editors?"; then
        echo "Currently selected editors:"
        for editor in "${!editors[@]}"; do
            print_current_selection editors "$editor"
        done
        
        for editor in "${!editors[@]}"; do
            if confirm "Include $editor?"; then
                editors[$editor]=1
            else
                editors[$editor]=0
            fi
        done
    fi

    # Browsers Selection
    print_header "Web Browsers"
    echo "Available browsers to install:"
    echo "  - Firefox"
    echo "  - Chrome"
    echo ""
    if confirm "Would you like to install any browsers?"; then
        echo "Currently selected browsers:"
        for browser in "${!browsers[@]}"; do
            print_current_selection browsers "$browser"
        done
        
        for browser in "${!browsers[@]}"; do
            if confirm "Include $browser?"; then
                browsers[$browser]=1
            else
                browsers[$browser]=0
            fi
        done
    fi

    # Development Tools Selection
    print_header "Additional Development Tools"
    echo "Available development tools:"
    echo "  - Rancher (Container Management)"
    echo "  - kubectx (Kubernetes Context Switcher)"
    echo "  - kube-ps1 (Kubernetes Shell Prompt)"
    echo ""
    if confirm "Would you like to install any of these Kubernetes tools?"; then
        echo "Currently selected development tools:"
        for tool in "${!dev_tools[@]}"; do
            print_current_selection dev_tools "$tool"
        done
        
        for tool in "${!dev_tools[@]}"; do
            if confirm "Include $tool?"; then
                dev_tools[$tool]=1
            else
                dev_tools[$tool]=0
            fi
        done
    fi

    # Productivity Apps Selection
    print_header "Productivity Applications"
    echo "Available productivity apps:"
    echo "  - Obsidian (Note Taking)"
    echo "  - Spark (Email Client)"
    echo "  - Grammarly (Writing Assistant)"
    echo "  - MeetingBar (Calendar in Menu Bar)"
    echo ""
    if confirm "Would you like to install any productivity applications?"; then
        echo "Currently selected productivity applications:"
        for app in "${!productivity_apps[@]}"; do
            print_current_selection productivity_apps "$app"
        done
        
        for app in "${!productivity_apps[@]}"; do
            if confirm "Include $app?"; then
                productivity_apps[$app]=1
            else
                productivity_apps[$app]=0
            fi
        done
    fi

    # Utility Apps Selection
    print_header "Utility Applications"
    echo "Available utility apps:"
    echo "  - Swish (Window Management)"
    echo "  - Discord (Communication)"
    echo "  - Raycast (Spotlight Replacement)"
    echo "  - AnyDesk (Remote Desktop)"
    echo ""
    if confirm "Would you like to install any utility applications?"; then
        echo "Currently selected utility applications:"
        for app in "${!utility_apps[@]}"; do
            print_current_selection utility_apps "$app"
        done
        
        for app in "${!utility_apps[@]}"; do
            if confirm "Include $app?"; then
                utility_apps[$app]=1
            else
                utility_apps[$app]=0
            fi
        done
    fi

    # Review Selections
    print_header "Configuration Review"
    
    echo -e "\nSelected Editors:"
    for editor in "${!editors[@]}"; do
        print_current_selection editors "$editor"
    done
    
    echo -e "\nSelected Browsers:"
    for browser in "${!browsers[@]}"; do
        print_current_selection browsers "$browser"
    done
    
    echo -e "\nSelected Development Tools:"
    for tool in "${!dev_tools[@]}"; do
        print_current_selection dev_tools "$tool"
    done
    
    echo -e "\nSelected Productivity Applications:"
    for app in "${!productivity_apps[@]}"; do
        print_current_selection productivity_apps "$app"
    done

    echo -e "\nSelected Utility Applications:"
    for app in "${!utility_apps[@]}"; do
        print_current_selection utility_apps "$app"
    done

    # Generate Configuration
    if confirm "Would you like to save this configuration?"; then
        generate_config
    else
        echo "Configuration cancelled."
        exit 1
    fi
}

# Run the setup
setup_config
