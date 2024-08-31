local M = {}

-- Function to toggle the terminal
function M.toggle_terminal()
  local term_bufnr = vim.fn.bufnr("term://")

  if term_bufnr == -1 then
    vim.cmd("botright split")
    vim.cmd("terminal")
    vim.cmd("resize 15")
    vim.b.terminal_toggle = true
    vim.cmd("startinsert")
  else
    local term_winnr = vim.fn.bufwinnr(term_bufnr)

    if term_winnr == -1 then
      vim.cmd("botright split")
      vim.cmd("buffer " .. term_bufnr)
      vim.cmd("resize 15")
      vim.cmd("startinsert")
    else
      -- Terminal is visible, hide it
      vim.cmd(term_winnr .. "close")
    end
  end
end

-- Set up a keymap to toggle the terminal
vim.api.nvim_set_keymap('n', '<Leader>t', ':lua require("config/terminal").toggle_terminal()<CR>',
  { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<SPACE>t', ':lua require("config/terminal").toggle_terminal()<CR>',
  { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<C-\\><C-q>', '<C-\\><C-n>:q<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<C-\\>q', '<C-\\><C-n>:q<cr>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<C-\\><C-q>', '<C-\\><C-n>:q<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-\\>q', '<C-\\><C-n>:q<cr>', { noremap = true, silent = true })

return M
