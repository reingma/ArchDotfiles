vim.g.have_nerd_font = true
vim.opt.formatoptions:remove "o"

-- default tab
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.wrap = true
vim.opt.linebreak = true

--clipboard to nvim
vim.opt.clipboard = "unnamedplus"

-- Relative line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- column for width
vim.opt.colorcolumn = '90'
vim.opt.signcolumn = 'yes'

vim.opt.breakindent = true

-- save undo history
vim.opt.undofile = true

-- ignore case unless there is capital leters or \C
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- how some characters will be displayed in nvim
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Display live substitutions.
vim.opt.inccommand = 'split'

-- Minimal number of lines to keep above and below cursor
vim.opt.scrolloff = 10

vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Show which line cursor is on
vim.opt.cursorline = true

-- Decrese mapped sequence wait time and displays which key sooner
vim.opt.timeoutlen = 300

-- Highlight when yanking
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying text)",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
