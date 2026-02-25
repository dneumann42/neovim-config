vim.my = {}

require("tools")
local modules = require("modules")

require("settings")
require("plugins")
require("start")

modules.reload_all()
