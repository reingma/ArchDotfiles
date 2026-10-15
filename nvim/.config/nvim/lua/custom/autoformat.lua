local setup = function()
  -- Autoformatting Setup
  local conform = require("conform")
  conform.setup({
    formatters_by_ft = {
      cpp = { "clang-format" },
      c = { "clang-format" },
      rust = { "rustfmt" },
      lua = { "stylua" },
      markdown = { "markdownlint-cli2", "prettier" },
      json = { "prettier" },
      jsonc = { "prettier" },
      javascript = { "prettierd", "prettier", stop_after_first = true },
      javascriptreact = { "prettierd", "prettier", stop_after_first = true },
      typescript = { "prettierd", "prettier", stop_after_first = true },
      typescriptreact = { "prettierd", "prettier", stop_after_first = true },
      css = { "prettierd", "prettier", stop_after_first = true },
      scss = { "prettierd", "prettier", stop_after_first = true },
      html = { "prettierd", "prettier", stop_after_first = true },
      graphql = { "prettierd", "prettier", stop_after_first = true },
      yaml = { "prettier" },
      sh = { "shfmt" },
      bash = { "shfmt" },
      tex = { "tex-fmt" },
      go = { "goimports", "gofumpt" },
      odin = { "odinfmt" },
      terraform = { "terraform_fmt" },
      ["terraform-vars"] = { "terraform_fmt" },
    },
  })

  -- don't rewrap prose; only fix indentation
  conform.formatters["tex-fmt"] = {
    prepend_args = { "--nowrap" },
  }

  conform.formatters.injected = {
    options = {
      ignore_errors = false,
      lang_to_formatters = {
        sql = { "sleek" },
      },
    },
  }

  vim.keymap.set("n", "<leader>f", function()
    require("conform").format({ async = true, lsp_fallback = true })
  end, { desc = "[F]ormat buffer" })
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("custom-conform", { clear = true }),
    callback = function(args)
      require("conform").format({
        bufnr = args.buf,
        lsp_fallback = true,
        quiet = true,
      })
    end,
  })
end

return { setup = setup }
