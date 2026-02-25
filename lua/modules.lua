local Module = {
    modules = {}
}

--- Create a new module with its own reload command group.
--- @param o table Must have a `name` field. Optionally an `on_reload` function.
Module.new = function(name)
    local function callback(o, ...)
        if o.unload then
            o.unload()
        end
        return o.load(...)
    end
    local function create_autocmd(o, group, name)
        vim.api.nvim_create_autocmd("User", {
            group = group,
            pattern = "ModuleReload_" .. name,
            callback = function(...) callback(o, ...) end,
        })
    end
    return function(o)
        o._group = vim.api.nvim_create_augroup("module_" .. name, { clear = true })
        Module.modules[name] = o
        if o.load then
            create_autocmd(o, o._group, name)
        end
        return o
    end
end

vim.my.module = Module.new

--- Emit a reload event to a specific module.
--- @param name string
function Module.reload(name)
    vim.api.nvim_exec_autocmds("User", { pattern = "ModuleReload_" .. name })
end

--- Emit a reload event to all registered modules.
function Module.reload_all()
    for name in pairs(Module.modules) do
        Module.reload(name)
    end
end

return Module
