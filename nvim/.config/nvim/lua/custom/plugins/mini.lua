return {
  {
    "echasnovski/mini.nvim",
    enabled = true,
    config = function()
      local statusline = require("mini.statusline")
      statusline.setup({ use_icons = true })
      require("mini.ai").setup()
      require("mini.surround").setup()
      require("mini.comment").setup()
    end,
  },
}
