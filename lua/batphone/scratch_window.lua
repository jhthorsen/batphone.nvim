local M = {
  defaults = {
    ft = "text",
    height = 30,
    width = 100,
    border = "rounded",
    title_pos = "center",
    minimal = false,
    noautocmd = false,
    bo = { buftype = "", buflisted = false, bufhidden = "hide", swapfile = false },
    wo = { winhighlight = "NormalFloat:Normal" },
    zindex = 20,
    keys = {
      q = "close",
    },
  },
}

function M.edit_register(item)
  local cannot_update = item.reg == '"' or item.reg == '.'
  local win = require("batphone.scratch_window").open({
    text = item.value,
    on_close = function(win)
      if not cannot_update then
        vim.fn.setreg(item.reg, vim.api.nvim_buf_get_lines(win.buf, 0, -1, false))
        vim.print("Updated register " .. item.reg)
      end
    end,
  })

  local title = cannot_update and "(read-only) " or "Edit register "
  win:set_title(title .. item.reg, "center")
end

function M.open(opts)
  return Snacks.win(vim.tbl_deep_extend("force", M.defaults, opts or {}))
end

return M
