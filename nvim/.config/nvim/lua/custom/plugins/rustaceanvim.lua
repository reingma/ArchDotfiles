return {
  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    ft = { "rust" },
    config = function()
      vim.g.rustaceanvim = {
        server = {
          cmd = { "rustup", "run", "stable", "rust-analyzer" },
          capabilities = require("blink.cmp").get_lsp_capabilities(),
          default_settings = {
            ["rust-analyzer"] = {
              cargo = { allFeatures = true },
              checkOnSave = { command = "clippy" },
              inlayHints = {
                bindingModeHints = { enable = true },
                closureReturnTypeHints = { enable = "always" },
                lifetimeElisionHints = { enable = "always", useParameterNames = true },
              },
            },
          },
        },
      }

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("rustaceanvim-attach", { clear = true }),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client or client.name ~= "rust_analyzer" then return end
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = args.buf, desc = "Rust: " .. desc })
          end
          map("<leader>re", "<cmd>RustLsp expandMacro<cr>", "[R]ust [E]xpand macro")
          map("<leader>rc", "<cmd>RustLsp openCargo<cr>", "[R]ust open [C]argo.toml")
          map("<leader>rr", "<cmd>RustLsp runnables<cr>", "[R]ust [R]unnables")
          map("<leader>rd", "<cmd>RustLsp debuggables<cr>", "[R]ust [D]ebuggables")
          map("<leader>rp", "<cmd>RustLsp rebuildProcMacros<cr>", "[R]ust rebuild [P]roc macros")
          map("K", "<cmd>RustLsp hover actions<cr>", "Hover actions")
        end,
      })
    end,
  },
}
