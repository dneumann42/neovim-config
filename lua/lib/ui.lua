local M = {}

function M.toggle_drawer_buffer(opts)
  opts = opts or {}
  opts.anchor = opts.anchor or "bottom"
  opts.size = opts.size or 25
  opts.startinsert = opts.startinsert or false
  assert(opts.name, "buffer name is required")

  local split = opts.anchor == "right" and "vsplit " or "split "
  local resize = opts.anchor == "right" and "vertical resize " or "resize "

  local buffer_number = vim.fn.bufnr(opts.name)
  if buffer_number == -1 then
    vim.cmd("botright " .. split .. (opts.new_buffer and opts.name or ""))
    if opts.command then
      vim.cmd(opts.command)
    end
    vim.cmd(resize .. opts.size)
    if opts.startinsert then
      vim.cmd("startinsert")
    end
    if opts.clear then
      vim.api.nvim_buf_set_lines(0, 0, -1, true, {})
    end
    if opts.read_only then
      vim.opt_local.readonly = true
    end
    if opts.on_new_buffer then
      opts.on_new_buffer(buffer_number)
    end
    return
  end
  local window_number = vim.fn.bufwinnr(buffer_number)
  if window_number == -1 then
    vim.cmd("botright " .. split)
    vim.cmd("buffer " .. buffer_number)
    vim.cmd(resize .. opts.size)
    if opts.startinsert then
      vim.cmd("startinsert")
    end
  else
    vim.cmd(window_number .. "close")
  end
end

return M
