--- Register a callback to be called when a file changes.
--- @param callback fun(file: string, event: string) Called with the file path and event name.
--- @return number augroup_id The autocmd group ID (pass to vim.api.nvim_del_augroup_by_id to unregister).
vim.my.on_file_change = function(callback)
  local group = vim.api.nvim_create_augroup("settings_file_change_" .. tostring(callback), { clear = true })
  vim.api.nvim_create_autocmd({ "BufWritePost", "FileChangedShellPost" }, {
    group = group,
    callback = function(args)
      callback(args.file, args.event)
    end,
  })
  return group
end

--- Print a value in a syntax-highlighted floating window.
vim.my.print = function(value)
  local lines = vim.split("return " .. vim.inspect(value), "\n", { plain = true })
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].filetype = "lua"
  vim.treesitter.start(buf, "lua")

  local width = 0
  for _, line in ipairs(lines) do width = math.max(width, #line) end
  width = math.min(width, vim.o.columns - 4)
  local height = math.min(#lines, vim.o.lines - 4)
  vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
  })
  vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = buf, nowait = true })
end

--- Require but without cache.
--- @param module Module name
vim.my.require_load = function(mod)
  package.loaded[mod] = nil
  return require(mod)
end

