local M = {
  lsp_auto_install = vim.env.NVIM_LSP_AUTO_INSTALL ~= "0",
  treesitter_install_skip = {},
  verbose = vim.env.VERBOSE == "1",
  mason_package_aliases = {
    cssls = "css-lsp",
    dockerls = "dockerfile-language-server",
    html = "html-lsp",
    jsonls = "json-lsp",
    postgres_lsp = "postgres-language-server",
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

function M.ensure_binary(executable, command, setup)
  if vim.fn.executable(executable) == 1 then
    setup()
  else
    vim.notify("Installing " .. executable .. "...", vim.log.levels.INFO, {})
    vim.fn.jobstart(command, {
      on_exit = function(_, code)
        if code == 0 then
          vim.notify(executable .. " installed successfully.", vim.log.levels.INFO, {})
          setup()
        else
          vim.notify("Failed to install " .. executable .. ". Run: " .. command, vim.log.levels.WARN, {})
        end
      end,
    })
  end
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
    local lsp_config = M.load_file_from_runtime_paths({ "lsp", lsp_name })
    if not lsp_config then
      vim.notify("Unable to find lsp config for " .. lsp_name, vim.log.levels.WARN, {})
    elseif M.lsp_auto_install == true then
      local cmd = lsp_config.cmd[1] or lsp_name
      local mason_package = M.mason_package_aliases[lsp_name] or cmd

      if string.match(vim.env.PATH, "/mason/") ~= "/mason/" then
        vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin:" .. vim.env.PATH
      end

      if vim.fn.executable(cmd) == 1 then
        M.debug(cmd .. " is already installed for " .. lsp_name .. ".")
      else
        vim.cmd("MasonInstall " .. mason_package)
      end
    end

    vim.lsp.enable({ lsp_name })
  end
end

function M.root_pattern(...)
  local patterns = M.tbl_flatten { ... }
  return function(startpath)
    startpath = M.strip_archive_subpath(startpath)
    for _, pattern in ipairs(patterns) do
      local match = M.search_ancestors(startpath, function(path)
        for _, p in ipairs(vim.fn.glob(table.concat({ escape_wildcards(path), pattern }, '/'), true, true)) do
          if vim.uv.fs_stat(p) then
            return path
          end
        end
      end)

      if match ~= nil then
        return match
      end
    end
  end
end

function M.lazy_user_command(cmds, setup)
  for cmd, nargs in pairs(cmds) do
    vim.api.nvim_create_user_command(cmd, function(params)
      setup()
      if #params.args > 0 then
        return vim.cmd(cmd .. " " .. params.args)
      else
        return vim.cmd(cmd)
      end
    end, { nargs = nargs })
  end
end

function M.once(event_name, callback)
  vim.api.nvim_create_autocmd("User", { once = true, pattern = event_name, callback = callback })
end

function M.treesitter_install(parsers)
  for _, parser in ipairs(parsers) do
    if vim.list_contains(M.treesitter_install_skip, parser) then return end

    local ts_config = require("nvim-treesitter.config")
    if vim.list_contains(ts_config.get_installed(), parser) then
      return M.debug(parser .. " treesitter support is already installed.")
    end

    if vim.fn.executable("tree-sitter") ~= 1 then
      vim.cmd("MasonInstall tree-sitter-cli")
    end

    require('nvim-treesitter').install({ parser })
  end
end

function M.startup()
  local method = vim.fs.root(0, ".git") ~= nil and "smart" or "recent"
  require("snacks.picker")[method]()
end

return M
