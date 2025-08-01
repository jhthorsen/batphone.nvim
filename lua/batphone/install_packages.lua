local M = {}
local already_asked_lang = {}
local treesitter = {}

function M.install(lang)
  if lang == nil or lang == "" then return end
  if lang == "snacks_win" then return end
  if already_asked_lang[lang] then return end
  if treesitter[lang] == true then vim.treesitter.start() end
  already_asked_lang[lang] = true

  local packages_text = { "The following commands will be run to install extra language support.", "" }
  local n_found = 0
  local n_not_installed = 0

  -- Find missing Tree-sitter packages
  local ts_config = require("nvim-treesitter.config")
  if not require("nvim-treesitter.parsers")[lang] then
    table.insert(packages_text, "# Treesitter does not seem to support " .. lang .. ".")
  elseif vim.list_contains(ts_config.get_installed(), lang) then
    table.insert(packages_text, "# Treesitter is installed for " .. lang .. ".")
    n_found = n_found + 1
    treesitter[lang] = true
    vim.treesitter.start()
  else
    if n_not_installed == 0 and vim.fn.executable("tree-sitter") ~= 1 then
      table.insert(packages_text, ":MasonInstall tree-sitter-cli")
      n_found = n_found + 1
    end

    table.insert(packages_text, ":TSInstall " .. lang)
    n_found = n_found + 1
    n_not_installed = n_not_installed + 1
  end

  -- Find missing Mason packages
  local lsp_mappings = require("mason-lspconfig.mappings").get_all()
  if not lsp_mappings.filetypes[lang] then
    table.insert(packages_text, "# Mason does not seem to support " .. lang .. ".")
  else
    for _, lsp_name in pairs(lsp_mappings.filetypes[lang]) do
      local lsp_config = vim.lsp.config[lsp_name] or {};
      local pkg_name = lsp_mappings.lspconfig_to_package[lsp_name]

      if not pkg_name or lsp_config["batphone_auto_install"] ~= true then
        table.insert(packages_text, "# Missing vim.lsp.config(\"" .. lsp_name .. "\", { batphone_auto_install = true })")
        goto continue
      end

      if #lsp_config.cmd and vim.fn.executable(lsp_config.cmd[1]) == 1 then
        table.insert(packages_text, "# " .. lsp_name .. "'s executable \"" .. lsp_config.cmd[1] .. "\" is installed")
        n_found = n_found + 1
        goto continue
      end

      table.insert(packages_text, "# " .. lsp_name .. "'s executable \"" .. lsp_config.cmd[1] .. "\" is missing")
      table.insert(packages_text, ":MasonInstall " .. pkg_name)
      n_found = n_found + 1
      n_not_installed = n_not_installed + 1
      ::continue::
    end
  end

  -- Do not show the window if nothing to do
  if n_found == 0 then return end
  if n_not_installed == 0 and vim.env.NVIM_AUTO_INSTALL_PACKAGES ~= "1" then return end

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

return M
