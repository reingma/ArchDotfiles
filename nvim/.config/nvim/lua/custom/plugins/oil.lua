return {
  {
    'stevearc/oil.nvim',
    dependencies = { { 'echasnovski/mini.icons', opts = {} } },
    config = function()
      CustomOilBar = function()
        local path = vim.fn.expand "%"
        path = path:gsub("oil://", "")

        return "  " .. vim.fn.fnamemodify(path, ":.")
      end

      require("oil").setup {
        columns = { "icon" },
        win_options = {
          winbar = "%{v:lua.CustomOilBar()}",
        },
      }
      vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open Parent Directory" })
      vim.keymap.set("n", "<leader>-", require('oil').toggle_float, { desc = "Open Parent Directory in floating wind" })
    end
  }
}
