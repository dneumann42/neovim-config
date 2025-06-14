local M = {
  buffer = -1,
}

function M.is_open()
  if M.buffer == 0 then
    return false
  end
  local window_number = vim.fn.bufwinnr(M.buffer)
  return window_number >= 0
end

function M.add_buffer(id)
  table.insert(M.buffers, id)
  M.buffer = id
end

function M.new_buffer()
end

function M.set_terminal_statusline(custom_text)
  vim.b.term_statusline_text = custom_text or "Terminal"
  vim.opt_local.statusline = '%{b:term_statusline_text}'
end

function M.set_buffer_to_window(buffer_id, window_id)
  vim.api.nvim_win_set_buf(window_id, buffer_id)
end

function M.new_tab()
  if not M.is_open() then
    return false
  end
  vim.cmd("tabnew")
end

function M.toggle_terminal(size)
  if vim.fn.bufexists(M.buffer) == 0 then
    M.buffer = -1
  end

  if M.is_open() then
    vim.api.nvim_buf_delete(M.buffer, { force = true })
    return
  end

  if M.buffer < 0 then
    vim.cmd("botright split")
    vim.cmd("terminal")
    vim.cmd('startinsert')
    vim.cmd('resize ' .. (size or 15))
    M.buffer = vim.fn.bufnr("term://")
  else
    vim.cmd("botright split")
    vim.cmd('startinsert')
    vim.cmd("buffer " .. M.buffer)
    vim.cmd('resize ' .. (size or 15))
  end

  M.set_terminal_statusline("TERM (0 / 0)")
end

local opts = { noremap = true, silent = true }

local mapping = require("config.mappings")
vim.keymap.set('n', mapping.terminal.toggle, M.toggle_terminal, opts)
vim.keymap.set('t', mapping.terminal.toggle, M.toggle_terminal, opts)
vim.keymap.set('t', '<C-x>n', M.new_tab, opts)

return M
