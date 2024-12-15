local M = {}

function M.toggle_terminal(size)
  require("lib.ui").toggle_drawer_buffer {
    name = "term://",
    command = "terminal",
    startinsert = true,
    size = size or 15,
  }
end

vim.api.nvim_set_keymap('n', '<SPACE>t', ':lua require("lib.terminal").toggle_terminal()<CR>',
  { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-SPACE>', ':lua require("lib.terminal").toggle_terminal()<CR>',
  { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<C-SPACE>', '<C-\\><C-n>:lua require("lib.terminal").toggle_terminal()<CR>',
  { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<C-\\><C-q>', '<C-\\><C-n>:q<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<C-\\>q', '<C-\\><C-n>:q<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-\\><C-q>', '<C-\\><C-n>:q<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-\\>q', '<C-\\><C-n>:q<cr>', { noremap = true, silent = true })

return M
