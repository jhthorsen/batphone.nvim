return {
  "copilotc-nvim/copilotchat.nvim",
  version = "*",
  lazy = true,
  build = "make tiktoken",
  cmd = "CopilotChat",
  dependencies = {
    { "zbirenbaum/copilot.lua" },
    { "nvim-lua/plenary.nvim" },
  },
  keys = require("batphone.keymaps").copilotchat,
  opts = {
    auto_follow_cursor = false,
    auto_insert_mode = true,
    answer_header = "# Copilot ",
    question_header = "# Me ",
    callback = function() require("CopilotChat").save("all") end,
    mappings = {
      close = { },
    },
    window = {
      layout = "horizontal",
      border = "single",
      height = 0.8,
      width = 1,
    },
  },
}
