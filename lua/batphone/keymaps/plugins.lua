local utils = require("batphone.utils")

return {
  blink = {
    preset = "default",
    ["<cr>"] = {
      function(cmp)
        if utils.has_words_before() then return cmp.select_and_accept() end
      end,
      "fallback",
    },
    ["<tab>"] = {
      function(cmp) return cmp.select_next() end,
      "fallback",
    },
    ["<s-tab>"] = {
      function(cmp) return cmp.select_prev() end,
      "fallback",
    }
  },
  conform = {
    { "<leader>cF", mode = { "n", "v" }, utils.format_code, desc = "Format Injected Langs" },
  },
  copilot = {
    { "<leader>cs", ":Copilot panel<CR>", desc = "Open Copilot completions" },
    { "<leader>cxd", ":Copilot disable<CR>", desc = "Disable Copilot", silent = false },
    { "<leader>cxs", ":Copilot status<CR>", desc = "Copilot status", silent = false },
    { "<leader>cxe", ":Copilot! attach<CR>:Copilot enable<CR>", desc = "Enable Copilot", silent = false },
  },
  copilotchat = {
    { "<leader>cc", function() utils.copilotchat_toggle("horizontal") end, desc = "Open Copilot Chat" },
    { "<leader>cz", function() utils.copilotchat_toggle("replace") end, desc = "Open Copilot Chat in fullscreen" },
    { "<leader>cp", function() require("CopilotChat").stop() end, desc = "Stop Copilot Chat" },
  },
  multicursor = {
    { "<c-d>", mode = { "n", "x" }, function() require("multicursor-nvim").matchAddCursor(1) end, desc = "Add new cursor by matching word/selection" },
    { "<c-s-d>", mode = { "n", "x" }, function() require("multicursor-nvim").matchAddCursor(-1) end, desc = "Add new cursor by matching word/selection" },
    { "<esc>", mode = { "n" }, utils.toggle_multicursors, desc = "Clear cursors" },
    { "<leader>mt", mode = { "n", "x" }, function() require("multicursor-nvim").toggleCursor() end, desc = "Add and remove cursors using the main cursor" },
    { "<leader>mr", function() require("multicursor-nvim").restoreCursors() end, desc = "Bring back cursors if you accidentally clear them" },
    { "<leader>mL", function() require("multicursor-nvim").alignCursors() end, desc = "Align cursor columns" },
  },
  snacks = {
    -- top pickers
    { "<c-space>", function() require("snacks.picker").smart() end, desc = "Smart Find Files" },
    { "<leader><space>", function() require("snacks.picker").smart() end, desc = "Smart Find Files" },
    { "<leader>ff", function() require("snacks.picker").files() end, desc = "Find Files" },
    { "<leader>fg", function() require("snacks.picker").git_files() end, desc = "Find Git Files" },
    { "<leader>fr", function() require("snacks.picker").recent() end, desc = "Recent" },
    { "<leader>fP", function() require("snacks.picker").files({ cwd = ".." }) end, desc = "Find parent Files" },
    { "<leader>b", function() require("snacks.picker").buffers() end, desc = "Buffers" },
    { "<leader>P", function() require("snacks.picker").projects() end, desc = "Projects" },
    { "<leader>:", function() require("snacks.picker").command_history() end, desc = "Command History" },
    { "<leader>a", function() require("snacks.picker").spelling() end, desc = "Spelling suggestions" },

    -- git
    { "<leader>gb", function() require("snacks.picker").git_branches() end, desc = "Git Branches" },
    { "<leader>gl", function() require("snacks.picker").git_log() end, desc = "Git Log" },
    { "<leader>gs", function() require("snacks.picker").git_status() end, desc = "Git Status" },
    { "<leader>gf", function() require("snacks.picker").git_log_file() end, desc = "Git Log File" },

    -- grep
    { "<leader>sB", function() require("snacks.picker").grep_buffers() end, desc = "Grep Open Buffers" },
    { "<leader>sg", function() require("snacks.picker").grep() end, desc = "Grep" },
    { "<leader>sw", function() require("snacks.picker").grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },

    -- search
    { '<leader>s"', function() require("snacks.picker").registers() end, desc = "Registers" },
    { '<leader>s/', function() require("snacks.picker").search_history() end, desc = "Search History" },
    { "<leader>sb", function() require("snacks.picker").lines() end, desc = "Buffer Lines" },
    { "<leader>sc", function() require("snacks.picker").command_history() end, desc = "Command History" },
    { "<leader>sh", function() require("snacks.picker").help() end, desc = "Help Pages" },
    { "<leader>sH", function() require("snacks.picker").highlights() end, desc = "Highlights" },
    { "<leader>sj", function() require("snacks.picker").jumps() end, desc = "Jumps" },
    { "<leader>sl", function() require("snacks.picker").loclist() end, desc = "Location List" },
    { "<leader>sm", function() require("snacks.picker").marks() end, desc = "Marks" },
    { "<leader>sM", function() require("snacks.picker").man() end, desc = "Man Pages" },
    { "<leader>sq", function() require("snacks.picker").qflist() end, desc = "Quickfix List" },
    { "<leader>sR", function() require("snacks.picker").resume() end, desc = "Resume" },
    { "<leader>su", function() require("snacks.picker").undo() end, desc = "Undo History" },

    -- neovim config and files
    { "<leader>na", function() require("snacks.picker").autocmds() end, desc = "Autocmds" },
    { "<leader>nC", function() require("snacks.picker").commands() end, desc = "Commands" },
    { "<leader>nc", function() require("snacks.picker").files({ cwd = vim.fn.stdpath("config") }) end, desc = "Config File" },
    { "<leader>nI", function() require("snacks.picker").icons() end, desc = "Icons" },
    { "<leader>nk", function() require("snacks.picker").keymaps() end, desc = "Keymaps" },
    { "<leader>nl", function() require("snacks.picker").files({ cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy") }) end, desc = "LazyVim files" },
    { "<leader>nn", function() require("snacks.picker").notifications() end, desc = "Notification History" },
    { "<leader>uC", function() require("snacks.picker").colorschemes() end, desc = "Colorschemes" },
  },
}
