-- Moving lines up and down in visual mode keeping indentation
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move and ident down' })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move and ident up' })
-- Allow moving without losing the center
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Scroll down' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Scroll up' })
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

-- Quickfix keymaps
vim.keymap.set("n", "<leader>qj", "<cmd>cnext<CR>", { desc = "[Q]uickfix [J](down)" })
vim.keymap.set("n", "<leader>qk", "<cmd>cprev<CR>", { desc = "[Q]uickfix [K](up)" })
vim.keymap.set("n", "<leader>qo", "<cmd>copen<CR>", { desc = "[Q]uickfix [O]pen" })
vim.keymap.set("n", "<leader>qc", "<cmd>cclose<CR>", { desc = "[Q]uickfix [C]lose" })

-- Toggle inlay hints
vim.keymap.set("n", "<space>tt", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = 0 }, { bufnr = 0 })
end, { desc = "[T]oggle [T]ray hints" })
