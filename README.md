# batphone.nvim

This Neovim plugin is my whole setup for Neovim.

The previous [iteration](https://github.com/jhthorsen/batphone.nvim/tree/v1.x.x) was inspired by [LazyVim](https://www.lazyvim.org), while "v2.x.x" is now an entirely rewrite based on the new [vim.pack](https://neovim.io/doc/user/pack.html) feature that will land in Neovim 0.12.x. The new package manager enables neovim configurations to be much simpler, and with very little indirect complexity.

## Prerequisites

You need [Neovim](https://github.com/neovim/neovim/releases) 0.12.x or later.

If you already have neovim set up, then you want to (back up) and clear out the
following directories first:

    $ rm -rf ~/.config/nvim ~/.cache/nvim ~/.local/share/nvim;

## Installation

    $ mkdir -p "$HOME/.config/nvim";
    $ curl -L https://github.com/jhthorsen/batphone.nvim/raw/refs/heads/v2.x.x/.config/nvim/init.lua \
        > "$HOME/.config/nvim/init.lua";
    $ neovim;

Note that the [init.lua][https://github.com/jhthorsen/batphone.nvim/blob/v2.x.x/.config/nvim/init.lua] file is only meant as inspiration, and should be edited by the user.

## Auto installation of packages

See the bundled [init.lua](https://github.com/jhthorsen/batphone.nvim/blob/v2.x.x/.config/nvim/init.lua) file to see how to install certain LSP, Mason and Treesitter features.

## Plugins

The example init.lua file has some plugins, but most of them are optional.

* [echasnovski/mini.nvim](https://github.com/echasnovski/mini.nvim)
* [copilotc-nvim/copilotchat.nvim](https://github.com/copilotc-nvim/copilotchat.nvim))
* [fang2hou/blink-copilot](https://github.com/fang2hou/blink-copilot)
* [folke/lazydev.nvim](https://github.com/folke/lazydev.nvim)
* [folke/snacks.nvim](https://github.com/folke/snacks.nvim)
* [folke/which-key.nvim](https://github.com/folke/which-key.nvim)
* [jake-stewart/multicursor.nvim](https://github.com/mg979/jake-stewart/multicursor.nvim)
* [nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
* [saghen/blink.cmp](https://github.com/saghen/blink.cmp)
* [stevearc/oil.nvim](https://github.com/stevearc/oil.nvim)
* [williamboman/mason.nvim](https://github.com/williamboman/mason.nvim)
* [zbirenbaum/copilot.lua](https://github.com/zbirenbaum/copilot.lua)

## Themes

[Kanagawa](https://github.com/rebelot/kanagawa.nvim) is my choice for now.

## Useful bash function

This function will invoke "nvim" with a file picker, when called without any
arguments.

    vi() {
      if [ -n "$*" ]; then nvim "$@";
      elif [ -d ".git" ]; then nvim -c ":lua Snacks.picker.smart()";
      else nvim -c ':lua require("jhthorsen.util").startup()';
      fi
    }

## Author

Jan Henning Thorsen
