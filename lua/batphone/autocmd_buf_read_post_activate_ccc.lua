vim.api.nvim_create_autocmd("BufReadPost", {
  group = vim.api.nvim_create_augroup("batphone__autocmd_buf_read_post_activate_ccc", { clear = true }),
  callback = function(event)
    vim.api.nvim_del_augroup_by_name("batphone__autocmd_buf_read_post_activate_ccc") -- Only want to do this once

    -- local test = "oklch(74% 0.16 236 / 100%)"
    local ccc = require("ccc")
    ccc.setup({
      alpha_show = "show",
      highlighter = { auto_enable = true },
      inputs = { ccc.input.oklch, ccc.input.rgb, ccc.input.hsl },
      outputs = { ccc.output.css_oklch, ccc.output.css_hsl, ccc.output.hex },
      convert = {
        { ccc.picker.hex, ccc.output.css_hsl },
        { ccc.picker.css_hsl, ccc.output.css_oklch },
        { ccc.picker.css_oklch, ccc.output.hex },
      },
    })
  end,
})
