local tab_size = 2

vim.opt.showmatch = true
vim.opt.shiftwidth = tab_size 
vim.opt.tabstop = tab_size
vim.opt.softtabstop = tab_size 
vim.opt.expandtab = true

vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.autoindent = true
vim.opt.number = true
vim.opt.wildmode = "longest,list"
vim.opt.cc = "120"

vim.g.mouse = "v"
vim.g.mapleader = ","

vim.cmd [[ filetype plugin indent on ]]
vim.cmd [[ filetype plugin on ]]
vim.cmd [[ syntax on ]]

vim.opt.mouse = "a"
vim.opt.encoding = "utf-8"
vim.opt.clipboard = "unnamedplus"
vim.opt.ttyfast = true
vim.opt.swapfile = true
vim.opt.backupdir = os.getenv("HOME") .. "/.cache/vim"

vim.keymap.set('n', '<leader>w', ':w<cr>')
vim.keymap.set('n', '<leader>q', ':q!<cr>')
vim.keymap.set('n', '<leader>c', ':noh<cr>')

vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')

vim.keymap.set('n', '<C-x>2', ':split<cr>')
vim.keymap.set('n', '<C-x>3', ':vsplit<cr>')
