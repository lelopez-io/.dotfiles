#!/bin/bash

# Colors for better readability
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Config directory
CONFIG_DIR="$HOME/.dotfiles/setup"
BREWFILE="$CONFIG_DIR/Brewfile"

# Store selections
declare -A browsers
declare -A dev_tools
declare -A productivity_apps

# Initialize default selections
browsers=(
    ["Firefox"]=1
    ["Chrome"]=1
)

dev_tools=(
    ["VSCode"]=1
    ["GitKraken"]=1
    ["Hyper"]=1
)

productivity_apps=(
    ["Obsidian"]=1
    ["1Password"]=1
    ["Spark"]=1
    ["Grammarly"]=1
    ["MeetingBar"]=1
)

# Helper Functions remain the same...
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

# Load existing configuration
load_existing_config() {
    mkdir -p "$CONFIG_DIR"
    
    # Load Brewfile selections if they exist
    if [ -f "$BREWFILE" ]; then
        # Parse existing Brewfile for selections
        while IFS= read -r line; do
            case "$line" in
                *"firefox"*) browsers["Firefox"]=1 ;;
                *"google-chrome"*) browsers["Chrome"]=1 ;;
                *"visual-studio-code"*) dev_tools["VSCode"]=1 ;;
                *"gitkraken"*) dev_tools["GitKraken"]=1 ;;
                *"hyper"*) dev_tools["Hyper"]=1 ;;
                *"obsidian"*) productivity_apps["Obsidian"]=1 ;;
                *"1password"*) productivity_apps["1Password"]=1 ;;
                *"spark"*) productivity_apps["Spark"]=1 ;;
                *"grammarly"*) productivity_apps["Grammarly"]=1 ;;
                *"meetingbar"*) productivity_apps["MeetingBar"]=1 ;;
            esac
        done < "$BREWFILE"
    fi
}

print_current_selection() {
    local -n array=$1
    local name=$2
    if [ "${array[$name]}" -eq 1 ]; then
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

generate_config() {
    # Backup existing files
    backup_file "$BREWFILE"

    # Create Brewfile based on selections
    echo "# Generated Brewfile - $(date)" > "$BREWFILE"
    echo "tap \"homebrew/bundle\"" >> "$BREWFILE"
    echo "tap \"homebrew/cask\"" >> "$BREWFILE"
    echo "tap \"homebrew/core\"" >> "$BREWFILE"
    echo "" >> "$BREWFILE"
    
    # Core utilities (always included)
    echo "# Core Utils" >> "$BREWFILE"
    echo "brew \"stow\"" >> "$BREWFILE"
    echo "brew \"mise\"" >> "$BREWFILE"
    echo "brew \"tree\"" >> "$BREWFILE"
    echo "brew \"tmux\"" >> "$BREWFILE"
    echo "brew \"neovim\"" >> "$BREWFILE"
    echo "brew \"git\"" >> "$BREWFILE"
    echo "brew \"prettierd\"" >> "$BREWFILE"
    echo "brew \"kubectx\"" >> "$BREWFILE"
    echo "brew \"kube-ps1\"" >> "$BREWFILE"
    echo "" >> "$BREWFILE"
    
    # Selected applications
    echo "# Applications" >> "$BREWFILE"
    
    # Add selected browsers
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
    
    # Add selected development tools
    for tool in "${!dev_tools[@]}"; do
        if [ "${dev_tools[$tool]}" -eq 1 ]; then
            case $tool in
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
    
    # Add selected productivity apps
    for app in "${!productivity_apps[@]}"; do
        if [ "${productivity_apps[$app]}" -eq 1 ]; then
            case $app in
                "Obsidian")
                    echo "cask \"obsidian\"" >> "$BREWFILE"
                    ;;
                "1Password")
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
    
    echo "This script will help you configure your development environment."
    echo "Existing configurations will be preserved and can be modified."
    echo "Press Enter to continue..."
    read

    # Browser Selection
    print_header "Browser Selection"
    echo "Currently selected browsers:"
    for browser in "${!browsers[@]}"; do
        print_current_selection browsers "$browser"
    done
    
    if confirm "Would you like to modify browser selection?"; then
        for browser in "${!browsers[@]}"; do
            if confirm "Include $browser?"; then
                browsers[$browser]=1
            else
                browsers[$browser]=0
            fi
        done
    fi

    # Development Tools Selection
    print_header "Development Tools"
    echo "Currently selected development tools:"
    for tool in "${!dev_tools[@]}"; do
        print_current_selection dev_tools "$tool"
    done
    
    if confirm "Would you like to modify development tools selection?"; then
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
    echo "Currently selected productivity applications:"
    for app in "${!productivity_apps[@]}"; do
        print_current_selection productivity_apps "$app"
    done
    
    if confirm "Would you like to modify productivity applications selection?"; then
        for app in "${!productivity_apps[@]}"; do
            if confirm "Include $app?"; then
                productivity_apps[$app]=1
            else
                productivity_apps[$app]=0
            fi
        done
    fi

    # Review Selections
    print_header "Configuration Review"
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
