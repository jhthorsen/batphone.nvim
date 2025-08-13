local M = {
  coilot = {
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
  },
  copilotchat = {
    model = "o3-mini",
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

function M.autocmd()
  vim.api.nvim_create_autocmd("BufEnter", {
    group = vim.api.nvim_create_augroup("batphone__copilotchat_buf_enter_once", { clear = true }),
    pattern = "copilot-chat",
    callback = function()
      vim.api.nvim_del_augroup_by_name("batphone__copilotchat_buf_enter_once") -- Only need to run this once
      M.rewrite_copilot_chat_history("default")
      require("CopilotChat").load("default")
    end
  })

  vim.api.nvim_create_autocmd("BufEnter", {
    group = vim.api.nvim_create_augroup("batphone__copilotchat_buf_enter", { clear = true }),
    pattern = "copilot-chat",
    callback = function()
      vim.opt_local.colorcolumn = {}
      vim.opt_local.conceallevel = 0
      vim.opt_local.ignorecase = true
      vim.opt_local.number = false
      vim.opt_local.relativenumber = false
      vim.opt_local.signcolumn = "no"
      vim.opt_local.wrap = true
    end
  })

  vim.api.nvim_create_autocmd("BufLeave", {
    group = vim.api.nvim_create_augroup("batphone__copilotchat_buf_leave", { clear = true }),
    pattern = "copilot-*",
    callback = function() require("CopilotChat").save("default") end
  })
end

function M.lazy(mod)
  return function()
    if not M.loaded then
      require("plenary")
      require("copilot").setup(M.copilot)
      require("copilot.auth").signin()
      require("CopilotChat").setup(M.copilotchat)
      M.autocmd()
      M.loaded = true
    end

    return require(mod or "snacks")
  end
end

function M.rewrite_copilot_chat_history(name)
  local cc = require("CopilotChat")
  local history_file = vim.fs.normalize(cc.config.history_path or "") .. "/" .. name .. ".json"
  local history_fh = io.open(history_file, "r")
  if not history_fh then return end

  local history = vim.json.decode(history_fh:read("*a"), { luanil = { array = true, object = true } })
  if #history <= 1 then return end

  history_fh:close()
  for i = #history, 1, -1 do
    if history[i].content == nil or history[i].content == "" then
      table.remove(history, i)
    end
  end

  history_fh = io.open(history_file, "w")
  if not history_fh then return end
  history_fh:write(vim.json.encode(history))
  history_fh:close()
end

return M
