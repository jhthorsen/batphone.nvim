local utils = require("batphone.utils")
local mapkey = utils.mapkey

mapkey("c", "<c-h>", "<left>", { desc = "Cmdline Movement", silent = false })
mapkey("c", "<c-l>", "<right>", { desc = "Cmdline Movement", silent = false })
mapkey("c", "<c-a>", "<home>", { desc = "Cmdline Movement", silent = false })
mapkey("c", "<c-e>", "<end>", { desc = "Cmdline Movement", silent = false })

mapkey("n", "<s-tab>", function() utils.focus_buffer("previous") end, { desc = "Prev Buffer" })
mapkey("n", "<tab>", function() utils.focus_buffer("next") end, { desc = "Next Buffer" })
mapkey("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
mapkey("n", "<leader>bd", function() Snacks.bufdelete() end, { desc = "Delete Buffer" })
mapkey("n", "<leader>bo", function() Snacks.bufdelete.other() end, { desc = "Delete Other Buffers" })
mapkey("n", "<leader>qa", "<cmd>wqa<cr>", { desc = "Save and Quit All" })
mapkey("n", "<leader>qq", utils.save_and_quit, { desc = "Save and Close Buffer" })
mapkey("n", "<leader>fn", ":echo expand('%')<cr>", { desc = "Show filename" })
mapkey({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

mapkey("n", "-", "<cmd>Oil<cr>", { desc = "Open File Explorer" })
mapkey("n", "<leader>e", function() require("oil").open_float() end, { desc = "Open File Explorer" })
mapkey("n", ",e", utils.edit_file, { desc = "Find and Edit" })

mapkey("n", "G", "Gzz", { desc = "Move to end and stay in center" })
mapkey("n", "<c-j>", "10j", { desc = "Jump ten lines down" })
mapkey("n", "<c-k>", "10k", { desc = "Jump ten lines up" })

mapkey("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Open man page for word" })

mapkey({ "n", "v" }, "0d", '"_d', { desc = "Delete" })
mapkey("x", "<leader>p", [["_dP]], { desc = "Paste into selection" })

mapkey("n", "<leader>ur", "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <c-l><cr>",
  { desc = "Redraw / Clear hlsearch / Diff Update" })

mapkey("n", "<c-_>", function() Snacks.terminal() end, { desc = "Terminal (cwd)" })
mapkey("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
mapkey("t", "<c-_>", "<cmd>close<cr>", { desc = "Hide Terminal" })

mapkey("n", "<leader>ti", vim.show_pos, { desc = "Inspect Pos" })
mapkey("n", "<leader>tI", "<cmd>InspectTree<cr>", { desc = "Inspect Tree" })

mapkey("n", "<leader>nL", "<cmd>Lazy<cr>", { desc = "LazyVim manager" })
mapkey("n", "<leader>nM", "<cmd>Mason<cr>", { desc = "Mason package manager" })

local toggle = require("snacks.toggle")

toggle.new({
  id = "signcolumn",
  name = "Sign column",
  get = function()
    return vim.wo.signcolumn == "yes"
  end,
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
