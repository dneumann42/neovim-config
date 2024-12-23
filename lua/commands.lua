local Path = require("plenary.path")
local context_manager = require("plenary.context_manager")
local with, open = context_manager.with, context_manager.open
local core = require("lib.core")
local Terminal = require("lib.terminal")

local M = {}

function M.read_commands_file(path)
  path = Path:new(path)
  if not path:exists() then
    return {}
  end
  return with(open(path:expand()), function(reader)
    return vim.tbl_filter(function(x) return x ~= "" end, core.split_lines(reader:read("*a")))
  end)
end

function M.write_commands_file(path, commands)
  path = Path:new(path)
  local contents = table.concat(commands or {}, "\n")
  with(open(path:expand(), "w"), function(writer)
    writer:write(contents)
  end)
end

function M.select_command(commands, on_select)
  vim.ui.select(commands, { prompt = "Select command" }, function(contents, idx)
    if on_select and contents and idx then
      on_select(contents, idx)
    end
  end)
end

function M.new_command(commands, on_new)
  vim.ui.input({ prompt = "command" }, function(cmd)
    if not cmd then
      return
    end
    table.insert(commands, 1, cmd)
    if on_new then
      on_new(commands)
    end
  end)
end

function M.get_first_terminal()
  local terminal_chans = {}
  for _, chan in pairs(vim.api.nvim_list_chans()) do
    if chan["mode"] == "terminal" and chan["pty"] ~= "" then
      table.insert(terminal_chans, chan)
    end
  end
  table.sort(terminal_chans, function(left, right)
    return left["buffer"] < right["buffer"]
  end)
  if #terminal_chans == 0 then
    return nil
  end
  return terminal_chans[1]["id"]
end

function M.send_to_terminal(terminal_chan, term_cmd_text)
  vim.api.nvim_chan_send(terminal_chan, term_cmd_text .. "\n")
end

function M.send_command_to_terminal(command)
  local terminal = M.get_first_terminal()
  if not terminal then
    Terminal.toggle_terminal()
    terminal = M.get_first_terminal()
    if terminal == nil then
      return nil
    end
  end

  M.send_to_terminal(terminal, command)
end

function M.run_command(command)
  M.send_command_to_terminal(command)
end

function M.new_and_run_command(full_path, commands)
  M.new_command(commands, function(cmds)
    M.write_commands_file(full_path, cmds)
    M.run_command(cmds[1] or "")
  end)
end

function M.run(select)
  local path = Path:new(".commands")
  local full_path = path:expand()
  if not path:exists() then
    with(open(path:expand(), "w"), function(writer)
      writer:write("")
    end)
  end

  local commands = M.read_commands_file(full_path)

  if #commands == 0 then
    return M.new_and_run_command(full_path, commands)
  end

  if select then
    M.select_command(commands, function(cmd, idx)
      table.remove(commands, idx)
      table.insert(commands, cmd)
      M.write_commands_file(full_path, commands)
      M.run_command(commands[1])
    end)
    return
  end

  M.run_command(commands[1])
end

function M.swap()
  M.run(true)
end

vim.api.nvim_create_user_command("SelectCommand", function() M.run(true) end, {})
vim.api.nvim_create_user_command("RunCommand", function() M.run() end, {})
vim.api.nvim_create_user_command("NewCommand", function()
  local path = Path:new(".commands"):expand()
  M.new_and_run_command(path, M.read_commands_file(path) or {})
end, {})

local bindings = require('config.keybindings')
vim.keymap.set('n', bindings.commands.run, ':RunCommand<cr>')
vim.keymap.set('n', bindings.commands.select, ':SelectCommand<cr>')
vim.keymap.set('n', bindings.commands.new, ':NewCommand<cr>')

vim.keymap.set('t', bindings.commands.run, '<C-\\><C-n>:RunCommand<cr>i')
vim.keymap.set('t', bindings.commands.select, '<C-\\><C-n>:SelectCommand<cr>i')
vim.keymap.set('t', bindings.commands.new, '<C-\\><C-n>:NewCommand<cr>i')

return {
  read = M.read_commands_file,
  write = M.write_commands_file,
  select = M.select_command,
}
