local mapkey = require('batphone.utils').mapkey

mapkey("n", "<leader>ur", "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
  { desc = "Redraw / Clear hlsearch / Diff Update" })

mapkey("n", "<c-_>", function() Snacks.terminal() end, { desc = "Terminal (cwd)" })
mapkey("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
mapkey("t", "<c-_>", "<cmd>close<cr>", { desc = "Hide Terminal" })

mapkey("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })
mapkey("n", "<leader>uI", "<cmd>InspectTree<cr>", { desc = "Inspect Tree" })

mapkey("n", "<leader>wL", "<cmd>Lazy<cr>", { desc = "Lazy" })
mapkey("n", "<leader>wM", "<cmd>Mason<cr>", { desc = "Mason" })

local toggle = require("snacks.toggle")
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
