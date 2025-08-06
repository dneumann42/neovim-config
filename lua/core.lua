vim.cmd("silent! colorscheme retrobox")

local config_path = vim.fn.stdpath("config")
local lua_dir = config_path .. "/lua"
local filename = lua_dir .. "/mymodule.lua"

local Core = {
        config_path = vim.fn.stdpath("config"),
        lua_dir = config_path .. "/lua"
}

function Core.require(path)
        package.loaded[path] = nil
        return require(path)
end

function Core.update_settings(override)
        local settings = Core.require("settings")
        local new_settings = vim.tbl_deep_extend('force', settings, override)
        local script = "return " .. vim.inspect(new_settings)
        local file_name = Core.lua_dir .. "/settings.lua"
        local file = io.open(file_name, "w")
        if file then
                file:write(script)
                file:close()

                vim.notify("Updated settings")
        else
                error("Failed to write to settings file")
        end
        Core.set_options()
end

function Core.set_tab_size(tab_size)
	vim.opt.showmatch = true
	vim.opt.shiftwidth = tab_size
	vim.opt.tabstop = tab_size
	vim.opt.softtabstop = tab_size
	vim.opt.expandtab = true
end

function Core.set_options()
	local settings = Core.require("settings")

	Core.set_tab_size(settings.tab_size)

	vim.opt.breakindent = true
	vim.opt.clipboard = "unnamedplus"
	vim.opt.cmdheight = 0
	vim.opt.completeopt = { "menu", "menuone", "noselect" }
end

vim.api.nvim_create_user_command("SetTabSize", function(value)
        Core.update_settings({ 
                common = {
                        tab_size = tonumber(value.args) 
                }
        })
end, { nargs = 1 })

Core.set_options()

return Core
