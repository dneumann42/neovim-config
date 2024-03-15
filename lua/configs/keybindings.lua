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
map('n', '<C-_>', ':CommentToggle<cr>')
map('v', '<C-_>', ':CommentToggle<cr>')
map('i', '<C-_>', '<esc>:CommentToggle<cr>')

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

-- Wikid

require("base")

local function do_compile(cmd)
  vim.cmd [[ :ToggleTerm direction="float"<cr> ]]
  local term = require("toggleterm")
  term.exec(cmd, vim.v.count)
end

function _G.compile()
  local path = vim.loop.cwd() .. '/' .. '.nvim_compile_command'
  if file_exists(path) then
    do_compile(read_file(path))
  else
    vim.ui.input({ prompt = 'Command: ' }, function(inp)
      if inp then
        write_file(path, inp)
        do_compile(inp)
      end
    end)
  end
end

map('n', '<f5>', ':lua compile()<cr>')
vim.api.nvim_set_keymap('t', '<f5>', [[ <C-\><C-n>:q<cr>:lua compile()<cr> ]], { noremap = true })
