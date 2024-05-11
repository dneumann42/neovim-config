local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

vim.g.mapleader = ','
vim.g.maplocalleader = ','

-- disable arrow keys
map('', '<up>', '<nop>')
map('', '<down>', '<nop>')
map('', '<left>', '<nop>')
map('', '<right>', '<nop>')

-- clear highlight
map('n', '<leader>c', ':nohl<cr>')

-- finding things
map('n', '<leader>/', ':Telescope live_grep<cr>')
map('n', '<leader>f', ':Telescope find_files<cr>')
map('n', '<leader>b', ':Telescope buffers<cr>')
map('n', '<leader>G', ':Git<cr>')

map('n', '<C-l>', ':wincmd l<cr>')
map('n', '<C-h>', ':wincmd h<cr>')
map('n', '<C-j>', ':wincmd j<cr>')
map('n', '<C-k>', ':wincmd k<cr>')

-- commenting
map('n', '<C-,>', ':CommentToggle<cr>')
map('v', '<C-,>', ':CommentToggle<cr>')
map('i', '<C-,>', '<esc>:CommentToggle<cr>')

-- tabs
map('n', '<leader>T', ':tabnew<cr>')
map('n', '<leader>tn', ':tabnext<cr>')
map('n', '<leader>tp', ':tabprevious<cr>')
map('n', '<leader>tc', ':tabclose<cr>')

map('n', '<leader>q', ':qa<cr>')
map('n', '<leader>w', ':w<cr>')

-- Emacs style splitting
map('n', '<C-x>1', ':only<cr>')
map('n', '<C-x>2', ':split<cr>')
map('n', '<C-x>3', ':vsplit<cr>')
map('n', '<C-x>0', ':x<cr>')

-- floaterm
map('n', '<C-x><space><space>', ':WikidDaily<cr>')

-- NvimTree
map('n', '<leader>nf', ':NvimTreeFindFile<cr>')
map('n', '<leader>e', ':NvimTreeToggle<cr>')

require("run-commands")

map('n', '<f5>', ':lua compile()<cr>')
map('n', '<f6>', ':lua new_compile()<cr>')
map('n', '<f4>', ':lua switch_command()<cr>')

map('t', '<f5>', [[ <C-\><C-n>:q<cr>:lua compile()<cr> ]], { noremap = true })
map('t', '<f6>', [[ <C-\><C-n>:q<cr>:lua new_compile()<cr> ]], { noremap = true })
map('t', '<f4>', [[ <C-\><C-n>:q<cr>:lua switch_command()<cr> ]], { noremap = true })
