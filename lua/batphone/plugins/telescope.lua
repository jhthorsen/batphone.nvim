return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    keys = require("batphone.keymaps.telescope"),
    opts = {
      defaults = {
        preview = false,
        prompt_prefix = " ",
        selection_caret = " ",
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
        buffers = { theme = "ivy" },
        diagnostics = { theme = "ivy" },
        git_files = { theme = "ivy" },
        find_files = { theme = "ivy" },
        live_grep = { theme = "ivy" },
        keymaps = { theme = "ivy" },
        oldfiles = { theme = "ivy" },
        spell_suggest = { theme = "ivy" },
      },
    },
  },
}
