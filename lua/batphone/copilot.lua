return {
  opts = function(override)
    return vim.tbl_deep_extend("force", {
      auto_trigger = false,
      suggestion = { debounce = 350 },
      should_attach = function(_, bufname)
        if not vim.bo.buflisted then return false end
        if vim.bo.buftype ~= "" then return false end
        if vim.env.ATTACH_COPILOT == "yes" then return true end
        if string.match(bufname, ".env") then return false end
        if string.match(bufname, "_alien") then return false end
        return true
      end
    }, override)
  end
}
