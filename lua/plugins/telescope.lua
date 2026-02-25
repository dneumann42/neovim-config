return {
    opts = {
        defaults = {
            layout_config = {
                vertical = { width = 0.5 }
            }
        },
        pickers = {
            find_files = {
                theme = "dropdown"
            },
            live_grep = {
                theme = "dropdown"
            }
        },
        extensions = {
            live_grep_args = {
                theme = "dropdown"
            }
        }
    },
    setup = function()
        local telescope = require("telescope")

        local bindings = vim.my.settings.bindings
        telescope.load_extension("live_grep_args")

        local builtin = require('telescope.builtin')
        vim.keymap.set('n', bindings.telescope_find_file, builtin.find_files, {})
        vim.keymap.set('n', bindings.telescope_find_buffer, builtin.buffers, {})
        vim.keymap.set('n', bindings.telescope_live_grep, function()
            require("telescope").extensions.live_grep_args.live_grep_args {
                theme = "dropdown"
            }
        end, {})
        vim.keymap.set('n', bindings.telescope_help, builtin.help_tags, {})
    end,
}
