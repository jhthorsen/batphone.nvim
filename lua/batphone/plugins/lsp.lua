local plugins_keymaps = require("batphone.keymaps.plugins")

return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        "folke/snacks.nvim",
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      { "saghen/blink.cmp" },
      { "williamboman/mason-lspconfig.nvim" },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    event = { "BufReadPost", "BufNewFile" },
    build = ":TSUpdate",
    opts = {
      sync_install = false,
      auto_install = true,
      highlight = {
        enable = true,
      },
    },
  },
  {
    "saghen/blink.cmp",
    version = "*",
    lazy = true,
    dependencies = {
      "fang2hou/blink-copilot",
      "rafamadriz/friendly-snippets",
    },
    opts = {
      keymap = plugins_keymaps.blink,
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
  },
  {
    "stevearc/conform.nvim",
    version = "*",
    lazy = true,
    cmd = "ConformInfo",
    keys = plugins_keymaps.conform,
    opts = {
      default_format_opts = {
        async = false,
        lsp_format = "fallback",
        quiet = false,
        timeout_ms = 3000,
      },
      formatters_by_ft = {
        fish = { "fish_indent" },
        lua = { "stylua" },
        sh = { "shfmt" },
      },
      formatters = {
        injected = { options = { ignore_errors = true } },
      },
    },
  },
  {
    "williamboman/mason.nvim",
    event = { "BufReadPost", "BufNewFile" },
    build = ":MasonUpdate",
    keys = plugins_keymaps.mason,
    dependencies = {
      { "williamboman/mason-lspconfig.nvim" },
    },
    config = function(_, opts)
      require("mason").setup(opts)
    end
  },
  {
    "zbirenbaum/copilot.lua",
    event = "VeryLazy",
    build = ":Copilot auth",
    keys = plugins_keymaps.copilot,
    config = function(_, opts)
      if vim.env.ENABLE_COPILOT == "force" or vim.env.ENABLE_COPILOT == "yes" then
        require("copilot").setup(opts)
      end
    end,
    opts = {
      server_opts_overrides = {},
      suggestion = { debounce = 350 },
      should_attach = function(_, bufname)
        local logger = require("copilot.logger")
        if not vim.bo.buflisted then
          logger.debug("not attaching, buffer is not 'buflisted'")
          return false
        end
        if vim.bo.buftype ~= "" then
          logger.debug("not attaching, buffer 'buftype' is " .. vim.bo.buftype)
          return false
        end
        if vim.env.ENABLE_COPILOT == "force" then
          return true
        end
        if string.match(bufname, "_alien") then
          logger.debug("not attaching, buffer is /_alien/")
          return false
        end
        if string.match(bufname, "env") then
          logger.debug("not attaching, buffer is /env/")
          return false
        end

        return true
      end
    },
  },
  {
    "copilotc-nvim/copilotchat.nvim",
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim" },
    },
    build = "make tiktoken",
    lazy = true,
    keys = plugins_keymaps.copilotchat,
    opts = {
      auto_follow_cursor = false,
      auto_insert_mode = true,
      answer_header = "# Copilot ",
      question_header = "# Me ",
      callback = function() require("CopilotChat").save("all") end,
      mappings = {
        close = { },
      },
      window = {
        layout = "horizontal",
        border = "single",
        height = 0.8,
        width = 1,
      },
    },
  },
}
