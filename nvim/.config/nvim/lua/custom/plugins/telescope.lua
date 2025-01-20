return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
      },
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
      'nvim-telescope/telescope-smart-history.nvim',
      "kkharji/sqlite.lua",
      'nvim-telescope/telescope-ui-select.nvim'
    },
    config = function()
      require("telescope").setup {
        extensions = {
          wrap_results  = true,
          fzf           = {},
          history       = {
            path = vim.fs.joinpath(vim.fn.stdpath("data"), "telescope_history.sqlite3"),
            limit = 100

          },
          ["ui-select"] = {
            require("telescope.themes").get_dropdown {}
          }
        }
      }
      pcall(require("telescope").load_extension, 'fzf')
      pcall(require("telescope").load_extension, 'smart_history')
      pcall(require("telescope").load_extension, 'ui-select')
      vim.keymap.set("n", "<leader>sh", require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set("n", "<leader>sf", require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set("n", "<leader>sb", require('telescope.builtin').buffers, { desc = "[S]earch [B]uffers" })
      --vim.keymap.set("n", "<leader>gw", require('telescope.builtin').grep_string, { desc = "[G]rep [W]ord" })
      vim.keymap.set("n", "<space>st", function()
        return require("telescope.builtin").git_files { cwd = vim.fn.expand "%:h" }
      end, { desc = "[S]earch gi[T} files" })
      vim.keymap.set("n", "<leader>/", require('telescope.builtin').current_buffer_fuzzy_find,
        { desc = "fuzzy find on current buffer" })

      -- Vim editing bindings
      vim.keymap.set("n", "<leader>en", function()
        local opts = require('telescope.themes').get_ivy({
          cwd = vim.fn.stdpath("config")
        })
        require("telescope.builtin").find_files(opts)
      end, { desc = '[E]ditor [N]avigation' })
      vim.keymap.set("n", "<leader>ep", function()
        local opts = require('telescope.themes').get_ivy({
          cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy")
        })
        require("telescope.builtin").find_files(opts)
      end, { desc = '[E]ditor [P]ackages' })

      require "custom.plugins.telescope.multigrep".setup()
      -- vim.keymap.set("n", "<leader>sg", live_multigrep, { desc = '[S]earch by [G]rep' })
    end
  }
}
