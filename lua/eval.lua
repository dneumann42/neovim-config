local Eval = {}

vim.d = vim.d or {}
local settings = require("settings")

function vim.d.eval_buffer()
    vim.cmd("so%")
    vim.print("Evaluated Buffer")
end

vim.keymap.set('n', settings.bindings.eval_buffer, function()
        vim.d.eval_buffer()
end, {})

return Eval
