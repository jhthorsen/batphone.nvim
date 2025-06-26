# batphone.nvim

This Neovim plugin is my whole setup for Neovim. It came to be after looking
into [LazyVim](https://www.lazyvim.org). I'm a bit envious to newcomers that
can start out fresh with LazyVim, since it just looks amazing.

I am however quite happy with my setup, since I like it a bit more minimalistic.

## Prerequisites

You need [Neovim](https://github.com/neovim/neovim/releases) 0.11.x or later.

If you already have neovim set up, then you want to (back up) and clear out the
following directories first:

    $ rm -rf ~/.config/nvim ~/.cache/nvim ~/.local/share/nvim;

## Installation

    $ mkdir -p "$HOME/.config/nvim";
    $ curl -L https://github.com/jhthorsen/batphone.nvim/raw/refs/heads/main/init.lazy.lua \
        > "$HOME/.config/nvim/init.lua";
    $ neovim;

## Environment variables

* `BATPHONE_COPILOT_MODEL=o3-mini` - Preselect a copilot model
* `BATPHONE_LSP_DISABLE="htmx,spectral"` - Disable LSP servers
* `BATPHONE_LSP_ENABLE="superhtml"` - Enable LSP servers
* `CARGO_FEATURES=a,b,c` - Enable features when editing rust files
* `ENABLE_COPILOT={no,yes,force}` - Enable Copilot plugin
* `NVIM_AUTO_INSTALL_PACKAGES=1` - Show install screen, even if there's nothing to do.
* `NVIM_COLORSCHEME=kanagawa-lotus` - Set a custom color scheme
* `NVIM_TERMINAL_SHELL=tmux` - Change the terminal to be started inside neovim

## Auto installation of packages

Batphone.nvim comes with a hook that will prompt you if you want to install a
[LSP](/jhthorsen/batphone.nvim/blob/main/lua/batphone/lsp.lua) and
Treesitter package.

## Plugins

* [echasnovski/mini.nvim](https://github.com/echasnovski/mini.nvim)
* [copilotc-nvim/copilotchat.nvim](https://github.com/copilotc-nvim/copilotchat.nvim))
* [fang2hou/blink-copilot](https://github.com/fang2hou/blink-copilot)
* [folke/lazy.nvim](https://github.com/folke/lazy.nvim)
* [folke/lazydev.nvim](https://github.com/folke/lazydev.nvim)
* [folke/snacks.nvim](https://github.com/folke/snacks.nvim)
* [folke/which-key.nvim](https://github.com/folke/which-key.nvim)
* [jake-stewart/multicursor.nvim](https://github.com/mg979/jake-stewart/multicursor.nvim)
* [neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
* [nvim-lualine/lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)
* [nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
* [rafamadriz/friendly-snippets](https://github.com/rafamadriz/friendly-snippets)
* [saghen/blink.cmp](https://github.com/saghen/blink.cmp)
* [stevearc/conform.nvim](https://github.com/stevearc/conform.nvim)
* [stevearc/oil.nvim](https://github.com/stevearc/oil.nvim)
* [williamboman/mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim)
* [williamboman/mason.nvim](https://github.com/williamboman/mason.nvim)
* [zbirenbaum/copilot.lua](https://github.com/zbirenbaum/copilot.lua)

## Themes

The color scheme can specified by setting the `NVIM_COLORSCHEME` environment
variable.

* [Kanagawa](https://github.com/rebelot/kanagawa.nvim)

## Useful bash function

This function will invoke "nvim" with a file picker, when called without any
arguments.

    vi() {
      if [ -n "$*" ]; then nvim "$@";
      elif [ -d ".git" ]; then nvim -c ":lua Snacks.picker.smart()";
      else nvim -c ":lua Snacks.picker.recent()";
      fi
    }

## Author

Jan Henning Thorsen
