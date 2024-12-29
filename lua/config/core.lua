vim.cmd.colorscheme("catppuccin")

local tab_size = 2

vim.opt.showmatch = true
vim.opt.shiftwidth = tab_size
vim.opt.tabstop = tab_size
vim.opt.softtabstop = tab_size
vim.opt.expandtab = true

-- custom tab size autocommands
vim.cmd [[
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
