local M = {}

function M.split_lines(input)
  local lines = {}
  for line in input:gmatch("([^\n]*)\n?") do
    table.insert(lines, line)
  end
  return lines
end

return M
