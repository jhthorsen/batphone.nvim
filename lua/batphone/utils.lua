local M = {}

M.dirname = vim.fs and vim.fs.dirname or function(p) return vim.fn.fnamemodify(p, ":h") end

function M.edit_file()
  local api = vim.api;
  local dir = require("batphone.utils").dirname(vim.fn.bufname())
  print(vim.api.nvim_buf_get_name(0));
  api.nvim_feedkeys(":edit " .. dir:gsub("[[]", "\\[") .. "/", "n", false)
  api.nvim_input("<TAB>")
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

return M
