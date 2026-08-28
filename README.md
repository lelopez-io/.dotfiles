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
./.setup/install.sh
```

After running the install script, you should:
1. Restart your terminal
2. Run `tmux` and press `prefix + I` to install tmux plugins
3. Open neovim to install plugins automatically

This will:

-   Install Homebrew, then prompt per Brewfile section for which tools to
    install (`[REQUIRED]` sections install automatically)
-   Link dotfiles using GNU Stow
-   Install language runtimes declared in `.config/mise/config.toml`
-   Configure shell extras (tmux plugins, nerd font, completions)
-   Configure Git (name, email, delta pager, gh extensions)

## Manual Configuration

If you prefer to manage dotfiles manually without the automatic setup:

```bash
# Install Stow package
brew install stow

# First time setup: create symlinks and adopt existing files
stow . --adopt

# For subsequent updates, just use
stow .
```

Note: The `--adopt` flag will convert your existing dotfiles into symlinks and move the original files into this repo. Use with caution and review any changes with git before committing.

### Working with Directories

Linking entire directories, such as `nvim`, is recommended to avoid rerunning Stow when subdirectories or files are added.

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

Tool selection is driven by the curated Brewfiles in `.setup/` — one per
machine profile (`development`, `productivity`, `personal`). The installer
parses their `## [REQUIRED]` / `## [OPTIONAL]` section headers and prompts
per optional section, so you can adopt only the parts of this tooling you
want. To add or change tools, edit the Brewfiles — they are the single
source of truth.

To re-run tool installation at any time:

```bash
./.setup/scripts/01-tool-install.sh
```

### Additional Configurations

The setup also creates symlinks for:

-   `.gitignore` → `~/.gitignore` (used as global git excludes file)

## Scripts vs Shell Functions

Two homes for personal helpers, split by one question: **does it need to change
the *current* shell?**

| Need | Home | Why |
|------|------|-----|
| A `cd` you stay in, an `export`/`unset` that persists, a `setopt` | **function** in `.zfunctions` | Only a sourced function can mutate the calling shell |
| Per-project env, team-shared (repo-relative paths) | **`[env]` in that repo's committed `mise.toml`** | Identical for every team member; set on cd in, unset on cd out |
| Per-project env, user-specific (your local `DATABASE_URL` for a scratch DB) | **`mise.local.toml`** next to it (globally git-ignored via `~/.gitignore`) | mise merges it over `mise.toml`; never committed |
| Personal defaults that apply everywhere (your AWS profile) | The tool's own untracked config (`~/.aws/config`), or `awsprof` per session | Env vars are overrides; ambient defaults live with the tool |
| Everything else — self-contained "programs" | **script** in `.local/bin/` | One file per tool; not parsed at shell startup; gets `--help`, exit codes, `set -euo pipefail`; language-agnostic |
| Self-contained *logic* — real parsing, concurrency, tests, or distribution | **compiled binary** (e.g. a `rust/` workspace, installed via `cargo install --root ~/.local`) | Shell has become the liability rather than the glue |

`.local/bin` is already on `PATH` (`.zprofile`) and stows to `~/.local/bin`, so a
new tool is just: drop an executable in `.dotfiles/.local/bin/`, `chmod +x`, and
`stow .` once to link it.

This repo is public, so it holds **mechanisms, not specifics**. The bar isn't
whether a *name* appears (a cSpell entry is just a spelling) — it's whether
something reveals how an organization works: emails, internal hosts, 1Password
item names, project layouts. Those live at the call site (typed per session)
or in the project's `mise.local.toml` (globally git-ignored).

Secrets never persist in the session env either: wrappers resolve them
per-invocation into the *child's* env only (`sopsx`, `opx`, `cld`, `pie`).
`OP_SESSION_*` from `opsignin` is the one sanctioned exception — but never
launch an agent from a shell that has it; `cld` and `pie` strip it before
exec as a backstop.

Script conventions:

-   Shebang `#!/usr/bin/env bash`, `set -euo pipefail`, a `usage()` heredoc, and
    a `-h|--help` case.
-   No filename extension (invoke as `keepawake`, not `keepawake.sh`).
-   Name a git helper `git-<verb>` and git picks it up as `git <verb>`
    automatically.
-   Keep GNU-only tool flags out of portable scripts, or guard for them — the
    shell has gnu-sed on `PATH`, a bare script may not.

`.zfunctions` was migrated to `.local/bin/` in one batch (some names went
underscore → hyphen, e.g. `video_info` → `video-info`) and briefly deleted —
then recreated when true shell-mutators showed up (`opsignin`, `awsprof`).
New self-contained helpers land in `.local/bin/`.

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
