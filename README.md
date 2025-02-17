# batphone.nvim

This Neovim plugin is my whole setup for Neovim. It came to be after looking
into [LazyVim](https://www.lazyvim.org). I'm a bit envious to newcomers that
can start out fresh with LazyVim, since it just looks amazing.

I am however quite happy with my setup, since I like it a bit more minimalistic.

## Prerequisites

You need [Neovim](https://github.com/neovim/neovim/releases) 0.10.x or later.

## Installation

    $ mkdir -p "$HOME/.config/nvim";
    $ curl -L https://github.com/jhthorsen/batphone.nvim/raw/refs/heads/main/init.lazy.lua \
        > "$HOME/.config/nvim/init.lua";
    $ neovim;

## Useful bash function

This function will invoke "nvim" with a file picker, when called without any
arguments.

    vi() {
      if [ -n "$*" ]; then nvim "$@";
      elif [ -d ".git" ]; then nvim -c ":Telescope git_files";
      else nvim -c ":Telescope oldfiles";
      fi
    }

## Credits

This latest iteration of my neovim setup has config that is copy/pasted from
[LazyVim](https://www.lazyvim.org).

## Plugins

- echasnovski/mini.nvim
- fang2hou/blink-copilot
- folke/flash.nvim
- folke/lazy.nvim
- folke/lazydev.nvim
- folke/snacks.nvim
- folke/which-key.nvim
- mg979/vim-visual-multi
- neovim/nvim-lspconfig
- nvim-lua/plenary.nvim
- nvim-lualine/lualine.nvim
- nvim-tree/nvim-web-devicons
- nvim-treesitter/nvim-treesitter
- rafamadriz/friendly-snippets
- rebelot/kanagawa.nvim
- saghen/blink.cmp
- stevearc/conform.nvim
- williamboman/mason-lspconfig.nvim
- williamboman/mason.nvim
- zbirenbaum/copilot.lua

## Author

Jan Henning Thorsen
