return {
    opts = {
        bar = {
            sources = function(buf, win)
                local sources = require("dropbar.sources")
                vim.print(sources)
                return { sources.path } -- only use file path, no symbols
            end,
        },
        sources = {
            path = {
                relative_to = function(_, win)
                    local ok, cwd = pcall(vim.fn.getcwd, win)
                    return ok and cwd or vim.fn.getcwd()
                end,
                max_depth = 9999,
            },
        },
    }
}
