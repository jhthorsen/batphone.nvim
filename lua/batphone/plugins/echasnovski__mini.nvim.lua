local function pad(l)
  return l + 2
end

local function section_buffers(opts)

  -- Create buffer tabs
  local tabs = {}
  local selected_idx = 0
  local total_width = 0
  local idx = 0
  for _, buf_id in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf_id].buflisted then
      idx = idx + 1
      if buf_id == vim.api.nvim_get_current_buf() then selected_idx = idx end
      tabs[idx] = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf_id), ":t")
      total_width = total_width + pad(#tabs[idx])
    end
  end

  if selected_idx == 0 then
    return { { hl = "MiniStatuslineInactive", strings = { "**empty**" } } }
  end

  -- Calculate visible buffer indexes
  local remove_ext = total_width > opts.trunc_width * 2
  local start_idx = selected_idx
  local end_idx = selected_idx
  total_width = pad(#tabs[selected_idx])
  while start_idx > 1 or end_idx < #tabs do
    if end_idx < #tabs then
      if remove_ext then
        tabs[end_idx + 1] = vim.fn.fnamemodify(tabs[end_idx + 1], ":t:r")
      end

      total_width = total_width + pad(#tabs[end_idx + 1])
      if total_width >= opts.trunc_width then break end
      end_idx = end_idx + 1
    end
    if start_idx > 1 then
      if remove_ext then
        tabs[start_idx - 1] = vim.fn.fnamemodify(tabs[start_idx - 1], ":t:r")
      end

      total_width = total_width + pad(#tabs[start_idx - 1])
      if total_width >= opts.trunc_width then break end
      start_idx = start_idx - 1
    end
  end

  -- Insert visible buffers into the section
  local groups = {}
  for i = start_idx, end_idx do
    local hl = i == selected_idx and "MiniStatuslineFilename" or "MiniStatuslineInactive"
    table.insert(groups, { hl = hl, strings = { tabs[i] } })
  end

  local last = #groups < #tabs and #tabs or ""
  table.insert(groups, "%<") -- Mark general truncate point
  table.insert(groups, { hl = "MiniStatuslineInactive", strings = { last } })

  return groups
end

return {
  "echasnovski/mini.nvim",
  version = "*",
  event = "VeryLazy",
  keys = require("batphone.keymaps").mini,
  config = function(_, _)
    -- require("mini.ai").setup() -- prevents "i" in multicursor mode from working
    require("mini.align").setup()
    require("mini.comment").setup()
    require("mini.move").setup()
    require("mini.surround").setup()

    local sl = require("mini.statusline");
    sl.setup({
      content = {
        active = function()
          local mode, mode_hl = sl.section_mode({ trunc_width = 140 })
          local location = sl.section_location({ trunc_width = 140 })
          local buffers_trunc_width = pad(vim.o.columns) - pad(#mode) - pad(#location)
          local groups = section_buffers({ trunc_width = buffers_trunc_width })

          table.insert(groups, "%=") -- End left alignment
          table.insert(groups, { hl = mode_hl, strings = { mode } })
          table.insert(groups, { hl = "MiniStatuslineDevinfo", strings = { location } })

          return sl.combine_groups(groups)
        end,
        inactive = nil
      },
    })
  end,
}
