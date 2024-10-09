local M = {}

function M.split_lines(input)
  local lines = {}
  for line in input:gmatch("([^\n]*)\n?") do
    table.insert(lines, line)
  end
  return lines
end

local function get_download_command(out)
  if vim.fn.executable('curl') == 1 then
    return "curl '{}' -o " .. out
  end
  if vim.fn.executable('wget') == 1 then
    return "wget '{}' -o " .. out
  end
  error("Thememanager requires 'curl' or 'wget'")
end

function M.download(url, out)
  local front = get_download_command(out)
  vim.cmd("!" .. front:gsub("{}", url))
end

return M
