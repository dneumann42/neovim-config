local Path = require("plenary.path")
local Ctx = require("plenary.context_manager")
local open, with = Ctx.open, Ctx.with

local compile_path = vim.loop.cwd() .. '/' .. '.nvim_compile_command'
local function do_compile(cmd)
  vim.cmd [[ :ToggleTerm direction="float"<cr> ]]
  local term = require("toggleterm")
  term.exec(cmd, vim.v.count)
end

local function read_compile_file_lines()
  local lines = {}
  local path = Path:new(compile_path)

  if not path:exists() then
    path:write("", "w")
    path:close()
  end

  local contents = with(open(path), function(reader)
    return reader:read("*a")
  end)

  for s in contents:gmatch("[^\r\n]+") do
    table.insert(lines, s)
  end

  return lines
end

function _G.new_compile()
  local path = Path:new(compile_path)
  vim.ui.input({ prompt = 'New compile command: ' }, function(inp)
    if inp then
      local lines = read_compile_file_lines()
      table.insert(lines, 1, inp)
      path:write(table.concat(lines, "\n"), "w")
      path:close()
      do_compile(inp)
    end
  end)
end

function _G.switch_command()
  local lines = read_compile_file_lines()
  local path = Path:new(compile_path)
  vim.ui.select(lines, { prompt = "Compile command: " }, function(opt)
    if opt then
      for i = 1, #lines do
        if lines[i] == opt then
          table.remove(lines, i)
          break
        end
      end
      table.insert(lines, 1, opt)
      path:write(table.concat(lines, "\n"), "w")
      path:close()
      do_compile(opt)
    end
  end)
end

function _G.compile()
  if Path:new(compile_path):exists() then
    local lines = read_compile_file_lines()
    if #lines > 0 then
      local cmd = lines[1]
      do_compile(cmd)
    end
  else
    new_compile()
  end
end
