# Dotfiles

This repository provides a streamlined setup for managing dotfiles and configuring a new development environment on macOS and Linux, utilizing GNU Stow for dotfile management.

## Prerequisites

### MacOS

1. Install Xcode Command Line Tools:
```bash
xcode-select --install
```

Note: Homebrew Cask is included with Homebrew and will be used to install macOS applications automatically. This eliminates the need for manual "drag and drop" installation of GUI applications.

### Linux (Debian/Ubuntu)

1. Install build essentials, git, and ZSH:
```bash
sudo apt-get update
sudo apt-get install -y build-essential git zsh
```

2. Set ZSH as default shell (restart required):
```bash
chsh -s $(which zsh)
```

Note: You'll need to log out and back in for the shell change to take effect.

## Quick Start

1. Clone the repository:

```bash
git clone https://github.com/lelopez-io/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

2. Run the setup script:

```bash
./setup/scripts/install.sh
```

After running the install script, you should:
1. Restart your terminal
2. Run `tmux` and press `prefix + I` to install tmux plugins
3. Open neovim to install plugins automatically

This will:

-   Configure your preferences (applications, git settings)
    - Git name and email
    - Global gitignore file
    - Default branch name (main)
-   Install core tools via Homebrew
-   Setup language environments (Node.js, Python, Ruby)
-   Link dotfiles using GNU Stow

## Manual Configuration

If you prefer to manage dotfiles manually without the automatic setup:

```bash
# Install Stow package
brew install stow

# Create symlinks (this won't overwrite any existing files)
stow . --adopt

# Review changes in Git and commit any you want to adopt
# Discard all "adopted" changes if you only want to use what is present in this repo
```

## Additional Development Tools

The following tools can be installed after the initial setup, depending on your development needs:

### Version Control Setup
- [Generate SSH Keys for Github](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#generating-a-new-ssh-key)
- [Add SSH Key to Github](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account)

### Mobile Development
- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- [Android Studio](https://developer.android.com/studio)
- [Xcode](https://developer.apple.com/xcode/) (MacOS only)

### Cloud Development
- [Google Cloud SDK](https://cloud.google.com/sdk/docs/install)

### Working with Directories

Linking entire directories, such as `nvim`, is recommended to avoid rerunning Stow when subdirectories or files are added.

```bash
# Delete the existing directory if everything already matches
rm -Rf ~/.config/nvim

# Re-run Stow to create a link to the `nvim` directory in this repo
stow . --adopt
```

## Customization

The setup is configurable through an interactive prompt that allows you to:

-   Select which applications to install
-   Configure Git credentials
-   Choose development tools
-   Select productivity applications

To reconfigure at any time:

```bash
./setup/configure.sh
```

### Additional Configurations

The setup also creates symlinks for:

-   `.gitignore` → `~/.gitignore` (used as global git excludes file)
-   `.env.aider` → `~/.env.aider` (for aider configuration access from any directory)

## Resources

-   [Setting the Stage][_r00]
-   [Manage dotfiles with GNU Stow][_r01]
-   [How I manage my dotfiles using GNU Stow][_r02]
-   [GNU Stow Default Ignore List][_r03]
-   [Stow Adopt Workflow][_r04]
-   [ThePrimeagen's init.lua][_r05]
-   [Neovim - Autocmd Groups][_r06]

[_r00]: https://www.lelopez.io/blog/dev-environement
[_r01]: https://dr563105.github.io/blog/manage-dotfiles-with-gnu-stow/
[_r02]: https://tamerlan.dev/how-i-manage-my-dotfiles-using-gnu-stow/
[_r03]: https://www.gnu.org/software/stow/manual/stow.html#Types-And-Syntax-Of-Ignore-Lists
[_r04]: https://unix.stackexchange.com/a/698982
[_r05]: https://github.com/ThePrimeagen/init.lua/tree/master
[_r06]: https://neovim.io/doc/user/autocmd.html#autocmd-groups
[_r07]: https://github.com/nvim-neotest/nvim-nio
[_r08]: https://github.com/ThePrimeagen/harpoon/issues/302
[_r09]: https://github.com/kmarius/jsregexp
[_r10]: https://github.com/L3MON4D3/LuaSnip/issues/569
[_r11]: https://github.com/L3MON4D3/LuaSnip/issues/759
