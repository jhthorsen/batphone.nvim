local dirname = vim.fs and vim.fs.dirname or function(p) return vim.fn.fnamemodify(p, ":h") end
local key = vim.keymap.set
local toggle = require("batphone.toggle").toggle;
local M = {}

function M.auto()
  key("v", "<", "<gv", { desc = "Indent and stay in indent mode" })
  key("v", ">", ">gv", { desc = "Indent and stay in indent mode" })

  key("n", "G", "Gzz", { desc = "Move to end and stay in center" })

  key("c", "<c-h>", "<left>", { desc = "Cmdline Movement", silent = false })
  key("c", "<c-l>", "<right>", { desc = "Cmdline Movement", silent = false })
  key("c", "<c-a>", "<home>", { desc = "Cmdline Movement", silent = false })
  key("c", "<c-e>", "<end>", { desc = "Cmdline Movement", silent = false })

  key({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'",
    { desc = "Moving the cursor through long soft-wrapped lines", expr = true, silent = true })
  key({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'",
    { desc = "Moving the cursor through long soft-wrapped lines", expr = true, silent = true })

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

function M.blink()
  return {
    preset = "default",
    ["<cr>"] = {
      function(ctx)
        local item = ctx.get_selected_item() or {}
        if item.source_id == "copilot" then return ctx.select_and_accept() end
        if item.source_id == "snippets" then return ctx.select_and_accept() end

        local col = vim.api.nvim_win_get_cursor(0)[2]
        if col == 0 then return nil end

        local line = vim.api.nvim_get_current_line()
        local word_before = line:sub(col, col):match("%w")
        if word_before ~= nil then return ctx.select_and_accept() end
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
end

function M.buffers()
  key("n", "<tab>", "<cmd>bnext<cr>", { desc = "Prev Buffer" })
  key("n", "<s-tab>", "<cmd>bprevious<cr>", { desc = "Next Buffer" })
  key("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
  key("n", "<leader>qa", "<cmd>wqa<cr>", { desc = "Save and Quit All" })
  key("n", "<leader>qq",
    function()
      local n_buffers = #vim.fn.getbufinfo({ buflisted = 1 })
      if string.match(vim.api.nvim_buf_get_name(0), "term://") ~= nil then
        vim.api.nvim_command("bd!");
        if n_buffers <= 1 then vim.api.nvim_command("quit") end
        return
      end

      local layout = vim.fn.winlayout()
      if #layout == 2 and layout[1] ~= "leaf" then
        vim.api.nvim_command("wincmd c");
        return
      end

      local modified = vim.api.nvim_get_option_value("modified", { buf = vim.api.nvim_get_current_buf() })
      vim.api.nvim_command(modified and "w|bd" or "bd");

      if n_buffers <= 1 then
        vim.api.nvim_command("quit")
        return
      end

      if layout[1] == "row" then
        vim.cmd("vsplit")
      elseif layout[1] == "col" then
        vim.cmd("split")
      end
    end,
    { desc = "Save and Close Buffer" }
  )
end

function M.copilot()
  local copilot_client = require("batphone.copilot").lazy("copilot.client")
  local copilot_command = require("batphone.copilot").lazy("copilot.command")

  vim.keymap.set('n', '<leader>cc', function()
    require("batphone.copilot").lazy("CopilotChat")().open()
  end)

  vim.keymap.set('n', '<leader>cp', function()
    local _ = require("batphone.copilot").lazy("CopilotChat")()
    local picker = require("snacks.picker")
    local items = {}

    if string.match(vim.api.nvim_buf_get_name(0), "copilot%-chat") == nil then
      items = {
        { name = "CopilotChatOpen",     text = "Open Chat" },
        { name = "CopilotChatExplain",  text = "Explain Code" },
        { name = "CopilotChatReview",   text = "Review Code" },
        { name = "CopilotChatFix",      text = "Fix Code Issues" },
        { name = "CopilotChatOptimize", text = "Optimize Code" },
        { name = "CopilotChatTests",    text = "Generate Tests" },
        { name = "CopilotChatDocs",     text = "Generate Docs" },
        { name = "CopilotChatCommit",   text = "Generate Commit Message" },
      }
    else
      items = {
        { name = "CopilotChatClose",    text = "Close Chat" },
        { name = "CopilotChatModels",   text = "Select Model" },
        { name = "CopilotChatStop",     text = "Stop Current Output" },
        { name = "CopilotChatPrompts",  text = "View/select Prompt Templates" },
        { name = "CopilotChatLoad",     text = "Load History" },
        { name = "CopilotChatSave",     text = "Save History" },
        { name = "CopilotChatReset",    text = "Reset Chat" },
      }
    end

    picker({
      layout = require("batphone.snacks").layout.helix,
      items = items,
      format = function(item)
        return { { item.text, 'SnacksPickerLabel' } }
      end,
      confirm = function(p, item)
        p:close()
        vim.cmd(item.name)
      end,
    })
  end, { desc = "Open Copilot Picker" })

  toggle({
    key = "<leader>ct",
    desc = { enabled = "Disable Copilot", disabled = "Enable Copilot" },
    current = function() return copilot_client().buf_is_attached(0) and true or false end,
    set = function(_) copilot_command().toggle() end
  })
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
  key("n", "<leader>nR", "<cmd>restart<cr>", { desc = "Restart neovim" })
  key("n", "<leader>nU", function() vim.pack.update() end, { desc = "Update Neovim Plugins" })
  key("n", "<leader>fn", ":echo expand('%')<cr>", { desc = "Show filename" })
  key("n", "<leader>nha", ":checkhealth<cr>", { desc = "Checkhealth" })
  key("n", "<leader>nhl", ":checkhealth vim.lsp<cr>", { desc = "Checkhealth LSP" })
  key("n", "<leader>nht", ":checkhealth nvim-treesitter vim.treesitter<cr>", { desc = "Checkhealth treesitter" })
  key("n", "<leader>nhw", ":checkhealth which-key<cr>", { desc = "Checkhealth which-key" })

  local function focus_window(dir, split_cmd)
    return function()
      local layout = vim.fn.winlayout()
      if layout[1] == "leaf" then vim.cmd(split_cmd) end
      local cmd = "wincmd " .. dir
      local ok, _ = pcall(vim.cmd, cmd)
      if not ok then vim.cmd("wincmd p") end
    end
  end

  key("n", "<leader>wh", focus_window("h", "vsplit"), { desc = "Go To Left Pane" })
  key("n", "<leader>wl", focus_window("l", "vsplit"), { desc = "Go To Right Pane" })
  key("n", "<leader>wj", focus_window("j", "split"), { desc = "Go To Pane Below" })
  key("n", "<leader>wk", focus_window("k", "split"), { desc = "Go To Pane Above" })

  key("n", ",e",
    function()
      local dir = dirname(vim.fn.bufname())
      print(vim.api.nvim_buf_get_name(0));
      vim.api.nvim_feedkeys(":edit " .. dir:gsub("[[]", "\\[") .. "/", "n", false)
      vim.api.nvim_input("<tab>")
    end,
    { desc = "Find and Edit" }
  )

  toggle({
    key = "<leader>uS",
    desc = { enabled = "Hide Sign Column", disabled = "Show Sign Column" },
    current = function() return vim.wo.signcolumn == "yes" end,
    set = function(enabled)
      vim.wo.signcolumn = enabled and "no" or "yes"
      vim.wo.number = not enabled
      vim.wo.relativenumber = not enabled
    end
  })

  toggle({
    key = "<leader>uL",
    desc = { enabled = "Show Absolute Line Numbers", disabled = "Show Relative Line Numbers" },
    option = "relativenumber",
  })

  toggle({
    key = "<leader>us",
    desc = { enabled = "Disable Spellcheck", disabled = "Enable Spellcheck" },
    option = "spell",
  })

  toggle({
    key = "<leader>uT",
    desc = { enabled = "Disable Treesitter", disabled = "Enable Treesitter" },
    current = function() return vim.b.ts_highlight end,
    set = function(enabled) vim.treesitter[enabled and "stop" or "start"]() end,
  })

  toggle({
    key = "<leader>uw",
    desc = { enabled = "Cut Long Lines", disabled = "Wrap Lines" },
    option = "wrap",
  })
end

function M.multicursor(mc)
  toggle({
    key = "<leader>me",
    mode = { "n", "v", "x" },
    desc = { enabled = "Clear Multicursors", disabled = "Enable Multicursors" },
    current = function() return mc.hasCursors() and mc.cursorsEnabled() end,
    set = function(enabled)
      if enabled then
        mc.clearCursors()
      elseif mc.hasCursors() then
        mc.enableCursors()
      else
        mc.restoreCursors()
      end
    end
  })

  key({ "n", "x" }, "<c-d>", function() mc.matchAddCursor(1) end, { desc = "Add Next Cursor" })
  key({ "n", "x" }, "<c-s-d>", function() mc.matchAddCursor(-1) end, { desc = "Add Prev Cursor" })
  key({ "v", "x" }, "I", mc.insertVisual, { desc = "Multicursor Insert" })
  key({ "v", "x" }, "A", mc.appendVisual, { desc = "Multicursor Append" })
  key({ "n" }, "<leader>mt", mc.toggleCursor, { desc = "Add and Remove Cursors" })
  key({ "n" }, "<leader>md", mc.disableCursors, { desc = "Multicursor Disable" })
  key({ "n", "v", "x" }, "<leader>ma", mc.alignCursors, { desc = "Align Cursors" })
  key({ "n", "x" }, "g<c-a>", mc.sequenceIncrement, {})
  key({ "n", "x" }, "g<c-x>", mc.sequenceDecrement, {})

  mc.addKeymapLayer(function(mk)
    mk({ "n", "x" }, "<esc>", mc.clearCursors)
    mk({ "v", "x" }, "i", "<c-a>i")
    mk({ "v", "x" }, "n", "<esc>")
  end)
end

function M.lsp()
  local function goto_diag(next, severity)
    severity = severity and vim.diagnostic.severity[severity] or nil
    local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
    go({ severity = severity })
  end

  toggle({
    key = "<leader>dx",
    desc = { enabled = "Disable Diagnostics", disabled = "Enable Diagnostics" },
    current = function() return vim.diagnostic.is_enabled() end,
    set = function(enabled) vim.diagnostic.enable(not enabled) end,
  })

  toggle({
    key = "<leader>uh",
    desc = { enabled = "Hide Inlay Hints", disabled = "Show Inlay Hints" },
    current = function() return vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }) end,
    set = function(enabled) vim.lsp.inlay_hint.enable(not enabled, { bufnr = 0 }) end,
  })

  toggle({
    key = "<leader>dv",
    desc = { enabled = "Hide Virtual Lines", disabled = "Show Virtual Lines" },
    current = function() return vim.diagnostic.config().virtual_lines and true or false end,
    set = function(enabled) vim.diagnostic.config({ virtual_lines = not enabled }) end
  })

  local picker = require("snacks.picker")
  key("n", "[e", function() goto_diag(false, "ERROR") end, { desc = "Prev Error" })
  key("n", "[w", function() goto_diag(false, "WARN") end, { desc = "Prev Warning" })
  key("n", "]e", function() goto_diag(true, "ERROR") end, { desc = "Next Error" })
  key("n", "]w", function() goto_diag(true, "WARN") end, { desc = "Next Warning" })
  key("n", "<leader>cf", function() return vim.lsp.buf.format() end, { desc = "Format code" })
  key("n", "<leader>ca", function() vim.lsp.buf.code_action() end, { desc = "Code Action" })
  key("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename symbol" })
  key("n", "<leader>cR", function() require("snacks.rename").rename_file() end, { desc = "Rename File" })
  key("n", "<leader>cS", function() return vim.lsp.buf.signature_help() end, { desc = "Signature Help" })
  key("n", "<leader>da", function() picker.diagnostics() end, { desc = "Workspace Diagnostics" })
  key("n", "<leader>db", function() picker.diagnostics_buffer() end, { desc = "Buffer Diagnostics" })
  key("n", "<leader>de", function() picker.diagnostics({ severity = "ERROR" }) end, { desc = "Workspace Errors" })
  key("n", "<leader>dd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
  key("n", "<leader>dn", function() goto_diag(true) end, { desc = "Next Diagnostic" })
  key("n", "<leader>dp", function() goto_diag(false) end, { desc = "Prev Diagnostic" })
  key("n", "<leader>ss", function() picker.lsp_symbols() end, { desc = "LSP Symbols" })
  key("n", "<leader>sS", function() picker.lsp_workspace_symbols() end, { desc = "LSP Workspace Symbols" })
  key("n", "gD", function() picker.lsp_declarations() end, { desc = "Goto Declaration" })
  key("n", "gd", function() picker.lsp_definitions() end, { desc = "Goto Definition" })
  key("n", "gI", function() picker.lsp_implementations() end, { desc = "Goto Implementation" })
  key("n", "gK", function() return vim.lsp.buf.signature_help() end, { desc = "Signature Help" })
  key("n", "gr", function() picker.lsp_references() end, { desc = "References", nowait = true })
  key("n", "gy", function() picker.lsp_type_definitions() end, { desc = "Goto T[y]pe Definition" })
  key("n", "K", function() return vim.lsp.buf.hover() end,
    { desc = "Displays information about the symbol under the cursor in a floating window" })
end

function M.mason()
  local ui = require("batphone.mason").lazy("mason.ui")
  key("n", "<leader>nM", function() ui().open() end, { desc = "Open Mason Package Manager" })
end

function M.oil()
  local oil = require("batphone.oil").lazy("oil")
  key("n", "<leader>fe", function() oil().open_float() end, { desc = "Open File Explorer" })
end

function M.snacks()
  local snacks = require("batphone.snacks").lazy("snacks")
  local picker = require("batphone.snacks").lazy("snacks.picker")

  key("n", "<leader>bd", function() snacks().bufdelete() end, { desc = "Delete Buffer" })
  key("n", "<leader>bo", function() snacks().bufdelete.other() end, { desc = "Delete Other Buffers" })
  key("n", "<leader>bs", function() picker().buffers() end, { desc = "Search Buffers (<leader>b)" })

  key("n", "<leader><space>", function() picker().smart() end, { desc = "Smart Find Files" })
  key("n", "<leader>ff", function() picker().files() end, { desc = "Find Files" })
  key("n", "<leader>fg", function() picker().git_files() end, { desc = "Find Git Files" })
  key("n", "<leader>fr", function() picker().recent() end, { desc = "Recent" })
  key("n", "<leader>fp", function() picker().projects() end, { desc = "Open File from Projects" })
  key("n", "<leader>fx", function() picker().files({ cwd = ".." }) end, { desc = "Find parent Files" })
  key("n", "<leader>b", function() picker().buffers() end, { desc = "Search Buffers" })
  key("n", "<leader>n:", function() picker().command_history() end, { desc = "Command History" })
  key("n", "z=", function() picker().spelling() end, { desc = "Spelling suggestions" })

  key("n", "<leader>gb", function() picker().git_branches() end, { desc = "Git Branches" })
  key("n", "<leader>gl", function() picker().git_log() end, { desc = "Git Log" })
  key("n", "<leader>gs", function() picker().git_status() end, { desc = "Git Status" })

  key("n", "<leader>sB", function() picker().grep_buffers() end, { desc = "Grep Open Buffers" })
  key("n", "<leader>sg", function() picker().grep() end, { desc = "Grep Project Files" })
  key({ "n", "x" }, "<leader>sw", function() picker().grep_word() end, { desc = "Visual selection or word" })

  key("n", '<leader>s"', function() picker().registers() end, { desc = "Registers" })
  key("n", "<leader>sb", function() picker().lines() end, { desc = "Buffer Lines" })
  key("n", "<leader>sj", function() picker().jumps() end, { desc = "Jumps" })
  key("n", "<leader>sl", function() picker().loclist() end, { desc = "Location List" })
  key("n", "<leader>sm", function() picker().marks() end, { desc = "Marks" })
  key("n", "<leader>sq", function() picker().qflist() end, { desc = "Quickfix List" })

  key("n", "<leader>na", function() picker().autocmds() end, { desc = "Search Auto-commands" })
  key("n", "<leader>nC", function() picker().commands() end, { desc = "Search Commands" })
  key("n", "<leader>nc", function() picker().files({ cwd = vim.fn.stdpath("config") }) end, { desc = "Search Config Files" })
  key("n", "<leader>nI", function() picker().icons() end, { desc = "Search Icons" })
  key("n", "<leader>nk", function() picker().keymaps() end, { desc = "Search Keymaps" })
  key("n", "<leader>nf", function() picker().files({ dirs = vim.api.nvim_get_runtime_file("lua/", true) }) end, { desc = "Plugin files" })
  key("n", "<leader>uC", function() picker().colorschemes() end, { desc = "Search Colorschemes" })

  key("n", "<leader>wz", function() snacks().zen() end, { desc = "Toggle Zen Mode" })
end

function M.terminal()
  local shell = vim.env.NVIM_TERMINAL_SHELL or vim.env.SHELL or "bash"

  key("t", "<leader><esc>", "<c-\\><c-n>", { desc = "Normal Mode" })
  key("n", "<leader>t", function()
    local layout = vim.fn.winlayout()

    -- Focus previous edit window if inside the terminal
    if string.match(vim.api.nvim_buf_get_name(0), "term://") ~= nil then
      return vim.cmd(layout[1] ~= nil and "wincmd p" or "close")
    end

    -- Focus already opened terminal
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
      local name = vim.api.nvim_buf_get_name(bufnr)
      if string.match(name or "", "term://") ~= nil then
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          if vim.api.nvim_win_get_buf(win) == bufnr then
            vim.api.nvim_set_current_win(win)
            return
          end
        end

       vim.cmd("buffer " .. bufnr)
       return
      end
    end

    -- Open a new terminal
    if vim.o.columns > 160 then
      vim.cmd("vsplit term://" .. shell)
    else
      vim.cmd("split term://" .. shell)
    end
  end, { desc = "Toggle Terminal" })
end

function M.which_key(wk)
  wk.add({ "<leader>h", function() wk.show() end, icon = "🎹", desc = "Show All Keys" })
end

return M
