vim.g.mapleader = ','
vim.g.maplocalleader = ','
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true
vim.cmd [[ 
colorscheme melange 
set clipboard+=unnamedplus
set number
set autoread
]] 

require("nvim-surround").setup {}
require("nvim_comment").setup { }

require("notify").setup {
  background_colour = "#000000",
}
