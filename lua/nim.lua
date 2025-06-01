-- this is a simple nim plugin that I'm working on, my goal is to have this be extremely reliable

local ns = vim.api.nvim_create_namespace("nim_diagnostics")

local buffers = {}

local function get_icon(marker)
  if marker == "Warning" then return "" end
  if marker == "Error" then return "" end
  if marker == "Hint" then return "󰌵" end
  return ""
end

local function get_severity(marker)
  if marker == "Warning" then return vim.diagnostic.severity.WARN end
  if marker == "Error" then return vim.diagnostic.severity.ERROR end
  if marker == "Hint" then return vim.diagnostic.severity.HINT end
  return ""
end

local function new_diagnostics()
  return {
    Warning = {},
    Error = {},
    Hint = {},
  }
end

local function get_diagnostics(path)
  buffers[path] = buffers[path] or new_diagnostics()
  return buffers[path]
end

local function report_line(line)
  if line == nil then return end
  local path = line:sub(1, (line:find("%(") or 0) - 1)
  if line:find("Warning") == nil and
      line:find("Error") == nil and
      line:find("Hint") == nil then
    return
  end
  if line:find("Hint") ~= nil and line:find("Hint") < 2 then
    return
  end
  local location = line:sub(line:find("%(") or 1, #line)
  local ln, col = location:match("%((%d+),%s*(%d+)%)")
  local info_type_start = location:sub((location:find("%)") or 1) + 2, #location)
  local info_type = info_type_start:sub(1, info_type_start:find(" ") - 2)
  if not info_type or not info_type_start then
    return
  end
  local diagnostics = get_diagnostics(path)
  if diagnostics[info_type] == nil then
    return
  end
  local msg = info_type_start:sub(info_type_start:find(" ") + 1, #info_type_start)
  table.insert(diagnostics[info_type], {
    lnum = tonumber(ln) - 1,
    col = tonumber(col) - 1,
    severity = get_severity(info_type),
    source = "nim",
    message = get_icon(info_type) .. " " .. msg,
  })
end

local function check_buffer()
  buffers = {}
  vim.fn.jobstart(
    { "nim", "check", vim.api.nvim_buf_get_name(0) },
    {
      stdout_buffered = true,
      stderr_buffered = true,
      on_stderr = function(_, lines)
        for i = 1, #lines do
          report_line(lines[i])
        end
      end,
      on_stdout = function(_, lines)
        for i = 1, #lines do
          report_line(lines[i])
        end
      end,
      on_exit = function()
        local full_path = vim.api.nvim_buf_get_name(0)
        local diagnostics = buffers[full_path] or new_diagnostics()
        local list = {}
        for i = 1, #diagnostics.Warning do table.insert(list, diagnostics.Warning[i]) end
        for i = 1, #diagnostics.Error do table.insert(list, diagnostics.Error[i]) end
        for i = 1, #diagnostics.Hint do table.insert(list, diagnostics.Hint[i]) end
        vim.diagnostic.set(ns, 0, list, {})
      end,
    }
  )
end

local function format_buffer()
  local path = vim.api.nvim_buf_get_name(0)
  vim.fn.system("nph " .. path .. " " .. path .. " < /dev/null")
  local view = vim.fn.winsaveview()
  vim.cmd("e")
  vim.fn.winrestview(view)
end

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.nim",
  callback = function()
    format_buffer()
    check_buffer()
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*.nim",
  callback = function()
    check_buffer()
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "nim",
  callback = function()
    vim.keymap.set("n", "<C-]>", function()
      vim.cmd("AnyJump")
    end, { buffer = true, desc = "Custom Nim jump handler" })
  end,
})

vim.keymap.set("n", "<leader>dd", function()
  vim.diagnostic.setqflist({
    severity = {
      min = vim.diagnostic.severity.WARN,
      max = vim.diagnostic.severity.ERROR,
    },
    open = true,
  })
end, { desc = "Show diagnostics in quickfix" })
