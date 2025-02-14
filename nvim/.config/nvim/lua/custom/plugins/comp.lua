return {
  {
    "saghen/blink.cmp",
    dependencies = {
      "L3MON4D3/LuaSnip",
      "kristijanhusak/vim-dadbod-completion",
    },

    version = "*",
    opts = {
      -- 'default' for mappings similar to built-in completion
      keymap = { preset = "default" },

      snippets = { preset = "luasnip" },

      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "mono",
      },

      signature = { enabled = true },
      sources = {
        default = {
          "lsp",
          "path",
          "snippets",
          --"buffer",
          --"copilot",
          "dadbod",
        },
        providers = {
          lsp = {
            name = "lsp",
            enabled = true,
            module = "blink.cmp.sources.lsp",
            score_offset = 1000,
          },
          dadbod = {
            name = "Dadbod",
            module = "vim_dadbod_completion.blink",
            score_offset = 950,
          },
        },
      },
    },
  },
}
