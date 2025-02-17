local function buffers_max_length()
  return vim.o.columns - 20
end

return {
  { "nvim-lua/plenary.nvim" },
  { "nvim-tree/nvim-web-devicons", lazy = true },
  { "echasnovski/mini.icons", event = "VeryLazy",
  },
  {
    "folke/snacks.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      zen = {
        toggles = {
          diagnostics = false,
          dim = false,
          git_signs = false,
          inlay_hints = false,
          mini_diff_signs = false,
        },
      },
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
    },
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      sections = {
        lualine_a = { { "buffers", max_length = buffers_max_length, mode = 0, symbols = { alternate_file = "" } } },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = { "selectioncount" },
        lualine_z = { "progress", "location" },
      },
      options = {
        always_divide_middle = true,
        globalstatus = true,
        icons_enabled = true,
        component_separators = { left = "", right = ""},
        section_separators = { left = "", right = ""},
      },
      statusline = {},
      tabline = {},
    },
  },
  {
    "rebelot/kanagawa.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      dimInactive = true,
      compile = false,
      commentStyle = { bold = false, italic = true },
      functionStyle = { bold = true, italic = false },
      keywordStyle = { bold = false, italic = false },
      statementStyle = { bold = false, italic = false },
      transparent = false,
      colors = {
        theme = {
          wave = {
            ui = { float = { bg = "none" } },
          },
        },
      },
    },
  },
}
