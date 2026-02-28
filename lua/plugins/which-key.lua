return {
    opts = {
        {
            preset  = "modern",
            delay   = 400,
            plugins = {
                marks     = true,
                registers = true,
                spelling  = { enabled = false },
                presets   = {
                    operators    = true,
                    motions      = true,
                    text_objects = true,
                    windows      = true,
                    nav          = true,
                    z            = true,
                    g            = true,
                },
            },
            win = { border = "rounded" },
        }
    },

    setup = function(wk)
        local b = vim.my.settings.bindings

        -- ── Global keymaps ────────────────────────────────────────────────
        wk.add({
            -- groups
            { "<leader>",  group = "Leader" },
            { "<space>",   group = "Space" },

            -- files
            { b.files_toggle, desc = "File explorer", mode = "n" },

            -- telescope
            { b.telescope_find_file,   desc = "Find files",        mode = "n" },
            { b.telescope_find_buffer, desc = "Find buffers",      mode = "n" },
            { b.telescope_live_grep,   desc = "Live grep",         mode = "n" },
            { b.telescope_help,        desc = "Help tags",         mode = "n" },

            -- git
            { b.neogit_status, desc = "Git status (Neogit)", mode = "n" },

            -- dropbar
            { b.dropbar_pick,                desc = "Dropbar: pick symbol",       mode = "n" },
            { b.dropbar_goto_context_start,  desc = "Dropbar: goto context start",mode = "n" },
            { b.dropbar_select_next_context, desc = "Dropbar: select next context",mode = "n" },

            -- lsp
            { b.lsp_definition,        desc = "LSP: definition",          mode = "n" },
            { b.lsp_declaration,       desc = "LSP: declaration",         mode = "n" },
            { b.lsp_references,        desc = "LSP: references",          mode = "n" },
            { b.lsp_implementation,    desc = "LSP: implementation",      mode = "n" },
            { b.lsp_hover,             desc = "LSP: hover",               mode = "n" },
            { b.lsp_signature_help,    desc = "LSP: signature help",      mode = "i" },
            { b.lsp_rename,            desc = "LSP: rename",              mode = "n" },
            { b.lsp_code_action,       desc = "LSP: code action",         mode = "n" },
            { b.lsp_document_symbol,   desc = "LSP: document symbols",    mode = "n" },
            { b.lsp_document_workspace,desc = "LSP: workspace symbols",   mode = "n" },
            { b.lsp_format,            desc = "LSP: format",              mode = "n" },

            -- splits
            { b.split_unsplit,     desc = "Close split",      mode = "n" },
            { b.split_onlysplit,   desc = "Only this split",  mode = "n" },
            { b.split_horizontal,  desc = "Split horizontal",  mode = "n" },
            { b.split_vertical,    desc = "Split vertical",    mode = "n" },

            -- terminal
            { b.toggle_terminal, desc = "Toggle terminal", mode = "n" },

            -- surround (visual + normal where applicable)
            { b.surround_add,           desc = "Surround: add",          mode = { "n", "v" } },
            { b.surround_delete,        desc = "Surround: delete",       mode = "n" },
            { b.surround_find,          desc = "Surround: find",         mode = "n" },
            { b.surround_find_left,     desc = "Surround: find (left)",  mode = "n" },
            { b.surround_highlight,     desc = "Surround: highlight",    mode = "n" },
            { b.surround_replace,       desc = "Surround: replace",      mode = "n" },
        })

        -- ── mini.files buffer-local mappings ─────────────────────────────
        -- Mirror the `mappings` table from lua/plugins/mini.files.lua so
        -- which-key can show them as contextual help while the explorer is open.
        vim.api.nvim_create_autocmd("User", {
            pattern  = "MiniFilesWindowOpen",
            callback = function(ev)
                local buf = ev.data and ev.data.buf_id
                if not buf then return end
                wk.add({
                    { "q",    buffer = buf, desc = "Close" },
                    { "l",    buffer = buf, desc = "Go in" },
                    { "L",    buffer = buf, desc = "Go in (keep open)" },
                    { "h",    buffer = buf, desc = "Go out" },
                    { "H",    buffer = buf, desc = "Go out (keep open)" },
                    { "'",    buffer = buf, desc = "Goto mark" },
                    { "m",    buffer = buf, desc = "Set mark" },
                    { "<BS>", buffer = buf, desc = "Reset to cwd" },
                    { "@",    buffer = buf, desc = "Reveal cwd" },
                    { "g?",   buffer = buf, desc = "Show built-in help" },
                    { "=",    buffer = buf, desc = "Synchronize (apply renames)" },
                    { "<",    buffer = buf, desc = "Trim path left" },
                    { ">",    buffer = buf, desc = "Trim path right" },
                })
            end,
        })
    end,
}
