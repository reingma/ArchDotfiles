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

      -- formatting is independent of LSP attach, so set it up once here
      require("custom.autoformat").setup()

      local capabilities = require("blink.cmp").get_lsp_capabilities()
      local servers = {
        bashls = true,
        lua_ls = {},
        -- rust_analyzer is managed by rustaceanvim (uses rustup-managed binary)
        templ = true,
        pyright = true,
        gopls = {
          settings = {
            gopls = {
              gofumpt = true,
              staticcheck = true,
              semanticTokens = true,
              usePlaceholders = false,
              completeUnimported = true,
              directoryFilters = { "-.git", "-node_modules" },
              analyses = {
                nilness = true,
                shadow = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
              },
              codelenses = {
                generate = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
            },
          },
        },
        -- Terraform: terraform-ls for completion/docs, tflint for provider-aware lint rules
        terraformls = true,
        tflint = true,
        dockerls = true,
        docker_compose_language_service = true,
        zls = true,
        -- Odin: ols (Mason package also ships odinfmt). Needs the odin compiler for core/base libs.
        ols = {
          init_options = {
            enable_semantic_tokens = true,
            enable_document_symbol = true,
            enable_hover = true,
            enable_snippets = true,
            enable_inlay_hints_params = true,
            enable_inlay_hints_default_params = true,
            enable_references = true,
            enable_format = false, -- conform runs odinfmt
            checker_args = "-vet -strict-style",
          },
        },
        hls = true,
        marksman = true,
        neocmake = true,
        -- TypeScript/JavaScript/React: vtsls wraps the VSCode TS extension (faster than
        -- ts_ls, better refactors, auto-imports). Formatting is left to prettier via conform.
        vtsls = {
          server_capabilities = {
            documentFormattingProvider = false,
            documentRangeFormattingProvider = false,
          },
          settings = {
            complete_function_calls = false,
            vtsls = {
              autoUseWorkspaceTsdk = true,
              enableMoveToFileCodeAction = true,
              experimental = {
                completion = { enableServerSideFuzzyMatch = true },
              },
            },
            typescript = {
              updateImportsOnFileMove = { enabled = "always" },
              suggest = { completeFunctionCalls = false },
              preferences = { importModuleSpecifier = "non-relative" },
              inlayHints = {
                enumMemberValues = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                parameterNames = { enabled = "literals" },
                parameterTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                variableTypes = { enabled = false },
              },
            },
            javascript = {
              updateImportsOnFileMove = { enabled = "always" },
            },
          },
        },
        -- ESLint as an LSP: diagnostics + code actions ("fix all" on <leader>ca)
        eslint = {
          settings = {
            workingDirectories = { mode = "auto" },
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
          filetypes = { "c", "cpp", "objc", "objcpp" },
        },
        tailwindcss = {
          -- default list includes markdown/mdx, which spawns it in every notes buffer
          filetypes = vim.tbl_filter(function(ft)
            return ft ~= "markdown" and ft ~= "mdx"
          end, vim.lsp.config.tailwindcss.filetypes or {}),
          settings = {
            tailwindCSS = {
              classAttributes = { "class", "className", "class:list", "classList", "ngClass" },
              experimental = {
                -- class completion inside cn(...), clsx(...), cva(...), tw`...`
                classRegex = {
                  { "cva\\(((?:[^()]|\\([^()]*\\))*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
                  { "cx\\(((?:[^()]|\\([^()]*\\))*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
                  { "cn\\(((?:[^()]|\\([^()]*\\))*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
                  { "clsx\\(((?:[^()]|\\([^()]*\\))*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
                  "tw`([^`]*)",
                },
              },
            },
          },
        },
        cssls = true,
        html = true,
        -- LaTeX: completion for \ref/\cite, labels, chktex diagnostics.
        -- Building and viewing stay with vimtex.
        texlab = {
          settings = {
            texlab = {
              chktex = { onOpenAndSave = true },
            },
          },
        },
        -- Grammar checker for prose (cover letters, blog posts, commit messages)
        harper_ls = {
          filetypes = { "tex", "markdown", "gitcommit" },
          settings = {
            ["harper-ls"] = {
              dialect = "American",
              -- vim's own spell checker already covers spelling (zg to add words)
              linters = { SpellCheck = false },
            },
          },
        },
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
        "prettier",
        "prettierd",
        "markdownlint-cli2",
        "shfmt",
        "shellcheck",
        "tex-fmt",
        -- go
        "goimports",
        "gofumpt",
        "golangci-lint",
        "gotestsum",
        -- docker
        "hadolint",
      }
      vim.list_extend(ensure_installed, servers_to_install)
      require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
      for name, config in pairs(servers) do
        if config == true then
          config = {}
        end
        config = vim.tbl_deep_extend("force", {}, {
          capabilities = capabilities,
        }, config)

        vim.lsp.config(name, config)
      end
      vim.lsp.enable(vim.tbl_keys(servers))

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local bufnr = args.buf
          local client = assert(vim.lsp.get_client_by_id(args.data.client_id), "must have valid client")
          local settings = servers[client.name]
          if type(settings) ~= "table" then
            settings = {}
          end
          -- vim.lsp.config has no server_capabilities field, so apply overrides here
          if settings.server_capabilities then
            for k, v in pairs(settings.server_capabilities) do
              if v == vim.NIL then
                v = nil
              end
              client.server_capabilities[k] = v
            end
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
          map("<leader>th", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
          end, "[T]oggle inlay [H]ints")
          if client:supports_method("textDocument/codeLens") then
            map("<leader>cl", vim.lsp.codelens.run, "[C]ode [L]ens run")
            vim.lsp.codelens.enable(true, { bufnr = bufnr })
          end

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
