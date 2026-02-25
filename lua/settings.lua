local settings_mt = { }

local settings = setmetatable(require("config/settings"), settings_mt)

vim.my.on_file_change(function(file, event)
  if not file:match("config/settings%.lua$") then return end
  settings = setmetatable(vim.my.require_load("config/settings"), settings_mt)
  require("modules").reload_all()
end)

return settings

