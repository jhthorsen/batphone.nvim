return {
  "nvim-lualine/lualine.nvim",
  version = "*",
  dependencies = {
    { "echasnovski/mini.icons" },
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
        max_length = function() return vim.o.columns - 20 end,
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
  config = function(_, opts)
    require("mini.icons").setup()
    require("mini.icons").mock_nvim_web_devicons()
    require("lualine").setup(opts)
  end,
}
