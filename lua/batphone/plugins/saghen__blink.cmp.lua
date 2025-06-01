return {
  "saghen/blink.cmp",
  version = "*",
  lazy = true,
  dependencies = {
    "fang2hou/blink-copilot",
    "rafamadriz/friendly-snippets",
    "zbirenbaum/copilot.lua",
  },
  opts = {
    keymap = require("batphone.keymaps").blink,
    appearance = {
      use_nvim_cmp_as_default = false,
    },
    cmdline = {
      enabled = false,
    },
    completion = {
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 750,
      },
      ghost_text = {
        enabled = true,
      },
      list = {
        selection = {
          preselect = false,
          auto_insert = true,
        }
      },
      menu = {
        draw = {
          treesitter = { "lsp" },
        },
      },
    },
    sources = {
      default = {
        "lazydev",
        "lsp",
        "snippets",
        "copilot",
        "buffer",
        "path",
      },
      providers = {
        buffer = {
          opts = {
            get_bufnrs = function()
              return vim.tbl_filter(
                function(bufnr) return vim.bo[bufnr].buftype == "" end,
                vim.api.nvim_list_bufs()
              )
            end,
          },
        },
        copilot = {
          name = "copilot",
          module = "blink-copilot",
          async = true,
          score_offset = 100,
        },
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offset = 100, -- make lazydev completions top priority (see `:h blink.cmp`)
        },
      },
    },
  },
}
