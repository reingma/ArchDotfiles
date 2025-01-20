return {
  'folke/which-key.nvim',
  event = 'VimEnter',
  config = function()
    require('which-key').setup()

    require('which-key').add {
      { '<leader>s',        group = '[S]earch' },
      { '<leader>e',        group = '[E]ditor' },
      { '<leader>x',        group = 'E[x]ecute' },
      { '<leader><leader>', group = 'Cofiguration Commands' },
      { 'gr',               group = 'lsp[GR]oup' },
      { '<leader>q',        group = '[Q]uickfix' },
      --{ '<leader>w', proxy = '<c-w>',   group = 'windows' },
    }
  end,
}
