return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      -- Mason must be loaded before its dependents so we need to set it up here.
      -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
      { "williamboman/mason.nvim", opts = {} },
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",

      -- Useful status updates for LSP.
      { "j-hui/fidget.nvim", opts = {} },
      -- Completition
      "saghen/blink.cmp",
      -- Formating
      "stevearc/conform.nvim",
      -- Schema information
      "b0o/SchemaStore.nvim",
      -- Multi line errors
      --{ "https://git.sr.ht/~whynothugo/lsp_lines.nvim" },
      {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
          library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
    },
    config = function()
      if vim.g.obsidian then
        return
      end

      local capabilities = require("blink.cmp").get_lsp_capabilities()
      local lspconfig = require("lspconfig")
      local servers = {
        bashls = true,
        lua_ls = {},
        rust_analyzer = true,
        templ = true,
        pyright = true,
        gopls = true,
        zls = true,
        ts_ls = {
          root_dir = require("lspconfig").util.root_pattern("package.json"),
          single_file = false,
          server_capabilities = {
            documentFormattingProvider = false,
          },
        },
        jsonls = {
          server_capabilities = {
            documentFormattingProvider = false,
          },
          settings = {
            json = {
              schemas = require("schemastore").json.schemas(),
              validate = { enable = true },
            },
          },
        },
        yamlls = {
          settings = {
            yaml = {
              schemaStore = {
                enable = false,
                url = "",
              },
              schemas = require("schemastore").yaml.schemas(),
            },
          },
        },
        clangd = {
          init_options = { clangdFileStatus = true },
          filetypes = { "c" },
        },
        tailwindcss = true,
      }
      local servers_to_install = vim.tbl_filter(function(key)
        local t = servers[key]
        if type(t) == "table" then
          return not t.manual_install
        else
          return t
        end
      end, vim.tbl_keys(servers))
      require("mason").setup()
      local ensure_installed = {
        "stylua",
        "lua_ls",
      }
      vim.list_extend(ensure_installed, servers_to_install)
      require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
      lspconfig.lua_ls.setup({ capabilities = capabilities })
      for name, config in pairs(servers) do
        if config == true then
          config = {}
        end
        config = vim.tbl_deep_extend("force", {}, {
          capabilities = capabilities,
        }, config)

        lspconfig[name].setup(config)
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local bufnr = args.buf
          local client = assert(vim.lsp.get_client_by_id(args.data.client_id), "must have valid client")
          local settings = servers[client.name]
          if type(settings) ~= "table" then
            settings = {}
          end

          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = args.buf, desc = "LSP: " .. desc })
          end
          map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
          map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
          map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclarations")
          map("gT", vim.lsp.buf.type_definition, "[G]oto [T]ype definition")
          map("K", vim.lsp.buf.hover, "Hover Info")

          map("<leader>cr", vim.lsp.buf.rename, "[C]ode [R]ename")
          map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
          map("<leader>wd", require("telescope.builtin").lsp_document_symbols, "[W]orking [D]ocument symbols")

          require("custom.autoformat").setup()

          -- require("lsp_lines").setup()
          -- vim.diagnostic.config { virtual_text = true, virtual_lines = false }
          --
          -- vim.keymap.set("n", "<leader>tll", function()
          --   local config = vim.diagnostic.config() or {}
          --   if config.virtual_text then
          --     vim.diagnostic.config { virtual_text = false, virtual_lines = true }
          --   else
          --     vim.diagnostic.config { virtual_text = true, virtual_lines = false }
          --   end
          -- end, { desc = "Toggle lsp_lines" })
        end,
      })
    end,
  },
}
