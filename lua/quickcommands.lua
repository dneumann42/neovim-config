local seen = {}
local runtime_filetypes = vim.api.nvim_get_runtime_file("ftplugin/*.vim", true)

local filetypes = {}

for _, path in ipairs(runtime_filetypes) do
  local ft = vim.fn.fnamemodify(path, ":t:r")
  if not seen[ft] then
    seen[ft] = true
    table.insert(filetypes, ft)
  end
end

local M = {}

function M.change_filetype()
  vim.ui.select(filetypes, { prompt = "Select filetype" }, function(ft)
    if not ft then
      return
    end
    vim.cmd("set filetype=" .. ft)
  end)
end

vim.api.nvim_create_user_command("ChangeFiletype", M.change_filetype, {})
