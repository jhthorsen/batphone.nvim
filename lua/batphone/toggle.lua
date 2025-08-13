local M = {
  color = { enabled = "green", disabled = "yellow" },
  icon = { enabled = " ", disabled = " " },
  option_map = {
    [true] = false,
    [false] = true,
    ["1"] = "0",
    ["0"] = "1",
    ["yes"] = "no",
    ["no"] = "yes",
    ["true"] = "false",
    ["false"] = "true",
  },
}

-- @param opts { desc = { }, key = string, mode? = string, current = function, set = function }
function M.toggle(opts)
  if opts.option then
    opts.current = function() return vim.opt[opts.option]:get() end
    opts.set = function(val) vim.opt[opts.option] = M.option_map[val] end
  end

  vim.keymap.set(
    opts.mode or "n",
    opts.key,
    function() opts.set(opts.current()) end,
    { desc = opts.desc.disabled }
  )

  local ok, wk = pcall(require, "which-key")
  if ok then
    wk.add({{
      opts.key,
      mode = opts.mode or "n",
      real = true,
      icon = function()
        local k = opts.current() and "enabled" or "disabled"
        return {
          icon = opts.icon and opts.icon[k] or M.icon[k],
          color = opts.color and opts.color[k] or M.color[k],
        }
      end,
      desc = function()
        local k = opts.current() and "enabled" or "disabled"
        return opts.desc[k]
      end,
    }})
  end
end

return M
