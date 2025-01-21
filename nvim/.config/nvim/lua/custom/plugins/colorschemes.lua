return {
  {
    "folke/tokyonight.nvim",
    config = function()
      vim.cmd.colorscheme("tokyonight")
    end,
  },
  {
    "eldritch-theme/eldritch.nvim",
    config = function()
      vim.cmd.colorscheme("eldritch")
    end,
  },
  { "catppuccin/nvim", name = "catppuccin" },
  { "rose-pine/neovim", name = "rose-pine" },
  {
    "andrew-george/telescope-themes",
    config = function()
      require("telescope").load_extension("themes")
    end,
  },
}
