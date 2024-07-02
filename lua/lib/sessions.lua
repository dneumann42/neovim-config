local M = {}

local cm = require("plenary.context_manager")

local function sessions_file_contents()
  local nvim_projects = os.getenv("HOME") .. "/.config/nvim/sessions.lua"
  local f = io.open(nvim_projects, "r")

  if not f then
    f = io.open(nvim_projects, "w")
    if f then
      f:write [[return {}]]
      f:close()
      f = io.open(nvim_projects, "r")
    end
  end

  if f then
    local contents = f:read("*a")
    f:close()
    local value, ok = pcall(function()
      return load(contents, "nvim", "t", _G)()
    end)
    if ok then
      return value
    end
  end
end

function M.save_session(name)
  for k, v in pairs(_G) do
    print(k, v)
  end
end

function M.add_project()
  local sessions = sessions_file_contents()
end

return M
