--[[
Dustin's Neovim Config
]]

vim.cmd [[ 
autocmd BufNewFile,BufReadPost *.nim,*.nims,*.nimble setfiletype nim 
]]

vim.settings = require("settings")
local plugins = require("plugins")
plugins.bootstrap()
require("lazy").setup(plugins.plugins)
require("configs")
