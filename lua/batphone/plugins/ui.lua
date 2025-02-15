local function buffers_max_length()
  return vim.o.columns - 20
end

return {
  {
    "echasnovski/mini.icons",
    lazy = true,
  },
  {
    "folke/snacks.nvim",
    event = "VeryLazy",
    opts = {
      explorer = {
        replace_netrw = true,
        indent = { enabled = true },
        input = { enabled = true },
        notifier = { enabled = true },
        scope = { enabled = true },
        scroll = { enabled = true },
        statuscolumn = { enabled = false },
        words = { enabled = true },
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
