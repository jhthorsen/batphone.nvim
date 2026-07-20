return {
  options = function()
    return {
      keys = {
        { ">", function() require("quicker").expand({ before = 1, after = 1, add_to_existing = true }) end, desc = "Expand quickfix context" },
        { "<", function() require("quicker").collapse() end, desc = "Collapse quickfix context" },
        { "q", function() require("quicker").toggle() end, desc = "Close quickfix list" },
      },
    }
  end
}
