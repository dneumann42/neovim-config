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
