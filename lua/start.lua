vim.my.apply_settings = function()
    local settings = vim.my.require_load("settings")

    -- Indentation
    local indent = settings.indentation
    vim.opt.tabstop = indent.value
    vim.opt.shiftwidth = indent.value
    vim.opt.expandtab = true

    if indent.lang then
        local group = vim.api.nvim_create_augroup("settings_indent_lang", { clear = true })
        for ft, val in pairs(indent.lang) do
            vim.api.nvim_create_autocmd("FileType", {
                group = group,
                pattern = ft,
                callback = function()
                    vim.opt_local.tabstop = val
                    vim.opt_local.shiftwidth = val
                end,
            })
        end
    end

    -- Colorscheme
    local cs = settings.colorscheme
    vim.cmd.colorscheme(cs.value)
    if cs.clear_background then
        vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    end
end

vim.my.module "Start" {
    load = function()
        vim.my.apply_settings()
    end
}
