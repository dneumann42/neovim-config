local function dashboard(lines)
  local max_width = 0
  for i = 1, #lines do
    max_width = math.max(#lines[i], max_width)
  end
  for _ = 1, 5 do
    table.insert(lines, 1, "")
  end
  local start_row = 10
  local start_col = 10

  -- Create a new buffer
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_set_current_buf(buf)
  vim.cmd [[setlocal nonumber norelativenumber]]

  -- Insert wrapped lines
  for i, line in ipairs(lines) do
    local row = start_row + i - 1
    vim.api.nvim_buf_set_lines(buf, row, row + 1, false, { string.rep(" ", start_col) .. line })
  end

  -- Apply gradient colors
  local ns_id = vim.api.nvim_create_namespace("DashboardGradient")
  local total_lines = #lines
  for i = 1, total_lines do
    local r = math.floor(155 * (1 - (i - 1) / (total_lines - 1)))
    local g = math.floor(155 * math.sin(math.pi * (i - 1) / (total_lines - 1)))
    local b = math.min(i * 10, 255)
    local color = string.format("#%02x%02x%02x", r, g, b)

    -- Create a unique highlight group for each line
    local hl_group = "DashboardGradient" .. i
    vim.api.nvim_set_hl(0, hl_group, { fg = color })

    -- Apply the highlight group to the line
    vim.api.nvim_buf_add_highlight(buf, ns_id, hl_group, start_row + i - 1 - 5, start_col, -1)
  end
end

-- Example usage
dashboard {
  "@@@  @@@  @@@  @@@@@@@@@@     ",
  "@@@  @@@  @@@  @@@@@@@@@@@    ",
  "@@!  @@@  @@!  @@! @@! @@!    ",
  "!@!  @!@  !@!  !@! !@! !@!    ",
  "@!@  !@!  !!@  @!! !!@ @!@    ",
  "!@!  !!!  !!!  !@!   ! !@!    ",
  ":!:  !!:  !!:  !!:     !!:    ",
  " ::!!:!   :!:  :!:     :!:    ",
  "  ::::     ::  :::     ::     ",
  "   :      :     :      :      ",
  "",
  "",
  "",
  "",
  "<space>rr    reload session",
  "<space>ss    save current session",
}
