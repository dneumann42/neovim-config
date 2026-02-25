local settings_mt = { }

vim.my.settings = setmetatable(require("config/settings"), settings_mt)

vim.my.on_file_change(function(file, event)
  if not file:match("config/settings%.lua$") then return end
  vim.my.settings = setmetatable(vim.my.require_load("config/settings"), settings_mt)
  require("modules").reload_all()
end)

return vim.my.settings

