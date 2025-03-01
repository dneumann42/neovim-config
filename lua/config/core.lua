vim.cmd.colorscheme("tokyonight")

local tab_size = 2

vim.opt.showmatch = true
vim.opt.shiftwidth = tab_size
vim.opt.tabstop = tab_size
vim.opt.softtabstop = tab_size
vim.opt.expandtab = true

-- custom tab size autocommands
vim.cmd [[
set clipboard+=unnamedplus
autocmd FileType cs setlocal shiftwidth=4 softtabstop=4 expandtab
]]

vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.autoindent = true
vim.opt.number = true
vim.opt.wildmode = "longest,list"

vim.cmd [[ filetype plugin indent on ]]
vim.cmd [[ filetype plugin on ]]
vim.cmd [[ syntax on ]]

vim.opt.mouse = "a"
vim.opt.encoding = "utf-8"
vim.opt.clipboard = "unnamedplus"
vim.opt.ttyfast = true
vim.opt.swapfile = true
vim.opt.backupdir = os.getenv("HOME") .. "/.cache/vim"

-- keeps the sign column visible so it doesn't jump around
vim.cmd [[ set scl=yes ]]

local bindings = require('config.keybindings')
vim.keymap.set('n', bindings.write, ':w<cr>')
vim.keymap.set('n', bindings.quit_all, ':qa!<cr>')
vim.keymap.set('n', bindings.quit, ':q!<cr>')
vim.keymap.set('n', bindings.clear_highlight, ':noh<cr>')

vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')

vim.keymap.set('n', bindings.split.horizontal, ':split<cr>')
vim.keymap.set('n', bindings.split.vertical, ':vsplit<cr>')
vim.keymap.set('n', '<C-x>1', ':on<cr>')

vim.cmd [[ au TextYankPost * silent! lua vim.highlight.on_yank() ]]

vim.cmd [[ au BufRead,BufNewFile *.asha set filetype=asha ]]
vim.cmd [[ au BufRead,BufNewFile *.owl set filetype=owl ]]
vim.cmd [[ au BufRead,BufNewFile vifmrc set filetype=vim ]]

vim.keymap.set('n', bindings.tab.new, ':tabnew<cr>')
vim.keymap.set('n', bindings.tab.next, ':tabnext<cr>')
vim.keymap.set('n', bindings.tab.prev, ':tabprevious<cr>')
vim.keymap.set('n', bindings.tab.close, ':tabclose<cr>')

-- make script executable and reload
vim.api.nvim_create_user_command("Executable", ":!chmod +x %", {})

local function wrap_lines_in_quotes(args)
  for line = args.line1, args.line2 do
    local content = vim.fn.getline(line)
    vim.fn.setline(line, '"' .. content .. '"')
  end
end

vim.api.nvim_create_user_command("QuoteLines", wrap_lines_in_quotes, { nargs = 0, range = true })

local lastplace = vim.api.nvim_create_augroup("LastPlace", {})
vim.api.nvim_clear_autocmds({ group = lastplace })
vim.api.nvim_create_autocmd("BufReadPost", {
  group = lastplace,
  pattern = { "*" },
  desc = "Remember last cursor place",
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})
