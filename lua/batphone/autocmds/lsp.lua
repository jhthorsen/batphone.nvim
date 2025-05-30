local already_asked_lang = {}

vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI", "CursorMoved" }, {
  group = vim.api.nvim_create_augroup("batphone_lsp_auto_install", { clear = true }),
  callback = function()
    local lang = vim.bo.filetype
    if lang == nil or lang == "" or lang == "snacks_win" then return end

    if already_asked_lang[lang] then return end
    already_asked_lang[lang] = true

    local packages_text = { "Do you want to run the following commands to get LSP and Treesitter support?", "" }
    local n_not_installed = 0

    -- Find missing Treesitter packages
    local ts_config = require("nvim-treesitter.config")
    if not require("nvim-treesitter.parsers")[lang] then
      table.insert(packages_text, "# Treesitter does not seem to support " .. lang .. ".")
    elseif vim.list_contains(ts_config.get_installed(), lang) then
      table.insert(packages_text, "# Treesitter is installed for " .. lang .. ".")
    else
      if n_not_installed == 0 and vim.fn.executable("tree-sitter") ~= 1 then
        table.insert(packages_text, ":MasonInstall tree-sitter-cli")
      end

      table.insert(packages_text, ":TSInstall " .. lang)
      n_not_installed = n_not_installed + 1
    end

    -- Find missing Mason packages
    local lsp_mappings = require("mason-lspconfig.mappings").get_all()
    if not lsp_mappings.filetypes[lang] then
      table.insert(packages_text, "# Mason does not seem to support " .. lang .. ".")
    else
      for _, lsp_name in pairs(lsp_mappings.filetypes[lang]) do
        local lsp_config = vim.lsp.config[lsp_name];
        local pkg_name = lsp_mappings.lspconfig_to_package[lsp_name]

        if not pkg_name or not lsp_config or lsp_config == false then
          table.insert(packages_text, "# " .. lsp_name .. " is unknown or disabled.")
          goto continue
        end

        if #lsp_config.cmd and vim.fn.executable(lsp_config.cmd[1]) == 1 then
          table.insert(packages_text, "# " .. lsp_name .. "'s executable " .. lsp_config.cmd[1] .. " is installed")
          goto continue
        end

        table.insert(packages_text, "# " .. lsp_name .. "'s executable " .. lsp_config.cmd[1] .. " is missing")
        table.insert(packages_text, ":MasonInstall " .. pkg_name)
        n_not_installed = n_not_installed + 1
        ::continue::
      end
    end

    if n_not_installed == 0 then
      return
    end

    table.insert(packages_text, "")
    table.insert(packages_text, "Usage:")
    table.insert(packages_text, "- Press \"q\" to exit and install.")
    table.insert(packages_text, "- Delete the lines that you don't want.")
    table.insert(packages_text, "- Run :Mason, :LspRestart or :LspInfo afterwards to see the status.")

    require("snacks").win({
      text = packages_text,
      border = "rounded",
      enter = true,
      focusable = true,
      style = "float",
      height = 0.6,
      width = 80,
      wo = {
        wrap = true,
      },
      on_win = function(win)
        win:set_title("LSP and Treesitter install")
        win:add_padding()
      end,
      on_close = function(win)
        for _, line in pairs(win:lines()) do
          if string.sub(line, 1, 1) == ":" then
            vim.cmd(string.sub(line, 2))
          end
        end
      end,
    })
  end
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("batphone_lsp_config", { clear = true }),
  callback = function(ev)
    require("batphone.keymaps.lsp")()
    require("batphone.utils").set_diagnostics({})

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
