local layout = {
  default = {
    preview = "main",
    layout = {
      box = "vertical",
      backdrop = false,
      col = -1,
      row = -2,
      width = function()
        if vim.o.columns < 90 then return 0.9
        else return 90 end
      end,
      height = 20,
      border = "rounded",
      title = " {title} {live} {flags}",
      title_pos = "center",
      { win = "input", height = 1, border = "none" },
      { win = "list", border = "none" },
      { win = "preview", title = "{preview}" },
    },
  },
  dropdown = {
    preview = "none",
    layout = {
      box = "vertical",
      backdrop = false,
      relative = "cursor",
      col = 1,
      row = 1,
      width = 0.4,
      height = 7,
      border = "rounded",
      { win = "list", border = "none" },
    },
  },
  no_preview = {
    preview = false,
  },
}

return {
  {
    "echasnovski/mini.nvim",
    version = "*",
    event = "VeryLazy",
    config = function(_, _)
      require("mini.ai").setup()
      require("mini.align").setup()
      require("mini.comment").setup()
      require("mini.move").setup()
      require("mini.surround").setup()
    end,
  },
  {
    "folke/snacks.nvim",
    version = "*",
    lazy = false,
    priority = 1000,
    keys = require("batphone.keymaps.plugins").snacks,
    opts = {
      picker = {
        prompt = " ",
        layout = layout.default,
        formatters = {
          file = {
            truncate = 90,
          },
        },
        sources = {
          autocmds = { layout = layout.no_preview },
          buffers = { layout = layout.no_preview },
          colorschemes = { layout = layout.no_preview },
          command_history = { layout = layout.no_preview },
          lines = { layout = layout.no_preview },
          notifications = { layout = layout.no_preview },
          search_history = { layout = layout.no_preview },
          spelling = { layout = layout.dropdown },
        },
      }, -- end picker
      styles = {
        zen = {
          height = 0.95,
          width = 120,
          minimal = true,
          backdrop = {
            transparent = true,
            blend = 10,
          },
        },
      },
      terminal = {
        shell = { vim.env.NVIM_TERMINAL_SHELL or vim.env.SHELL or "bash" }
      },
      zen = {
        toggles = {
          diagnostics = false,
          dim = false,
          git_signs = false,
          inlay_hints = false,
          mini_diff_signs = false,
        },
      },
    },
  },
  {
    "jake-stewart/multicursor.nvim",
    version = "*",
    event = "VeryLazy",
    keys = require("batphone.keymaps.plugins").multicursor,
    opts = {},
  },
}
