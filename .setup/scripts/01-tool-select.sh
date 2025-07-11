#!/usr/bin/env bash

# Colors for better readability
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Config directory
SETUP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BREWFILE="$SETUP_DIR/Brewfile"

# Helper function to check if a package is a cask
is_cask() {
    local package=$1
    if brew info --cask $package &>/dev/null; then
        return 0  # True, it's a cask
    else
        return 1  # False, it's not a cask
    fi
}

# Data structure format: "name:description:package_name:enabled"
declare -a ESSENTIAL_TOOLS=(
    "Stow:Dotfile management:stow:1"
    "Mise:Version management:mise:1"
    "Tree:Directory visualization:tree:1"
    "Tmux:Terminal multiplexer:tmux:1"
    "Neovim:Text editor:neovim:1"
    "Prettierd:Code formatting:prettierd:1"
    "Stylua:Lua formatting:stylua:1"
    "YT-DLP:Video download utility:yt-dlp:1"
    "FFmpeg:Media processing:ffmpeg:1"
    "LibYAML:YAML parser:libyaml:1"
    "Silver Searcher:Code search:the_silver_searcher:1"
    "Ripgrep:Fast search utility:ripgrep:1"
    "Wget:File download utility:wget:1"
    "JQ:JSON processing:jq:1"
    "Delta:Git diff viewer:git-delta:1"
    "SOPS:Secrets management:sops:1"
    "1Password CLI:Command line 1Password access:1password-cli:1"
)

declare -a EDITORS=(
    "VSCode:Visual Studio Code - popular IDE:visual-studio-code:0"
    "Ghostty:Terminal Emulator:ghostty:0"
    "GitKraken:Git GUI Client (Paid):gitkraken:0"
)

declare -a BROWSERS=(
    "Firefox:Mozilla Firefox:firefox:0"
    "Chrome:Google Chrome:google-chrome:0"
)

declare -a DEV_TOOLS=(
    "Rancher:Container Management:rancher:0"
    "kubectx:Kubernetes Context Switcher:kubectx:0"
    "kube-ps1:Kubernetes Shell Prompt:kube-ps1:0"
)

declare -a PRODUCTIVITY_APPS=(
    "Obsidian:Note Taking:obsidian:0"
    "MeetingBar:Calendar in Menu Bar:meetingbar:0"
)

declare -a UTILITY_APPS=(
    "Swish:Window Management:swish:0"
    "Discord:Communication:discord:0"
    "Raycast:Spotlight Replacement:raycast:0"
    "AnyDesk:Remote Desktop:anydesk:0"
    "HiddenBar:Menu Bar Management:hiddenbar:0"
    "OnePassword:Password Manager:1password:0"
)

# Helper function to get array item by index and field
get_field() {
    local array_item="$1"
    local field_index="$2"
    echo "$array_item" | cut -d: -f$field_index
}

# Helper function to set enabled status
set_enabled() {
    local array_name=$1
    local index=$2
    local enabled=$3
    eval 'local item="${'"$array_name"'[$index]}"'
    local name=$(get_field "$item" 1)
    local desc=$(get_field "$item" 2)
    local package=$(get_field "$item" 3)
    eval "$array_name[$index]=\"$name:$desc:$package:$enabled\""
}

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
    local item="$1"
    local name=$(get_field "$item" 1)
    local enabled=$(get_field "$item" 4)
    if [ "$enabled" = "1" ]; then
        echo -e "[${GREEN}✓${NC}] $name"
    else
        echo -e "[${RED}✗${NC}] $name"
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

# Helper function to prompt for category installation
prompt_category() {
    local array_name=$1  # Name of the array
    local category_name=$2  # Display name of the category

    print_header "$category_name"
    echo "Available $category_name to install:"
    eval 'for item in "${'"$array_name"'[@]}"; do
        name=$(get_field "$item" 1)
        desc=$(get_field "$item" 2)
        echo "  - $name ($desc)"
    done'
    echo ""

    if confirm "Would you like to install any of these $category_name?"; then
        eval 'for i in "${!'"$array_name"'[@]}"; do
            local item="${'"$array_name"'[$i]}"
            local name=$(get_field "$item" 1)
            if confirm "Include $name?"; then
                set_enabled '"$array_name"' $i 1
            else
                set_enabled '"$array_name"' $i 0
            fi
        done'
    fi
}

# Helper function to generate category in Brewfile
generate_category() {
    local array_name=$1  # Name of the array
    local category_name=$2  # Category name for Brewfile comment

    # Check if any items in this category are enabled
    local has_enabled=false
    eval 'for item in "${'"$array_name"'[@]}"; do
        if [ "$(get_field "$item" 4)" = "1" ]; then
            has_enabled=true
            break
        fi
    done'

    if $has_enabled; then
        echo "# $category_name" >> "$BREWFILE"
        eval 'for item in "${'"$array_name"'[@]}"; do
            if [ "$(get_field "$item" 4)" = "1" ]; then
                local package=$(get_field "$item" 3)
                
                # Auto-detect if this is a cask
                if is_cask "$package"; then
                    echo "cask \"$package\"" >> "$BREWFILE"
                else
                    echo "brew \"$package\"" >> "$BREWFILE"
                fi
            fi
        done'
        echo "" >> "$BREWFILE"
    fi
}

generate_config() {
    # Backup existing files
    backup_file "$BREWFILE"

    # Create Brewfile based on selections
    echo "# Generated Brewfile - $(date)" > "$BREWFILE"
    # No tap needed as homebrew/bundle is now integrated into Homebrew core
    echo "" >> "$BREWFILE"

    # Generate each category
    generate_category ESSENTIAL_TOOLS "Essential Tools"
    generate_category EDITORS "Editors"
    generate_category BROWSERS "Browsers"
    generate_category DEV_TOOLS "Development Tools"
    generate_category PRODUCTIVITY_APPS "Productivity Applications"
    generate_category UTILITY_APPS "Utility Applications"

    echo -e "${GREEN}Configuration files generated successfully!${NC}"
    echo "Generated files:"
    echo "- $BREWFILE"
    echo -e "\nBackups of previous configurations (if any) were created"
}

create_minimal_brewfile() {
    echo "Creating minimal default Brewfile for essential tools only..."
    echo "# Default minimal Brewfile - $(date)" > "$BREWFILE"
    echo "" >> "$BREWFILE"
    echo "# Essential Tools" >> "$BREWFILE"
    
    # Add all essential tools to minimal Brewfile
    for item in "${ESSENTIAL_TOOLS[@]}"; do
        local package=$(get_field "$item" 3)
        local enabled=$(get_field "$item" 4)
        
        if [ "$enabled" = "1" ]; then
            # Auto-detect if this is a cask
            if is_cask "$package"; then
                echo "cask \"$package\"" >> "$BREWFILE"
            else
                echo "brew \"$package\"" >> "$BREWFILE"
            fi
        fi
    done
    
    echo -e "${GREEN}Minimal Brewfile created.${NC} All essential tools will be installed."
    echo "You can run the setup again to select more tools later."
}

setup_config() {
    clear
    print_header "Development Environment Setup"
    
    # Check if Brewfile already exists
    if [ -f "$BREWFILE" ]; then
        echo "A Brewfile already exists at: $BREWFILE"
        echo ""
        echo "Options:"
        echo "  1. Keep using existing Brewfile (no changes)"
        echo "  2. Select new tools (overwrites existing Brewfile)"
        echo "  3. Create minimal Brewfile (only essential tools)"
        echo ""
        read -p "Choose an option (1-3): " option
        
        case $option in
            1)
                echo "Using existing Brewfile. No changes made."
                exit 0
                ;;
            2)
                echo "Proceeding with tool selection..."
                # Continue to the selection process
                ;;
            3)
                create_minimal_brewfile
                exit 0
                ;;
            *)
                echo "Invalid option. Using existing Brewfile."
                exit 0
                ;;
        esac
    else # No Brewfile exists
        echo "No Brewfile found. Let's create one."
        echo ""
        if ! confirm "Would you like to select which tools to install?"; then
            create_minimal_brewfile
            exit 0
        fi
    fi
    
    # Proceed with normal tool selection
    echo "The following essential tools will be installed automatically:"
    echo ""
    for tool in "${ESSENTIAL_TOOLS[@]}"; do
        name=$(get_field "$tool" 1)
        desc=$(get_field "$tool" 2)
        echo "  - $name ($desc)"
    done
    echo ""
    echo "You can now choose additional optional tools to install."
    echo "Press Enter to continue..."
    read

    # Prompt for each category
    prompt_category EDITORS "Code Editors and IDEs"
    prompt_category BROWSERS "Web Browsers"
    prompt_category DEV_TOOLS "Additional Development Tools"
    prompt_category PRODUCTIVITY_APPS "Productivity Applications"
    prompt_category UTILITY_APPS "Utility Applications"

    # Review Selections
    print_header "Configuration Review"

    echo -e "\nSelected Editors:"
    for item in "${EDITORS[@]}"; do
        print_current_selection "$item"
    done

    echo -e "\nSelected Browsers:"
    for item in "${BROWSERS[@]}"; do
        print_current_selection "$item"
    done

    echo -e "\nSelected Development Tools:"
    for item in "${DEV_TOOLS[@]}"; do
        print_current_selection "$item"
    done

    echo -e "\nSelected Productivity Applications:"
    for item in "${PRODUCTIVITY_APPS[@]}"; do
        print_current_selection "$item"
    done

    echo -e "\nSelected Utility Applications:"
    for item in "${UTILITY_APPS[@]}"; do
        print_current_selection "$item"
    done

    # Generate Configuration
    generate_config
}

# Run the setup
setup_config