return {
    opts = {
        {
            content = {
                filter = nil,
                highlight = nil,
                prefix = nil,
                sort = nil,
            },

            mappings = {
                close       = 'q',
                go_in       = 'l',
                go_in_plus  = 'L',
                go_out      = 'h',
                go_out_plus = 'H',
                mark_goto   = "'",
                mark_set    = 'm',
                reset       = '<BS>',
                reveal_cwd  = '@',
                show_help   = 'g?',
                synchronize = '=',
                trim_left   = '<',
                trim_right  = '>',
            },

            options = {
                permanent_delete = true,
                use_as_default_explorer = true,
            },

            windows = {
                max_number = math.huge,
                preview = false,
                width_focus = 50,
                width_nofocus = 15,
                width_preview = 25,
            },
        }
    },
    setup = function(mini)
        local bindings = vim.my.settings.bindings
        vim.keymap.set('n', bindings.files_toggle, mini.open, {})

        local help_buf = nil
        local help_win = nil

        local lines = {
            "  mini.files",
            " ─────────────────────",
            "  l / L    in / in+",
            "  h / H    out / out+",
            "  q        close",
            "  =        sync",
            "  <BS>     reset",
            "  @        reveal cwd",
            "  m / '    mark set/go",
            "  < / >    trim path",
            "  g?       help",
        }

        local width = 0
        for _, line in ipairs(lines) do
            width = math.max(width, #line)
        end

        local function open_help()
            if help_win and vim.api.nvim_win_is_valid(help_win) then return end

            help_buf = vim.api.nvim_create_buf(false, true)
            vim.api.nvim_buf_set_lines(help_buf, 0, -1, false, lines)
            vim.bo[help_buf].modifiable = false

            -- highlights
            vim.api.nvim_buf_add_highlight(help_buf, -1, "Title",   0, 0, -1)
            vim.api.nvim_buf_add_highlight(help_buf, -1, "Comment", 1, 0, -1)
            for i = 2, #lines - 1 do
                vim.api.nvim_buf_add_highlight(help_buf, -1, "Special", i, 2, 9)
                vim.api.nvim_buf_add_highlight(help_buf, -1, "Comment", i, 9, -1)
            end

            help_win = vim.api.nvim_open_win(help_buf, false, {
                relative  = "editor",
                anchor    = "SE",
                row       = vim.o.lines - 2,
                col       = vim.o.columns - 1,
                width     = width,
                height    = #lines,
                style     = "minimal",
                border    = "rounded",
                focusable = false,
                zindex    = 50,
            })
        end

        local function close_help()
            if help_win and vim.api.nvim_win_is_valid(help_win) then
                vim.api.nvim_win_close(help_win, true)
            end
            if help_buf and vim.api.nvim_buf_is_valid(help_buf) then
                vim.api.nvim_buf_delete(help_buf, { force = true })
            end
            help_win = nil
            help_buf = nil
        end

        vim.api.nvim_create_autocmd("User", {
            pattern  = "MiniFilesWindowOpen",
            callback = open_help,
        })

        vim.api.nvim_create_autocmd("User", {
            pattern  = "MiniFilesExplorerClose",
            callback = close_help,
        })
    end
}
