return {
  {
    "nvim-telescope/telescope.nvim",
    version = "*",
    cmd = "Telescope",
    keys = require("batphone.keymaps.plugins").telescope,
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      defaults = {
        preview = false,
        prompt_prefix = " ",
        selection_caret = " ",
        layout_strategy = "bottom_pane",
        sorting_strategy = "ascending",
        border = true,
        borderchars = {
          prompt = { "─", " ", " ", " ", "─", "─", " ", " " },
          results = { " " },
          preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        },

        -- open files in the first window that is an actual file.
        -- use the current window if no other window is available.
        get_selection_window = function()
          local wins = vim.api.nvim_list_wins()
          table.insert(wins, 1, vim.api.nvim_get_current_win())
          for _, win in ipairs(wins) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.bo[buf].buftype == "" then
              return win
            end
          end
          return 0
        end,
      },
      pickers = {
        registers = { theme = "cursor" },
        spell_suggest = { theme = "cursor" },
      },
    },
  },
}
