local settings_template = {
  is_transparent = false,
  colorscheme = "melange",
}

local fmt = string.format

local function file_exists(path)
  local f = io.open(path)
  if f ~= nil then
    f:close()
    return true
  end
  return false
end

local function get_save_path()
  local p = vim.fn.stdpath "config"
  return fmt("%s/%s", p, "lua/settings/default.lua"), "w"
end

local function save_settings(new_settings)
  local f = io.open(get_save_path())
  if f then
    f:write(fmt("return %s", vim.inspect(new_settings)))
    f:close()
  else
    error("Failed to find default settings")
  end
end

if not file_exists(get_save_path()) then
  save_settings(settings_template)
end

return setmetatable({
  save = save_settings,
}, {
    __index = function(self, idx)
      return require("settings/default")[idx]
    end,

    __newindex = function(self, idx, v)
      local settings = require("settings/default")
      settings[idx] = v
      save_settings(settings)
    end
})
