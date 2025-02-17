local mapkey = require("batphone.utils").mapkey

local function edit_file()
  local api = vim.api;
  local dir = require("batphone.utils").dirname(vim.fn.bufname())
  print(vim.api.nvim_buf_get_name(0));
  api.nvim_feedkeys(":edit " .. dir:gsub("[[]", "\\[") .. "/", "n", false)
  api.nvim_input("<TAB>")
end

local function save_and_quit()
  local api = vim.api
  local modified = api.nvim_get_option_value("modified", { buf = api.nvim_get_current_buf() })
  local cmd = modified and "w|bd" or "bd";
  api.nvim_command(cmd)

  if #vim.fn.getbufinfo({ buflisted = 1 }) <= 1 then
    api.nvim_command("quit")
  end
end

mapkey("n", "<S-Tab>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
mapkey("n", "<Tab>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
mapkey("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
mapkey("n", "<leader>bd", function() Snacks.bufdelete() end, { desc = "Delete Buffer" })
mapkey("n", "<leader>bo", function() Snacks.bufdelete.other() end, { desc = "Delete Other Buffers" })
mapkey("n", "<leader>q", save_and_quit, { desc = "Save and Quit" })
mapkey("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })
mapkey("n", "<leader>fn", ":echo expand('%')<CR>", { desc = "Show filename" })
mapkey({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

mapkey('n', ',e', edit_file, { desc = 'Find and edit file' })

mapkey("n", "G", "Gzz", { desc = "Move to end and stay in center" })
mapkey("n", "<c-j>", "10j", { desc = "Jump ten lines down" })
mapkey("n", "<c-k>", "10k", { desc = "Jump ten lines up" })
mapkey("n", "<c-b>", "<c-u>zz", { desc = "Jump half a page up and center" })
mapkey("n", "<c-f>", "<c-d>zz", { desc = "Jump half a page down and center" })

mapkey("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move line down" })
mapkey("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move line up" })
mapkey("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move line down" })
mapkey("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move line up" })
mapkey("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move line down" })
mapkey("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move line up" })

mapkey("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Open man page for word" })
mapkey("i", "<c-s>", "<cmd>Telescope spell_suggest", { desc = "Spell suggestions" });

mapkey("x", "<leader>p", [["_dP]], { desc = "Paste into selection" })
