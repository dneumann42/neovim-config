local M = {
  buffer = -1
}

function M.toggle_terminal(size)
  if vim.fn.bufexists(M.buffer) == 0 then
    M.buffer = -1
  end

  if M.buffer >= 0 then
    local window_number = vim.fn.bufwinnr(M.buffer)
    if window_number >= 0 then
      vim.cmd("close")
      return
    end
  end

  if M.buffer == -1 then
    vim.cmd("botright split")
    vim.cmd("terminal")
    vim.cmd('startinsert')
    vim.cmd('resize ' .. (size or 15))
    M.buffer = vim.fn.bufnr("term://")
    return
  end

  if M.buffer >= 0 then
    vim.cmd("botright split")
    vim.cmd('startinsert')
    vim.cmd("buffer " .. M.buffer)
    vim.cmd('resize ' .. (size or 15))
  end
end

local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<C-SPACE>', M.toggle_terminal, opts)
vim.keymap.set('t', '<C-SPACE>', M.toggle_terminal, opts)

return M
