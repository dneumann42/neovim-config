local settings = require("settings")

local bindings = vim.d.settings.bindings

local function map(buf, mode, lhs, rhs)
    vim.keymap.set(mode, lhs, rhs, { buffer = buf, silent = true })
end

vim.g.mapleader = settings.mapleader

vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.clipboard:append("unnamedplus")

vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.autoindent = true
vim.opt.wildmode = "longest,list"
vim.opt.syntax = "on"

function vim.d.set_tab_size(size)
    vim.o.tabstop = size
    vim.o.shiftwidth = size
    vim.o.softtabstop = size
    vim.o.expandtab = true
end

vim.d.set_tab_size(settings.tab_size)

vim.api.nvim_create_user_command("TabSize", function(opts)
  local n = tonumber(opts.args)
  if not n then error("TabSize expects a number") end
  vim.d.set_tab_size(n)
end, { nargs = 1, desc = "Set tab/shift/softtab to size and expandtab" })

-- splits and unsplits
vim.keymap.set('n', bindings.split_horizontal, ':split<cr>')
vim.keymap.set('n', bindings.split_vertical, ':vsplit<cr>')
vim.keymap.set('n', bindings.split_onlysplit, ':on<cr>')
vim.keymap.set('n', bindings.split_unsplit, ':q!<cr>')

-- Auto pairs
local ps = {
    ["("] = ")",
    ["["] = "]",
    ["{"] = "}",
    ['"'] = '"',
    ["'"] = "'",
    ["`"] = "`",
}

for open, close in pairs(ps) do
    vim.keymap.set("i", open, function()
        return open .. close .. "<Left>"
    end, { expr = true })

    -- close char should just skip over if already there
    vim.keymap.set("i", close, function()
        local col = vim.fn.col(".")
        local line = vim.fn.getline(".")
        if line:sub(col, col) == close then
            return "<Right>"
        else
            return close
        end
    end, { expr = true })
end

-- LSP config

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local buf = args.buf
        local client = vim.lsp.get_client_by_id(args.data and args.data.client_id or 0)
        if not client then
            client = (vim.lsp.get_clients({ bufnr = buf })[1])
        end
        if not client or client.name == "nimlangserver" then return end

        map(buf, "n", bindings.lsp_definition, vim.lsp.buf.definition)
        map(buf, "n", bindings.lsp_declaration, vim.lsp.buf.declaration)
        map(buf, "n", bindings.lsp_references, vim.lsp.buf.references)
        map(buf, "n", bindings.lsp_implementation, vim.lsp.buf.implementation)
        map(buf, "n", bindings.lsp_hover, vim.lsp.buf.hover)
        map(buf, "n", bindings.lsp_signature_help, vim.lsp.buf.signature_help)
        map(buf, "n", bindings.lsp_rename, vim.lsp.buf.rename)
        map(buf, "n", bindings.lsp_code_action, vim.lsp.buf.code_action)
        map(buf, "n", bindings.lsp_document_symbol, vim.lsp.buf.document_symbol)
        map(buf, "n", bindings.lsp_document_workspace, function() vim.lsp.buf.workspace_symbol("") end)
        map(buf, "n", bindings.lsp_format, function() vim.lsp.buf.format({ async = true }) end)

        if client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
            vim.lsp.inlay_hint.enable(true)
        end
    end,
})


local function root_pattern(patterns)
    return function(startpath)
        local path = startpath or vim.api.nvim_buf_get_name(0)
        local dir = path ~= "" and vim.fs.dirname(path) or vim.loop.cwd()
        return vim.fs.find(patterns, { upward = true, path = dir })[1] and
            vim.fs.dirname(vim.fs.find(patterns, { upward = true, path = dir })[1]) or vim.loop.cwd()
    end
end

local function start_server(opts)
    local root = opts.root_dir and opts.root_dir() or vim.loop.cwd()
    vim.lsp.start({
        name = opts.name,
        cmd = opts.cmd,
        root_dir = root,
        single_file_support = true,
        capabilities = vim.lsp.protocol.make_client_capabilities(),
        settings = opts.settings,
    })
end

local lua_root = root_pattern { ".git", ".stylua.toml" }
local ts_root = root_pattern { "tsconfig.json", "jsconfig.json", "package.json", ".git" }
local c_root = root_pattern { "compile_commands.json", "compile_flags.txt", ".git" }

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
    pattern = { "*.lua" },
    callback = function()
        start_server {
            name = "lua_ls",
            cmd = { "lua-language-server" },
            root_dir = lua_root,
            settings = {
                Lua = {
                    diagnostics = { globals = { "vim" } },
                    workspace = { checkThirdParty = false },
                    telemetry = { enable = false },
                    hint = { enable = true },
                },
            },
        }
    end,
})

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
    pattern = { "*.c", "*.h", "*.cpp", "*.cxx", "*.cc", "*.hpp", "*.hh", "*.m", "*.mm" },
    callback = function()
        start_server {
            name = "clangd",
            cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=never" },
            root_dir = c_root,
        }
    end,
})

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
    pattern = { "*.js", "*.jsx", "*.ts", "*.tsx" },
    callback = function()
        start_server {
            name = "tsserver",
            cmd = { "typescript-language-server", "--stdio" },
            root_dir = ts_root,
            settings = {
                typescript = { inlayHints = { includeInlayParameterNameHints = "all", includeInlayVariableTypeHints = true, includeInlayFunctionLikeReturnTypeHints = true } },
                javascript = { inlayHints = { includeInlayParameterNameHints = "all", includeInlayVariableTypeHints = true, includeInlayFunctionLikeReturnTypeHints = true } },
            },
        }
    end,
})

function vim.d.pick_user_command()
  local cmds = vim.api.nvim_get_commands({ builtin = false })
  local entries = {}
  for name, cmd in pairs(cmds) do
    local desc = cmd.desc or ""
    table.insert(entries, { name = name, cmd = cmd, display = name .. (desc ~= "" and (" — " .. desc) or ""), ordinal = name .. " " .. desc })
  end
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  pickers.new({}, {
    prompt_title = "User Commands",
    finder = finders.new_table({
      results = entries,
      entry_maker = function(e) return { value = e, display = e.display, ordinal = e.ordinal } end,
    }),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, map)
      local function run()
        local sel = action_state.get_selected_entry()
        if not sel then return end
        local name, cmd = sel.value.name, sel.value.cmd
        local nargs, args = cmd.nargs, ""
        if nargs ~= "0" then
          args = vim.fn.input(":" .. name .. " ")
          if nargs == "1" and args == "" then return end
        end
        actions.close(prompt_bufnr)
        vim.cmd(name .. (args ~= "" and (" " .. args) or ""))
      end
      map("i", "<CR>", run)
      map("n", "<CR>", run)
      return true
    end,
  }):find()
end

vim.api.nvim_create_user_command("PickUserCommand", function()
    vim.d.pick_user_command()
end, { nargs = 0, desc = "Pick a user define command" })
