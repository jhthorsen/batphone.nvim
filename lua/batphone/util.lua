local M = {
  lsp_auto_install = vim.env.NVIM_LSP_AUTO_INSTALL ~= "0",
  treesitter_install_skip = {},
  verbose = vim.env.VERBOSE == "1",
  mason_package_aliases = {
    cssls = "css-lsp",
    pylsp = "python-lsp-server",
    sqlls = "sqlls",
    svelte = "svelte-language-server",
  },
}

function M.debug(msg)
  if M.verbose then
    vim.notify(msg, vim.log.levels.DEBUG, {})
  end
end

function M.warn(msg)
  vim.notify(msg, vim.log.levels.WARN, {})
end

function M.load_file_from_runtime_paths(rel_path)
  for _, runtime_directory in ipairs(vim.api.nvim_list_runtime_paths()) do
    local fullpath = runtime_directory .. "/" .. table.concat(rel_path, "/") .. ".lua"
    if vim.fn.filereadable(fullpath) == 1 then
      -- Avoid returning nil when file is found
      local ret = dofile(fullpath)
      if ret == nil then return 0 else return ret end
    end
  end

  return nil
end

function M.lsp_enable(lsp_names)
  for _, lsp_name in ipairs(lsp_names) do
    local lsp_config = M.load_file_from_runtime_paths({"lsp", lsp_name})
    if not lsp_config then
      M.warn("Unable to find lsp config for " .. lsp_name .. ".")
    elseif M.lsp_auto_install == true then
      local cmd = lsp_config.cmd[1] or lsp_name
      local mason_package = M.mason_package_aliases[lsp_name] or cmd

      if string.match(vim.env.PATH, "/mason/") ~= "/mason/" then
        vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin:" .. vim.env.PATH
      end

      if vim.fn.executable(cmd) == 1 then
        M.debug(cmd .. " is already installed for " .. lsp_name .. ".")
      else
        require("batphone.mason").lazy("mason")() -- Need to require mason before installing the packages
        vim.cmd("MasonInstall " .. mason_package)
      end
    end

    vim.lsp.enable({ lsp_name })
  end
end

function M.treesitter_install(parsers)
  for _, parser in ipairs(parsers) do
    if vim.list_contains(M.treesitter_install_skip, parser) then return end

    local ts_config = require("nvim-treesitter.config")
    if vim.list_contains(ts_config.get_installed(), parser) then
      return M.debug(parser .. " treesitter support is already installed.")
    end

    if vim.fn.executable("tree-sitter") ~= 1 then
      require("batphone.mason").lazy("mason")() -- Need to require mason before installing the packages
      vim.cmd("MasonInstall tree-sitter-cli")
    end

    vim.cmd("TSInstall " .. parser)
  end
end

function M.startup()
  local method = vim.fs.root(0, ".git") ~= nil and "smart" or "recent"
  local picker = require("batphone.snacks").lazy("snacks.picker")
  picker()[method]()
end

return M
