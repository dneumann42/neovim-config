vim.my = {}

require("tools")
local modules = require("modules")

require("settings")
vim.g.mapleader = vim.my.settings.mapleader.value

require("plugins")
require("start")
require("nim")

modules.reload_all()
