local mapkey = require("batphone.utils").mapkey
local utils = require("batphone.utils")

mapkey("n", "<S-Tab>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
mapkey("n", "<Tab>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
mapkey("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
mapkey("n", "<leader>bd", function() Snacks.bufdelete() end, { desc = "Delete Buffer" })
mapkey("n", "<leader>bo", function() Snacks.bufdelete.other() end, { desc = "Delete Other Buffers" })
mapkey("n", "<leader>q", utils.save_and_quit, { desc = "Save and Quit" })
mapkey("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })
mapkey("n", "<leader>fn", ":echo expand('%')<CR>", { desc = "Show filename" })
mapkey({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

mapkey("n", "<leader>e", function() Snacks.explorer() end, { desc = "Open file explorer" })
mapkey('n', ',e', utils.edit_file, { desc = 'Find and edit file' })

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
mapkey("i", "<c-s>", "<cmd>Telescope spell_suggest<cr>", { desc = "Spell suggestions" });

mapkey("x", "<leader>p", [["_dP]], { desc = "Paste into selection" })

mapkey("n", "<leader>ur", "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
  { desc = "Redraw / Clear hlsearch / Diff Update" })

mapkey("n", "<c-_>", function() Snacks.terminal() end, { desc = "Terminal (cwd)" })
mapkey("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
mapkey("t", "<c-_>", "<cmd>close<cr>", { desc = "Hide Terminal" })

mapkey("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })
mapkey("n", "<leader>uI", "<cmd>InspectTree<cr>", { desc = "Inspect Tree" })

mapkey("n", "<leader>wL", "<cmd>Lazy<cr>", { desc = "Lazy" })

local toggle = require("snacks.toggle")

toggle.new({
  id = "signcolumn",
  name = "Sign column",
  get = function()
    return vim.wo.signcolumn == "yes"
  end,
  set = function(show)
    vim.wo.signcolumn = show and 'yes' or 'no'
    vim.wo.number = show
    vim.wo.relativenumber = show
  end
}):map("<leader>uS")

toggle.animate():map("<leader>ua")
toggle.dim():map("<leader>uD")
toggle.indent():map("<leader>ug")
toggle.line_number():map("<leader>ul")
toggle.option("background", { off = "light", on = "dark" , name = "Dark Background" }):map("<leader>ub")
toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2, name = "Conceal Level" }):map("<leader>uc")
toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
toggle.option("spell", { name = "Spelling" }):map("<leader>us")
toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
toggle.profiler():map("<leader>dpp")
toggle.profiler_highlights():map("<leader>dph")
toggle.treesitter():map("<leader>uT")
toggle.zen():map("<leader>uz")
