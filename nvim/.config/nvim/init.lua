require("config.lazy")
--leader key
vim.g.mapleader = " "

-- default tab
vim.opt.shiftwidth = 4
--clipboard to nvim
vim.opt.clipboard = "unnamedplus"

-- Using tree sitter to change particular highlights
-- capture group for builtins are set to yellow
-- vim.cmd [[hi @function.builtin.lua guifg=yellow]]

-- file sourceing keymaps
vim.keymap.set("n", "<leader><leader>x", "<cmd>source %<CR>")
vim.keymap.set("n", "<leader>x", ":.lua<CR>")
vim.keymap.set("v", "<leader>x", ":lua<CR>")

-- Highlight when yanking
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying text)",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
