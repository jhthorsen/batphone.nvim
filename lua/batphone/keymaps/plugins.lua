local format_code = function()
  require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
end

return {
  blink = {
    preset = "default",
    ["<CR>"] = { "select_and_accept", "fallback" },
    ["<Tab>"] = { "select_next", "fallback" },
    ["<S-Tab>"] = { "select_prev", "fallback" },
  },
  conform = {
    { "<leader>cF", mode = { "n", "v" }, format_code, desc = "Format Injected Langs" },
  },
  copilot = {
    { "<leader>ap", ":Copilot panel<CR>", desc = "Open a window with Copilot completions" },
    { "<leader>ad", ":Copilot disable<CR>", desc = "Disable Copilot", silent = false },
    { "<leader>as", ":Copilot status<CR>", desc = "Check Copilot status", silent = false },
    { "<leader>ae", ":Copilot! attach<CR>:Copilot enable<CR>", desc = "Enable Copilot", silent = false },
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
  multi = {
    { "<c-d>", "<c-n>", mode = { "n", "v" }, remap = true, desc = "Multiple cursors" },
  },
  telescope = {
    { "<c-p>", "<cmd>Telescope git_files<cr>", desc = "Find Files (git-files)" },
    { "<leader>b", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", desc = "Switch Buffer" },
    { "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
    { "<leader>sp", "<cmd>Telescope spell_suggest<cr>", desc = "Quickfix List" },
    { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find all files" },
    { "<leader>fG", "<cmd>Telescope find_files<cr>", desc = "Find git files" },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Grep" },
    { "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "Commits" },
    { "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "Status" },
    { "<leader>s\"", "<cmd>Telescope registers<cr>", desc = "Registers" },
    { "<leader>sa", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
    { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer" },
    { "<leader>sc", "<cmd>Telescope command_history<cr>", desc = "Command History" },
    { "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
    { "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document Diagnostics" },
    { "<leader>sD", "<cmd>Telescope diagnostics<cr>", desc = "Workspace Diagnostics" },
    { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
    { "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "Search Highlight Groups" },
    { "<leader>sj", "<cmd>Telescope jumplist<cr>", desc = "Jumplist" },
    { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
    { "<leader>sl", "<cmd>Telescope loclist<cr>", desc = "Location List" },
    { "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
    { "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
    { "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
    { "<leader>sR", "<cmd>Telescope resume<cr>", desc = "Resume" },
    { "<leader>sq", "<cmd>Telescope quickfix<cr>", desc = "Quickfix List" },
  },
}
