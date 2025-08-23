-- [[ Dustin's Neovim Config ]]

local settings = {
    tab_size = 4
}

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true
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

vim.pack.add {
    { src = 'https://github.com/nvim-lua/plenary.nvim.git' },
    { src = 'https://github.com/folke/which-key.nvim.git' },
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter.git', version = "main" },
    { src = 'https://github.com/echasnovski/mini.icons.git' },
    { src = 'https://github.com/nvim-tree/nvim-tree.lua.git' },
    { src = 'https://github.com/neovim/nvim-lspconfig.git' },
    { src = 'https://github.com/akinsho/toggleterm.nvim.git' },
    { src = 'https://github.com/echasnovski/mini.pairs.git' },
    { src = 'https://github.com/kylechui/nvim-surround.git' },
    { src = 'https://codeberg.org/mfussenegger/nvim-dap.git' },
    { src = 'https://github.com/catppuccin/nvim.git' },
}

require("mini.icons").setup {}
require("which-key").setup {}
require("mini.pairs").setup {}
require("nvim-tree").setup {
    hijack_cursor = true,
    auto_reload_on_write = true,
    disable_netrw = false,
    hijack_netrw = true,
    hijack_unnamed_buffer_when_opening = false,
    root_dirs = {},
    prefer_startup_root = false,
    sync_root_with_cwd = true,
    reload_on_bufenter = true,
    respect_buf_cwd = false,
    select_prompts = false,
    sort = {
        sorter = "name",
        folders_first = true,
        files_first = false,
    },
    view = {
        centralize_selection = false,
        cursorline = true,
        cursorlineopt = "both",
        debounce_delay = 15,
        side = "left",
        preserve_window_proportions = false,
        number = false,
        relativenumber = false,
        signcolumn = "yes",
        width = 30,
        float = {
            enable = false,
            quit_on_focus_loss = true,
            open_win_config = {
                relative = "editor",
                border = "rounded",
                width = 30,
                height = 30,
                row = 1,
                col = 1,
            },
        },
    },
    renderer = {
        add_trailing = false,
        group_empty = false,
        full_name = false,
        root_folder_label = ":~:s?$?/..?",
        indent_width = 2,
        special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md" },
        hidden_display = "none",
        symlink_destination = true,
        decorators = { "Git", "Open", "Hidden", "Modified", "Bookmark", "Diagnostics", "Copied", "Cut", },
        highlight_git = "none",
        highlight_diagnostics = "none",
        highlight_opened_files = "none",
        highlight_modified = "none",
        highlight_hidden = "none",
        highlight_bookmarks = "none",
        highlight_clipboard = "name",
        indent_markers = {
            enable = false,
            inline_arrows = true,
            icons = {
                corner = "└",
                edge = "│",
                item = "│",
                bottom = "─",
                none = " ",
            },
        },
        icons = {
            web_devicons = {
                file = {
                    enable = true,
                    color = true,
                },
                folder = {
                    enable = false,
                    color = true,
                },
            },
            git_placement = "before",
            modified_placement = "after",
            hidden_placement = "after",
            diagnostics_placement = "signcolumn",
            bookmarks_placement = "signcolumn",
            padding = {
                icon = " ",
                folder_arrow = " ",
            },
            symlink_arrow = " ➛ ",
            show = {
                file = true,
                folder = true,
                folder_arrow = true,
                git = true,
                modified = true,
                hidden = false,
                diagnostics = true,
                bookmarks = true,
            },
            glyphs = {
                default = "",
                symlink = "",
                bookmark = "󰆤",
                modified = "●",
                hidden = "󰜌",
                folder = {
                    arrow_closed = "",
                    arrow_open = "",
                    default = "",
                    open = "",
                    empty = "",
                    empty_open = "",
                    symlink = "",
                    symlink_open = "",
                },
                git = {
                    unstaged = "✗",
                    staged = "✓",
                    unmerged = "",
                    renamed = "➜",
                    untracked = "★",
                    deleted = "",
                    ignored = "◌",
                },
            },
        },
    },
    hijack_directories = {
        enable = true,
        auto_open = true,
    },
    update_focused_file = {
        enable = false,
        update_root = {
            enable = false,
            ignore_list = {},
        },
        exclude = false,
    },
    system_open = {
        cmd = "",
        args = {},
    },
    git = {
        enable = true,
        show_on_dirs = true,
        show_on_open_dirs = true,
        disable_for_dirs = {},
        timeout = 400,
        cygwin_support = false,
    },
    diagnostics = {
        enable = false,
        show_on_dirs = false,
        show_on_open_dirs = true,
        debounce_delay = 500,
        severity = {
            min = vim.diagnostic.severity.HINT,
            max = vim.diagnostic.severity.ERROR,
        },
        icons = {
            hint = "",
            info = "",
            warning = "",
            error = "",
        },
    },
    modified = {
        enable = false,
        show_on_dirs = true,
        show_on_open_dirs = true,
    },
    filters = {
        enable = true,
        git_ignored = true,
        dotfiles = false,
        git_clean = false,
        no_buffer = false,
        no_bookmark = false,
        custom = {},
        exclude = {},
    },
    live_filter = {
        prefix = "[FILTER]: ",
        always_show_folders = true,
    },
    filesystem_watchers = {
        enable = true,
        debounce_delay = 50,
        ignore_dirs = {
            "/.ccls-cache",
            "/build",
            "/node_modules",
            "/target",
        },
    },
    actions = {
        use_system_clipboard = true,
        change_dir = {
            enable = true,
            global = false,
            restrict_above_cwd = false,
        },
        expand_all = {
            max_folder_discovery = 300,
            exclude = {},
        },
        file_popup = {
            open_win_config = {
                col = 1,
                row = 1,
                relative = "cursor",
                border = "shadow",
                style = "minimal",
            },
        },
        open_file = {
            quit_on_open = false,
            eject = true,
            resize_window = true,
            relative_path = true,
            window_picker = {
                enable = true,
                picker = "default",
                chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
                exclude = {
                    filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
                    buftype = { "nofile", "terminal", "help" },
                },
            },
        },
        remove_file = {
            close_window = true,
        },
    },
    trash = {
        cmd = "gio trash",
    },
    tab = {
        sync = {
            open = false,
            close = false,
            ignore = {},
        },
    },
    notify = {
        threshold = vim.log.levels.INFO,
        absolute_path = true,
    },
    help = {
        sort_by = "key",
    },
    ui = {
        confirm = {
            remove = true,
            trash = true,
            default_yes = false,
        },
    },
    experimental = {
    },
    log = {
        enable = false,
        truncate = false,
        types = {
            all = false,
            config = false,
            copy_paste = false,
            dev = false,
            diagnostics = false,
            git = false,
            profile = false,
            watcher = false,
        },
    },

}

local dap = require("dap")
dap.configurations.lua = {
    {
        name = 'Current file (local-lua-dbg, lua)',
        type = 'local-lua',
        request = 'launch',
        cwd = '${workspaceFolder}',
        program = {
            lua = 'lua5.3',
            file = '${file}',
        },
        args = {},
    },
}

require("toggleterm").setup {
    start_in_insert = true,
}

require("catppuccin").setup {
    flavour = "auto", -- latte, frappe, macchiato, mocha
    background = {    -- :h background
        light = "latte",
        dark = "mocha",
    },
    transparent_background = false, -- disables setting the background color.
    float = {
        transparent = false,        -- enable transparent floating windows
        solid = false,              -- use solid styling for floating windows, see |winborder|
    },
    show_end_of_buffer = false,     -- shows the '~' characters after the end of buffers
    term_colors = false,            -- sets terminal colors (e.g. `g:terminal_color_0`)
    dim_inactive = {
        enabled = false,            -- dims the background color of inactive window
        shade = "dark",
        percentage = 0.15,          -- percentage of the shade to apply to the inactive window
    },
    no_italic = false,              -- Force no italic
    no_bold = false,                -- Force no bold
    no_underline = false,           -- Force no underline
    styles = {                      -- Handles the styles of general hi groups (see `:h highlight-args`):
        comments = { "italic" },    -- Change the style of comments
        conditionals = { "italic" },
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
        -- miscs = {}, -- Uncomment to turn off hard-coded styles
    },
    color_overrides = {},
    custom_highlights = {},
    default_integrations = true,
    auto_integrations = false,
    integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        notify = false,
        mini = {
            enabled = true,
            indentscope_color = "",
        },
        -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
    },
}

-- setup must be called before loading
vim.cmd.colorscheme "catppuccin"

vim.keymap.set('n', '<c-space>', ':ToggleTerm<cr>')
vim.keymap.set('t', '<c-space>', '<c-\\><c-n>:ToggleTerm<cr>')

local function set_tab_size(tab_size)
    vim.opt.showmatch = true
    vim.opt.shiftwidth = tab_size
    vim.opt.tabstop = tab_size
    vim.opt.softtabstop = tab_size
    vim.opt.expandtab = true
end

set_tab_size(settings.tab_size)

local function make_background_transparent()
    for _, group in ipairs(vim.fn.getcompletion('', 'highlight')) do
        if group ~= "Visual" and group ~= "VisualNOS" then
            local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group })
            if ok and hl then
                if hl.bg then
                    hl.bg = 0
                    vim.api.nvim_set_hl(0, group, hl)
                end
            end
        end
    end
end

make_background_transparent()

vim.api.nvim_create_autocmd("ColorScheme", {
    callback = make_background_transparent,
})

local on_attach_lsp = function(client, bufnr)
    local opts = { noremap = true, silent = true, buffer = bufnr }

    -- Keymaps for LSP
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

    -- Diagnostics
    vim.keymap.set("n", "[d", function()
        vim.diagnostic.jump { count = 1, float = true }
    end, opts)
    vim.keymap.set("n", "]d", function()
        vim.diagnostic.jump { count = -1, float = true }
    end, opts)
    vim.keymap.set("n", "<leader>F", vim.lsp.buf.format, opts)

    vim.keymap.set("n", "<M-CR>", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", '<C-K>', vim.diagnostic.open_float)
end

local lspconfig = require("lspconfig")

lspconfig.lua_ls.setup({
    on_attach = on_attach_lsp,
    settings = {
        Lua = {
            completion = {
                autoRequire = true,
                displayContext = 10
            },
            telemetry = {
                enable = false,
            },
            diagnostics = {
                globals = { 'vim' },
            },
            workspace = {
                checkThirdParty = true,
                library = {
                    "${3rd}/love2d/library",
                    "/usr/local/share/lua/5.3",
                    vim.env.VIMRUNTIME .. "/lua",
                    vim.env.VIMRUNTIME .. "/lua/vim/lsp",
                    vim.fn.stdpath("config") .. "/lua",
                }
            },
        },
    },
})

lspconfig.ts_ls.setup({ on_attach = on_attach_lsp })
lspconfig.pyright.setup({ on_attach = on_attach_lsp })

vim.keymap.set('n', '<M-0>', ':NvimTreeToggle<cr>')
vim.keymap.set('i', '<M-0>', ':NvimTreeToggle<cr>')

require("nvim-surround").setup {}
