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

--- Require but without cache.
--- @param module Module name
vim.my.require_load = function(mod)
  package.loaded[mod] = nil
  return require(mod)
end

