-- Dustin Neumann's neovim config

vim.g.mapleader = ','
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("config.general")
require("config.terminal")
require("bootstrap")
require("config.restart")

require("interactive.interactive")

require("commands")
require("dashboard")
