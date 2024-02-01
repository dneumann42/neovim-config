local settings_template = {
  is_transparent = false,
  colorscheme = "melange",
  tabs = 2,
  wiki = "~/.wiki",
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

local SETTINGS_PATH = 'lua/settings'

local function get_save_path()
  local p = vim.fn.stdpath "config"
  return fmt("%s/%s/%s", p, SETTINGS_PATH, "default.lua"), "w"
end

local function get_theme_path()
  local p = vim.fn.stdpath "config"
  return fmt("%s/%s/%s", p, SETTINGS_PATH, "theme.lua"), "w"
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

local M = {
  save = save_settings,
  listeners = {},
}

function M.on_key_change(key, callback)
  M.listeners[key] = M.listeners[key] or {}
  table.insert(M.listeners[key], callback)
end

function M.get(idx)
  return require("settings/default")[idx]
end

function M.set(idx, v, noemit)
  local settings = require("settings/default")
  settings[idx] = v

  if not noemit then
    for _, call in ipairs(M.listeners[idx] or {}) do
      call(idx, v)
    end
  end

  save_settings(settings)
end

local watchers = {}
local file_times = {}

local function last_write_time(path)
  local f = io.popen("stat -c %Y \"" .. path .. "\"")
  if f then
    local v = f:read()
    f:close()
    return v
  end
end

local function add_watcher(path, callback)
  watchers[path] = watchers[path] or {}
  table.insert(watchers[path], callback)
  file_times[path] = last_write_time(path)
end

local timer = vim.loop.new_timer()
timer:start(1000, 1000, vim.schedule_wrap(function()
  for path, calls in pairs(watchers) do
    local now = last_write_time(path)
    if now ~= file_times[path] then
      file_times[path] = now
      for _, c in ipairs(calls) do
        c()
      end
    end
  end
end))

add_watcher(get_save_path(), function()
  local code_file = io.open(get_save_path(), "r")
  local code = "{}"
  if code_file then
    code = code_file:read("*a")
    code_file:close()
  end
  local settings = loadstring(code)()
  for k, v in pairs(settings) do
    for _, c in ipairs(M.listeners[k] or {}) do
      c(k, v)
    end
  end
end)

add_watcher(get_theme_path(), function()
  local f = io.open(get_theme_path(), "r")
  if f then
    local contents = f:read("*a")
    local _, _, theme = contents:find('"colorscheme ([%w-_]+)"')
    if theme and type(theme) == 'string' then
      vim.settings.set("colorscheme", theme)
    end
    f:close()
  end
end)

return M
