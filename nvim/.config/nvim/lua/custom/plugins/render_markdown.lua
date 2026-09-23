return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    ft = { "markdown" },
    opts = {
      render_modes = { "n", "c" },
      heading = {
        sign = false,
        icons = { "󰉫 ", "󰉬 ", "󰉭 ", "󰉮 ", "󰉯 ", "󰉰 " },
      },
      code = {
        sign = false,
        width = "block",
        right_pad = 1,
      },
      bullet = {
        icons = { "●", "○", "◆", "◇" },
      },
    },
  },
}
