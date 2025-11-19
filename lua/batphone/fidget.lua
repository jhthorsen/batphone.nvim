local M = {
  opts = {
    progress = {
      poll_rate = 1,
      ignore_done_already = true,
      display = {
        done_ttl = 2,
        render_limit = 3,
      },
    }
  },
}

function M.setup()
  require("fidget").setup(M.opts)
end

return M
