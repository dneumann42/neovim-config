-- lua/shellpop.lua
local M = {}
local state = { buf = nil, win = nil }
local cfg = { height = 12 }

local function is_float(win)
  local c = vim.api.nvim_win_get_config(win)
  return c and c.relative ~= "" and c.relative ~= nil
end

local function is_sidebar(buf)
  local ft = vim.bo[buf].filetype
  return ft == "neo-tree" or ft == "NvimTree"
end

local function pick_host_win()
  local cur = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_win_get_buf(cur)
  if not is_float(cur) and not is_sidebar(buf) then return cur end
  for _, w in ipairs(vim.api.nvim_list_wins()) do
    local b = vim.api.nvim_win_get_buf(w)
    if not is_float(w) and not is_sidebar(b) then return w end
  end
  return cur
end

local function ensure_term()
  if state.buf and vim.api.nvim_buf_is_valid(state.buf) and vim.bo[state.buf].buftype == "terminal" then
    return state.buf
  end
  vim.cmd("terminal")
  state.buf = vim.api.nvim_get_current_buf()
  vim.bo[state.buf].bufhidden = "hide"
  return state.buf
end

local function open_term(host)
  vim.api.nvim_set_current_win(host)
  vim.cmd("belowright " .. tostring(cfg.height) .. "split")
  state.win = vim.api.nvim_get_current_win()
  local buf = ensure_term()
  vim.api.nvim_win_set_buf(state.win, buf)
  vim.api.nvim_set_current_win(state.win)
  vim.cmd("startinsert") -- focus & insert mode
end

function M.toggle()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    pcall(vim.api.nvim_win_close, state.win, true)
    state.win = nil
    return
  end
  local host = pick_host_win()
  open_term(host)
end

function M.setup(opts)
  cfg = vim.tbl_deep_extend("force", cfg, opts or {})
  vim.api.nvim_create_user_command("ShellPop", function() M.toggle() end, {})
end

return M
