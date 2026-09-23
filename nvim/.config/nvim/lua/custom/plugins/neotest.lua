return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "rouge8/neotest-rust",
    },
    ft = { "rust" },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-rust")({
            -- uses `cargo nextest` if installed, falls back to `cargo test`
            args = { "--no-capture" },
          }),
        },
      })

      local nt = require("neotest")
      local map = function(keys, func, desc)
        vim.keymap.set("n", keys, func, { desc = "Test: " .. desc })
      end

      map("<leader>tn", function() nt.run.run() end,                        "[T]est [N]earest")
      map("<leader>tf", function() nt.run.run(vim.fn.expand("%")) end,      "[T]est [F]ile")
      map("<leader>ts", function() nt.run.run(vim.fn.getcwd()) end,         "[T]est [S]uite")
      map("<leader>tl", function() nt.run.run_last() end,                   "[T]est run [L]ast")
      map("<leader>tS", function() nt.summary.toggle() end,                 "[T]est [S]ummary")
      map("<leader>to", function() nt.output_panel.toggle() end,            "[T]est [O]utput")
      map("<leader>tx", function() nt.run.stop() end,                       "[T]est stop [X]")
    end,
  },
}
