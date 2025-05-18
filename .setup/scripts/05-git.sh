#!/bin/bash
set -e

echo "=== Setting up Git Configuration ==="

# Configure git if not already set
echo "Checking Git configuration..."
if [ -z "$(git config --global user.name)" ]; then
    read -p "Enter your Git name: " git_name
    git config --global user.name "$git_name"
    echo "Git user name set to: $git_name"
fi

if [ -z "$(git config --global user.email)" ]; then
    read -p "Enter your Git email: " git_email
    git config --global user.email "$git_email"
    echo "Git email set to: $git_email"
fi

# Set default branch to main if not set
if [ -z "$(git config --global init.defaultBranch)" ]; then
    echo "Setting default Git branch to 'main'..."
    git config --global init.defaultBranch main
fi

# Configure git to use global gitignore if not already set
if [ -z "$(git config --global core.excludesfile)" ]; then
    echo "Setting up global gitignore..."
    git config --global core.excludesfile ~/.gitignore
fi

# Setup SSH for GitHub if not already configured
echo "Checking SSH configuration for Git..."
if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
    echo "No SSH key found. Would you like to generate one for Git? (Recommended)"
    read -p "Generate SSH key? (y/n) " generate_key
    
    if [[ "$generate_key" =~ ^[Yy]$ ]]; then
        echo "Please enter your email for the SSH key:"
        read -p "Email: " git_email
        
        # Generate SSH key
        ssh-keygen -t ed25519 -C "$git_email"
        
        # Start SSH agent
        eval "$(ssh-agent -s)"
        
        # Create or update SSH config
        mkdir -p "$HOME/.ssh"
        if [ ! -f "$HOME/.ssh/config" ]; then
            echo "Host github.com
    AddKeysToAgent yes
    UseKeychain yes
    IdentityFile ~/.ssh/id_ed25519" > "$HOME/.ssh/config"
        else
            if ! grep -q "Host github.com" "$HOME/.ssh/config"; then
                echo "
Host github.com
    AddKeysToAgent yes
    UseKeychain yes
    IdentityFile ~/.ssh/id_ed25519" >> "$HOME/.ssh/config"
            fi
        fi
        
        # Add key to keychain (MacOS only)
        if [[ "$OSTYPE" == "darwin"* ]]; then
            ssh-add --apple-use-keychain ~/.ssh/id_ed25519
        else
            ssh-add ~/.ssh/id_ed25519
        fi
        
        # Display public key for copying
        echo "Your SSH public key is:"
        echo "-------------------------"
        cat ~/.ssh/id_ed25519.pub
        echo "-------------------------"
        echo "Please add this key to your GitHub account."
        echo "Visit: https://github.com/settings/keys"
    fi
else
    echo "SSH key already exists at ~/.ssh/id_ed25519"
fi

# Display git configuration summary
echo "Git configuration summary:"
echo "-------------------------"
echo "User name: $(git config --global user.name)"
echo "Email: $(git config --global user.email)"
echo "Default branch: $(git config --global init.defaultBranch)"
echo "Global ignore file: $(git config --global core.excludesfile)"
echo "-------------------------"

echo "Git configuration complete!"