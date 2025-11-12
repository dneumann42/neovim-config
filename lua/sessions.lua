-- Session management

local settings = require("settings")

vim.d = vim.d or {}

local path = vim.env.HOME .. "/" .. settings.auto_session_path

function vim.d.create_session(path)
    vim.fn.system { "mkdir", "-p", vim.env.HOME .. "/.local/share/nvim/" }
    vim.cmd(":mksession! " .. path)
end

function vim.d.restart()
    vim.d.create_session(path)
    vim.cmd ":restart"
end

function vim.d.file_exists(path)
    return vim.fn.filereadable(path) == 1
end

function vim.d.restore_session(path)
    if vim.fn.getcwd() ~= vim.env.HOME and vim.d.file_exists(path) then
        vim.cmd("so " .. path)
        vim.fn.system { "rm", path }
    end
end

vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("Sessions", { clear = true }),
  callback = function()
      vim.d.restore_session(path)
  end,
  nested = true,
})

vim.api.nvim_create_user_command("Restart", function()
    vim.d.create_session(path)
    vim.d.restore_session(path)
end, {})
