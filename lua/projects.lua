local Path = require("plenary.path")
local context_manager = require("plenary.context_manager")
local with, open = context_manager.with, context_manager.open
local core = require("lib.core")

local projects_filename = ".nvim_projects"

local M = {}

local function get_git_root()
  local dot_git_path = vim.fn.finddir(".git", ".;")
  return vim.fn.fnamemodify(dot_git_path, ":h")
end

local function get_pfile_path()
  local path = vim.fs.joinpath(tostring(vim.fn.stdpath("config")), projects_filename)
  return Path:new(path)
end

local function get_lines_from_projects_file()
  local path = get_pfile_path()
  if not path:exists() then
    return {}
  end
  return with(open(path:expand()), function(reader)
    return vim.tbl_filter(function(x) return x ~= "" end, core.split_lines(reader:read("*a")))
  end)
end

local function write_lines_to_projects_file(lines)
  local path = get_pfile_path()
  local contents = table.concat(lines or {}, "\n")
  with(open(path:expand(), "w"), function(writer)
    writer:write(contents)
  end)
end

local function get_project_parts(line)
  local parts = {}
  for part in string.gmatch(line, "([^,]+)") do
    table.insert(parts, part)
  end
  return parts
end

function M.add_project()
  local path = get_git_root()
  local dir = vim.fn.fnamemodify(path, ':p')
  if dir:sub(-1) == "/" then
    dir = dir:sub(1, -2)
  end
  local name = vim.fn.fnamemodify(dir, ":t")
  local lines = get_lines_from_projects_file()

  for i = 1, #lines do
    if get_project_parts(lines[i])[2] == dir then
      vim.print("Project already exists")
      return
    end
  end

  vim.ui.input({ prompt = "Project Name", default = name }, function(new_name)
    if new_name == nil then
      return
    end

    table.insert(lines, new_name .. "," .. dir)
    write_lines_to_projects_file(lines)
    vim.print("Added project")
  end)
end

function M.remove_project()
  local lines = get_lines_from_projects_file()
  local names = {}
  for i = 1, #lines do
    local splits = get_project_parts(lines[i])
    table.insert(names, splits[1])
  end
  vim.ui.select(names, { prompt = "Select a project" }, function(name, idx)
    if not name or not idx then
      return
    end
    table.remove(lines, idx)
    write_lines_to_projects_file(lines)
  end)
end

function M.open_project()
  local lines = get_lines_from_projects_file()
  local names = {}
  for i = 1, #lines do
    local splits = get_project_parts(lines[i])
    table.insert(names, splits[1])
  end
  vim.ui.select(names, { prompt = "Select a project" }, function(name, idx)
    if not name or not idx then
      return
    end
    local project_path = get_project_parts(lines[idx])[2]
    vim.api.nvim_set_current_dir(project_path)

    local builtin = require('telescope.builtin')
    builtin.find_files()
  end)
end

vim.api.nvim_create_user_command("AddProject", M.add_project, {})
vim.api.nvim_create_user_command("OpenProject", M.open_project, {})
vim.api.nvim_create_user_command("RemoveProject", M.remove_project, {})

vim.keymap.set("n", "<leader>P", function()
  vim.cmd("OpenProject")
end)

return M
