-- Neovim config by Dustin H. Neumann

vim.d = vim.d or {}

vim.opt.rtp:prepend(vim.fn.stdpath("config"))

local settings = require("settings")
local sessions = require("sessions")
local plugins = require("plugins")
local terminal = require("terminal")

terminal.setup { height = 12 }

require("editor")

vim.keymap.set({ "n", "t" }, settings.bindings.toggle_terminal, function()
    require("terminal").toggle()
end, { silent = true })

for k, v in pairs(settings.filetype) do
    assert(type(v) == "table")
    vim.api.nvim_create_autocmd("FileType", {
        pattern = k,
        callback = function()
            if v.tab_size then
                assert(type(v.tab_size) == "number")
                vim.bo.tabstop = v.tab_size
                vim.bo.shiftwidth = v.tab_size
                vim.bo.softtabstop = v.tab_size
            end
        end
    })
end

vim.keymap.set("n", "<leader>cd", function()
    local path = vim.fn.input("cd: ", vim.fn.getcwd(), "dir")
    if path ~= "" then
        vim.cmd("silent cd " .. vim.fn.fnameescape(path))
        print("cd → " .. vim.fn.getcwd())
    end
end, { desc = "Change directory interactively" })

-- Keep Neovim rooted at the git toplevel when starting inside a repo.
function vim.d.git_toplevel(path)
  if vim.system then
    local res = vim.system({ "git", "-C", path, "rev-parse", "--show-toplevel" }, { text = true }):wait()
    if res.code == 0 and res.stdout then
      return (res.stdout:gsub("%s+$", ""))
    end
  else
    local lines = vim.fn.systemlist({ "git", "-C", path, "rev-parse", "--show-toplevel" })
    if vim.v.shell_error == 0 and lines[1] then
      return (lines[1]:gsub("%s+$", ""))
    end
  end
end

do
  local group = vim.api.nvim_create_augroup("StayInGitRoot", { clear = true })
  vim.api.nvim_create_autocmd("VimEnter", {
    group = group,
    callback = function()
      local cwd = vim.loop.cwd()
      local root = vim.d.git_toplevel(cwd)
      if not root or root == "" then
        vim.g.project_root = nil
        return
      end
      vim.g.project_root = root
      if cwd ~= root then
        pcall(vim.api.nvim_set_current_dir, root)
      end
      vim.api.nvim_create_autocmd("DirChanged", {
        group = group,
        callback = function(args)
          if args.cwd == root then
            return
          end
          vim.schedule(function()
            if vim.fn.getcwd() ~= root then
              pcall(vim.api.nvim_set_current_dir, root)
            end
          end)
        end,
      })
    end,
  })
end

vim.d.update_plugins()
vim.d.update_plugin_configs()

local ui = require("ui")
ui.setup()

vim.keymap.set("n", "<leader>w", ":wa!<cr>")

require("nim")

