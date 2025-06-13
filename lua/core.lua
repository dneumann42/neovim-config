local settings = require("config.settings")

local function set_tab_size(tab_size)
	vim.opt.showmatch = true
	vim.opt.shiftwidth = tab_size
	vim.opt.tabstop = tab_size
	vim.opt.softtabstop = tab_size
	vim.opt.expandtab = true
end

set_tab_size(settings.tab_size)

vim.api.nvim_create_user_command("SetTabSize", function(value)
	set_tab_size(tonumber(value.args))
end, { nargs = 1 })
