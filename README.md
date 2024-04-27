# Dotfiles

This repository utilizes GNU Stow for easy setup on new machines, facilitating the management of dotfiles with Git versioning.

<!-- prettier-ignore -->
| | |
|-|-|
| Tip: | For a more detailed guide, check [this article][_r00]. |

## Quick Guide

```sh
# Install Stow package
brew install stow

# Create symlinks (this won't overwrite any existing files)
stow . --adopt

# Review changes in Git and commit any you want to adopt
# Discard all "adopted" changes if you only want to use what is present in this repo
```

## Directories

Linking entire directories, such as `nvim`, is recommended to avoid rerunning Stow when subdirectories or files are added.

```sh
# Delete the existing directory if everything already matches
rm -Rf ~/.config/nvim

# Re-run Stow to create a link to the `nvim` directory in this repo
stow . --adopt
```

## Resources

- [Setting the Stage][_r00]
- [Manage dotfiles with GNU Stow][_r01]
- [How I manage my dotfiles using GNU Stow][_r02]
- [GNU Stow Default Ignore List][_r03]
- [Stow Adopt Workflow][_r04]
- [ThePrimeagen's init.lua][_r05]
- [Neovim - Autocmd Groups][_r06]

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

