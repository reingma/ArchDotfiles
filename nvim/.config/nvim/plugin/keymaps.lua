-- Moving lines up and down in visual mode keeping indentation
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move and ident down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move and ident up" })
-- Allow moving without losing the center
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up" })
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "<c-j>", "<c-w><c-j>")
vim.keymap.set("n", "<c-k>", "<c-w><c-k>")
vim.keymap.set("n", "<c-l>", "<c-w><c-l>")
vim.keymap.set("n", "<c-h>", "<c-w><c-h>")
-- Quickfix keymaps
vim.keymap.set("n", "<leader>qj", "<cmd>cnext<CR>", { desc = "[Q]uickfix [J](down)" })
vim.keymap.set("n", "<leader>qk", "<cmd>cprev<CR>", { desc = "[Q]uickfix [K](up)" })

local function toggle_quickfix()
  local windows = vim.fn.getwininfo()
  for _, win in pairs(windows) do
    if win["quickfix"] == 1 then
      vim.cmd.cclose()
      return
    end
  end
  vim.cmd.copen()
end

vim.keymap.set("n", "<leader>qt", toggle_quickfix, { desc = "[Q]uickfix [T]oggle" })

-- Toggle inlay hints
vim.keymap.set("n", "<leader>tt", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
end, { desc = "[T]oggle [T]ray hints" })

--TODO: add control f for fast navigation to files (sessionizer)
