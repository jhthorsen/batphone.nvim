local mapkey = require('batphone.utils').mapkey

mapkey("v", "<", "<gv", { desc = "Indent and stay in indent mode" })
mapkey("v", ">", ">gv", { desc = "Indent and stay in indent mode" })

mapkey({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Moving the cursor through long soft-wrapped lines", expr = true, silent = true })
mapkey({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Moving the cursor through long soft-wrapped lines", expr = true, silent = true })

mapkey("i", ".", ".<c-g>u", { desc = "Auto undo" })
mapkey("i", ";", ";<c-g>u", { desc = "Auto undo" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
mapkey("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
mapkey("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
mapkey("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
mapkey("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
mapkey("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
mapkey("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
