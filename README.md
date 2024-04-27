# Dotfiles

The following repo uses GNU Stow for easy setup on new machines. It also allows me to freely edit my dotfiles while making use of git for versioning.

<!-- prettier-ignore -->
| | | 
|-|-|
| Tip: | For a more detailed guide feel free to visit the following article [here][_r0] |

## Quick Guide

```sh
# install stow package
brew install stow

# create symlinks (this won't overwrite any files that may exist)
stow . --adopt

# verify changes in git and commit any we actually want to adopt
# feel free to discard all "adopted" changes if we only want to
# use what is present in this repo
```

<!-- prettier-ignore -->
| | | 
|-|-|
| Important: | Remember to re-run the `stow` command whenever you add new files. Otherwise their symlink will not exist and will result in module not found issues |

## Resources

-   [Setting the Stage][_r0]
-   [Manage dotfiles with GNU Stow][_r1]
-   [How I manage my dotfiles using GNU Stow][_r2]
-   [GNU Stow Default Ignore List][_r3]
-   [Stow Adopt Workflow][_r4]
-   [ThePrimeagen's init.lua][_r5]
-   [Neovim - Autocmd Groups][_r6]

[_r0]: https://www.lelopez.io/blog/dev-environement
[_r1]: https://dr563105.github.io/blog/manage-dotfiles-with-gnu-stow/
[_r2]: https://tamerlan.dev/how-i-manage-my-dotfiles-using-gnu-stow/
[_r3]: https://www.gnu.org/software/stow/manual/stow.html#Types-And-Syntax-Of-Ignore-Lists
[_r4]: https://unix.stackexchange.com/a/698982
[_r5]: https://github.com/ThePrimeagen/init.lua/tree/master
[_r6]: https://neovim.io/doc/user/autocmd.html#autocmd-groups
[_r7]: https://github.com/nvim-neotest/nvim-nio
[_r8]: https://github.com/ThePrimeagen/harpoon/issues/302
