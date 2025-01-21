local setup = function()
  -- Autoformatting Setup
  local conform = require "conform"
  conform.setup {
    formatters_by_ft = {
      lua = { "stylua" },
    },
  }

  conform.formatters.injected = {
    options = {
      ignore_errors = false,
      lang_to_formatters = {
        sql = { "sleek" },
      },
    },
  }

  vim.keymap.set("n", "<leader>f", function() require("conform").format { async = true, lsp_fallback = true } end,
    { desc = "[F]ormat buffer" })
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("custom-conform", { clear = true }),
    callback = function(args)
      require("conform").format {
        bufnr = args.buf,
        lsp_fallback = true,
        quiet = true,
      }
    end,
  })
end

setup()

return { setup = setup }
