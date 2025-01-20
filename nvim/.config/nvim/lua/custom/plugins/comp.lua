return {
  {
    'saghen/blink.cmp',
    dependencies = 'rafamadriz/friendly-snippets',

    version = '*',
    opts = {
      -- 'default' for mappings similar to built-in completion
      keymap = { preset = 'default' },

      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'mono'
      },

      signature = { enabled = true },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer', },
      },
    },
  }
}
