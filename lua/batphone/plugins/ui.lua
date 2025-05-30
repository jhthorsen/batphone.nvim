local function buffers_max_length()
  return vim.o.columns - 20
end

return {
  { "nvim-lua/plenary.nvim", version = "*" },
  { "echasnovski/mini.icons", event = "VeryLazy", version = "*" },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      expand = 3,
    },
    config = function(_, opts)
      require("which-key.plugins.presets").operators["v"] = nil
      require("which-key").setup(opts)
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    version = "*",
    dependencies = {
      { "nvim-tree/nvim-web-devicons", version = "*" },
    },
    opts = {
      options = {
        always_divide_middle = true,
        globalstatus = true,
        icons_enabled = true,
        component_separators = { left = "", right = ""},
        section_separators = { left = "", right = ""},
      },
      sections = {
        lualine_a = { {
          "buffers",
          max_length = buffers_max_length,
          show_filename_only = true,
          symbols = { alternate_file = "" },
        } },
        lualine_b = { },
        lualine_c = { },
        lualine_x = { { "mode", fmt = function(str) return str:sub(1, 3) end } },
        lualine_y = { "selectioncount" },
        lualine_z = { "progress", "location" },
      },
      tabline = { },
      winbar = { },
    },
  },
  {
    "rebelot/kanagawa.nvim",
    version = "*",
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
      overrides = function(colors)
        local theme = colors.theme
        return {
          CursorLine = { bg = theme.ui.bg_p1 },
          CursorLineNr = { bg = theme.ui.bg_gutter, fg = theme.diag.warning, bold = false },
          LineNr = { bg = theme.ui.bg_gutter, fg = theme.ui.special, bold = false },
          Float = { bg = "none" },
        }
      end,
    },
  },
  {
    "stevearc/oil.nvim",
    lazy = false,
    dependencies = {
      { "echasnovski/mini.icons" },
    },
    opts = {
      default_file_explorer = true,
      skip_confirm_for_simple_edits = true,
      float = {
        border = "rounded",
        max_width = 80,
        max_height = 0.6,
      },
      keymaps = {
        ["q"] = { "actions.close", mode = "n" },
      },
      view_options = {
        show_hidden = true,
      },
    },
  },
}
