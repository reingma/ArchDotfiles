return {
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory", "DiffviewToggleFiles", "DiffviewFocusFiles" },
    opts = {
      enhanced_diff_hl = true,
      use_icons = vim.g.have_nerd_font == true,
      view = {
        merge_tool = { layout = "diff3_mixed" },
      },
    },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "[G]it [D]iff working tree" },
      { "<leader>gm", "<cmd>DiffviewOpen origin/HEAD...HEAD --imply-local<cr>", desc = "[G]it diff against [M]ain (PR view)" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "[G]it file [H]istory" },
      { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "[G]it repo [H]istory" },
      { "<leader>gh", ":DiffviewFileHistory<cr>", mode = "v", desc = "[G]it [H]istory of selection" },
      { "<leader>gq", "<cmd>DiffviewClose<cr>", desc = "[G]it diff [Q]uit" },
    },
  },
}
