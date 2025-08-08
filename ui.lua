local Ui = {}
local Core = require("core")

function vim.ui.select2(options, cfg, on_select)
    local n = require("nui-components")

    local renderer = n.create_renderer({
        width = 60,
        height = 20,
    })

    local signal = n.create_signal({
        selected = cfg.selected and { cfg.selected } or {}
    })

    local data = {}
    for i = 1, #options do
        local o = options[i]
        table.insert(data, n.option(o.label, { id = o.id }))
    end

    local function body()
        return n.select({
            autofocus = true,
            border_label = cfg.prompt or "Select",
            selected = signal.selected,
            data = data,
            multiselect = false,
            on_select = function(nodes)
                signal.selected = nodes
                renderer:close()
                on_select(nodes.id)
            end,
            on_change = function(nodes)
                vim.cmd.colorscheme(nodes.id)
            end,
            mappings = function()
                return {
                    {
                        mode = { "n" },
                        key = 'q',
                        handler = function()
                            if cfg.selected then
                                vim.cmd.colorscheme(cfg.selected)
                            end
                            renderer:close()
                        end,
                    },
                    {
                        mode = { "n" },
                        key = 'p',
                        handler = function()
                        end,
                    },
                    {
                        mode = { "n" },
                        key = 'n',
                        handler = function()
                        end,
                    }
                }
            end
        })
    end

    renderer:render(body)
end

function vim.ui.find_file()
    local n = require("nui-components")

    local renderer = n.create_renderer({
        width = 60,
        height = 20,
    })

    local function body()
        -- return n.col
    end

    renderer:render(body)
end

function Ui.configure()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    require("autoclose").setup {
        options = {
            disabled_filetypes = {
                "TelescopePrompt"
            },
            disable_command_mode = true,
        }
    }

    require("neo-tree").setup {
        use_libuv_file_watcher = true,
        close_if_last_window = true,
        popup_border_style = "single",
        follow_current_file = {
            enabled = true,
            leave_dirs_open = true,
        },
        window = {
            position = "left",
            width = 40,
            mappings = {
                ["P"] = {
                    "toggle_preview",
                    config = {
                        use_float = true,
                        use_image_nvim = false
                    }
                },
                ["/"] = "noop"
            }
        },
        filesystem = {
            -- I manually handle this behavior
            hijack_netrw_behavior = "disabled"
        },
        default_component_configs = {
            diagnostics = {
                symbols = {
                    hint = "󰌵",
                    info = " ",
                    warn = " ",
                    error = " ",
                },
                highlights = {
                    hint = "DiagnosticSignHint",
                    info = "DiagnosticSignInfo",
                    warn = "DiagnosticSignWarn",
                    error = "DiagnosticSignError",
                },
            },
            git_status = {
                symbols = {
                    -- Change type
                    added     = "",
                    modified  = "",
                    deleted   = "✖",
                    renamed   = "󰁕",
                    -- Status type
                    untracked = "",
                    ignored   = "",
                    unstaged  = "",
                    staged    = "",
                    conflict  = "",
                }
            },
        },
    }

    vim.keymap.set('n', "<leader>n", function()
        vim.cmd "Neotree toggle reveal=true"
    end)

    -- ensure neotree stays left when moving splits
    local function is_neotree_open()
        for _, win_id in ipairs(vim.api.nvim_list_wins()) do
            local buf_id = vim.api.nvim_win_get_buf(win_id)
            local buf_name = vim.api.nvim_buf_get_name(buf_id)
            if string.find(buf_name, 'neo%-tree') then
                return true
            end
        end
        return false
    end

    local function wincmd_H()
        local toggle = is_neotree_open()
        if toggle then vim.cmd [[ Neotree toggle ]] end
        vim.cmd [[ wincmd H ]]
        if toggle then
            local current_win = vim.api.nvim_get_current_win()
            vim.cmd [[ Neotree toggle ]]
            vim.api.nvim_set_current_win(current_win)
        end
    end

    vim.keymap.set('n', '<C-w>H', wincmd_H)

    vim.api.nvim_create_autocmd("BufEnter", {
        group = vim.api.nvim_create_augroup("Neotree_start_directory", { clear = true }),
        desc = "Start Neo-tree with directory",
        once = true,
        callback = function()
            if vim.g.started_neotree then
                return
            end
            vim.g.started_neotree = true
            local arg0 = vim.fn.argv(0)
            if vim.fn.isdirectory(arg0) == 1 then
                if type(arg0) == "string" then
                    vim.fn.chdir(arg0)
                end

                vim.cmd [[ Neotree position=current ]]
            end
        end,
    })

    require("telescope").setup {
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
    }

    require('telescope').load_extension("live_grep_args")
    local builtin = require('telescope.builtin')

    vim.keymap.set('n', '<leader>f', builtin.find_files, {})
    vim.keymap.set('n', '<leader>g', function()
        require("telescope").extensions.live_grep_args.live_grep_args {
            theme = "dropdown"
        }
    end, {})
    vim.keymap.set('n', '<leader>b', builtin.buffers, {})
    vim.keymap.set('n', '<leader>ht', builtin.help_tags, {})

    require 'nvim-treesitter.configs'.setup {
        ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },
        sync_install = false,
        auto_install = true,
        highlight = {
            enable = true,
        },
    }
end

vim.api.nvim_create_user_command("ColorScheme", function(value)
    vim.cmd("silent! colorscheme " .. value.args)
    Core.update_settings({ common = { colorscheme = value.args } })
end, { nargs = 1 })

vim.api.nvim_create_user_command("SwitchColorScheme", function(value)
    local colorschemes = vim.fn.getcompletion("", "color")

    local current_colorscheme = vim.g.colors_name

    local options = {}
    for i = 1, #colorschemes do
        table.insert(options, { id = colorschemes[i], label = colorschemes[i] })
    end

    vim.ui.select2(options, {
        prompt = 'Pick a new theme: ',
        selected = current_colorscheme
    }, function(choice)
        Core.update_settings({ common = { colorscheme = choice } })
    end)
end, { nargs = 0 })

Ui.configure()

return Ui
