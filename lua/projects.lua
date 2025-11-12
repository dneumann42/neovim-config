vim.d.projects = {
    markers = {
        ".git", "package.json", "pnpm-workspace.yaml", "yarn.lock",
        "pyproject.toml", "Cargo.toml", "go.mod",
        "Makefile", "CMakeLists.txt",
    },
    paths = {
    }
}

local function fs_exists(p) return vim.loop.fs_stat(p) ~= nil end

local function is_git_repo(path)
    if fs_exists(path .. "/.git") then return true end
    if vim.system then
        local r = vim.system({ "git", "-C", path, "rev-parse", "--is-inside-work-tree" }, { text = true }):wait()
        return (r.code == 0) and r.stdout:match("true")
    else
        return vim.fn.system({ "git", "-C", path, "rev-parse", "--is-inside-work-tree" }):match("true") ~= nil
    end
end

function vim.d.projects:find_marker(path)
    for _, f in ipairs(self.markers) do
        if fs_exists(path .. "/" .. f) then return f end
    end
    return nil
end

function vim.d.projects:check(path, cb)
    local marker = self:find_marker(path)
    local git = is_git_repo(path)
    if git or marker then
        cb(path, { is_git = git, marker = marker })
    end
end

function vim.d.projects:prompt_yes_no(msg)
    local choice = vim.fn.confirm(msg, "&Yes\n&No", 2) -- 1=yes, 2=no
    return choice == 1
end

local function get_directory_name()
    local dir = vim.fn.getcwd()
    local i = #dir
    while i > 1 do
        local ch = dir:sub(i, i)
        if ch == "\\" or ch == "/" then
            return dir:sub(i + 1, #dir)
        end
        i = i - 1
    end
end

function vim.d.projects:add_project()
    local name = vim.fn.input({ prompt = "Project name: ", default = get_directory_name() })
    if not name then
        return
    end
    local cwd = vim.fn.getcwd()
    table.insert(vim.d.projects.paths, {
        name = name,
        path = cwd
    })
end

function vim.d.projects:write_projects()
    local projects_path = vim.env.HOME .. "/.local/share/nvim/"
    vim.system { 'mkdir', "-p", projects_path }
    local lines = {}
    for i = 1, #vim.d.projects.paths do
        local project = vim.d.projects.paths[i]
        table.insert(lines, string.format([['%s' '%s']], project.name, project.path))
    end
    local content = table.concat(lines, "\n")
    local file = io.open(projects_path .. "projects", "w")
    if file then
        file:write(content)
        file:close()
    end
end

function vim.d.projects.read_projects()
    local projects_path = vim.env.HOME .. "/.local/share/nvim/"
    vim.system { 'mkdir', "-p", projects_path }
    local file = io.open(projects_path .. "projects", "r")
    if not file then
        return
    end

    local content = file:read("*a")
    local it = 1

    while it < #content do
        local start = 1

        local ch = content:sub(it, it)

        if ch == "'" then
            it = it + 1
            local name_start = it
            while it < #content and content:sub(it, it) ~= "'" do
                it = it + 1
            end
            if it > #content then
                error("Invalid project name. unexpected EOF")
            end

            local name = content:sub(name_start, it - 1)

            it = it + 1
            while it < #content and content:sub(it, it) == " " do
                it = it + 1
            end
            if it > #content then
                error("Invalid whitespace. unexpected EOF")
            end

            if ch == "'" then
                it = it + 1
                local path_start = it
                while it < #content and content:sub(it, it) ~= "'" do
                    it = it + 1
                end
                if it > #content then
                    error("Invalid project path. unexpected EOF")
                end
                it = it + 1

                local path = content:sub(path_start, it - 1)

                table.insert(vim.d.projects.paths, {
                    name = name,
                    path = path
                })
            end
        end

        if ch == "\r" then it = it + 1 end
        ch = content:sub(it, it)
        if ch == "\n" then it = it + 1 end
    end

    file:close()
end

vim.api.nvim_create_autocmd("VimEnter", {
    group = vim.api.nvim_create_augroup("Projects", { clear = true }),
    callback = function()
        vim.d.read_projects()
    end,
    nested = true,
})
