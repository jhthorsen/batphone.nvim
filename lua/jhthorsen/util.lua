local M = {
  lsp_auto_install = vim.env.NVIM_LSP_AUTO_INSTALL ~= "0",
  treesitter_install_skip = {},
  verbose = vim.env.VERBOSE == "1",
}

function M.debug(msg)
  if M.verbose then
    vim.api.nvim_echo({{msg}}, true, {err = false})
  end
end

function M.err(msg)
  vim.api.nvim_echo({{msg}}, true, {err = true})
end

function M.lsp_enable(lsp_name, o)
  local opts = o or {}
  local ok, lsp_config = pcall(require, "lsp." .. lsp_name)
  if not ok then
    return M.err("Unable to find lsp config for " .. lsp_name .. ".")
  end

  if M.lsp_auto_install == true then
    local cmd = lsp_config.cmd[1] or lsp_name
    local mason_package = opts.package or cmd

    if string.match(vim.env.PATH, "/mason/") ~= "/mason/" then
      vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin:" .. vim.env.PATH
    end

    if vim.fn.executable(cmd) == 1 then
      M.debug(cmd .. " is already installed for " .. lsp_name .. ".")
    else
      require("jhthorsen.mason").lazy("mason")() -- Need to require mason before installing the packages
      vim.cmd("MasonInstall " .. mason_package)
    end
  end

  vim.lsp.enable({ lsp_name })
end

function M.treesitter_install(parser)
  if vim.list_contains(M.treesitter_install_skip, parser) then return end

  local ts_config = require("nvim-treesitter.config")
  if vim.list_contains(ts_config.get_installed(), parser) then
    return M.debug(parser .. " treesitter support is already installed.")
  end

  if vim.fn.executable("tree-sitter") ~= 1 then
    require("jhthorsen.mason").lazy("mason")() -- Need to require mason before installing the packages
    vim.cmd("MasonInstall tree-sitter-cli")
  end

  vim.cmd("TSInstall " .. parser)
end

function M.startup()
  local method = vim.fs.root(0, ".git") ~= nil and "smart" or "recent"
  local picker = require("jhthorsen.snacks").lazy("snacks.picker")
  picker()[method]()
end

return M
