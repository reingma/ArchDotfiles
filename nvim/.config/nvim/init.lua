vim.g.termguicolors = true
vim.opt.termguicolors = true
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.lazy")
--leader key

-- Using tree sitter to change particular highlights
-- capture group for builtins are set to yellow
-- vim.cmd [[hi @function.builtin.lua guifg=yellow]]
