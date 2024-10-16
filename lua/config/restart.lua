local path = require("plenary.path")
local job = require('plenary.job')

local function create_restart_script()
  local config_path = vim.fn.stdpath("config")
  local script_path = path:new(config_path, "restart.sh")

  if script_path:exists() then
    return script_path:absolute()
  end

  local content = [[
#!/bin/bash
nvim_pid=$(pgrep nvim)
kill $nvim_pid
nvim]]

  script_path:write(content, 'w')

  job:new({
    command = 'chmod',
    args = { '+x', script_path:absolute() },
    on_exit = function(j, r)
      vim.print(r, j:result())
    end
  }):sync()

  return script_path:absolute()
end

local function restart_neovim()
  local script_path = create_restart_script()
  -- vim.cmd('wa')
  vim.fn.system(script_path)
end

vim.api.nvim_create_user_command('RestartNvim', restart_neovim, {})
