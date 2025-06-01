vim.g.mapleader = ','
vim.g.mouse = "v"
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("config.lazy")
require("config.core")
require("config.statusline")
require("config.nim")
require("commands")
require("projects")
require("maindo")
require("nim")
