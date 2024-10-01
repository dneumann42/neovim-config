function get_theme_colors()
  local colors = {}
  for _, hex in pairs(vim.api.nvim_get_hl(0, {})) do
    vim.print(hex)
    if hex.fg then
      table.insert(colors, string.format("#%06x", hex.fg))
    end
  end
  return colors
end

local function dashboard(logo_lines, lines)
  local max_width = 0
  for i = 1, #logo_lines do
    max_width = math.max(#logo_lines[i], max_width)
  end
  for _ = 0, 2 do
    table.insert(logo_lines, 1, "")
  end
  local start_row, start_col = 5, 10

  -- Create a new buffer
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_set_current_buf(buf)
  vim.cmd [[setlocal nonumber norelativenumber]]

  -- Insert wrapped lines
  for i, line in ipairs(logo_lines) do
    local row = start_row + i - 1
    vim.api.nvim_buf_set_lines(buf, row, row + 1, false, { string.rep(" ", start_col) .. line })
  end

  for i, line in ipairs(lines) do
    local row = 5 + start_row + i - 1
    vim.api.nvim_buf_set_lines(buf, row, row + 1, false, { string.rep(" ", start_col) .. line })
  end
end

-- Example usage
local function show_dashboard()
  dashboard({
    "███▄▄▄▄      ▄████████  ▄██████▄   ▄█    █▄   ▄█    ▄▄▄▄███▄▄▄▄  ",
    "███▀▀▀██▄   ███  ║ ███ ███  ║ ███ ███   .███ ███  ▄██▀▀▀███▀▀▀██▄",
    "███   ███   ███  ╙─█▀  ███  ║ ███ ███  ..███ ███▌ ███ ..███  .███",
    "███  .███  ▄███▄▄▄     ███  ║ ███ ███ .. ███ ███▌ ███.. ███ ..███",
    "███ ..███ ▀▀███▀▀▀     ███  ╙─███ ███..╓─███ ███▌ ███.  ███.. ███",
    "███.. ███   ███  . █▄  ███  . ███ ███. ║ ███ ███  ███   ███.  ███",
    "███.  ███   ███ ...███ ███ ...███ ███  ║ ███ ███  ███   ███   ███",
    " ▀█   █▀    ████████▀   ▀██████▀   ▀██████▀  █▀  ..▀█  .███   █▀ ",
    "               ┬ ..      ┐ ┬         ...┬       ..  | .. ┬    |  ",
    "",
    " - Dustin's config",
    "",
    "the date is " .. os.date("%D"),
    string.rep("▂", 40),
    "",
    "<space>rr    reload session",
    "<space>ss    save current session",
    string.rep("▂", 40),
    ""
  }, {})
end

vim.keymap.set('n', '<space>D', show_dashboard)
