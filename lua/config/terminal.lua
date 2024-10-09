local M = {}

function M.toggle_terminal(size)
  size = size or 15
  local buffer_number = vim.fn.bufnr("term://")
  if buffer_number == -1 then
    vim.cmd("botright split")
    vim.cmd("terminal")
    vim.cmd("resize " .. tostring(size))
    vim.b.terminal_toggle = true
    vim.cmd("startinsert")
    return
  end
  local term_winnr = vim.fn.bufwinnr(buffer_number)
  if term_winnr == -1 then
    vim.cmd("botright split")
    vim.cmd("buffer " .. buffer_number)
    vim.cmd("resize 15")
    vim.cmd("startinsert")
  else
    vim.cmd(term_winnr .. "close")
  end
end

vim.api.nvim_set_keymap('n', '<leader>t', ':lua require("config/terminal").toggle_terminal()<CR>',
  { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<SPACE>t', ':lua require("config/terminal").toggle_terminal()<CR>',
  { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-SPACE>', ':lua require("config/terminal").toggle_terminal()<CR>',
  { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<C-SPACE>', '<C-\\><C-n>:lua require("config/terminal").toggle_terminal()<CR>',
  { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<C-\\><C-q>', '<C-\\><C-n>:q<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<C-\\>q', '<C-\\><C-n>:q<cr>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<C-\\><C-q>', '<C-\\><C-n>:q<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-\\>q', '<C-\\><C-n>:q<cr>', { noremap = true, silent = true })

return M
