vim.d = vim.d or {}

function vim.d.get_themes()
    local themes = vim.fn.getcompletion("", "color")
    local xs = {}
    for _, name in ipairs(themes) do
        table.insert(xs, name)
    end
    return xs
end

function vim.d.select_theme()
    local start = vim.g.colors_name
    vim.g.__theme_selected = false
    require('telescope.builtin').colorscheme {
        enable_preview = true,
        attach_mappings = function(prompt_bufnr, map)
            local actions = require('telescope.actions')
            local action_state = require('telescope.actions.state')

            local function apply_and_close()
                local entry = action_state.get_selected_entry()
                vim.g.__theme_selected = true
                actions.close(prompt_bufnr)
                if entry and entry.value then
                    pcall(vim.cmd.colorscheme, entry.value)
                end
            end

            local function restore_and_close()
                actions.close(prompt_bufnr)
                if not vim.g.__theme_selected and start then
                    pcall(vim.cmd.colorscheme, start)
                end
            end

            map('i', '<CR>', apply_and_close)
            map('n', '<CR>', apply_and_close)
            map('i', '<Esc>', restore_and_close)
            map('n', '<Esc>', restore_and_close)
            map('i', '<C-c>', restore_and_close)
            map('n', '<C-c>', restore_and_close)
            return true
        end,
    }
end

local UI = {}

local function find_netrw_autoload()
    -- 1) $VIMRUNTIME/autoload/netrw.vim
    local vr = vim.env.VIMRUNTIME
    if vr then
        local p = vr .. "/autoload/netrw.vim"
        if vim.uv.fs_stat(p) then return p end
    end
    -- 2) &runtimepath
    local hits = vim.fn.globpath(vim.o.runtimepath, "autoload/netrw.vim", true, true)
    if #hits > 0 then return hits[1] end
    -- 3) Bob nightly fallback (your path hint)
    -- Search broadly for .../pack/dist/opt/netrw/autoload/netrw.vim
    local patterns = {
        "**/pack/dist/opt/netrw/autoload/netrw.vim",
        "share/bob/nightly/share/nvim/runtime/pack/dist/opt/netrw/autoload/netrw.vim",
    }
    local bases = {
        vim.fn.stdpath("data"),
        vim.fn.stdpath("cache"),
        vim.fn.stdpath("config"),
        vim.loop.os_homedir(),
        "/",
    }
    for _, base in ipairs(bases) do
        for _, pat in ipairs(patterns) do
            local g = vim.fn.glob(base .. "/" .. pat, true, true)
            if type(g) == "table" and #g > 0 then return g[1] end
            if type(g) == "string" and g ~= "" then return g end
        end
    end
    return nil
end

local function writefile(path, text)
    return pcall(vim.fn.writefile, vim.split(text, "\n", { plain = true }), path)
end

function UI.setup()
    vim.api.nvim_create_user_command("SwitchTheme", function() vim.d.select_theme() end, {})
    vim.opt.laststatus = 3
    vim.opt.cmdheight = 0
    vim.opt.showmode = false
    -- always show sign column
    vim.cmd([[ set scl=yes ]])

    vim.cmd([[ filetype plugin indent on ]])
    vim.cmd([[ filetype plugin on ]])

    vim.opt.mouse               = "a"
    vim.opt.encoding            = "utf-8"
    vim.opt.ttyfast             = true
    vim.opt.swapfile            = true
    vim.opt.backupdir           = vim.env.HOME .. "/.cache/vim"

    vim.g.netrw_liststyle       = 3
    vim.g.netrw_banner          = 0
    vim.g.netrw_keepdir         = 0
    vim.g.netrw_winsize         = 20
    vim.g.netrw_localcopydircmd = "cp -r"

    vim.cmd [[ hi! link netrwMarkFile Search ]]

    local settings = require("settings")
    local bindings = vim.d.bindings

    local function find_netrw_window(tabpage)
        for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tabpage)) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.bo[buf].filetype == "netrw" then
                return win
            end
        end
        return nil
    end

    local function netrw_toggle()
        local current_tab = vim.api.nvim_get_current_tabpage()
        local netrw_win = find_netrw_window(current_tab)
        if netrw_win then
            vim.api.nvim_win_close(netrw_win, true)
            return
        end
        local file_to_reveal = vim.fn.expand("%:p")
        local target = vim.g.project_root
        if not target or target == "" then
            local cwd = vim.fn.getcwd()
            local git_root = vim.d.git_toplevel and vim.d.git_toplevel(cwd)
            if git_root and git_root ~= "" then
                target = git_root
            elseif vim.fn.expand("%") ~= "" then
                target = vim.fn.expand("%:p:h")
            else
                target = cwd
            end
        end
        local previous_win = vim.api.nvim_get_current_win()
        vim.cmd("Lexplore " .. vim.fn.fnameescape(target))
        netrw_win = find_netrw_window(current_tab)
        if not netrw_win then return end
        vim.api.nvim_set_current_win(netrw_win)
        vim.cmd("setlocal filetype=netrw") -- Explicitly set filetype
        vim.cmd("doautocmd BufReadPost")

        local function reveal_current_file()
            if not file_to_reveal or file_to_reveal == "" then return end
            local netrw_buf = vim.api.nvim_win_get_buf(netrw_win)
            local ok, netrw_dir = pcall(vim.api.nvim_buf_get_var, netrw_buf, "netrw_curdir")
            if not ok or not netrw_dir or netrw_dir == "" then return end
            local abs_dir = vim.fn.fnamemodify(netrw_dir, ":p")
            local abs_file = vim.fn.fnamemodify(file_to_reveal, ":p")
            if abs_dir:sub(-1) ~= "/" then abs_dir = abs_dir .. "/" end
            if abs_file:sub(1, #abs_dir) ~= abs_dir then return end
            pcall(vim.fn["netrw#Refresh"])
            pcall(vim.cmd, "silent keepalt keepjumps Lexplore " .. vim.fn.fnameescape(abs_file))
            vim.cmd("redraw")
        end

        reveal_current_file()
        if vim.api.nvim_win_is_valid(previous_win) then
            vim.api.nvim_set_current_win(previous_win)
        end
    end

    vim.d.toggle_netrw = netrw_toggle

    vim.keymap.set("n", bindings.netrw_toggle, netrw_toggle, { desc = "Toggle Netrw" })

    local netrw_reveal_group = vim.api.nvim_create_augroup("NetrwRevealFile", { clear = true })
    vim.api.nvim_create_autocmd("BufNewFile", {
        group = netrw_reveal_group,
        pattern = "*",
        callback = function(args)
            vim.b[args.buf].is_new_file = true
        end,
    })
    vim.api.nvim_create_autocmd("BufWritePost", {
        group = netrw_reveal_group,
        pattern = "*",
        callback = function(args)
            if not vim.b[args.buf].is_new_file then return end
            vim.b[args.buf].is_new_file = nil -- only trigger once

            local fpath = vim.fn.expand("<afile>:p")
            if not fpath or fpath == "" then return end

            local netrw_win = nil
            for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
                for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
                    local buf = vim.api.nvim_win_get_buf(win)
                    if vim.bo[buf] and vim.bo[buf].filetype == "netrw" then
                        netrw_win = win
                        break
                    end
                end
                if netrw_win then break end
            end

            if not netrw_win then return end

            local netrw_buf = vim.api.nvim_win_get_buf(netrw_win)
            local netrw_dir = vim.api.nvim_buf_get_var(netrw_buf, "netrw_curdir")
            local file_dir = vim.fn.fnamemodify(fpath, ":h")

            if not (netrw_dir and file_dir:find(netrw_dir, 1, true)) then return end

            local current_win = vim.api.nvim_get_current_win()
            vim.api.nvim_set_current_win(netrw_win)
            pcall(vim.fn["netrw#Refresh"])
            vim.cmd("redraw")
            pcall(vim.cmd, "Lexplore " .. vim.fn.fnameescape(fpath))
            vim.api.nvim_set_current_win(current_win)
        end,
    })

    vim.g.netrw_hide = 1
    vim.g.netrw_list_hide = [[\(^\|\s\s\)\zs\.\S\+]]
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "netrw",
        callback = function()
            vim.keymap.set("n", "H", "gh", { buffer = true, remap = true, desc = "Toggle dotfiles" })

            vim.api.nvim_create_autocmd("FileType", {
                pattern = "netrw",
                callback = function()
                    vim.keymap.set("n", "<2-LeftMouse>", "<Nop>", { buffer = true })
                end,
            })
        end,
    })

    pcall(vim.cmd.colorscheme, settings.color_scheme)

    if vim.g.neovide then
        local alpha = function()
            return string.format("%x", math.floor(255 * (vim.g.transparency or 0.8)))
        end
        -- g:neovide_opacity should be 0 if you want to unify transparency of content and title bar.
        vim.g.neovide_opacity = 0.85
        vim.g.transparency = 0.8
        vim.g.neovide_background_color = "#0f1117" .. alpha()

        vim.o.guifont = "Source Code Pro:h14"

        vim.g.neovide_floating_shadow = true
        vim.g.neovide_floating_z_height = 10
        vim.g.neovide_light_angle_degrees = 45
        vim.g.neovide_light_radius = 5
        vim.g.neovide_floating_corner_radius = 0.5

        vim.g.neovide_refresh_rate = 85
        vim.g.neovide_confirm_quit = false
        vim.g.neovide_cursor_trail_size = 0.0

        vim.keymap.set('n', '<C-+>', function() vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1 end, { desc = "Increase font size" })
        vim.keymap.set('n', '<C-_>', function() vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1 end, { desc = "Decrease font size" })
    end
end

return UI
