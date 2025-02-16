local mapkey = require('batphone.utils').mapkey

mapkey("n", "<S-Tab>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
mapkey("n", "<Tab>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
mapkey("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
mapkey("n", "<leader>bd", function() Snacks.bufdelete() end, { desc = "Delete Buffer" })
mapkey("n", "<leader>bo", function() Snacks.bufdelete.other() end, { desc = "Delete Other Buffers" })
mapkey("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })
mapkey("n", "<leader>fn", ":echo expand('%')<CR>", { desc = "Show filename" })
mapkey({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

mapkey("n", "G", "Gzz", { desc = "Move to end and stay in center" })
mapkey("n", "<c-j>", "10j", { desc = "Jump ten lines down" })
mapkey("n", "<c-k>", "10k", { desc = "Jump ten lines up" })
mapkey("n", "<c-b>", "<c-u>zz", { desc = "Jump half a page up and center" })
mapkey("n", "<c-f>", "<c-d>zz", { desc = "Jump half a page down and center" })

mapkey("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
mapkey("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
mapkey("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
mapkey("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
mapkey("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
mapkey("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

mapkey("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg" })

-- Greatest remap ever
mapkey("x", "<leader>p", [["_dP]], {})

-- Next greatest remap ever : asbjornHaland
mapkey({ "n", "v" }, "<leader>y", [["+y]], {})
mapkey("n", "<leader>Y", [["+Y]], {})
mapkey({ "n", "v" }, "<leader>d", [["_d]], {})
