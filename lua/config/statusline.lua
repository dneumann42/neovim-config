local mode_labels = {
  n = "NORMAL",
  v = "VISUAL",
  V = "VISUAL LINE",
  s = "SELECT",
  S = "SELECT LINE",
  i = "INSERT",
  ic = "INSERT",
  R = "REPLACE",
  Rv = "VISUAL REPLACE",
  c = "COMMAND",
  cv = "VIM EX",
  ce = "EX",
  r = "PROMPT",
  rm = "MOAR",
  t = "TERMINAL",
  ["r?"] = "CONFIRM",
  ["!"] = "SHELL",
  [""] = "SELECT BLOCK",
  [""] = "VISUAL BLOCK",
}

local mode_colors = {
  n = "%#StatuslineAccent#",
  i = "%#StatuslineInsertAccent#",
  ic = "%#StatuslineInsertAccent#",
  v = "%#StatuslineVisualAccent#",
  V = "%#StatuslineVisualAccent#",
  [""] = "%#StatuslineVisualAccent#",
  R = "%#StatuslineReplaceAccent#",
  c = "%#StatuslineCmdLineAccent#",
  t = "%#StatuslineTerminalAccent#"
}

local function get_mode_label()
  local mode = vim.api.nvim_get_mode().mode
  return mode_labels[mode] or "UNKNOWN"
end

local function get_mode_color()
  local mode = vim.api.nvim_get_mode().mode
  return mode_colors[mode] or "%#StatuslineAccent#"
end

local function get_filename()
  local fpath = vim.fn.fnamemodify(vim.fn.expand "%", ":~:.:h")
  local base = (fpath == "" or fpath == ".") and " " or string.format(" %%<%s/", fpath)
  local fname = vim.fn.expand("%:t")
  return fname == "" and "" or base .. fname
end

local function get_line_info()
  return "%=[%l/%L] (%p%%) col:%c"
end

local function get_lsp()
  local levels = {
    errors = "ERROR",
    warnings = "WARN",
    info = "INFO",
    hints = "HINT",
  }
  local level_status = {
    [levels.errors] = "%#LspDiagnosticsSignError#",
    [levels.warnings] = "%#LspDiagnosticsSignWarning#",
    [levels.info] = "%#LspDiagnosticsSignInformation#",
    [levels.hints] = "%#LspDiagnosticsSignHint#󰌵",
  }
  local lines = {}
  for _, level in pairs(levels) do
    local tbl = vim.diagnostic.get(0, { severity = level })
    if #tbl > 0 then
      table.insert(lines, level_status[level] .. " " .. #tbl)
    end
  end
  return table.concat(lines, " ")
end

_G.statusline = {
  active = function()
    return table.concat {
      get_mode_color(),
      get_mode_label(),
      get_filename(),
      " ",
      get_lsp(),
      get_line_info()
    }
  end,
  inactive = function()
    return " %F"
  end
}

vim.cmd([[
  augroup Statusline
  au!
  au WinEnter,BufEnter * setlocal statusline=%!v:lua.statusline.active()
  au WinLeave,BufLeave * setlocal statusline=%!v:lua.statusline.inactive()
  au WinEnter,BufEnter,FileType NvimTree setlocal statusline=%!v:lua.Statusline.inactive()
  augroup END
]], false)
