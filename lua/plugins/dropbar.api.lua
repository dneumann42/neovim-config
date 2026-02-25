return {
    setup = function()
        local dropbar_api = require("dropbar.api")
        local bindings = vim.my.settings.bindings
        vim.keymap.set('n', bindings.dropbar_pick, dropbar_api.pick, { desc = 'Pick symbols in winbar' })
        vim.keymap.set('n', bindings.dropbar_goto_context_start, dropbar_api.goto_context_start,
            { desc = 'Go to start of current context' })
        vim.keymap.set('n', bindings.dropbar_select_next_context, dropbar_api.select_next_context,
            { desc = 'Select next context' })
    end,
}
