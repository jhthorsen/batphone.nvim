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
  flash = {
    { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
  },
  mason = {
    { "<leader>wM", "<cmd>Mason<cr>", desc = "Mason" },
  },
  multicursor = {
    { "<c-d>", mode = { "n", "x" }, function() require("multicursor-nvim").matchAddCursor(1) end, desc = "Add new cursor by matching word/selection" },
    { "<c-s-d>", mode = { "n", "x" }, function() require("multicursor-nvim").matchAddCursor(-1) end, desc = "Add new cursor by matching word/selection" },
    { "<esc>", mode = { "n" }, utils.toggle_multicursors, desc = "Clear cursors" },
    { "<leader>mt", mode = { "n", "x" }, function() require("multicursor-nvim").toggleCursor() end, desc = "Add and remove cursors using the main cursor" },
    { "<leader>mr", function() require("multicursor-nvim").restoreCursors() end, desc = "Bring back cursors if you accidentally clear them" },
    { "<leader>mL", function() require("multicursor-nvim").alignCursors() end, desc = "Align cursor columns" },
  },
  telescope = {
    { "<c-p>", "<cmd>Telescope git_files<cr>", desc = "Find Files (git-files)" },
    { "<leader>b", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", desc = "List Buffers" },
    { "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
    { "<leader>db", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document Diagnostics" },
    { "<leader>de", "<cmd>Telescope diagnostics severity=ERROR<cr>", desc = "Workspace Errors" },
    { "<leader>dw", "<cmd>Telescope diagnostics severity=WARN<cr>", desc = "Workspace Warnings" },
    { "<leader>da", "<cmd>Telescope diagnostics<cr>", desc = "Workspace Diagnostics" },
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find all files" },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
    { "<leader>fo", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
    { "<leader>fG", "<cmd>Telescope git_files<cr>", desc = "Git files" },
    { "<leader>fP", utils.telescope_find_package_files, desc = "Package files" },
    { "<leader>fp", utils.telescope_find_parent_files, desc = "Find parent files" },
    { "<leader>qf", "<cmd>Telescope quickfix<cr>", desc = "Quickfix List" },
    { "<leader>qh", "<cmd>Telescope quickfixhistory<cr>", desc = "Quickfix History" },
    { "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "Git Status" },
    { "<leader>sa", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
    { "<leader>\"", "<cmd>Telescope registers<cr>", desc = "List registers" },
    { "<leader>/", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer" },
    { "<leader>sc", "<cmd>Telescope command_history<cr>", desc = "Command History" },
    { "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
    { "<leader>sp", "<cmd>Telescope spell_suggest<cr>", desc = "Spell suggestions" },
    { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
    { "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "Search Highlight Groups" },
    { "<leader>sj", "<cmd>Telescope jumplist<cr>", desc = "Jumplist" },
    { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
    { "<leader>sl", "<cmd>Telescope loclist<cr>", desc = "Location List" },
    { "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
    { "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
    { "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
    { "<leader>sR", "<cmd>Telescope resume<cr>", desc = "Resume" },
  },
}
