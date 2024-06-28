-- Dustin Neumann's neovim config, version approx. 9997

vim.g.mapleader = ','
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("lib.core")
require("config.general")
require("bootstrap")
require("theme")
