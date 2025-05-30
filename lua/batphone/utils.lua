local copilotchat_first_time = true
local find_parent_files_cache = {}
local diagnostics_opts = {
  severity_sort = false,
  signs = true,
  underline = false,
  update_in_insert = true,
  virtual_text = false,
}

local M = {}

M.dirname = vim.fs and vim.fs.dirname or function(p) return vim.fn.fnamemodify(p, ":h") end

function M.copilotchat_toggle(layout)
  local cc = require("CopilotChat")

  if copilotchat_first_time then cc.load("all") end
  copilotchat_first_time = false

  if layout == "replace" then
    cc.toggle({window = {layout = layout}})
  else
    cc.toggle({window = {layout = layout, width = 1, height = 0.8}})
  end
end

function M.edit_file()
  local api = vim.api;
  local dir = require("batphone.utils").dirname(vim.fn.bufname())
  print(vim.api.nvim_buf_get_name(0));
  api.nvim_feedkeys(":edit " .. dir:gsub("[[]", "\\[") .. "/", "n", false)
  api.nvim_input("<tab>")
end

function M.focus_buffer(next_or_previous)
  vim.cmd("b" .. next_or_previous)
  vim.cmd("echo expand('%')")
end

function M.format_code()
  require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
end

function M.has_words_before()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  if col == 0 then
    return false
  end
  local line = vim.api.nvim_get_current_line()
  return line:sub(col, col):match("%w") ~= nil
end

function M.mapkey(mode, key, action, opts)
  local defaults = { silent = true }
  vim.keymap.set(mode, key, action, vim.tbl_extend("force", defaults, opts))
end

function M.save_and_quit()
  local api = vim.api
  local modified = api.nvim_get_option_value("modified", { buf = api.nvim_get_current_buf() })
  local n_buffers = #vim.fn.getbufinfo({ buflisted = 1 })

  api.nvim_command(modified and "w|bd" or "bd");

  if n_buffers <= 1 then
    api.nvim_command("quit")
  end
end

function M.set_diagnostics(opts)
  if opts == nil then
    return diagnostics_opts
  end

  diagnostics_opts = vim.tbl_extend("force", diagnostics_opts, opts)
  vim.diagnostic.config(diagnostics_opts)
  return diagnostics_opts
end

function M.split_string(s, delimiter)
    delimiter = delimiter or "%s"
    local t = {}
    local i = 1
    for str in string.gmatch(s, "([^" .. delimiter .. "]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

function M.toggle_multicursors()
  local mc = require("multicursor-nvim")
  if not mc.cursorsEnabled() then
    mc.enableCursors()
  elseif mc.hasCursors() then
    mc.clearCursors()
  end
end

return M
