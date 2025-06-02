local M = {}

-- utility functions

local dirname = vim.fs and vim.fs.dirname or function(p) return vim.fn.fnamemodify(p, ":h") end

local function get_word_before_cursor()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  if col == 0 then return nil end
  local line = vim.api.nvim_get_current_line()
  return line:sub(col, col):match("%w")
end

local function mapkey(mode, key, action, opts)
  local defaults = { silent = true }
  vim.keymap.set(mode, key, action, vim.tbl_extend("force", defaults, opts))
end

-- keymap helpers

local function goto_diag(next, severity)
  severity = severity and vim.diagnostic.severity[severity] or nil
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  go({ severity = severity })
end

local function goto_buf(next_or_previous)
  vim.cmd("b" .. next_or_previous)
  vim.cmd("echo expand('%')")
end

local function toggle_copilot(layout)
  local cc = require("CopilotChat")

  if copilotchat_first_time then cc.load("all") end
  copilotchat_first_time = false

  if layout == "replace" then
    cc.toggle({window = {layout = layout}})
  else
    cc.toggle({window = {layout = layout, width = 1, height = 0.8}})
  end
end

-- keymaps module

function M.keys_additional()
  mapkey("n", "<leader>nL", "<cmd>Lazy<cr>", { desc = "LazyVim manager" })

  mapkey("n", "<s-tab>", function() goto_buf("previous") end, { desc = "Prev Buffer" })
  mapkey("n", "<tab>", function() goto_buf("next") end, { desc = "Next Buffer" })
  mapkey("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
  mapkey("n", "<leader>qa", "<cmd>wqa<cr>", { desc = "Save and Quit All" })

  mapkey("n", "<leader>qq",
    function()
      local modified = vim.api.nvim_get_option_value("modified", { buf = vim.api.nvim_get_current_buf() })
      local n_buffers = #vim.fn.getbufinfo({ buflisted = 1 })
      vim.api.nvim_command(modified and "w|bd" or "bd");
      if n_buffers <= 1 then vim.api.nvim_command("quit") end
    end,
    { desc = "Save and Close Buffer" }
  )

  mapkey("n", "<leader>fn", ":echo expand('%')<cr>", { desc = "Show filename" })
  mapkey({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })
  mapkey("x", "<leader>p", [["_dP]], { desc = "Paste into selection" })
  mapkey("n", "<leader>ur", "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <c-l><cr>",
    { desc = "Redraw / Clear hlsearch / Diff Update" })
  mapkey("n", "<leader>ti", vim.show_pos, { desc = "Inspect Pos" })
  mapkey("n", "<leader>tI", "<cmd>InspectTree<cr>", { desc = "Inspect Tree" })

  mapkey("n", ",e",
    function()
      local dir = dirname(vim.fn.bufname())
      print(vim.api.nvim_buf_get_name(0));
      vim.api.nvim_feedkeys(":edit " .. dir:gsub("[[]", "\\[") .. "/", "n", false)
      vim.api.nvim_input("<tab>")
    end,
    { desc = "Find and Edit" }
  )
end

function M.keys_automagic()
  mapkey("v", "<", "<gv", { desc = "Indent and stay in indent mode" })
  mapkey("v", ">", ">gv", { desc = "Indent and stay in indent mode" })

  mapkey({ "n", "v" }, "0d", '"_d', { desc = "Delete" })

  mapkey("n", "G", "Gzz", { desc = "Move to end and stay in center" })
  mapkey("n", "<c-j>", "10j", { desc = "Jump ten lines down" })
  mapkey("n", "<c-k>", "10k", { desc = "Jump ten lines up" })

  mapkey("c", "<c-h>", "<left>", { desc = "Cmdline Movement", silent = false })
  mapkey("c", "<c-l>", "<right>", { desc = "Cmdline Movement", silent = false })
  mapkey("c", "<c-a>", "<home>", { desc = "Cmdline Movement", silent = false })
  mapkey("c", "<c-e>", "<end>", { desc = "Cmdline Movement", silent = false })

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
end

function M.keys_lsp()
  local picker = require("snacks.picker")
  local toggle = require("snacks.toggle")

  toggle.diagnostics():map("<leader>ud")
  toggle.inlay_hints():map("<leader>uh")
  toggle.new({
    id = "diagnostics_virtual_lines",
    name = "Diagnostics virtual lines",
    get = function() return vim.diagnostic.config().virtual_lines end,
    set = function(virtual_lines) vim.diagnostic.config({ virtual_lines = virtual_lines }) end
  }):map("<leader>uv")

  mapkey("i", "<leader>cS", function() return vim.lsp.buf.signature_help() end, { desc = "Signature Help" })
  mapkey("n", "[e", function() goto_diag(false, "ERROR") end, { desc = "Prev Error" })
  mapkey("n", "[w", function() goto_diag(false, "WARN") end, { desc = "Prev Warning" })
  mapkey("n", "]e", function() goto_diag(true, "ERROR") end, { desc = "Next Error" })
  mapkey("n", "]w", function() goto_diag(true, "WARN") end, { desc = "Next Warning" })

  mapkey("n", "<leader>ca", function() vim.lsp.buf.code_action() end, { desc = "Code Action" })
  mapkey("n", "<leader>cR", function() require("snacks.rename").rename_file() end, { desc = "Rename File" })
  mapkey("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename" })
  mapkey("n", "<leader>da", function() picker.diagnostics() end, { desc = "Workspace Diagnostics" })
  mapkey("n", "<leader>db", function() picker.diagnostics_buffer() end, { desc = "Buffer Diagnostics" })
  mapkey("n", "<leader>de", function() picker.diagnostics({ severity = "ERROR" }) end, { desc = "Workspace Errors" })
  mapkey("n", "<leader>dd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
  mapkey("n", "<leader>dn", function() goto_diag(true) end, { desc = "Next Diagnostic" })
  mapkey("n", "<leader>dp", function() goto_diag(false) end, { desc = "Prev Diagnostic" })
  mapkey("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename" })
  mapkey("n", "<leader>ss", function() picker.lsp_symbols() end, { desc = "LSP Symbols" })
  mapkey("n", "<leader>sS", function() picker.lsp_workspace_symbols() end, { desc = "LSP Workspace Symbols" })
  mapkey("n", "gD", function() picker.lsp_declarations() end, { desc = "Goto Declaration" })
  mapkey("n", "gd", function() picker.lsp_definitions() end, { desc = "Goto Definition" })
  mapkey("n", "gI", function() picker.lsp_implementations() end, { desc = "Goto Implementation" })
  mapkey("n", "gK", function() return vim.lsp.buf.signature_help() end, { desc = "Signature Help" })
  mapkey("n", "gr", function() picker.lsp_references() end, { desc = "References", nowait = true })
  mapkey("n", "gy", function() picker.lsp_type_definitions() end, { desc = "Goto T[y]pe Definition" })
  mapkey("n", "K", function() return vim.lsp.buf.hover() end, { desc = "Displays information about the symbol under the cursor in a floating window"})
end

function M.multicursor(mc)
  mapkey({ "n", "x" }, "<c-d>", function() mc.matchAddCursor(1) end, { desc = "Add Next Cursor" })
  mapkey({ "n", "x" }, "<c-s-d>", function() mc.matchAddCursor(-1) end, { desc = "Add Prev Cursor" })
  mapkey({ "n", "x" }, "<c-q>", mc.toggleCursor, { desc = "Toggle cursor" })

  mapkey({ "n", "x" }, "<leader>mt", function() require("multicursor-nvim").toggleCursor() end, { desc = "Add and remove cursors using the main cursor" })
  mapkey({ "n" }, "<leader>mr", function() require("multicursor-nvim").restoreCursors() end, { desc = "Bring back cursors if you accidentally clear them" })
  mapkey({ "n" }, "<leader>mL", function() require("multicursor-nvim").alignCursors() end, { desc = "Align cursor columns" })

  mc.addKeymapLayer(function(layerSet)
    layerSet("n", "<esc>", function()
      if not mc.cursorsEnabled() then
        mc.enableCursors()
      else
        mc.clearCursors()
      end
    end)
  end)
end

function M.keys_snacks()
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
end

M.blink = {
  preset = "default",
  ["<cr>"] = {
    function(ctx)
      local item = ctx.get_selected_item() or {}
      if item.source_id == "copilot" then return ctx.select_and_accept() end
      if item.source_id == "snippets" then return ctx.select_and_accept() end
      if get_word_before_cursor() ~= nil then return ctx.select_and_accept() end
    end,
    "fallback",
  },
  ["<tab>"] = {
    function(ctx) return ctx.select_next() end,
    "fallback",
  },
  ["<s-tab>"] = {
    function(ctx) return ctx.select_prev() end,
    "fallback",
  }
}

M.conform = {
  { "<leader>cF", mode = { "n", "v" },
    function() require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 }) end,
    desc = "Format Injected Langs",
  },
}

M.copilot = {
  { "<leader>cs", ":Copilot panel<cr>", desc = "Open Copilot completions" },
  { "<leader>cxd", ":Copilot disable<cr>", desc = "Disable Copilot", silent = false },
  { "<leader>cxs", ":Copilot status<cr>", desc = "Copilot status", silent = false },
  { "<leader>cxe", ":Copilot! attach<cr>:Copilot enable<cr>", desc = "Enable Copilot", silent = false },
}

M.copilotchat = {
  { "<leader>cc", function() toggle_copilot("horizontal") end, desc = "Open Copilot Chat" },
  { "<leader>cz", function() toggle_copilot("replace") end, desc = "Open Copilot Chat in fullscreen" },
  { "<leader>cp", function() require("CopilotChat").stop() end, desc = "Stop Copilot Chat" },
}

M.mason = {
  { "<leader>nM", "<cmd>Mason<cr>", desc = "Mason package manager" },
}

M.oil = {
  { "-", "<cmd>Oil<cr>", desc = "Open File Explorer" },
  { "<leader>e", function() require("oil").open_float() end, desc = "Open File Explorer" },
}

M.snacks = {
  -- regular keys
  { "<leader>bd", function() require("snacks").bufdelete() end, desc = "Delete Buffer" },
  { "<leader>bo", function() require("snacks").bufdelete.other() end, desc = "Delete Other Buffers" },

  -- top pickers
  { "<c-space>", function() require("snacks.picker").smart() end, desc = "Smart Find Files" },
  { "<leader><space>", function() require("snacks.picker").smart() end, desc = "Smart Find Files" },
  { "<leader>ff", function() require("snacks.picker").files() end, desc = "Find Files" },
  { "<leader>fg", function() require("snacks.picker").git_files() end, desc = "Find Git Files" },
  { "<leader>fr", function() require("snacks.picker").recent() end, desc = "Recent" },
  { "<leader>fP", function() require("snacks.picker").files({ cwd = ".." }) end, desc = "Find parent Files" },
  { "<leader>b", function() require("snacks.picker").buffers() end, desc = "Buffers" },
  { "<leader>P", function() require("snacks.picker").projects() end, desc = "Projects" },
  { "<leader>:", function() require("snacks.picker").command_history() end, desc = "Command History" },
  { "z=", function() require("snacks.picker").spelling() end, desc = "Spelling suggestions" },

  -- git
  { "<leader>gb", function() require("snacks.picker").git_branches() end, desc = "Git Branches" },
  { "<leader>gl", function() require("snacks.picker").git_log() end, desc = "Git Log" },
  { "<leader>gs", function() require("snacks.picker").git_status() end, desc = "Git Status" },
  { "<leader>gf", function() require("snacks.picker").git_log_file() end, desc = "Git Log File" },

  -- grep
  { "<leader>sB", function() require("snacks.picker").grep_buffers() end, desc = "Grep Open Buffers" },
  { "<leader>sg", function() require("snacks.picker").grep() end, desc = "Grep" },
  { "<leader>sw", function() require("snacks.picker").grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },

  -- search
  { '<leader>s"', function() require("snacks.picker").registers() end, desc = "Registers" },
  { '<leader>s/', function() require("snacks.picker").search_history() end, desc = "Search History" },
  { "<leader>sb", function() require("snacks.picker").lines() end, desc = "Buffer Lines" },
  { "<leader>sc", function() require("snacks.picker").command_history() end, desc = "Command History" },
  { "<leader>sh", function() require("snacks.picker").help() end, desc = "Help Pages" },
  { "<leader>sH", function() require("snacks.picker").highlights() end, desc = "Highlights" },
  { "<leader>sj", function() require("snacks.picker").jumps() end, desc = "Jumps" },
  { "<leader>sl", function() require("snacks.picker").loclist() end, desc = "Location List" },
  { "<leader>sm", function() require("snacks.picker").marks() end, desc = "Marks" },
  { "<leader>sM", function() require("snacks.picker").man() end, desc = "Man Pages" },
  { "<leader>sq", function() require("snacks.picker").qflist() end, desc = "Quickfix List" },
  { "<leader>sR", function() require("snacks.picker").resume() end, desc = "Resume" },
  { "<leader>su", function() require("snacks.picker").undo() end, desc = "Undo History" },

  -- neovim config and files
  { "<leader>na", function() require("snacks.picker").autocmds() end, desc = "Autocmds" },
  { "<leader>nl", function() require("snacks.picker").lsp_config() end, desc = "Lsp Info" },
  { "<leader>nC", function() require("snacks.picker").commands() end, desc = "Commands" },
  { "<leader>nc", function() require("snacks.picker").files({ cwd = vim.fn.stdpath("config") }) end, desc = "Config File" },
  { "<leader>nI", function() require("snacks.picker").icons() end, desc = "Icons" },
  { "<leader>nk", function() require("snacks.picker").keymaps() end, desc = "Keymaps" },
  { "<leader>nf", function() require("snacks.picker").files({ cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy") }) end, desc = "LazyVim files" },
  { "<leader>nn", function() require("snacks.picker").notifications() end, desc = "Notification History" },
  { "<leader>uC", function() require("snacks.picker").colorschemes() end, desc = "Colorschemes" },

  -- terminal
  { "<C-/>", "<cmd>close<cr>", mode = "t", desc = "Hide Terminal" },
  { "<C-_>", "<cmd>close<cr>", mode = "t", desc = "Hide Terminal" },
  { "<c-_>", function() require("snacks").terminal() end, desc = "Terminal (cwd)" },
}

M.which_key = {
  { "<leader>h", function() require("which-key").show() end, desc = "Show which-key" },
}

return M
