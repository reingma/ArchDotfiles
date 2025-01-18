return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'vim-telescope/telescope-fzf-native.nvim',
        build = 'make',
      }
    },
    config = function()
      require("telescope").setup {
        extensions = { fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        } }
      }
      require("telescope").load_extension('fzf')
      vim.keymap.set("n", "<leader>sh", require('telescope.builtin').help_tags)
      vim.keymap.set("n", "<leader>sf", require('telescope.builtin').find_files)

      -- Vim editing bindings
      vim.keymap.set("n", "<leader>en", function()
        local opts = require('telescope.themes').get_ivy({
          cwd = vim.fn.stdpath("config")
        })
        require("telescope.builtin").find_files(opts)
      end)
      vim.keymap.set("n", "<leader>ep", function()
        local opts = require('telescope.themes').get_ivy({
          cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy")
        })
        require("telescope.builtin").find_files(opts)
      end)

      require "custom.plugins.telescope.multigrep".setup()
    end
  }
}
