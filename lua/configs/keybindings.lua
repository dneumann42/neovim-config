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

-- explorer
map('n', '<leader>e', ':NvimTreeToggle<cr>')

map('n', '<C-l>', ':wincmd l<cr>')
map('n', '<C-h>', ':wincmd h<cr>')
map('n', '<C-j>', ':wincmd j<cr>')
map('n', '<C-k>', ':wincmd k<cr>')

-- commenting
map('n', '<c-/>', ':CommentToggle<cr>')

-- tabs
map('n', '<leader>T', ':tabnew<cr>')
map('n', '<leader>tn', ':tabnext<cr>')
map('n', '<leader>tp', ':tabprevious<cr>')
map('n', '<leader>tc', ':tabclose<cr>')

map('n', '<leader>q', ':qa<cr>')
map('n', '<leader>w', ':w<cr>')
