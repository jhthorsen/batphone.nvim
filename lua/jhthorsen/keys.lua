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

function M.setup()
  M.auto()
  M.buffers()
  M.edit()
  M.editor()
end

return M
