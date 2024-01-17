--[[
Dustin's Neovim Config
]]

local plugins = require("plugins")
plugins.bootstrap()
require("lazy").setup(plugins.plugins)
require("configs")
