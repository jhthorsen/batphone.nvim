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
    model = vim.env.BATPHONE_COPILOT_MODEL or "o3-mini",
    auto_follow_cursor = true,
    auto_insert_mode = false,
    answer_header = "# Copilot ",
    question_header = "# Me ",
    window = {
      layout = "horizontal",
      border = "single",
      height = 0.8,
      width = 1,
    },
  },
}
