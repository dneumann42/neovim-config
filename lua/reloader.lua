local config_dir = vim.env.XDG_CONFIG_HOME

local function reload_configs()
  local scan = require('plenary.scandir')
  local paths = scan.scan_dir(
    vim.fn.expand(config_dir .. "/nvim/lua/plugins"),
    { hidden = true, depth = 2 })

  local configs = {}

  for i = 1, #paths do
    paths[i] = paths[i]
        :gsub(config_dir, "")
        :gsub("/nvim/lua/", "")
        :gsub(".lua", "")
    local plugs = require(paths[i])
    for pi = 1, #plugs do
      local v = plugs[pi]
      if type(v) == "table" then
        if v.config then
          table.insert(configs, {
            name = v[1],
            config = v.config
          })
        end
      end
    end
  end

  for i = 1, #configs do
    configs[i].config()
  end
end

vim.api.nvim_create_user_command("ReloadConfigs", reload_configs, {})
