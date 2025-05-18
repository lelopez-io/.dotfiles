---
category: Tutorials
title: Setting the Stage
description: What I use when setting up a computer for software development
comments: true
---

![Empty Canvas](/blog/images/lienzo.webp)

[Lienzo](https://www.spanishdict.com/translate/lienzo) - Just as a painter relies on clean brushes and a well-prepared canvas, a software developer's artistry is deeply influenced by their chosen tools and materials. The right environment, frameworks, and applications provide the backdrop upon which code, like paint strokes, transforms into software masterpieces.

---

## Productivity Tools

Let's start by gather some essential tools that will be constant companions throughout our development journey. These are the applications that I install on every machine forming the cornerstone of a productive toolkit.

1. [**Obsidian:**](https://obsidian.md/) A powerful note-taking app that helps organize thoughts, ideas, and code snippets.
2. [**1Password:**](https://1password.com/) For managing and securing passwords and sensitive information.
3. [**Firefox:**](https://www.mozilla.org/en-US/firefox/new/) The main browser for researching and browsing with any quality of life addons such as an ad blocker.
4. [**Chrome:**](https://www.google.com/chrome/) The testing grounds browser where we limit what addons we install in order to avoid any conflicts while developing.
5. [**Grammarly:**](https://app.grammarly.com/) Your writing assistant to ensure clean code comments and documentation.
6. [**MeetingBar:**](https://meetingbar.app/) A handy tool for keeping track of meetings and appointments.

## Development Easel

These are the programs where the most time is spent! Feel free to style them to preference or start with the provided config files to get up and good quickly.

1. [**Visual Studio Code:**](https://code.visualstudio.com/) A versatile code editor.
    - Download and install the latest version from their website.
    - To enable launching from the command line: Press `Cmd+Shift+P`, search for "Shell Command", and select "Install 'code' command in PATH".
    - Be sure to sign in with Github in order to save profile settings.
    - Take a look at [this file](https://github.com/lelopez-io/.dotfiles/blob/main/.vscode/settings.json) for the settings I typically use.
    - To apply these settings: Press `Cmd+Shift+P`, search for "User Settings (JSON)", and copy the contents of the file into your settings JSON.
2. [**GitKraken:**](https://www.gitkraken.com/) A powerful Git GUI client for version control.
    - Download and install the latest version from their website.
3. [**Ghostty:**](https://ghostty.org/) A highly customizable terminal emulator.
    - Download and install the latest version from their website.
4. [**Nerd Fonts:**](https://www.nerdfonts.com/) - Fonts that can support the various glyphs used by command line tools.
    - Follow [this link](https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/AnonymousPro/Regular/AnonymiceProNerdFontMono-Regular.ttf) for my go-to font and download the raw file.
    - Install by double clicking the font file.

## Command Palette

Our terminal will be the main entry point for the various operations required while developing software. We'll spend some time configuring a few command line tools so that we can use it efficiently.

Although there are a few OS specific steps initially, once we have a consistent foundation, the rest should be platform agnostic between MacOS and Linux.

|          |                                                                                                                                             |
| -------- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| **Tip:** | Windows users should look into [WSL](https://learn.microsoft.com/en-us/windows/wsl/install) in order follow along with minimum differences. |

### Foundational Dependencies

#### MacOS

1. [**Xcode Command Line Tools:**](https://developer.apple.com/xcode/resources/) Enables UNIX-style development via your terminal.
    - Install with the following _terminal_ command
        ```zsh
        xcode-select --install
        ```

|          |                                                                                                                                 |
| -------- | ------------------------------------------------------------------------------------------------------------------------------- |
| **Tip:** | Macs comes with ZSH as the default shell. Git and other build essentials come bundled in the command line tools installed above |

#### Linux (Debian/Ubuntu)

1. [**Build Essentials:**](https://packages.debian.org/sid/build-essential) A package of packages used for building software
    - Install with the following _terminal_ command
        ```sh
        sudo apt-get install build-essential
        ```
2. [**Git:**](https://packages.debian.org/sid/git) A version control system.
    - Install with the following _terminal_ command
        ```sh
        sudo apt-get install git
        ```
3. [**ZSH:**](https://zsh.sourceforge.io/) A shell we'll be extending to make our terminal more helpful
    - Install with the following _terminal_ command
        ```sh
        sudo apt-get install zsh
        ```
    - Set as default shell
        ```sh
        sudo chsh -s $(which zsh)
        ```

### Package Manager

1. [**Homebrew:**](https://brew.sh/) This a go-to for most devs using MacOS. By using this, Linux users can also follow along
    - Install with the following _terminal_ command
        ```zsh
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        ```

### Dotfiles

1. [**Dotfiles:**](https://github.com/lelopez-io/.dotfiles/tree/main) My preferred starting point. If you have your own setting already present, we'll be able to merge them in in a later step.
    - Clone the repo to your home directory
        ```zsh
        git clone https://github.com/lelopez-io/.dotfiles.git ~/.dotfiles
        ```
2. [**GNU Stow:**](https://www.gnu.org/software/stow/) This will help manage all the dot files required for our config by allowing us to version control them.
    - Install the `stow` package
        ```zsh
        brew install stow
        ```
    - Move into the repo
        ```zsh
        cd ~/.dotfiles
        ```
    - Initialize you home directory with the contents in `~/.dotfiles`
        ```zsh
        # The adopt flag will keep any files/settings you have locally.
        stow . --adopt
        ```
3. **Resolve Conflicts:** You can use git to pick and choose what you want to keep. Alternatively, you can discard all changes and keep the repo values instead.

|                |                                                                                                                                                                                                                                                                                     |
| -------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Important:** | If you have used neovim before, you'll want to delete the `~/.config/nvim` directory and re-run the stow command should you wish to keep the repo `nvim` config. Otherwise delete the repo `nvim` directory before running stow so that only your settings are kept without merging |

### Terminal Editor

1. [**NeoVim:**](https://neovim.io/) A vim based text editor that we can extend and configure.
    - Install with the following _terminal_ command
        ```zsh
        brew install neovim
        ```
    - **If you didn't use stow:** copy the following [files](https://github.com/lelopez-io/.dotfiles/tree/main/.config/nvim) to your local `~/.config/nvim` directory
2. **Packages:** Since the config makes use of `folke/lazy.nvim`, we simply have to start neovim for all packages to be installed
    - Install the packages using the following _editor_ command.
        ```sh
        nvim
        ```
3. [**prettierd:**](https://github.com/fsouza/prettierd#installation-guide) Allows our editor to efficiently cleanup and format our files consistently.
    - Install with the following _terminal_ command
        ```zsh
        brew install fsouza/prettierd/prettierd
        ```

### Terminal Multiplexer

1. [**TMUX:**](https://github.com/tmux/tmux/wiki/Installing) Enables multiple terminals to be created and accessed from a single screen.
    - Install with the following _terminal_ command
        ```zsh
        brew install tmux
        ```
    - **If you didn't use stow:** copy the following [file](https://github.com/lelopez-io/.dotfiles/tree/main/.tmux.conf) to your local `~/.tmux.conf` file'
    - Note that we specify `CTRL+A` i.e. `<C-A>` as the prefix key. This means any time we want issue TMUX a command, we need to start with the prefix key.
2. [**TPM:**](https://github.com/tmux-plugins/tpm#installation) A plugin manager for our terminal multiplexer
    - Install with the following _terminal_ command
        ```zsh
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
        ```
3. [**Plugins:**](https://github.com/tmux-plugins/tpm#installing-plugins)
    - Start TMUX with the following _terminal_ command
        ```zsh
        tmux
        ```
    - Install plugins with the following _tmux_ command
        ```tmux
        # <C-a>-I # press CTRL+A at the same time, let go and then press SHIFT+i
        ```

### Shell Configuration

1. [**oh-my-zsh:**](https://ohmyz.sh/#install) A framework for managing our zsh configuration
    - Install with the following _terminal_ command
        ```zsh
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        ```
2. [**Spaceship:**](https://spaceship-prompt.sh/getting-started/#Installing) A ZSH prompt that makes your time in the terminal more pleasant by offering useful information
    - Install with the following _terminal_ command
        ```zsh
        git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1
        ```
    - Link the theme file with the following _terminal_ command
        ```zsh
        ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
        ```
3. [**zsh-syntax-highlighting:**](https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md#oh-my-zsh) Allows us to easily review our commands as we type them.
    - Install with the following _terminal_ command
        ```zsh
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
        ```
4. [**zshrc:**](https://github.com/ohmyzsh/ohmyzsh/wiki/Settings) We can configure our local shell with `.zshrc` as the main entry point.
    - **If you didn't use stow:** copy the following to your `$HOME` directory:
    - [.zshrc](https://github.com/lelopez-io/.dotfiles/tree/main/.zshrc) - sets the theme and plugins while also linking out to the remaining config files.
    - [.zsh_prompt](https://github.com/lelopez-io/.dotfiles/tree/main/.zsh_prompt) - configures the prompt so that it displays useful information to us.
    - [.zsh_profile](https://github.com/lelopez-io/.dotfiles/tree/main/.zsh_profile) - links out to the various cli tools we'll use
    - [.zsh_aliases](https://github.com/lelopez-io/.dotfiles/tree/main/.zsh_aliases) - sets up aliases for frequently used commands

|          |                                                                                                                                                                                                                                            |
| -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Tip:** | Create empty `.zsh_aliases` and `.zsh_profile` files and fill them as needed with only the commands/aliases you use. By filling it out as you go you can avoid errors should you have configurations defined for commands not yet present. |

### Shell Navigation

#### Linux (Debian/Ubuntu)

For Linux users, we need a specific version of openssl to install the version of ruby we want.

1. [**libssl**](https://packages.debian.org/buster/libssl-dev)

    - Install with the following _terminal_ command
        ```zsh
        sudo apt-get update
        sudo apt-get install -y build-essential libssl-dev zlib1g-dev libyaml-dev libreadline-dev libncurses5-dev libffi-dev libgdbm-dev
        ```

2. [**openssl:**](https://www.openssl.org/)
    - Install with the following _terminal_ command
        ```zsh
        brew install openssl@3.0
        ```
    - Add the following _terminal_ environment variable
        ```zsh
        export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@3.0)"
        ```
    - If interested in seeing why these steps are required see these issues
        - [https://teratail.com/questions/4ixflbces78f84](https://teratail.com/questions/4ixflbces78f84)
        - [https://github.com/rbenv/ruby-build/issues/1740#issuecomment-1153411255](https://github.com/rbenv/ruby-build/issues/1740#issuecomment-1153411255)
        - [https://github.com/rvm/rvm/issues/5365#issuecomment-1642414673](https://github.com/rvm/rvm/issues/5365#issuecomment-1642414673)

#### Linux & MacOS

The rest of the commands will work for both platforms.

1. [**tree:**](https://formulae.brew.sh/formula/tree) Allows us to display directories as tries in our terminal
    - Install with the following _terminal_ command
        ```zsh
        brew install tree
        ```
2. [**rubyenv:**](https://github.com/rbenv/rbenv#homebrew) Allows us to install specific versions of ruby. We'll need ruby in order to install colorls later.
    - Install with the following _terminal_ command
        ```zsh
        brew install rbenv ruby-build
        ```
    - Add the related entry(s) to `~/.zsh_profile`
    - Source the `~/.zshrc` file for it to take effect
3. [**ruby:**](https://github.com/rbenv/rbenv#installing-ruby-versions) Well be able to use rubyenv to install the version we want
    - Install with the following _terminal_ command
        ```zsh
        rbenv install 3.2.2
        ```
    - Configure the global version to use
        ```zsh
        rbenv global 3.2.2
        ```
    - Source the `~/.zshrc` file & ensure we're using the correct ruby version.
        ```zsh
        source ~/.zshrc
        which ruby
        which gem
        ```
4. [**colorls:**](https://github.com/athityakumar/colorls#installation)
    - Install with the following _terminal_ command
        ```zsh
        gem install colorls
        ```
    - Add the related entry(s) to `~/.zsh_profile`
    - Source the `~/.zshrc` file for it to take effect

### Version Control

Last but definitely not least is to get your machine configured with your distributed version control. Here we'll setup for Github but the steps should be similar if you have a different provider.

1. [**generate ssh key:**](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#generating-a-new-ssh-key)
    - Initialize by running the following command in your terminal:
        ```zsh
        ssh-keygen -t ed25519 -C "your_email@example.com"
        ```
2. [**register key with agent:**](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#adding-your-ssh-key-to-the-ssh-agent)
    - Start the agent:
        ```zsh
        eval "$(ssh-agent -s)"
        ```
    - Open/Init config file
        ```zsh
        vim ~/.ssh/config
        ```
    - Add the following to the end of the `~/.ssh/config` file
        ```~/.ssh/config
        Host github.com
            AddKeysToAgent yes
            UseKeychain yes
            IdentityFile ~/.ssh/id_ed25519
        ```
    - (MacOS only) Add the key to your keychain
        ```zsh
        ssh-add --apple-use-keychain ~/.ssh/id_ed25519
        ```
3. [**add to key to account:**](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account)
    - Copy the public key with the following command:
        ```zsh
        pbcopy < ~/.ssh/id_ed25519.pub
        ```
    - Paste that key in your online account settings.
    - Test the key by running the following command:
        ```zsh
        ssh -T git@github.com
        ```

|               |                                                                                                                                                              |
| ------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Important** | You will only ever share the public key. This public key is used to verify that any code pushed up is actually yours _aka_ signed by your local private key. |

## Project Muses

From here the rest depends on you and what kind of software you are looking to develop. Often the size of your team and company will influence how much of the stack you have to touch. Additionally, if you are joining a team with existing projects, it's best you look at their READMEs and other documentation for specific instruction on how to best configure their tooling.

The following are some of the tools I've had to use across various projects and have become staples in my workflow.

### Frontend Development

#### Javascript/Typescript

1. [**nvm:**](https://github.com/nvm-sh/nvm#installing-and-updating) A Node version manager allows you have multiple versions of node should you have to work on projects with different requirements.
    - Install with the following _terminal_ command
        ```zsh
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
        ```
    - Add the related entry(s) to `~/.zsh_profile`
    - Source the `~/.zshrc` file for it to take effect
2. [**node:**](https://github.com/nvm-sh/nvm#usage) With NVM we can install the latest LTS version for our runtime environment
    - Install with the following _terminal_ command
        ```zsh
        nvm install node
        ```
    - Source the `~/.zshrc` file for it to take effect

### Backend Development

#### Python

1. [**pyenv:**](https://github.com/pyenv/pyenv#homebrew-in-macos) A Python version manager. Similar to Node above, it's possible to work on multiple projects that depend on different versions.
    - Install with the following _terminal_ command
        ```zsh
        brew install pyenv pyenv-virtualenv
        ```
    - Add the related entry(s) to `~/.zsh_profile`
    - Source the `~/.zshrc` file for it to take effect
2. [**python:**](https://github.com/pyenv/pyenv?tab=readme-ov-file#usage)
    - Install with the following _terminal_ command
        ```zsh
        pyenv install 3
        ```
    - Configure the global default
        ```zsh
        pyenv global 3
        ```
    - Init a virtual env (as needed / if a project requires this)
        ```
        pyenv virtualenv project-name
        ```

### Mobile Development

#### Flutter

1. [**Flutter:**](https://docs.flutter.dev/get-started/install) Helps you develop cross platform applications.
    - Installation is not as simple as the instructions for Python or Node and can vary depending on platform. Please visit their site for the latests instructions.
    - Add the related entry(s) to `~/.zsh_profile`
    - Source the `~/.zshrc` file for it to take effect
2. [**Android Studio:**](https://developer.android.com/studio/index.html)
    - Download and install then follow flow for SDK Command-Line Tools
3. [**Xcode**](https://developer.apple.com/xcode/)
    - Download and install

### Containers

1. [**Rancher Desktop:**](https://docs.rancherdesktop.io/getting-started/installation/)

    - Install the latest [release](https://github.com/rancher-sandbox/rancher-desktop/releases)
    - Pick the `dockerd` runtime when given the option.
    - Select manual path config when give the option.
    - Add the related entry(s) to `~/.zsh_profile`
    - Source the `~/.zshrc` file for it to take effect

|                |                                                                                   |
| -------------- | --------------------------------------------------------------------------------- |
| **Important:** | Rancher Desktop is a pre-requisite if you are also going to be working Kubernetes |

### Kubernetes

1. [**kubectl:**](https://kubernetes.io/docs/reference/kubectl/) A command line tool for communicating with a Kubernetes cluster's control plane.
    - This comes from the Rancher Desktop install mentioned above.
    - Add the related entry(s) to `~/.zsh_profile`
    - Source the `~/.zshrc` file for it to take effect
2. [**kubectx + kubens:**](https://github.com/ahmetb/kubectx#homebrew-macos-and-linux) A useful tool that allows us to easily switch between clusters and namespaces
    - Install with the following _terminal_ command
        ```zsh
        brew install kubectx
        ```
3. [**kube-ps1:**](https://github.com/jonmosco/kube-ps1?tab=readme-ov-file#macos-brew-ports) Allows us to disable kubernetes status in our prompt when not needed.
    - Install with the following _terminal_ command
        ```zsh
        brew install kube-ps1
        ```
    - Add the related entry(s) to `~/.zsh_aliases`
    - Source the `~/.zshrc` file for it to take effect

### Google Cloud

1. [**google-cloud-sdk:**](https://cloud.google.com/sdk/docs/install)
    - Download the appropriate package for your platform
    - Extract the `google-cloud-sdk` directory to the `~/.gcloud` path
    - Add the related entry(s) to `~/.zsh_profile`
    - Source the `~/.zshrc` file for it to take effect

### CI/CD

1. [**Concourse/Fly**](https://concourse-ci.org/fly.html)
    - Install with the following _terminal_ command
        ```zsh
        brew install --cask fly
        ```
    - Add the related entry(s) to `~/.zsh_profile`
    - Source the `~/.zshrc` file for it to take effect
