return {
  {
    "pwntester/octo.nvim",
    cmd = "Octo",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
    },
    opts = {
      picker = "telescope",
      enable_builtin = true,
      default_merge_method = "squash",
      default_delete_branch = true,
    },
    keys = {
      { "<leader>oo", "<cmd>Octo<cr>", desc = "[O]cto actions" },
      { "<leader>op", "<cmd>Octo pr list<cr>", desc = "[O]cto [P]R list" },
      { "<leader>oP", "<cmd>Octo pr search is:open review-requested:@me<cr>", desc = "[O]cto [P]Rs awaiting my review" },
      { "<leader>oc", "<cmd>Octo pr create<cr>", desc = "[O]cto [C]reate PR" },
      { "<leader>ob", "<cmd>Octo pr<cr>", desc = "[O]cto PR for current [B]ranch" },
      { "<leader>or", "<cmd>Octo review<cr>", desc = "[O]cto [R]eview start/resume" },
      { "<leader>oi", "<cmd>Octo issue list<cr>", desc = "[O]cto [I]ssue list" },
      { "<leader>os", "<cmd>Octo search<cr>", desc = "[O]cto [S]earch" },
    },
  },
}
