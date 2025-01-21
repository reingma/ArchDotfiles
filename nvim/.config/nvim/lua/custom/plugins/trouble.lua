return {
  {
    "folke/trouble.nvim",
    opts = {},
    cmd = "Trouble",
    keys = {
      {
        "<leader>xl",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "E[x]ecption [L]ist",
      },
      {
        "<leader>xL",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "E[x]ecption [L]ist for current buffer",
      },
    },
  },
}
