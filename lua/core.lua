local config_path = vim.fn.stdpath("config")

local Core = {
    config_path = vim.fn.stdpath("config"),
    cache_path = vim.fn.stdpath("cache"),
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

    vim.api.nvim_exec_autocmds("User", { pattern = "SettingsUpdated" })
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

    Core.set_tab_size(settings.common.tab_size)

    vim.cmd.colorscheme(settings.common.colorscheme)

    vim.g.mapleader = ","
    vim.g.maplocalleader = ","
    vim.g.big_file = { size = 1024 * 5000, lines = 50000 }

    vim.opt.breakindent = true
    vim.opt.clipboard = "unnamedplus"
    vim.opt.cmdheight = 0
    vim.opt.completeopt = { "menu", "menuone", "noselect" }
    vim.opt.fileencoding = "utf-8"
    vim.opt.fillchars = { eob = " " }
    vim.opt.foldenable = true
    vim.opt.foldlevel = 99
    vim.opt.foldlevelstart = 99
    vim.opt.foldcolumn = "1"
    vim.opt.ignorecase = true
    vim.opt.infercase = true
    vim.opt.laststatus = 3
    vim.opt.number = true
    vim.opt.preserveindent = true
    vim.opt.pumheight = 10
    vim.opt.relativenumber = false
    vim.opt.signcolumn = "yes"
    vim.opt.splitbelow = true
    vim.opt.splitright = true
    vim.opt.termguicolors = true
    vim.opt.undofile = true
    vim.opt.updatetime = 300
    vim.opt.virtualedit = "block"
    vim.opt.writebackup = false
    vim.opt.shada = "!,'1000,<50,s10,h"
    vim.opt.history = 1000
    vim.opt.swapfile = false
    vim.opt.wrap = true
    vim.opt.autochdir = true
    vim.opt.scrolloff = 10
    vim.opt.sidescrolloff = 8
    vim.opt.selection = "old"
    vim.opt.viewoptions:remove "curdir"
    vim.opt.shortmess:append { s = true, I = true }
    vim.opt.backspace:append { "nostop" }
    vim.opt.diffopt:append { "algorithm:histogram", "linematch:60" }
    vim.opt.iskeyword:remove("(")
end

local function file_exists(path)
    return vim.loop.fs_stat(path) ~= nil
end

function Core.is_neo_tree_open()
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        local b = vim.api.nvim_buf_get_name(bufnr)
        if string.find(b, "neo%-tree") then
            return true
        end
    end
    return false
end

function Core.build_session_state()
    -- this generates a dictionary of variables that I want to save within the session
    local neo_tree_open = Core.is_neo_tree_open()
    return string.format([[
        let g:session_state = {
            \ 'neo-tree-open': %d,
        \}
    ]], neo_tree_open and 1 or 0)
end

function Core.restore_session()
    local session = Core.cache_path .. "/nvim_session"
    if file_exists(session) then
        -- vim.cmd("source " .. session)

        -- vim.cmd([[
        --   if g:session_state['neo-tree-open'] == 1
        --     execute 'Neotree show'
        --   endif
        -- ]])

        -- Fixes an issue where syntax highlighting is disabled
        local settings = require("settings")
        vim.cmd.colorscheme(settings.common.colorscheme)
    end
end

function Core.configure_sessions()
    local session = Core.cache_path .. "/nvim_session"
    vim.schedule(Core.restore_session)
    vim.api.nvim_create_autocmd("VimLeavePre", {
        callback = function()
            vim.cmd(string.format("mksession! %s", session))
            local f = io.open(session, "a")
            if f then
                f:write(Core.build_session_state())
                f:close()
            end
        end,
    })
end

vim.api.nvim_create_user_command("SetTabSize", function(value)
    Core.update_settings({
        common = {
            tab_size = tonumber(value.args)
        }
    })
end, { nargs = 1 })

vim.api.nvim_create_autocmd("User", {
    pattern = "SettingsUpdated",
    callback = function()
        Core.set_options()
    end,
})

Core.set_options()
Core.configure_sessions()

return Core
