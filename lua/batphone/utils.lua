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

function M.edit_file()
  local api = vim.api;
  local dir = require("batphone.utils").dirname(vim.fn.bufname())
  print(vim.api.nvim_buf_get_name(0));
  api.nvim_feedkeys(":edit " .. dir:gsub("[[]", "\\[") .. "/", "n", false)
  api.nvim_input("<TAB>")
end

function M.format_code()
  require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
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

function M.telescope_find_package_files()
  require("telescope.builtin").find_files({
    prompt_title = "Find package files",
    cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy")
  })
end

function M.telescope_find_parent_files(opts)
  opts = opts or {}

  local parent_dir = vim.fn.fnamemodify(vim.uv.cwd(), ":h")
  local dynamic_finder = {
    entry_maker = require("telescope.make_entry").gen_from_file({ cwd = parent_dir }),
    fn = function()
     local results = find_parent_files_cache[parent_dir]
     if not results then
       results = vim.fn.systemlist("rg --files " .. parent_dir)
       find_parent_files_cache[parent_dir] = results
     end

     return results
    end,
  }

  require("telescope.pickers").new(opts, {
    prompt_title = "Find files in parent directories",
    debounce = 200,
    finder = require("telescope.finders").new_dynamic(dynamic_finder),
    previewer = nil,
    sorter = require("telescope.config").values.file_sorter(opts),
  }):find()
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
