-- List of events:
-- https://gist.github.com/dtr2300/2f867c2b6c051e946ef23f92bd9d1180

local function rewrite_copilot_chat_history(name)
  local cc = require("CopilotChat")
  local history_file = vim.fs.normalize(cc.config.history_path or "") .. "/" .. name .. ".json"
    vim.print(history_file)
  local history_fh = io.open(history_file, "r")
  if not history_fh then return end

  local history = vim.json.decode(history_fh:read("*a"), { luanil = { array = true, object = true } })
  if #history <= 1 then return end

  history_fh:close()
  for i = #history, 1, -1 do
    if history[i].content == nil or history[i].content == "" then
      table.remove(history, i)
    end
  end

  history_fh = io.open(history_file, "w")
  if not history_fh then return end
  history_fh:write(vim.json.encode(history))
  history_fh:close()
end

-- Go to last location when opening a buffer
vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("batphone_last_loc", { clear = true }),
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
      return
    end

    vim.b[buf].lazyvim_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, "\"")
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

local batphone_copilot_first_time = true
vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("batphone_copilot_start", { clear = true }),
  pattern = "copilot-*",
  callback = function()
    if batphone_copilot_first_time then
      rewrite_copilot_chat_history("default")
      require("CopilotChat").load("default")
      batphone_copilot_first_time = false
    end

    vim.opt_local.colorcolumn = {}
    vim.opt_local.conceallevel = 0
    vim.opt_local.ignorecase = true
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
    vim.opt_local.wrap = true
  end
})

vim.api.nvim_create_autocmd("BufLeave", {
  group = vim.api.nvim_create_augroup("batphone_copilot_end", { clear = true }),
  pattern = "copilot-*",
  callback = function()
    require("CopilotChat").save("default")
  end
})

-- Auto create directory when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("batphone_auto_create_dir", { clear = true }),
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then
      return
    end

    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- Auto install packages
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI", "CursorMoved", "InsertEnter" }, {
  group = vim.api.nvim_create_augroup("batphone_lsp_auto_install", { clear = true }),
  callback = function()
    require("batphone.install_packages").install(vim.bo.filetype)
  end,
})

-- Close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("batphone_close_with_q", { clear = true }),
  pattern = {
    "checkhealth",
    "dbout",
    "gitsigns-blame",
    "grug-far",
    "help",
    "lspinfo",
    "neotest-output-panel",
    "neotest-output",
    "neotest-summary",
    "notify",
    "PlenaryTestPopup",
    "qf",
    "spectre_panel",
    "startuptime",
    "tsplayground",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set("n", "q", function()
        vim.cmd("close")
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, {
        buffer = event.buf,
        silent = true,
        desc = "Quit buffer",
      })
    end)
  end,
})

-- Setup LSP
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("batphone_lsp_config", { clear = true }),
  callback = function(ev)
    -- Only need to run this once
    vim.api.nvim_del_augroup_by_name("batphone_lsp_config")

    require("batphone.keymaps").keys_lsp();

    local signs = {
      Hint = "👀",
      Info = " ",
      Warn = "⚠️",
      Error = "‼️",
    }

    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    vim.diagnostic.config(vim.deepcopy({
      severity_sort = true,
      underline = true,
      update_in_insert = false,
      virtual_text = false,
      virtual_lines = false,
      signs = {
        text = {
          [vim.diagnostic.severity.HINT] = signs.Hint,
          [vim.diagnostic.severity.INFO] = signs.Info,
          [vim.diagnostic.severity.WARN] = signs.Warn,
          [vim.diagnostic.severity.ERROR] = signs.Error,
        },
      },
    }))

    vim.lsp.inlay_hint.enable(false)

    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client ~= nil and client.server_capabilities ~= nil then
      local capabilities = client.server_capabilities or {}

      capabilities.textDocument = vim.tbl_deep_extend(
        "force",
        capabilities.textDocument or {},
        {
          completion = {
           completionItem = {
             snippetSupport = true,
             preselectSupport = true,
             labelDetailsSupport = true,
             commitCharactersSupport = true,
             documentationFormat = { "markdown", "plaintext" },
           },
          },
          hover = {
            contentFormat = { "markdown", "plaintext" },
          },
          signatureHelp = {
            signatureInformation = {
              documentationFormat = { "markdown", "plaintext" },
            },
          },
        }
      )

      capabilities.workspace = vim.tbl_deep_extend(
        "force",
        capabilities.workspace or {},
        {
          fileOperations = {
            didRename = true,
            willRename = true,
          },
        }
      )

      client.server_capabilities = capabilities
    end
  end,
})

vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("batphone_oil_move_file", { clear = true }),
  pattern = "OilActionsPost",
  callback = function(event)
    local actions = event.data.actions

    -- normalize actions before reading "type"
    if actions.type == nil then actions = actions[1] end

    if actions.type == "move" then
      require("snacks.rename").on_rename_file(actions.src_url, actions.dest_url)
    end
  end,
})
