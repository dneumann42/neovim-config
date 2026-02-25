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

vim.my.module "Plugins" {
    load = function()
        local settings = vim.my.settings
        vim.pack.add(plugins(settings.plugin_list))
        vim.pack.add(plugins(settings.theme_list))

        local scan = require("plenary.scandir")
        local plugin_dir = vim.fn.stdpath("config") .. "/lua/plugins"
        for _, file in ipairs(scan.scan_dir(plugin_dir, { depth = 1, search_pattern = "%.lua$" })) do
            if file:match("^" .. plugin_dir .. "/[^/]+$") then
                local cfg = dofile(file)
                local stem = file:match("/([^/]+)%.lua$")
                local ok, mod = pcall(require, stem)
                if cfg.opts and ok and type(mod) == "table" and mod.setup then
                    mod.setup(unpack(cfg.opts))
                end
                if cfg.setup then
                    cfg.setup(ok and mod or nil)
                end
            end
        end
    end
}
