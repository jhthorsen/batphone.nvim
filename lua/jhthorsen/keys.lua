local dirname = vim.fs and vim.fs.dirname or function(p) return vim.fn.fnamemodify(p, ":h") end
local key = vim.keymap.set
local M = {}

function M.auto()
  key("v", "<", "<gv", { desc = "Indent and stay in indent mode" })
  key("v", ">", ">gv", { desc = "Indent and stay in indent mode" })

  key("n", "G", "Gzz", { desc = "Move to end and stay in center" })

  key("c", "<c-h>", "<left>", { desc = "Cmdline Movement", silent = false })
  key("c", "<c-l>", "<right>", { desc = "Cmdline Movement", silent = false })
  key("c", "<c-a>", "<home>", { desc = "Cmdline Movement", silent = false })
  key("c", "<c-e>", "<end>", { desc = "Cmdline Movement", silent = false })

  key({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Moving the cursor through long soft-wrapped lines", expr = true, silent = true })
  key({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Moving the cursor through long soft-wrapped lines", expr = true, silent = true })

  key("i", ".", ".<c-g>u", { desc = "Auto undo" })
  key("i", ";", ";<c-g>u", { desc = "Auto undo" })

  -- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
  key("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
  key("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
  key("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
  key("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
  key("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
  key("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
end

function M.buffers()
  key("n", "<tab>", "<cmd>bnext<cr>", { desc = "Prev Buffer" })
  key("n", "<s-tab>", "<cmd>bprevious<cr>", { desc = "Next Buffer" })
  key("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
  key("n", "<leader>qa", "<cmd>wqa<cr>", { desc = "Save and Quit All" })

  key("n", "<leader>qq",
    function()
      local modified = vim.api.nvim_get_option_value("modified", { buf = vim.api.nvim_get_current_buf() })
      local n_buffers = #vim.fn.getbufinfo({ buflisted = 1 })
      vim.api.nvim_command(modified and "w|bd" or "bd");
      if n_buffers <= 1 then vim.api.nvim_command("quit") end
    end,
    { desc = "Save and Close Buffer" }
  )
end

function M.edit()
  key("n", "<a-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move line down" })
  key("n", "<a-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move line up" })
  key("n", "<c-j>", "10jzz", { desc = "Jump ten lines down" })
  key("n", "<c-k>", "10kzz", { desc = "Jump ten lines up" })
  key({ "n", "v" }, "0d", '"_d', { desc = "Delete" })
end

function M.editor()
  key("n", "<leader>nt", "<cmd>InspectTree<cr>", { desc = "Inspect Tree" })
  key("n", "<leader>nU", function() vim.pack.update() end, { desc = "Update Neovim Plugins" })
  key("n", "<leader>fn", ":echo expand('%')<cr>", { desc = "Show filename" })
  key("n", "<leader>nha", ":checkhealth<cr>", { desc = "Checkhealth" })
  key("n", "<leader>nhl", ":checkhealth vim.lsp<cr>", { desc = "Checkhealth LSP" })
  key("n", "<leader>nht", ":checkhealth nvim-treesitter vim.treesitter<cr>", { desc = "Checkhealth treesitter" })
  key("n", "<leader>nhw", ":checkhealth which-key<cr>", { desc = "Checkhealth which-key" })

  key("n", ",e",
    function()
      local dir = dirname(vim.fn.bufname())
      print(vim.api.nvim_buf_get_name(0));
      vim.api.nvim_feedkeys(":edit " .. dir:gsub("[[]", "\\[") .. "/", "n", false)
      vim.api.nvim_input("<tab>")
    end,
    { desc = "Find and Edit" }
  )
end

function M.snacks(snacks)
  local picker = require("snacks.picker")
  local toggle = require("snacks.toggle")
  toggle.new({
    id = "jhthorsen__signcolumn",
    name = "Sign column",
    get = function() return vim.wo.signcolumn == "yes" end,
    set = function(show)
      vim.wo.signcolumn = show and "yes" or "no"
      vim.wo.number = show
      vim.wo.relativenumber = show
    end
  }):map("<leader>uS")

  toggle.indent():map("<leader>ug")
  toggle.line_number():map("<leader>ul")
  toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2, name = "Conceal Level" }):map("<leader>uc")
  toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
  toggle.option("spell", { name = "Spelling" }):map("<leader>us")
  toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
  toggle.treesitter():map("<leader>uT")
  toggle.zen():map("<leader>uz")

  key("n", "<leader>bd", function() snacks.bufdelete() end, { desc = "Delete Buffer" })
  key("n", "<leader>bo", function() snacks.bufdelete.other() end, { desc = "Delete Other Buffers" })
  key("n", "<leader>bs", function() picker.buffers() end, { desc = "Search Buffers (<leader>b)" })

  key("n", "<leader><space>", function() picker.smart() end, { desc = "Smart Find Files" })
  key("n", "<leader>ff", function() picker.files() end, { desc = "Find Files" })
  key("n", "<leader>fg", function() picker.git_files() end, { desc = "Find Git Files" })
  key("n", "<leader>fr", function() picker.recent() end, { desc = "Recent" })
  key("n", "<leader>fp", function() picker.projects() end, { desc = "Open File from Projects" })
  key("n", "<leader>fx", function() picker.files({ cwd = ".." }) end, { desc = "Find parent Files" })
  key("n", "<leader>b", function() picker.buffers() end, { desc = "Search Buffers" })
  key("n", "<leader>:", function() picker.command_history() end, { desc = "Command History" })
  key("n", "z=", function() picker.spelling() end, { desc = "Spelling suggestions" })

  key("n", "<leader>gb", function() picker.git_branches() end, { desc = "Git Branches" })
  key("n", "<leader>gl", function() picker.git_log() end, { desc = "Git Log" })
  key("n", "<leader>gs", function() picker.git_status() end, { desc = "Git Status" })

  key("n", "<leader>sB", function() picker.grep_buffers() end, { desc = "Grep Open Buffers" })
  key("n", "<leader>sg", function() picker.grep() end, { desc = "Grep Project Files" })
  key({ "n", "x" }, "<leader>sw", function() picker.grep_word() end, { desc = "Visual selection or word" })

  key("n", '<leader>s"', function() picker.registers() end, { desc = "Registers" })
  key("n", "<leader>sb", function() picker.lines() end, { desc = "Buffer Lines" })
  key("n", "<leader>sj", function() picker.jumps() end, { desc = "Jumps" })
  key("n", "<leader>sl", function() picker.loclist() end, { desc = "Location List" })
  key("n", "<leader>sm", function() picker.marks() end, { desc = "Marks" })
  key("n", "<leader>sq", function() picker.qflist() end, { desc = "Quickfix List" })

  key("n", "<leader>na", function() picker.autocmds() end, { desc = "Search Auto-commands" })
  key("n", "<leader>nC", function() picker.commands() end, { desc = "Search Commands" })
  key("n", "<leader>nc", function() picker.files({ cwd = vim.fn.stdpath("config") }) end, { desc = "Search Config Files" })
  key("n", "<leader>nI", function() picker.icons() end, { desc = "Search Icons" })
  key("n", "<leader>nk", function() picker.keymaps() end, { desc = "Search Keymaps" })
  key("n", "<leader>nf", function() picker.files({ dirs = vim.api.nvim_get_runtime_file("lua/", true) }) end, { desc = "Plugin files" })
  key("n", "<leader>uC", function() picker.colorschemes() end, { desc = "Search Colorschemes" })

  key("n", "<c-_>", function() snacks.terminal() end, { desc = "Terminal (cwd)" })
  key("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
  key("t", "<C-_>", "<cmd>close<cr>", { desc = "Hide Terminal" })
end

function M.setup()
  M.auto()
  M.buffers()
  M.edit()
  M.editor()
end

return M
