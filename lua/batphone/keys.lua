local toggle = require("batphone.toggle").toggle;
local M = {}

function M.auto()
  vim.keymap.set("v", "<", "<gv", { desc = "Indent and stay in indent mode" })
  vim.keymap.set("v", ">", ">gv", { desc = "Indent and stay in indent mode" })

  vim.keymap.set("c", "<c-h>", "<left>", { desc = "Cmdline Movement", silent = false })
  vim.keymap.set("c", "<c-l>", "<right>", { desc = "Cmdline Movement", silent = false })
  vim.keymap.set("c", "<c-a>", "<home>", { desc = "Cmdline Movement", silent = false })
  vim.keymap.set("c", "<c-e>", "<end>", { desc = "Cmdline Movement", silent = false })

  vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Moving the cursor through long soft-wrapped lines", expr = true, silent = true })
  vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Moving the cursor through long soft-wrapped lines", expr = true, silent = true })

  vim.keymap.set("i", ".", ".<c-g>u", { desc = "Set Undo break" })
  vim.keymap.set("i", ";", ";<c-g>u", { desc = "Set Undo break" })
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
  vim.keymap.set("n", "<tab>", "<cmd>bnext|echo expand('%')<cr>", { desc = "Prev Buffer" })
  vim.keymap.set("n", "<s-tab>", "<cmd>bprevious|echo expand('%')<cr>", { desc = "Next Buffer" })
  vim.keymap.set("n", "<c-q>", "<cmd>bp|bd#|echo expand('%')<cr>", { desc = "Delete Buffer" })
  vim.keymap.set("n", "<leader>qa", "<cmd>wqa<cr>", { desc = "Save and Quit All" })
  vim.keymap.set("n", "<leader>qs", "<cmd>wa!|echo expand('%')<cr>", { desc = "Save all open buffers" })
end

function M.codecompanion()
  require("batphone.util").once("CopilotLoaded", function()
    toggle({
      key = "<leader>cE",
      desc = { enabled = "Disable Copilot", disabled = "Enable Copilot" },
      current = function() return require("copilot.client").buf_is_attached() end,
      set = function(enabled) vim.cmd(enabled and "Copilot disable" or "Copilot enable") end
    })
  end)

  require("batphone.util").once("CodeCompanionLoaded", function()
    local cmd = function(command)
      return function()
        require("codecompanion.config").config.display.chat.window.layout = vim.o.columns > 200 and "vertical" or "horizontal"
        vim.cmd(command)
      end
    end

    vim.keymap.set("n", "<leader>cc", cmd("CodeCompanionChat Toggle"), { desc = "CodeCompanion Chat" })
    vim.keymap.set("n", "<leader>cH", cmd("CodeCompanionHistory"), { desc = "CodeCompanion History" })
    vim.keymap.set("n", "<leader>cs", cmd("CodeCompanionSummaries"), { desc = "CodeCompanion Summaries" })
    vim.keymap.set("v", "<leader>ce", cmd("CodeCompanion /explain"), { desc = "Explain Code" })
    vim.keymap.set("v", "<leader>cf", cmd("CodeCompanion /fix"), { desc = "Fix Code" })
    vim.keymap.set("n", "<leader>cl", cmd("CodeCompanion /lsp"), { desc = "Explain The LSP Diagnostics" })
    vim.keymap.set("v", "<leader>ct", cmd("CodeCompanion /tests"), { desc = "Generte Tests" })
  end)
end

function M.edit()
  vim.keymap.set({ "n", "v" }, "0d", '"_d', { desc = "Delete" })
  vim.keymap.set("n", "<leader>cp", '<cmd>CccPick<cr>', { desc = "Open Color Picker" })
  vim.keymap.set("n", "<leader>cP", '<cmd>CccConvert<cr>', { desc = "Convert Color" })
end

function M.editor()
  vim.keymap.set("n", "<leader>nR", "<cmd>restart<cr>", { desc = "Restart neovim" })
  vim.keymap.set("n", "<leader>nU", function() vim.pack.update() end, { desc = "Update Neovim Plugins" })
  vim.keymap.set("n", "<leader>uc", "<cmd>CccHighlighterToggle<cr>", { desc = "Toggle Color Highlighter" })
  vim.keymap.set("n", "<leader>nha", ":checkhealth<cr>", { desc = "Check Neovim Health" })
  vim.keymap.set("n", "<leader>nhl", ":checkhealth vim.lsp<cr>", { desc = "Checkhealth LSP" })
  vim.keymap.set("n", "<leader>nht", ":checkhealth nvim-treesitter vim.treesitter<cr>", { desc = "Checkhealth treesitter" })
  vim.keymap.set("n", "<leader>nhw", ":checkhealth which-key<cr>", { desc = "Checkhealth which-key" })

  toggle({
    key = "<leader>ul",
    desc = { enabled = "Show Absolute Line Numbers", disabled = "Show Relative Line Numbers" },
    option = "relativenumber",
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

  vim.keymap.set({ "n", "x" }, "<c-d>", function() mc.matchAddCursor(1) end, { desc = "Add Next Cursor" })
  vim.keymap.set({ "n", "x" }, "<c-s-d>", function() mc.matchAddCursor(-1) end, { desc = "Add Prev Cursor" })
  vim.keymap.set({ "n" }, "<leader>md", mc.disableCursors, { desc = "Multicursor Disable" })
  vim.keymap.set({ "n" }, "<leader>mt", mc.toggleCursor, { desc = "Add and Remove Cursors" })
  vim.keymap.set({ "n", "v", "x" }, "<leader>ma", mc.alignCursors, { desc = "Align Cursors" })
  vim.keymap.set({ "v" }, "<space>i", "<s-i>", { desc = "Insert Before Selection" })
  vim.keymap.set({ "v" }, "<space>a", "<s-a>", { desc = "Insert After Selection" })

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

  vim.keymap.set("n", "<leader>cf", function() vim.lsp.buf.format() end, { desc = "Format code" })
  vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end, { desc = "Code Action" })
  vim.keymap.set("n", "<leader>cr", function() vim.lsp.buf.rename() end, { desc = "Rename symbol" })
  vim.keymap.set("n", "<leader>cR", function() require("snacks.rename").rename_file() end, { desc = "Rename File" })
  vim.keymap.set("n", "<leader>cS", function() vim.lsp.buf.signature_help() end, { desc = "Signature Help" })
  vim.keymap.set("n", "<leader>da", function() vim.diagnostic.setqflist() end, { desc = "Workspace Diagnostics" })
  vim.keymap.set("n", "<leader>db", function() vim.diagnostic.setqflist({ bufnr = 0, severity = vim.diagnostic.severity.ERROR }) end, { desc = "Buffer Diagnostics" })
  vim.keymap.set("n", "<leader>de", function() vim.diagnostic.setqflist({ severity = vim.diagnostic.severity.ERROR }) end, { desc = "Workspace Errors" })
  vim.keymap.set("n", "<leader>dd", function() vim.diagnostic.open_float() end, { desc = "Line Diagnostics" })
  vim.keymap.set("n", "<leader>ss", function() require("snacks.picker").lsp_symbols() end, { desc = "LSP Symbols" })
  vim.keymap.set("n", "<leader>sS", function() require("snacks.picker").lsp_workspace_symbols() end, { desc = "LSP Workspace Symbols" })
  vim.keymap.set("n", "gD", function() require("snacks.picker").lsp_declarations() end, { desc = "Goto Declaration" })
  vim.keymap.set("n", "gd", function() require("snacks.picker").lsp_definitions() end, { desc = "Goto Definition" })
  vim.keymap.set("n", "gI", function() require("snacks.picker").lsp_implementations() end, { desc = "Goto Implementation" })
  vim.keymap.set("n", "gK", function() vim.lsp.buf.signature_help() end, { desc = "Signature Help" })
  vim.keymap.set("n", "gr", function() require("snacks.picker").lsp_references() end, { desc = "References", nowait = true })
  vim.keymap.set("n", "gy", function() require("snacks.picker").lsp_type_definitions() end, { desc = "Goto T[y]pe Definition" })
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, { desc = "Displays information about the symbol under the cursor in a floating window" })
end

function M.mason()
  require("batphone.util").lazy_user_command(
    { Mason = 0, MasonInstall = 1, MasonUpdate = 0 },
    function() require("mason").setup({}) end
  )

  vim.keymap.set("n", "<leader>nM", "<cmd>Mason<cr>", { desc = "Open Mason Package Manager" })
end

function M.quicker()
  local quicker = require("quicker").toggle

  local function ifquickfixlist(a, b)
    return #vim.fn.getqflist() <= 0 and vim.api.nvim_feedkeys(b, "n", false) or pcall(vim.cmd, a)
  end

  vim.keymap.set("n", "<c-j>", function() ifquickfixlist("cnext", "10jzz") end, { desc = "Jump Down" })
  vim.keymap.set("n", "<c-k>", function() ifquickfixlist("cprevious", "10kzz") end, { desc = "Jump Up" })
  vim.keymap.set("n", "<leader>dq", function() return #vim.fn.getqflist() > 0 and quicker({ focus = true, }) or vim.diagnostic.setqflist() end, { desc = "Toggle Quickfix" })
  vim.keymap.set("n", "<leader>dl", function() quicker({ focus = true, loclist = true }) end, { desc = "Toggle Loclist" })
end

function M.snacks()
  local snacks = require("snacks")
  local picker = require("snacks.picker")

  vim.keymap.set("n", "z=", function() picker.spelling() end, { desc = "Spelling suggestions" })
  vim.keymap.set("n", ",e", function()
    local cwd = vim.fs.dirname(vim.fn.bufname())
    snacks.explorer({
      cwd = cwd,
      focus = "input",
      hidden = true,
      jump = { close = true },
      matcher = { cwd_bonus = true, filename_bonus = true, fuzzy = true },
      sort = { fields = { "#text", "score:desc" } },
      tree = false,
      win = {
        input = {
          keys = {
            ["<Esc>"] = { "toggle_focus", mode = { "n", "i" } },
          },
        },
      },
    })
  end, { desc = "Find and Edit" })

  vim.keymap.set("n", "<leader><space>", function() picker.smart() end, { desc = "Smart Find Files" })
  vim.keymap.set("n", "<leader>b", function() picker.buffers() end, { desc = "Switch Buffer" })
  vim.keymap.set("n", "<leader>fe", function() snacks.explorer() end, { desc = "Open File Explorer" })
  vim.keymap.set("n", "<leader>ff", function() picker.files({ hidden = true }) end, { desc = "Find Files" })
  vim.keymap.set("n", "<leader>fg", function() picker.git_files() end, { desc = "Find Git Files" })
  vim.keymap.set("n", "<leader>fp", function() picker.projects() end, { desc = "Open File from Projects" })
  vim.keymap.set("n", "<leader>fx", function() picker.files({ cwd = ".." }) end, { desc = "Find parent Files" })
  vim.keymap.set("n", "<leader>n:", function() picker.command_history() end, { desc = "Command History" })
  vim.keymap.set("n", "<leader>sb", function() picker.grep_buffers() end, { desc = "Grep Open Buffers" })
  vim.keymap.set("n", "<leader>sg", function() picker.grep() end, { desc = "Grep Project Files" })

  vim.keymap.set("n", '<leader>s"', function()
    picker.registers({
      preview = "none",
      confirm = function(p, item)
        p:close()
        require("batphone.scratch_window").edit_register(item)
      end,
    })
  end, { desc = "Edit Register" })

  vim.keymap.set("n", "<leader>sj", function() picker.jumps() end, { desc = "Jumps" })
  vim.keymap.set("n", "<leader>sm", function() picker.marks() end, { desc = "Marks" })

  vim.keymap.set("n", "<leader>na", function() picker.autocmds() end, { desc = "Search Auto-commands" })
  vim.keymap.set("n", "<leader>nC", function() picker.commands() end, { desc = "Search Commands" })
  vim.keymap.set("n", "<leader>nc", function() picker.files({ cwd = vim.fn.stdpath("config") }) end, { desc = "Search Config Files" })
  vim.keymap.set("n", "<leader>nI", function() picker.icons() end, { desc = "Search Icons" })
  vim.keymap.set("n", "<leader>nk", function() picker.keymaps() end, { desc = "Search Keymaps" })
  vim.keymap.set("n", "<leader>nf", function() picker.files({ dirs = vim.api.nvim_get_runtime_file("lua/", true) }) end, { desc = "Plugin files" })
  vim.keymap.set("n", "<leader>uC", function() picker.colorschemes() end, { desc = "Search Colorschemes" })

  vim.keymap.set("n", "<leader>nn", function() snacks.notifier.show_history() end, { desc = "Show notifications" })
  vim.keymap.set("n", "<leader>uz", function() snacks.zen() end, { desc = "Toggle Zen Mode" })
  vim.keymap.set("n", "<leader>uf", function() snacks.zen.zoom() end, { desc = "Fullscreen Window" })
  vim.keymap.set("n", "<leader>us", "<cmd>vsplit<cr>", { desc = "Split Window" })

  vim.keymap.set({ "n", "t" }, "<leader>ut", function() snacks.terminal.toggle() end, { desc = "Toggle terminal" })

  vim.keymap.set({ "n", "t" }, "<leader>qq", function()
    local is_terminal = string.match(vim.api.nvim_buf_get_name(0), "term://") ~= nil
    if is_terminal then return snacks.terminal.toggle() end

    local is_modified = vim.api.nvim_get_option_value("modified", { buf = vim.api.nvim_get_current_buf() })
    if is_modified then vim.api.nvim_command("silent w!") end

    local n_buffers = #vim.fn.getbufinfo({ buflisted = 1 })
    if n_buffers <= 1 and #snacks.terminal.list() >= 1 then
      vim.ui.select({ "Close neovim", "Show the terminal", "Do nothing" }, {}, function(choice)
        if choice == "Close neovim" then
          vim.api.nvim_command("quit")
        elseif choice == "Show the terminal" then
          snacks.terminal.toggle()
        end
      end)
    elseif n_buffers <= 1 then
      vim.api.nvim_command("quit")
    else
      vim.api.nvim_command("bp|bd#");
    end
  end, { desc = "Close Buffer" })
end

return M
