local Ui = {}

local Core = require("core")

function Ui.configure_widgets()
    local n = require("nui-components")

    local renderer = n.create_renderer({
        width = 60,
        height = 20,
    })

    local signal = n.create_signal({
        selected = { "poland" }
    })

    local body = function()
        return n.select({
            autofocus = true,
            border_label = "Select countries",
            selected = signal.selected,
            data = {
                n.separator("Europe"),
                n.option("Poland", { id = "poland" }),
                n.option("Spain", { id = "spain" }),
                n.option("Portugal", { id = "portugal" }),
                n.option("France", { id = "france" }),
                n.option("Germany", { id = "germany" }),
                n.separator("North America"),
                n.option("USA", { id = "usa" }),
                n.option("Canada", { id = "canada" }),
            },
            multiselect = true,
            on_select = function(nodes)
                signal.selected = nodes
                renderer:close()
            end,
        })
    end

    renderer:render(body)
end

function Ui.configure()
    require("neo-tree").setup {
        use_libuv_file_watcher = true,
        close_if_last_window = true,
        popup_border_style = "single",
        follow_current_file = {
            enabled = true
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
                    added     = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
                    modified  = "", -- or "", but this is redundant info if you use git_status_colors on the name
                    deleted   = "✖", -- this can only be used in the git_status source
                    renamed   = "󰁕", -- this can only be used in the git_status source
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
end

vim.api.nvim_create_user_command("ColorScheme", function(value)
    -- local colorscheme = require("settings").common.colorscheme
    vim.cmd("silent! colorscheme " .. value.args)
    Core.update_settings({ common = { colorscheme = value.args } })
end, { nargs = 1 })

vim.api.nvim_create_user_command("SwitchColorScheme", function(value)
    local colorschemes = vim.fn.getcompletion("", "color")

    vim.ui.select(colorschemes, {
        prompt = 'Pick a new theme: ',
        format_item = function(item)
            return item
        end,
    }, function(choice)
        if not choice then
            return
        end

        vim.cmd("silent! colorscheme " .. choice)
        Core.update_settings({ common = { colorscheme = choice } })
    end)
end, { nargs = 0 })

Ui.configure()
Ui.configure_widgets()

return Ui
