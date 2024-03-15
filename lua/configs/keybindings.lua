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

require("base")

-- COMPILATION COMMAND

local compile_path = vim.loop.cwd() .. '/' .. '.nvim_compile_command'
local function do_compile(cmd)
  vim.cmd [[ :ToggleTerm direction="float"<cr> ]]
  local term = require("toggleterm")
  term.exec(cmd, vim.v.count)
end

local function read_compile_file_lines()
  local lines = {}
  local contents = read_file(compile_path)
  for s in contents:gmatch("[^\r\n]+") do
    table.insert(lines, s)
  end
  return lines
end

function _G.new_compile()
  vim.ui.input({ prompt = 'New compile command: ' }, function(inp)
    if inp then
      local lines = read_compile_file_lines()
      table.insert(lines, 1, inp)
      write_file(compile_path, table.concat(lines, "\n"))
      do_compile(inp)
    end
  end)
end

function _G.switch_command()
  local lines = read_compile_file_lines()
  vim.ui.select(lines, { prompt = "Compile command: " }, function(opt)
    if opt then
      for i = 1, #lines do
        if lines[i] == opt then
          table.remove(lines, i)
          break
        end
      end
      table.insert(lines, 1, opt)
      write_file(compile_path, table.concat(lines, "\n"))
      do_compile(opt)
    end
  end)
end

function _G.compile()
  if file_exists(compile_path) then
    local lines = read_compile_file_lines()
    if #lines > 0 then
      local cmd = lines[1]
      do_compile(cmd)
    end
  else
    new_compile()
  end
end

map('n', '<f5>', ':lua compile()<cr>')
map('n', '<f6>', ':lua new_compile()<cr>')
map('n', '<f4>', ':lua switch_command()<cr>')

vim.api.nvim_set_keymap('t', '<f5>', [[ <C-\><C-n>:q<cr>:lua compile()<cr> ]], { noremap = true })
vim.api.nvim_set_keymap('t', '<f6>', [[ <C-\><C-n>:q<cr>:lua new_compile()<cr> ]], { noremap = true })
vim.api.nvim_set_keymap('t', '<f4>', [[ <C-\><C-n>:q<cr>:lua switch_command()<cr> ]], { noremap = true })
