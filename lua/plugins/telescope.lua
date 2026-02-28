return {
    opts = {
        defaults = {
            layout_strategy = "horizontal",
            layout_config = {
                horizontal = {
                    preview_width = 0.55,
                    width = 0.9,
                    height = 0.85,
                }
            },
        },
        pickers = {
            find_files = {},
            live_grep = {},
        },
        extensions = {}
    },
    setup = function()
        local telescope = require("telescope")

        local bindings = vim.my.settings.bindings
        telescope.load_extension("live_grep_args")

        local builtin = require('telescope.builtin')
        vim.keymap.set('n', bindings.telescope_find_file, builtin.find_files, {})
        vim.keymap.set('n', bindings.telescope_find_buffer, builtin.buffers, {})
        vim.keymap.set('n', bindings.telescope_live_grep, function()
            require("telescope").extensions.live_grep_args.live_grep_args()
        end, {})
        vim.keymap.set('n', bindings.telescope_help, builtin.help_tags, {})
    end,
}
