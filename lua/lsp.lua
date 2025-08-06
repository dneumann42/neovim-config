local Lsp = {}

local Core = require("core")
local Config = {
    lua_ls = {
        settings = {
            Lua = {
            },
        },
    }
}

function Lsp.configure()
    local settings = Core.require("settings")
    for i = 1, #settings.lsp.enabled do
        local cfg = settings.lsp.enabled[i]
        vim.lsp.enable(cfg)
        vim.lsp.config(cfg, Config[cfg] or {})
    end
end

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.server_capabilities.documentFormattingProvider then
            vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = args.buf,
                callback = function()
                    vim.lsp.buf.format({ bufnr = args.buf })
                end,
            })
        end
    end,
})

vim.api.nvim_create_autocmd("User", {
    pattern = "SettingsUpdated",
    callback = function()
        Lsp.configure()
    end,
})
Lsp.configure()

vim.api.nvim_create_user_command("EnableLsp", function(value)
    local enabled = require("settings").lsp.enabled
    for i = 1, #enabled do
        if enabled[i] == value.args then
            return
        end
    end
    table.insert(enabled, value.args)
    Core.update_settings({ lsp = { enabled = enabled } })
end, { nargs = 1 })

return Lsp
