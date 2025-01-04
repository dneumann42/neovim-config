local M = {}

local UI = require("lib.ui")

local buffer_number = -1

function M.toggle_terminal(size)
  if buffer_number == -1 then
    UI.toggle_drawer_buffer {
      name = "term://",
      command = "terminal",
      startinsert = true,
      size = size or 15,
      on_new_buffer = function(buf)
        buffer_number = buf
        vim.print({ buf })
      end
    }
  else
    UI.toggle_drawer_buffer_number({
      startinsert = true,
      size = size or 15,
    }, buffer_number)
  end
end

vim.api.nvim_set_keymap('n', '<SPACE>t', ':lua require("lib.terminal").toggle_terminal()<CR>',
  { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-SPACE>', ':lua require("lib.terminal").toggle_terminal()<CR>',
  { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<C-SPACE>', '<C-\\><C-n>:lua require("lib.terminal").toggle_terminal()<CR>',
  { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<C-\\><C-q>', '<C-\\><C-n>:q<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<C-\\>q', '<C-\\><C-n>:q<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<M-CR>', '', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<C-\\><C-q>', '<C-\\><C-n>:q<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-\\>q', '<C-\\><C-n>:q<cr>', { noremap = true, silent = true })

return M
