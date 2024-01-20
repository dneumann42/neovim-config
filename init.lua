--[[
Dustin's Neovim Config
]]

vim.cmd [[ 
autocmd BufNewFile,BufReadPost *.nim,*.nims,*.nimble setfiletype nim 
]]

local plugins = require("plugins")
plugins.bootstrap()
require("lazy").setup(plugins.plugins)

vim.settings = require("settings")
require("configs")
