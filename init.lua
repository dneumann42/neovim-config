vim.g.mapleader = ","
vim.g.mouse = "v"
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("core")
require("modules")
require("plugins")
require("lsp")

-- load session
-- local MiniSessions = require("mini.sessions")
-- local session = MiniSessions.get_latest()
-- if session then
-- end
