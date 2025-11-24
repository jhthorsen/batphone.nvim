local key = vim.keymap.set
local toggle = require("batphone.toggle").toggle;
local M = {}

function M.auto()
  key("v", "<", "<gv", { desc = "Indent and stay in indent mode" })
  key("v", ">", ">gv", { desc = "Indent and stay in indent mode" })

  key("c", "<c-h>", "<left>", { desc = "Cmdline Movement", silent = false })
  key("c", "<c-l>", "<right>", { desc = "Cmdline Movement", silent = false })
  key("c", "<c-a>", "<home>", { desc = "Cmdline Movement", silent = false })
  key("c", "<c-e>", "<end>", { desc = "Cmdline Movement", silent = false })

  key({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'",
    { desc = "Moving the cursor through long soft-wrapped lines", expr = true, silent = true })
  key({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'",
    { desc = "Moving the cursor through long soft-wrapped lines", expr = true, silent = true })

  key("i", ".", ".<c-g>u", { desc = "Set Undo break" })
  key("i", ";", ";<c-g>u", { desc = "Set Undo break" })
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
  key("n", "<tab>", "<cmd>bnext|echo expand('%')<cr>", { desc = "Prev Buffer" })
  key("n", "<s-tab>", "<cmd>bprevious|echo expand('%')<cr>", { desc = "Next Buffer" })
  key("n", "<c-q>", "<cmd>bp|bd#|echo expand('%')<cr>", { desc = "Delete Buffer" })
  key("n", "<leader>qa", "<cmd>wqa<cr>", { desc = "Save and Quit All" })
  key("n", "<leader>qq", "<cmd>silent w!|bp|bd#|echo expand('%')<cr>", { desc = "Delete Buffer" })
  key("n", "<leader>qs", "<cmd>wa!|echo expand('%')<cr>", { desc = "Save all open buffers" })
end

function M.codecompanion()
  local cc = require("batphone.codecompanion")

  toggle({
    key = "<leader>cE",
    desc = { enabled = "Disable Copilot", disabled = "Enable Copilot" },
    current = function() return cc.copilot_is_enabled() end,
    set = function(enabled) cc.copilot_enable(not enabled) end,
  })

  key("n", "<leader>cc", cc.cmd("CodeCompanionChat Toggle"), { desc = "CodeCompanion Chat" })
  key("n", "<leader>cA", cc.cmd("CodeCompanionActions"), { desc = "CodeCompanion Actions" })
  key("n", "<leader>cH", cc.cmd("CodeCompanionHistory"), { desc = "CodeCompanion History" })
  key("n", "<leader>cl", cc.cmd("CodeCompanion /lsp"), { desc = "Explain The LSP Diagnostics" })
  key("n", "<leader>cs", cc.cmd("CodeCompanionSummaries"), { desc = "CodeCompanion Summaries" })

  key("v", "<leader>cA", cc.cmd("CodeCompanionChat Add"), { desc = "Add Code To Chat" })
  key("v", "<leader>ce", cc.cmd("CodeCompanion /explain"), { desc = "Explain Code" })
  key("v", "<leader>cf", cc.cmd("CodeCompanion /fix"), { desc = "Fix Code" })
  key("v", "<leader>ct", cc.cmd("CodeCompanion /tests"), { desc = "Generte Tests" })
end

function M.edit()
  key({ "n", "v" }, "0d", '"_d', { desc = "Delete" })
end

function M.editor()
  key("n", "<leader>nR", "<cmd>restart<cr>", { desc = "Restart neovim" })
  key("n", "<leader>nU", function() vim.pack.update() end, { desc = "Update Neovim Plugins" })
  key("n", "<leader>nha", ":checkhealth<cr>", { desc = "Check Neovim Health" })
  key("n", "<leader>nhl", ":checkhealth vim.lsp<cr>", { desc = "Checkhealth LSP" })
  key("n", "<leader>nht", ":checkhealth nvim-treesitter vim.treesitter<cr>", { desc = "Checkhealth treesitter" })
  key("n", "<leader>nhw", ":checkhealth which-key<cr>", { desc = "Checkhealth which-key" })

  toggle({
    key = "<leader>ul",
    desc = { enabled = "Show Absolute Line Numbers", disabled = "Show Relative Line Numbers" },
    option = "relativenumber",
  })

  toggle({
    key = "<leader>us",
    desc = { enabled = "Disable Spellcheck", disabled = "Enable Spellcheck" },
    option = "spell",
  })

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
  key({ "n" }, "<leader>md", mc.disableCursors, { desc = "Multicursor Disable" })
  key({ "n" }, "<leader>mt", mc.toggleCursor, { desc = "Add and Remove Cursors" })
  key({ "n", "v", "x" }, "<leader>ma", mc.alignCursors, { desc = "Align Cursors" })
  key({ "v" }, "<space>i", "<s-i>", { desc = "Insert Before Selection" })
  key({ "v" }, "<space>a", "<s-a>", { desc = "Insert After Selection" })

  mc.addKeymapLayer(function(mk)
    mk({ "n" }, "<esc>", mc.clearCursors)
    mk({ "v" }, "I", "<c-a>i", { desc = "Insert Before Selection" })
    mk({ "v" }, "A", "<esc>li", { desc = "Insert After Selection" })
    mk({ "v" }, "<space>i", "<c-a>i", { desc = "Insert Before Selection" })
    mk({ "v" }, "<space>a", "<esc>li", { desc = "Insert After Selection" })
  end)
end

function M.lsp()
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
  key("n", "<leader>cf", function() vim.lsp.buf.format() end, { desc = "Format code" })
  key("n", "<leader>ca", function() vim.lsp.buf.code_action() end, { desc = "Code Action" })
  key("n", "<leader>cr", function() vim.lsp.buf.rename() end, { desc = "Rename symbol" })
  key("n", "<leader>cR", function() require("snacks.rename").rename_file() end, { desc = "Rename File" })
  key("n", "<leader>cS", function() vim.lsp.buf.signature_help() end, { desc = "Signature Help" })
  key("n", "<leader>da", function() vim.diagnostic.setqflist() end, { desc = "Workspace Diagnostics" })
  key("n", "<leader>db", function() vim.diagnostic.setqflist({ bufnr = 0, severity = vim.diagnostic.severity.ERROR }) end, { desc = "Buffer Diagnostics" })
  key("n", "<leader>de", function() vim.diagnostic.setqflist({ severity = vim.diagnostic.severity.ERROR }) end, { desc = "Workspace Errors" })
  key("n", "<leader>dd", function() vim.diagnostic.open_float() end, { desc = "Line Diagnostics" })
  key("n", "<leader>ss", function() picker.lsp_symbols() end, { desc = "LSP Symbols" })
  key("n", "<leader>sS", function() picker.lsp_workspace_symbols() end, { desc = "LSP Workspace Symbols" })
  key("n", "gD", function() picker.lsp_declarations() end, { desc = "Goto Declaration" })
  key("n", "gd", function() picker.lsp_definitions() end, { desc = "Goto Definition" })
  key("n", "gI", function() picker.lsp_implementations() end, { desc = "Goto Implementation" })
  key("n", "gK", function() vim.lsp.buf.signature_help() end, { desc = "Signature Help" })
  key("n", "gr", function() picker.lsp_references() end, { desc = "References", nowait = true })
  key("n", "gy", function() picker.lsp_type_definitions() end, { desc = "Goto T[y]pe Definition" })
  key("n", "K", function() vim.lsp.buf.hover() end, { desc = "Displays information about the symbol under the cursor in a floating window" })
end

function M.mason()
  local ui = require("batphone.mason").lazy("mason.ui")
  key("n", "<leader>nM", function() ui().open() end, { desc = "Open Mason Package Manager" })
end

function M.quicker()
  local quicker = require("quicker").toggle

  local function ifquickfixlist(a, b)
    vim.api.nvim_feedkeys(#vim.fn.getqflist() > 0 and a or b, "n", false)
  end

  key("n", "<c-j>", function() ifquickfixlist(":cnext", "10jzz") end, { desc = "Jump Down" })
  key("n", "<c-k>", function() ifquickfixlist(":cprevious", "10kzz") end, { desc = "Jump Up" })
  key("n", "<leader>dq", function() return #vim.fn.getqflist() > 0 and quicker({ focus = true, }) or vim.diagnostic.setqflist() end, { desc = "Toggle Quickfix" })
  key("n", "<leader>dl", function() quicker({ focus = true, loclist = true }) end, { desc = "Toggle Loclist" })
end

function M.snacks()
  local snacks = require("snacks")
  local picker = require("snacks.picker")

  key("n", "z=", function() picker.spelling() end, { desc = "Spelling suggestions" })
  key("n", ",e", function() snacks.explorer({ focus = "input", hidden = true, tree = false }) end, { desc = "Open File Explorer" })

  key("n", "<leader><space>", function() picker.smart() end, { desc = "Smart Find Files" })
  key("n", "<leader>b", function() picker.buffers() end, { desc = "Switch Buffer" })
  key("n", "<leader>fe", function() snacks.explorer() end, { desc = "Open File Explorer" })
  key("n", "<leader>ff", function() picker.git_files() end, { desc = "Find Git Files" })
  key("n", "<leader>fp", function() picker.projects() end, { desc = "Open File from Projects" })
  key("n", "<leader>fx", function() picker.files({ cwd = ".." }) end, { desc = "Find parent Files" })
  key("n", "<leader>n:", function() picker.command_history() end, { desc = "Command History" })
  key("n", "<leader>sb", function() picker.grep_buffers() end, { desc = "Grep Open Buffers" })
  key("n", "<leader>sg", function() picker.grep() end, { desc = "Grep Project Files" })

  key("n", '<leader>s"', function()
    picker.registers({
      preview = "none",
      confirm = function(p, item)
        p:close()
        require("batphone.scratch_window").edit_register(item)
      end,
    })
  end, { desc = "Edit Register" })

  key("n", "<leader>sj", function() picker.jumps() end, { desc = "Jumps" })
  key("n", "<leader>sm", function() picker.marks() end, { desc = "Marks" })

  key("n", "<leader>na", function() picker.autocmds() end, { desc = "Search Auto-commands" })
  key("n", "<leader>nC", function() picker.commands() end, { desc = "Search Commands" })
  key("n", "<leader>nc", function() picker.files({ cwd = vim.fn.stdpath("config") }) end, { desc = "Search Config Files" })
  key("n", "<leader>nI", function() picker.icons() end, { desc = "Search Icons" })
  key("n", "<leader>nk", function() picker.keymaps() end, { desc = "Search Keymaps" })
  key("n", "<leader>nf", function() picker.files({ dirs = vim.api.nvim_get_runtime_file("lua/", true) }) end, { desc = "Plugin files" })
  key("n", "<leader>uC", function() picker.colorschemes() end, { desc = "Search Colorschemes" })

  key("n", "<leader>nn", function() snacks.notifier.show_history() end, { desc = "Show notifications" })
  key("n", "<leader>wz", function() snacks.zen() end, { desc = "Toggle Zen Mode" })
  key("n", "<leader>wf", "<cmd>only<cr>", { desc = "Fullscreen" })
end

function M.which_key(wk)
  wk.add({ "<leader>h", function() wk.show() end, icon = "🎹", desc = "Show All Keys" })
end

return M
