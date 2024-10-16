local M = {}

local function show_panel_at_cursor(text)
  -- Get current window and cursor position
  local win = vim.api.nvim_get_current_win()
  local cursor = vim.api.nvim_win_get_cursor(win)
  local row, col = cursor[1], cursor[2]

  local lines = vim.split(text, "\n")
  local w = 0
  for _, v in ipairs(lines) do
    w = math.max(w, #v)
  end

  -- Create a buffer for the floating window
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, true, lines)

  -- Set up floating window options
  local opts = {
    relative = "win",
    bufpos = {
      row,
      col,
    },
    col = col + 2,
    width = w,
    height = #lines,
    style = "minimal",
    border = "single"
  }

  -- Create the floating window
  local float_win = vim.api.nvim_open_win(buf, false, opts)

  -- Close the floating window when cursor moves
  vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
    callback = function()
      if vim.api.nvim_win_is_valid(float_win) then
        vim.api.nvim_win_close(float_win, true)
      end
    end,
    once = true
  })
end

-- Example usage
vim.api.nvim_create_user_command("ShowPanel", function()
  show_panel_at_cursor("This is a test panel\nwith multiple lines")
end, {})

local function get_visual_selection()
  local vstart = vim.fn.getpos("'<")
  local vend = vim.fn.getpos("'>")
  local line_start = vstart[2]
  local line_end = vend[2]
  local lines = vim.fn.getline(line_start, line_end)
  if type(lines) == "string" then
    return lines
  end
  return table.concat(lines, "\n")
end

function M.global_search(size)
  require("lib.ui").toggle_drawer_buffer {
    name = "<global_search>",
    new_buffer = true,
    size = size or 35,
    anchor = "right",
    clear = true,
    on_new_buffer = function(_buffer_number)
      vim.cmd("setlocal nonumber norelativenumber")
    end
  }
end

function M.eval_function()
  local cur_line = vim.api.nvim_win_get_cursor(0)[1]
  local start_line = vim.fn.search("^function", "bnW")
  local end_line = vim.fn.search("^end", "nW")

  if start_line == 0 or end_line == 0 or cur_line < start_line or cur_line > end_line then
    return nil
  end

  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  local para = table.concat(lines, "\n")

  M.eval(para)
end

function M.eval(code)
  local ok, val = pcall(function()
    return load(code, "main", "t", _G)()
  end)
  if not ok then
    local ok2, val2 = pcall(function()
      local lua = "return (" .. code .. ")"
      return load(lua, "main", "t", _G)()
    end)
    if not ok2 then
      show_panel_at_cursor(vim.inspect(val))
    else
      return val2
    end
  end
  return val
end

function M.eval_buffer()
  local lines = vim.api.nvim_buf_get_lines(0, 0, vim.api.nvim_buf_line_count(0), false)
  local content = table.concat(lines, "\n")

  local v = M.eval(content)
  if v ~= nil then
    show_panel_at_cursor(vim.inspect(v))
  end

  require("fidget").notify("evaluated buffer.", nil, {})
end

function M.eval_selection()
  local vis = get_visual_selection()
  local result = M.eval(vis)
  show_panel_at_cursor(vim.inspect(result))
end

-- Example usage
vim.api.nvim_create_user_command("GetSelection", function()
  local selection = get_visual_selection()
end, { range = true })

vim.keymap.set('n', '<leader>o', ':lua require("interactive/interactive").global_search()<CR>',
  { noremap = true, silent = true })

vim.keymap.set('n', '<space>cf', ':lua require("interactive/interactive").eval_function()<CR>',
  { noremap = true, silent = true })
vim.keymap.set('n', '<space>cb', ':lua require("interactive/interactive").eval_buffer()<CR>',
  { noremap = true, silent = true })

vim.keymap.set('v', '<space><space>', ':lua require("interactive/interactive").eval_selection()<CR>',
  { noremap = true, silent = true })
return M
