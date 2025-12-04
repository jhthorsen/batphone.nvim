vim.api.nvim_create_autocmd("BufReadPost", {
  once = true,
  callback = function(event)
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
