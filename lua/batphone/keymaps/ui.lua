local mapkey = require('batphone.utils').mapkey

mapkey("n", "<leader>ur", "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
  { desc = "Redraw / Clear hlsearch / Diff Update" })

mapkey("n", "<c-_>", function() Snacks.terminal() end, { desc = "Terminal (cwd)" })
mapkey("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
mapkey("t", "<c-_>", "<cmd>close<cr>", { desc = "Hide Terminal" })

mapkey("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })
mapkey("n", "<leader>uI", "<cmd>InspectTree<cr>", { desc = "Inspect Tree" })

mapkey("n", "<leader>cl", "<cmd>Lazy<cr>", { desc = "Lazy" })
mapkey("n", "<leader>cm", "<cmd>Mason<cr>", { desc = "Mason" })

Snacks.toggle.animate():map("<leader>ua")
Snacks.toggle.dim():map("<leader>uD")
Snacks.toggle.indent():map("<leader>ug")
Snacks.toggle.line_number():map("<leader>ul")
Snacks.toggle.option("background", { off = "light", on = "dark" , name = "Dark Background" }):map("<leader>ub")
Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2, name = "Conceal Level" }):map("<leader>uc")
Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
Snacks.toggle.profiler():map("<leader>dpp")
Snacks.toggle.profiler_highlights():map("<leader>dph")
Snacks.toggle.treesitter():map("<leader>uT")
Snacks.toggle.zen():map("<leader>uz")
