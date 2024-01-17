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
map('n', '<leader>/', ':Telescope live_grep<cr>')
