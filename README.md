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

## Environment variables

### BATPHONE\_NVIM\_DISABLE\_LSP\_SERVERS

This environment variable can be set to disable certain
[language\_servers](/jhthorsen/batphone.nvim/tree/main/lua/batphone/language_servers)

Example:

    export BATPHONE_NVIM_DISABLE_LSP_SERVERS="gopls perlnavigator"

## Structure

It's a bug if something is out of place.

### Entry point

[lua/batphone/init.lua](/jhthorsen/batphone.nvim/blob/main/lua/batphone/init.lua)
loads most basic parts. Some of these modules might become
[lazy](https://github.com/folke/lazy.nvim/blob/e5e9bf48211a13d9ee6c1077c88327c49c1ab4a0/lua/lazy/core/plugin.lua#L382) in the future.

### Basics

* [Auto commands](/jhthorsen/batphone.nvim/blob/main/lua/batphone/autocmds.lua)
* [Options](/jhthorsen/batphone.nvim/blob/main/lua/batphone/options.lua)

### Keymaps

#### Automagic

[lua/batphone/keymaps/automagic.lua](/jhthorsen/batphone.nvim/blob/main/lua/batphone/keymaps/automagic.lua)
contains keymaps that does not require additional knowledge, meaning they
*should just happen* when you press regular (neo)vim keys.

#### User

[lua/batphone/keymaps/user.lua](/jhthorsen/batphone.nvim/blob/main/lua/batphone/keymaps/user.lua)
contains misc keymaps, which all should have a "desc", so the file does not
require additional documentation.

#### Plugin keys

[lua/batphone/keymaps/plugins.lua](/jhthorsen/batphone.nvim/blob/main/lua/batphone/keymaps/plugins.lua)
contains pure data structures that can be passed on to `keys`
in the [Lazy spec](https://lazy.folke.io/spec#spec-lazy-loading).

#### Other files

The other files in the keymaps directory should map to a given
[plugin](/jhthorsen/batphone.nvim/tree/main/lua/batphone/plugins).

### LSP / Treesitter

[lua/batphone/language\_servers](/jhthorsen/batphone.nvim/tree/main/lua/batphone/language_servers)
contains instructions for the language server protocol and treesitter.

### Plugins

[lua/batphone/plugins](/jhthorsen/batphone.nvim/tree/main/lua/batphone/plugins)
is imported by [Lazy.nvim](https://lazy.folke.io/usage/structuring#%EF%B8%8F-importing-specs-config--opts)
when Batphone.nvim is loaded.

Currently the following plugins are (lazy) loaded:

- [echasnovski/mini.nvim](https://github.com/echasnovski/mini.nvim)
- [fang2hou/blink-copilot](https://github.com/fang2hou/blink-copilot)
- [folke/flash.nvim](https://github.com/folke/flash.nvim)
- [folke/lazy.nvim](https://github.com/folke/lazy.nvim)
- [folke/lazydev.nvim](https://github.com/folke/lazydev.nvim)
- [folke/snacks.nvim](https://github.com/folke/snacks.nvim)
- [folke/which-key.nvim](https://github.com/folke/which-key.nvim)
- [mg979/vim-visual-multi](https://github.com/mg979/vim-visual-multi)
- [neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
- [nvim-lua/plenary.nvim](https://github.com/nvim-lua/plenary.nvim)
- [nvim-lualine/lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)
- [nvim-tree/nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons)
- [nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
- [rafamadriz/friendly-snippets](https://github.com/rafamadriz/friendly-snippets)
- [rebelot/kanagawa.nvim](https://github.com/rebelot/kanagawa.nvim)
- [saghen/blink.cmp](https://github.com/saghen/blink.cmp)
- [stevearc/conform.nvim](https://github.com/stevearc/conform.nvim)
- [williamboman/mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim)
- [williamboman/mason.nvim](https://github.com/williamboman/mason.nvim)
- [zbirenbaum/copilot.lua](https://github.com/zbirenbaum/copilot.lua)

### Utils and functions

[utils](/jhthorsen/batphone.nvim/blob/main/lua/batphone/utils.lua) contains
various functions, which is probably needs a better structure. Consider this
experimental for now.

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

## Author

Jan Henning Thorsen
