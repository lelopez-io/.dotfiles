---
category: Tutorials
title: Setting the Stage
description: What I use when setting up a computer for software development
comments: true
---

![Empty Canvas](/blog/images/lienzo.webp)

[Lienzo](https://www.spanishdict.com/translate/lienzo) - Just as a painter relies on clean brushes and a well-prepared canvas, a software developer's artistry is deeply influenced by their chosen tools and materials. The right environment, frameworks, and applications provide the backdrop upon which code, like paint strokes, transforms into software masterpieces.

## Automated Setup

The easiest way to set up this development environment is to use the automated setup script. For detailed instructions, please refer to the [dotfiles repository README](https://github.com/lelopez-io/.dotfiles#readme).

The automated script will guide you through an interactive setup process, allowing you to choose which tools to install. It handles all the steps described below in the correct order, making it the recommended approach for most users.

---

## Foundational Dependencies

### MacOS

1. [**Xcode Command Line Tools:**](https://developer.apple.com/xcode/resources/) Enables UNIX-style development via your terminal.
    ```zsh
    xcode-select --install
    ```

|          |                                                                                                                                 |
| -------- | ------------------------------------------------------------------------------------------------------------------------------- |
| **Tip:** | Macs comes with ZSH as the default shell. Git and other build essentials come bundled in the command line tools installed above |

### Linux (Debian/Ubuntu)

1. [**Build Essentials:**](https://packages.debian.org/sid/build-essential) A package of packages used for building software

    ```sh
    sudo apt-get install build-essential
    ```

2. [**Git:**](https://packages.debian.org/sid/git) A version control system.

    ```sh
    sudo apt-get install git
    ```

3. [**ZSH:**](https://zsh.sourceforge.io/) A shell we'll be extending to make our terminal more helpful
    ```sh
    sudo apt-get install zsh
    sudo chsh -s $(which zsh) $USER
    ```

## Core Setup

### MacOS

1. [**Homebrew:**](https://brew.sh/) A package manager for macOS that simplifies the installation of software.
    - Install with the following _terminal_ command
        ```bash
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        ```
    - Add Homebrew to your PATH
        ```bash
        eval "$(/opt/homebrew/bin/brew shellenv)"
        ```

### Linux (Debian/Ubuntu)

1. [**Homebrew:**](https://brew.sh/) A package manager for Linux that simplifies the installation of software.
    - Install with the following _terminal_ command
        ```bash
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        ```
    - Add Homebrew to your PATH
        ```bash
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        ```

## Configure Your Tools

Before installing software, you need to decide which tools you'd like to use. The following categories of tools are available:

### Essential Tools

These core command-line utilities form the foundation of your development environment:

-   [**Stow:**](https://www.gnu.org/software/stow/) Symlink management for dotfiles
-   [**Tmux:**](https://github.com/tmux/tmux) Terminal multiplexer for multiple sessions
-   [**Neovim:**](https://neovim.io/) Modern, enhanced Vim text editor
-   [**Prettierd:**](https://github.com/fsouza/prettierd) Daemon for the Prettier code formatter
-   [**Stylua:**](https://github.com/JohnnyMorganz/StyLua) Lua code formatter
-   [**YT-DLP:**](https://github.com/yt-dlp/yt-dlp) Media downloader
-   [**FFmpeg:**](https://ffmpeg.org/) Media processing library
-   [**LibYAML:**](https://github.com/yaml/libyaml) YAML parser and emitter
-   [**Silver Searcher (ag):**](https://github.com/ggreer/the_silver_searcher) Fast code search tool
-   [**Ripgrep:**](https://github.com/BurntSushi/ripgrep) Fast file content searcher
-   [**Wget:**](https://www.gnu.org/software/wget/) File downloader
-   [**JQ:**](https://stedolan.github.io/jq/) JSON processor
-   [**Git-Delta:**](https://github.com/dandavison/delta) Syntax-highlighting pager for git
-   [**Mise:**](https://mise.jdx.dev/) Modern runtime version manager

If installing manually, you can install essential tools with Homebrew:

-   Install with the following _terminal_ command
    ```bash
    brew install stow tmux neovim prettierd stylua yt-dlp ffmpeg libyaml the_silver_searcher ripgrep wget jq git-delta mise
    ```

### Development Editors & Environments

These are the programs where you'll spend most of your development time:

1. [**Visual Studio Code:**](https://code.visualstudio.com/) A versatile code editor.

    - Install with the following _terminal_ command
        ```bash
        brew install --cask visual-studio-code
        ```

2. [**GitKraken:**](https://www.gitkraken.com/) A powerful Git GUI client for version control.

    - Install with the following _terminal_ command
        ```bash
        brew install --cask gitkraken
        ```

3. [**Ghostty:**](https://ghostty.org/) A highly customizable terminal emulator.

    - Install with the following _terminal_ command
        ```bash
        brew install --cask ghostty
        ```

4. [**Nerd Fonts:**](https://www.nerdfonts.com/) Fonts with glyphs for shell and editors.
    - For macOS, install with the following _terminal_ command
        ```bash
        curl -fLo "$HOME/Library/Fonts/AnonymiceProNerdFontMono-Regular.ttf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/AnonymousPro/Regular/AnonymiceProNerdFontMono-Regular.ttf
        ```
    - For Linux, install with the following _terminal_ commands
        ```bash
        mkdir -p "$HOME/.local/share/fonts"
        curl -fLo "$HOME/.local/share/fonts/AnonymiceProNerdFontMono-Regular.ttf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/AnonymousPro/Regular/AnonymiceProNerdFontMono-Regular.ttf
        fc-cache -f -v
        ```

### Browsers

Essential browsers for development and testing:

1. [**Firefox:**](https://www.mozilla.org/en-US/firefox/new/) The main browser for research with ad-blockers and extensions.

    - Install with the following _terminal_ command
        ```bash
        brew install --cask firefox
        ```

2. [**Chrome:**](https://www.google.com/chrome/) A clean testing environment with minimal extensions.
    - Install with the following _terminal_ command
        ```bash
        brew install --cask google-chrome
        ```

### Development Tools

Specialized tools for container and cloud development:

1. [**Rancher Desktop:**](https://rancherdesktop.io/) Container management platform.

    - Install with the following _terminal_ command
        ```bash
        brew install --cask rancher
        ```

2. [**Kubectx:**](https://github.com/ahmetb/kubectx) Tool for switching Kubernetes contexts.

    - Install with the following _terminal_ command
        ```bash
        brew install kubectx
        ```

3. [**Kube-ps1:**](https://github.com/jonmosco/kube-ps1) Kubernetes prompt for bash and zsh.
    - Install with the following _terminal_ command
        ```bash
        brew install kube-ps1
        ```

### Productivity Applications

Tools to help organize your work:

1. [**Obsidian:**](https://obsidian.md/) A powerful note-taking app for thoughts, ideas, and code snippets.

    - Install with the following _terminal_ command
        ```bash
        brew install --cask obsidian
        ```

2. [**MeetingBar:**](https://meetingbar.app/) A handy tool for tracking meetings in your menu bar.
    - Install with the following _terminal_ command
        ```bash
        brew install --cask meetingbar
        ```

### Utility Applications

Additional utilities to enhance your workflow:

1. [**Swish:**](https://highlyopinionated.co/swish/) Window management through gestures.

    - Install with the following _terminal_ command
        ```bash
        brew install --cask swish
        ```

2. [**Discord:**](https://discord.com/) Communication platform for communities.

    - Install with the following _terminal_ command
        ```bash
        brew install --cask discord
        ```

3. [**Raycast:**](https://www.raycast.com/) Productivity launcher and replacement for Spotlight.

    - Install with the following _terminal_ command
        ```bash
        brew install --cask raycast
        ```

4. [**AnyDesk:**](https://anydesk.com/) Remote desktop software.

    - Install with the following _terminal_ command
        ```bash
        brew install --cask anydesk
        ```

5. [**HiddenBar:**](https://github.com/dwarvesf/hidden/) Cleanup your menu bar icons.

    - Install with the following _terminal_ command
        ```bash
        brew install --cask hiddenbar
        ```

6. [**1Password:**](https://1password.com/) Password manager and secure information storage.
    - Install with the following _terminal_ command
        ```bash
        brew install --cask 1password
        ```

## Setting Up Language Environments

With [mise](https://mise.jdx.dev/) (the modern runtime version manager), you can easily manage multiple programming language versions:

1. **Activate mise:**

    - Install with the following _terminal_ command
        ```bash
        eval "$(mise activate bash)"
        ```

2. **Set up Node.js:**

    - Install with the following _terminal_ command
        ```bash
        mise use --global node@lts
        ```

3. **Set up Python:**

    - Install with the following _terminal_ command
        ```bash
        mise use --global python@3.12
        ```

4. **Set up Ruby:**
    - Install with the following _terminal_ command
        ```bash
        RUBY_CONFIGURE_OPTS="--with-libyaml-dir=$(brew --prefix libyaml)" mise use --global ruby@latest
        ```

## Shell Configuration

### Terminal Enhancements

We'll set up several tools to make your terminal more powerful and user-friendly:

1. **Install colorls** for enhanced directory listings:

    - Install with the following _terminal_ command
        ```bash
        mise exec ruby -- gem install colorls
        ```

2. **Install aider** for AI-assisted coding:

    - Install with the following _terminal_ command
        ```bash
        mise exec python -- python -m pip install -U aider-chat
        ```

3. **Install oh-my-zsh** framework for managing zsh configuration:

    - Install with the following _terminal_ command
        ```bash
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        ```

4. **Install spaceship prompt** for an enhanced terminal experience:

    - Install with the following _terminal_ command

        ```bash
        git clone https://github.com/spaceship-prompt/spaceship-prompt.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/spaceship-prompt" --depth=1
        ```

    - Link the theme file:
        - Install with the following _terminal_ command
            ```bash
            ln -sf "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/spaceship-prompt/spaceship.zsh-theme" "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/spaceship.zsh-theme"
            ```

5. **Install zsh plugins** for syntax highlighting and autosuggestions:

    - Install with the following _terminal_ command
        ```bash
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
        git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
        ```

6. **Setup tmux plugin manager** for extending your terminal multiplexer:

    - Install with the following _terminal_ command
        ```bash
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
        ```

7. **Install nerd fonts** for terminal glyphs (platform-specific):

    - For macOS, install with the following _terminal_ command

        ```bash
        curl -fLo "$HOME/Library/Fonts/AnonymiceProNerdFontMono-Regular.ttf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/AnonymousPro/Regular/AnonymiceProNerdFontMono-Regular.ttf
        ```

    - For Linux, install with the following _terminal_ command
        ```bash
        mkdir -p "$HOME/.local/share/fonts"
        curl -fLo "$HOME/.local/share/fonts/AnonymiceProNerdFontMono-Regular.ttf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/AnonymousPro/Regular/AnonymiceProNerdFontMono-Regular.ttf
        fc-cache -f -v
        ```

## Git Configuration

### Setting up Git

Git is essential for version control. Let's configure it for use with GitHub:

1. **Configure git user details** if not already set:

    - Install with the following _terminal_ command
        ```bash
        git config --global user.name "Your Name"
        git config --global user.email "your.email@example.com"
        ```

2. **Set default branch to main**:

    - Install with the following _terminal_ command
        ```bash
        git config --global init.defaultBranch main
        ```

3. **Configure git to use global gitignore**:

    - Install with the following _terminal_ command
        ```bash
        git config --global core.excludesfile ~/.gitignore
        ```

4. **Generate SSH key** for GitHub:

    - Install with the following _terminal_ command
        ```bash
        ssh-keygen -t ed25519 -C "your.email@example.com"
        ```

5. **Start SSH agent**:

    - Install with the following _terminal_ command
        ```bash
        eval "$(ssh-agent -s)"
        ```

6. **Create SSH config**: - Install with the following _terminal_ command
   `bash
        mkdir -p ~/.ssh
        cat > ~/.ssh/config << EOL
Host github.com
    AddKeysToAgent yes
    UseKeychain yes
    IdentityFile ~/.ssh/id_ed25519
EOL
        `

7. **Add key to keychain** (platform-specific):

    - For macOS, install with the following _terminal_ command

        ```bash
        ssh-add --apple-use-keychain ~/.ssh/id_ed25519
        ```

    - For Linux, install with the following _terminal_ command
        ```bash
        ssh-add ~/.ssh/id_ed25519
        ```

8. **Display the public key** (add to GitHub):
    - Install with the following _terminal_ command
        ```bash
        cat ~/.ssh/id_ed25519.pub
        ```

## Dotfiles Setup

### Managing Configuration Files

Dotfiles help maintain consistent configurations across different machines:

1. [**Dotfiles:**](https://github.com/lelopez-io/.dotfiles/tree/main) My preferred starting point for configuration files.

    - **Clone the repository** if you haven't already:

        - Install with the following _terminal_ command
            ```zsh
            git clone https://github.com/lelopez-io/.dotfiles.git ~/.dotfiles
            ```

    - **Change to the dotfiles directory**:

        - Install with the following _terminal_ command
            ```zsh
            cd ~/.dotfiles
            ```

    - **Use stow to create symlinks**:
        - Install with the following _terminal_ command
            ```zsh
            stow . --adopt
            ```

    At this point, you can either:

    - **Option 1**: Keep changes from your existing configs:

        - Install with the following _terminal_ command
            ```zsh
            git add . && git commit -m 'feat: adopt existing configs'
            ```

    - **Option 2**: Discard changes and use repo versions:

        - Install with the following _terminal_ command
            ```zsh
            git restore .
            stow . --restow
            ```

    - **Set up additional symlinks**:
        - Install with the following _terminal_ command
            ```zsh
            ln -sf "$HOME/.dotfiles/.gitignore" "$HOME/.gitignore"
            ln -sf "$HOME/.dotfiles/.env.aider" "$HOME/.env.aider"
            ```

## Final Configuration Steps

After installing all components, you need to complete a few final steps to get everything working properly:

### Configure Visual Studio Code

1. **Launch VS Code and configure settings**:
    - Launch VS Code from the command line
        ```bash
        code
        ```
    - Open the settings JSON by pressing `Cmd+Shift+P` (macOS) or `Ctrl+Shift+P` (Linux), typing "Preferences: Open Settings (JSON)", and selecting it
    - Copy the contents from the [repository's settings file](https://github.com/lelopez-io/.dotfiles/blob/main/.vscode/settings.json)
    - Paste these settings into your settings JSON file and save

### Install Tmux Plugins

1. **Start tmux and install plugins**:
    - Launch tmux in your terminal
        ```bash
        tmux
        ```
    - Install the plugins by pressing `Ctrl+A` and then `Shift+I`
    - You'll see a message at the bottom of the screen confirming the plugins are installed

### Initialize Neovim Plugins

1. **Launch Neovim to set up plugins**:
    - Start Neovim from your terminal
        ```bash
        nvim
        ```
    - The lazy.nvim plugin manager will automatically detect and install all configured plugins
    - Wait for the installation to complete before using Neovim

---

That's it! Your development environment should now be set up and ready to go. If you encounter any issues, please refer to the specific tool's documentation or check for errors in the console output.

|          |                                                                                                                                                                                                                                                  |
| -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Tip:** | If you're using the automated script (`./install.sh`), it handles all of these steps for you in the correct order. If you prefer to understand what's happening or want more control, following this manual guide gives you the same end result. |

## Additional Specialized Tools

For more specialized development needs, you can extend your setup with language-specific and cloud development tools. Here are some examples:

1. **For Go development**:

    - Install with the following _terminal_ command
        ```bash
        mise use --global go@latest
        ```

2. **For Rust development**:

    - Install with the following _terminal_ command
        ```bash
        mise use --global rust@stable
        ```

3. **For Java development**:

    - Install with the following _terminal_ command
        ```bash
        mise use --global java@temurin-17
        ```

4. **For PHP development**:

    - Install with the following _terminal_ command
        ```bash
        mise use --global php@8.1
        ```

5. **Cloud provider tools**:

    - **AWS CLI**:

        - Install with the following _terminal_ command
            ```bash
            brew install awscli
            ```

    - **Azure CLI**:

        - Install with the following _terminal_ command
            ```bash
            brew install azure-cli
            ```

    - **Google Cloud SDK**:
        - Install with the following _terminal_ command
            ```bash
            brew install --cask google-cloud-sdk
            ```
