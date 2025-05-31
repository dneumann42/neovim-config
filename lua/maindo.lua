local bindings = require("config/keybindings")

local M = {}


function M.find_execution_name()
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0) -- {line, col}
  local current_line = cursor[1]

  for line = current_line, 1, -1 do
    local content = vim.api.nvim_buf_get_lines(bufnr, line - 1, line, false)[1]
    if content then
      local heading = content:match("^%s*#+%s*(.+)$")
      if heading then
        return heading
      end
    end
  end
  return nil
end

function M.execute()
  local name = M.find_execution_name()

  local full_path = vim.api.nvim_buf_get_name(0)
  local relative_path = vim.fn.fnamemodify(full_path, ":.")

  if name then
    local cmd = string.format(
      'maindo -e:"%s" %s', name, relative_path
    )
    vim.fn.system(cmd .. " < /dev/null")
    vim.cmd(":e")
  end
end

vim.api.nvim_create_user_command("MaindoExecute", M.execute, {})

vim.keymap.set('n', bindings.maindo.execute, ':MaindoExecute<cr>')

local function on_markdown_save()
  M.execute()
end

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.md",
  callback = on_markdown_save,
})

return M
