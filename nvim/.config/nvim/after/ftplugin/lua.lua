local set = vim.opt_local

set.shiftwidth = 2
set.number = true
set.relativenumber = true

-- file sourceing keymaps
vim.keymap.set("n", "<leader>xf", ":.lua<CR>", { desc = 'E[x]ecute lua [F]ile' })
vim.keymap.set("n", "<leader><leader>x", "<cmd>source %<CR>", { desc = 'E[x]ecute (Source buffer)' })
vim.keymap.set("v", "<leader>xs", ":lua<CR>", { desc = 'E[x]ecute lua [S]election' })
