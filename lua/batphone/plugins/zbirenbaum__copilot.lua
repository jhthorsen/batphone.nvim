return {
  "zbirenbaum/copilot.lua",
  version = "*",
  lazy = true,
  build = ":Copilot auth",
  cmd = "Copilot",
  keys = require("batphone.keymaps").copilot,
  config = function(_, opts)
    if vim.env.ENABLE_COPILOT == "force" or vim.env.ENABLE_COPILOT == "yes" then
      require("copilot").setup(opts)
    end
  end,
  opts = {
    server_opts_overrides = {},
    suggestion = { debounce = 350 },
    should_attach = function(_, bufname)
      local logger = require("copilot.logger")
      if not vim.bo.buflisted then
        logger.debug("not attaching, buffer is not 'buflisted'")
        return false
      end
      if vim.bo.buftype ~= "" then
        logger.debug("not attaching, buffer 'buftype' is " .. vim.bo.buftype)
        return false
      end
      if vim.env.ENABLE_COPILOT == "force" then
        return true
      end
      if string.match(bufname, "_alien") then
        logger.debug("not attaching, buffer is /_alien/")
        return false
      end
      if string.match(bufname, "env") then
        logger.debug("not attaching, buffer is /env/")
        return false
      end

      return true
    end
  },
}
