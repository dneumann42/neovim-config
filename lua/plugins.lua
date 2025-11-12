local function plugins(tbl)
    for i = 1, #tbl do
        local p = tbl[i]
        local src = p.src or p[1] or error("Expected src")
        p.name = src
        if src:sub(1, 4) ~= "http" then
            src = "https://github.com/" .. src
        end
        p.src = src
    end
    return tbl
end

vim.d.plugin_list = plugins {
    { "nvim-lua/plenary.nvim" },
    { "nvim-tree/nvim-web-devicons" },
    { "sindrets/diffview.nvim" },
    { "ibhagwan/fzf-lua" },
    { "folke/snacks.nvim" },
    { "NeogitOrg/neogit" },
    { "nvim-mini/mini.surround" },
    { "Bekaboo/dropbar.nvim" },
    { "prichrd/netrw.nvim" },
    { "nvim-mini/mini.files" },
    { "b0o/incline.nvim" },

    -- NOTE: I might replace telescope with mini.pick. need to see about document previews, 
    -- and hooking into the events so I can preview things like themes live.
    -- I could also replace telescope with snacks.nvim.
    { "nvim-telescope/telescope.nvim" },
    { "nvim-telescope/telescope-live-grep-args.nvim" },
    { "nvim-treesitter/nvim-treesitter" },
    { "nvim-mini/mini.indentscope" },
    { "pechorin/any-jump.vim" },
}

vim.d.theme_list = plugins {
    { "vague2k/vague.nvim" },
    { "rebelot/kanagawa.nvim" },
    { "catppuccin/nvim" },
    { "sontungexpt/witch" },
    { "folke/tokyonight.nvim" },
    { "catppuccin/nvim" },
    { "bluz71/vim-moonfly-colors" },
}

function vim.d.update_plugins()
    vim.pack.add(vim.d.plugin_list)
    vim.pack.add(vim.d.theme_list)
end

function vim.d.update_plugin_configs()
    local settings = require("settings")
    for k, v in pairs(settings.plugins) do
        local plug = require(k)
        if plug.setup then
            plug.setup(v.opts)
        end
        if v.setup then
            v.setup(plug)
        end
    end
end

return vim.d.plugin_list
